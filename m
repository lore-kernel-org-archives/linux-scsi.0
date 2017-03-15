From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/6] ipr: Fix SATA EH hang
Date: Wed, 15 Mar 2017 16:58:41 -0500
Message-ID: <20170315215841.E563EC6042@b03ledav006.gho.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45188 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754000AbdCOV6t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 17:58:49 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2FLsR0c094938
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 17:58:48 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 296ng7uchj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 17:58:47 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Wed, 15 Mar 2017 17:58:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, djeffery@redhat.com


This patch fixes a hang that can occur in ATA EH with ipr. With ipr's usage of
libata, commands should never end up on ap->eh_done_q. The timeout function we use
for ipr, even for SATA devices, is scsi_times_out, so ATA_QCFLAG_EH_SCHEDULED
never gets set for ipr and EH is driven completely by ipr and SCSI. The SCSI
EH thread ends up calling ipr's eh_device_reset_handler,
which then calls ata_std_error_handler. This ends up calling ipr_sata_reset,
which issues a reset to the device. This should result in all pending commands
getting failed back and having ata_qc_complete called for them, which should
end up clearing ATA_QCFLAG_FAILED as qc->flags gets zeroed in ata_qc_free.
This ensures that when we end up in ata_eh_finish, we don't do anything more
with the command.

On adapters that only support a single interrupt and when running with two MSI-X
vectors or less, the adapter firmware guarantees that responses to all outstanding
commands are sent back prior to sending the response to the SATA reset command.
On newer adapters supporting multiple HRRQs, however, this can no longer be guaranteed,
since the command responses and reset response may be processed on different HRRQs.

If ipr returns from ipr_sata_reset before the outstanding command was returned,
this sends us down the path of __ata_eh_qc_complete which then moves the associated
scsi_cmd from the work_q in scsi_eh_bus_device_reset to ap->eh_done_q,
which then will sit there forever and we will be wedged. 

This patch fixes this up by ensuring that any outstanding commands are flushed
before returning from eh_device_reset_handler for a SATA device.

Reported-by: David Jeffery <djeffery@redhat.com>

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   62 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 21 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_fix_sata_eh_hang2 drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_fix_sata_eh_hang2	2017-03-13 16:32:37.663087624 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2017-03-13 16:32:37.670087596 -0500
@@ -5067,6 +5067,23 @@ static bool ipr_cmnd_is_free(struct ipr_
 }
 
 /**
+ * ipr_match_res - Match function for specified resource entry
+ * @ipr_cmd:	ipr command struct
+ * @resource:	resource entry to match
+ *
+ * Returns:
+ *	1 if command matches sdev / 0 if command does not match sdev
+ **/
+static int ipr_match_res(struct ipr_cmnd *ipr_cmd, void *resource)
+{
+	struct ipr_resource_entry *res = resource;
+
+	if (res && ipr_cmd->ioarcb.res_handle == res->res_handle)
+		return 1;
+	return 0;
+}
+
+/**
  * ipr_wait_for_ops - Wait for matching commands to complete
  * @ipr_cmd:	ipr command struct
  * @device:		device to match (sdev)
@@ -5246,7 +5263,7 @@ static int ipr_sata_reset(struct ata_lin
 	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
 	struct ipr_resource_entry *res;
 	unsigned long lock_flags = 0;
-	int rc = -ENXIO;
+	int rc = -ENXIO, ret;
 
 	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -5260,9 +5277,19 @@ static int ipr_sata_reset(struct ata_lin
 	if (res) {
 		rc = ipr_device_reset(ioa_cfg, res);
 		*classes = res->ata_class;
-	}
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+
+		ret = ipr_wait_for_ops(ioa_cfg, res, ipr_match_res);
+		if (ret != SUCCESS) {
+			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_ABBREV);
+			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+
+			wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+		}
+	} else
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	LEAVE;
 	return rc;
 }
@@ -5291,9 +5318,6 @@ static int __ipr_eh_dev_reset(struct scs
 	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
 	res = scsi_cmd->device->hostdata;
 
-	if (!res)
-		return FAILED;
-
 	/*
 	 * If we are currently going through reset/reload, return failed. This will force the
 	 * mid-layer to call ipr_eh_host_reset, which will then go to sleep and wait for the
@@ -5332,19 +5356,6 @@ static int __ipr_eh_dev_reset(struct scs
 		spin_unlock_irq(scsi_cmd->device->host->host_lock);
 		ata_std_error_handler(ap);
 		spin_lock_irq(scsi_cmd->device->host->host_lock);
-
-		for_each_hrrq(hrrq, ioa_cfg) {
-			spin_lock(&hrrq->_lock);
-			list_for_each_entry(ipr_cmd,
-					    &hrrq->hrrq_pending_q, queue) {
-				if (ipr_cmd->ioarcb.res_handle ==
-				    res->res_handle) {
-					rc = -EIO;
-					break;
-				}
-			}
-			spin_unlock(&hrrq->_lock);
-		}
 	} else
 		rc = ipr_device_reset(ioa_cfg, res);
 	res->resetting_device = 0;
@@ -5358,15 +5369,24 @@ static int ipr_eh_dev_reset(struct scsi_
 {
 	int rc;
 	struct ipr_ioa_cfg *ioa_cfg;
+	struct ipr_resource_entry *res;
 
 	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
+	res = cmd->device->hostdata;
+
+	if (!res)
+		return FAILED;
 
 	spin_lock_irq(cmd->device->host->host_lock);
 	rc = __ipr_eh_dev_reset(cmd);
 	spin_unlock_irq(cmd->device->host->host_lock);
 
-	if (rc == SUCCESS)
-		rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
+	if (rc == SUCCESS) {
+		if (ipr_is_gata(res) && res->sata_port)
+			rc = ipr_wait_for_ops(ioa_cfg, res, ipr_match_res);
+		else
+			rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
+	}
 
 	return rc;
 }
_
