From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: fix bad locking during eh_abort
Date: Thu, 26 May 2005 16:19:38 -0700
Message-ID: <20050526231938.GA31205@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:62326 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261616AbVEZXTj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 19:19:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>

James,

Please apply, this should go in before 2.6.12 is released.




Correct incorrect locking order in qla2xxx_eh_abort() handler which
would case a hang during certain code-paths.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_os.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

drivers/scsi/qla2xxx/qla_os.c: needs update
Index: drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- d9be308337b4cca0f0829b0bd62f1d5b830954e1/drivers/scsi/qla2xxx/qla_os.c  (mode:100644)
+++ uncommitted/drivers/scsi/qla2xxx/qla_os.c  (mode:100644)
@@ -547,16 +547,15 @@
 
 		break;
 	}
+	spin_unlock(&ha->hardware_lock);
 
 	/* Wait for the command to be returned. */
 	if (ret == SUCCESS) {
-		spin_unlock(&ha->hardware_lock);
 		if (qla2x00_eh_wait_on_command(ha, cmd) != QLA_SUCCESS) {
 			qla_printk(KERN_ERR, ha, 
 			    "scsi(%ld:%d:%d): Abort handler timed out -- %lx "
 			    "%x.\n", ha->host_no, id, lun, serial, ret);
 		}
-		spin_lock(&ha->hardware_lock);
 	}
 	spin_lock_irq(ha->host->host_lock);
 
