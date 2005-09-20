From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: eh_active checks in qla2xxx error handling
Date: Tue, 20 Sep 2005 13:25:53 -0700
Message-ID: <20050920202553.GJ19002@plap.qlogic.org>
References: <20050906122028.GA22963@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:26021 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S964783AbVITUZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2005 16:25:54 -0400
Content-Disposition: inline
In-Reply-To: <20050906122028.GA22963@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Duane Grigsby <duane.grigsby@qlogic.com>

On Tue, 06 Sep 2005, Christoph Hellwig wrote:

> qla2xxx is the only driver looking at eh_active, and doing the wait
> for oustanding commands only from EH thread resets but not from the
> ioctls looks rather wrong to me.  Do you remember the rational for it?

As Duane mentioned, this looks to be some residual from the 2.4 era
which unfortunately I've yet to find a reasonably valid justification
for...Alas, another loss of history...

---
Here's a patch which drops the eh_active checks in the qla2xxx
eh_handler callbacks.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>


diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -797,29 +797,19 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 		goto eh_dev_reset_done;
 	}
 
-	/*
-	 * If we are coming down the EH path, wait for all commands to
-	 * complete for the device.
-	 */
-	if (cmd->device->host->eh_active) {
-		if (qla2x00_eh_wait_for_pending_target_commands(ha, id))
-			ret = FAILED;
-
-		if (ret == FAILED) {
-			DEBUG3(printk("%s(%ld): failed while waiting for "
-			    "commands\n", __func__, ha->host_no));
-			qla_printk(KERN_INFO, ha,
-			    "%s: failed while waiting for commands\n",
-			    __func__);
-
-			goto eh_dev_reset_done;
-		}
-	}
-
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): DEVICE RESET SUCCEEDED.\n", ha->host_no, id, lun);
+	/* Flush outstanding commands. */
+	if (qla2x00_eh_wait_for_pending_target_commands(ha, id))
+		ret = FAILED;
+	if (ret == FAILED) {
+		DEBUG3(printk("%s(%ld): failed while waiting for commands\n",
+		    __func__, ha->host_no));
+		qla_printk(KERN_INFO, ha,
+		    "%s: failed while waiting for commands\n", __func__);
+	} else
+		qla_printk(KERN_INFO, ha,
+		    "scsi(%ld:%d:%d): DEVICE RESET SUCCEEDED.\n", ha->host_no,
+		    id, lun);
 
-eh_dev_reset_done:
 	return ret;
 }
 
@@ -921,10 +911,9 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *c
 	if (ret == FAILED)
 		goto eh_bus_reset_done;
 
-	/* Waiting for our command in done_queue to be returned to OS.*/
-	if (cmd->device->host->eh_active)
-		if (!qla2x00_eh_wait_for_pending_commands(ha))
-			ret = FAILED;
+	/* Flush outstanding commands. */
+	if (!qla2x00_eh_wait_for_pending_commands(ha))
+		ret = FAILED;
 
 eh_bus_reset_done:
 	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
