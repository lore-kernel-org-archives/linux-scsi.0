From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 11/17] cxlflash: Remove unnecessary DMA mapping
Date: Wed, 12 Apr 2017 14:15:02 -0500
Message-ID: <1492024502-56029-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752393AbdDLTPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:15:19 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJCFG6110473
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:19 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29s91kf6cc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:19 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 15:15:17 -0400
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Devices supported by the cxlflash driver are fully coherent and do not
require a bus address mapping. Avoid unnecessary path length by using
the virtual address and length already present in the scatter-gather
entry.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index ebba3c9..3c4a833 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -176,7 +176,6 @@ static void cmd_complete(struct afu_cmd *cmd)
 		dev_dbg_ratelimited(dev, "%s:scp=%p result=%08x ioasc=%08x\n",
 				    __func__, scp, scp->result, cmd->sa.ioasc);
 
-		scsi_dma_unmap(scp);
 		scp->scsi_done(scp);
 
 		if (cmd_is_tmf) {
@@ -445,7 +444,6 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	struct scatterlist *sg = scsi_sglist(scp);
 	u16 req_flags = SISL_REQ_FLAGS_SUP_UNDERRUN;
 	ulong lock_flags;
-	int nseg = 0;
 	int rc = 0;
 
 	dev_dbg_ratelimited(dev, "%s: (scp=%p) %d/%d/%d/%llu "
@@ -487,15 +485,8 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	}
 
 	if (likely(sg)) {
-		nseg = scsi_dma_map(scp);
-		if (unlikely(nseg < 0)) {
-			dev_err(dev, "%s: Fail DMA map\n", __func__);
-			rc = SCSI_MLQUEUE_HOST_BUSY;
-			goto out;
-		}
-
-		cmd->rcb.data_len = sg_dma_len(sg);
-		cmd->rcb.data_ea = sg_dma_address(sg);
+		cmd->rcb.data_len = sg->length;
+		cmd->rcb.data_ea = (uintptr_t)sg_virt(sg);
 	}
 
 	cmd->scp = scp;
@@ -513,8 +504,6 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	memcpy(cmd->rcb.cdb, scp->cmnd, sizeof(cmd->rcb.cdb));
 
 	rc = afu->send_cmd(afu, cmd);
-	if (unlikely(rc))
-		scsi_dma_unmap(scp);
 out:
 	return rc;
 }
-- 
2.1.0
