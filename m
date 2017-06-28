From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 2/3] cxlflash: Update send_tmf() parameters
Date: Wed, 28 Jun 2017 12:14:30 -0500
Message-ID: <1498670070-39805-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1498669929-39684-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59544 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751532AbdF1ROl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 13:14:41 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5SHDoj8047050
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2017 13:14:40 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bccv0m3bt-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2017 13:14:40 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Wed, 28 Jun 2017 13:14:39 -0400
In-Reply-To: <1498669929-39684-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>
Cc: Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The current send_tmf() implementation is based on the caller providing
a SCSI command reference. In reality all that is needed is a SCSI device
reference as the routine uses a private command.

Refactor send_tmf() to pass the private adapter configuration reference
and a SCSI device reference. As a nice side effect, this will ease the
burden of converting caller routines to be based solely off of a SCSI
device reference.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 455564f..7054e11 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -459,21 +459,20 @@ static u32 cmd_to_target_hwq(struct Scsi_Host *host, struct scsi_cmnd *scp,
 
 /**
  * send_tmf() - sends a Task Management Function (TMF)
- * @afu:	AFU to checkout from.
- * @scp:	SCSI command from stack describing target.
+ * @cfg:	Internal structure associated with the host.
+ * @sdev:	SCSI device destined for TMF.
  * @tmfcmd:	TMF command to send.
  *
  * Return:
  *	0 on success, SCSI_MLQUEUE_HOST_BUSY or -errno on failure
  */
-static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
+static int send_tmf(struct cxlflash_cfg *cfg, struct scsi_device *sdev,
+		    u64 tmfcmd)
 {
-	struct Scsi_Host *host = scp->device->host;
-	struct cxlflash_cfg *cfg = shost_priv(host);
+	struct afu *afu = cfg->afu;
 	struct afu_cmd *cmd = NULL;
 	struct device *dev = &cfg->dev->dev;
-	int hwq_index = cmd_to_target_hwq(host, scp, afu);
-	struct hwq *hwq = get_hwq(afu, hwq_index);
+	struct hwq *hwq = get_hwq(afu, PRIMARY_HWQ);
 	char *buf = NULL;
 	ulong lock_flags;
 	int rc = 0;
@@ -500,12 +499,12 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 
 	cmd->parent = afu;
 	cmd->cmd_tmf = true;
-	cmd->hwq_index = hwq_index;
+	cmd->hwq_index = hwq->index;
 
 	cmd->rcb.ctx_id = hwq->ctx_hndl;
 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
-	cmd->rcb.port_sel = CHAN2PORTMASK(scp->device->channel);
-	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
+	cmd->rcb.port_sel = CHAN2PORTMASK(sdev->channel);
+	cmd->rcb.lun_id = lun_to_lunid(sdev->lun);
 	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
 			      SISL_REQ_FLAGS_SUP_UNDERRUN |
 			      SISL_REQ_FLAGS_TMF_CMD);
@@ -2430,15 +2429,15 @@ static int cxlflash_eh_abort_handler(struct scsi_cmnd *scp)
 static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 {
 	int rc = SUCCESS;
-	struct Scsi_Host *host = scp->device->host;
+	struct scsi_device *sdev = scp->device;
+	struct Scsi_Host *host = sdev->host;
 	struct cxlflash_cfg *cfg = shost_priv(host);
 	struct device *dev = &cfg->dev->dev;
-	struct afu *afu = cfg->afu;
 	int rcr = 0;
 
 	dev_dbg(dev, "%s: (scp=%p) %d/%d/%d/%llu "
 		"cdb=(%08x-%08x-%08x-%08x)\n", __func__, scp, host->host_no,
-		scp->device->channel, scp->device->id, scp->device->lun,
+		sdev->channel, sdev->id, sdev->lun,
 		get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
 		get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
 		get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
@@ -2447,7 +2446,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 retry:
 	switch (cfg->state) {
 	case STATE_NORMAL:
-		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
+		rcr = send_tmf(cfg, sdev, TMF_LUN_RESET);
 		if (unlikely(rcr))
 			rc = FAILED;
 		break;
-- 
2.1.0
