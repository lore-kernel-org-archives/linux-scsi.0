From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [2/5]  qla2xxx: Set firmware options fixes
Date: Mon, 12 Jul 2004 07:05:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040712140528.GA6954@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:19885 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263429AbUGLVQ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 17:16:59 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1866 04/07/12 09:30:06 andrew.vasquez@apc.qlogic.com +1 -0
  Fix issue where firmware options were not properly being
  set before firmware initialization.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_init.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-07-12 09:54:32 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-07-12 09:54:32 -07:00
@@ -783,7 +783,6 @@
 static void
 qla2x00_update_fw_options(scsi_qla_host_t *ha)
 {
-	/* Setup seriallink options */
 	uint16_t swing, emphasis;
 
 	memset(ha->fw_options, 0, sizeof(ha->fw_options));
@@ -807,7 +806,6 @@
 	emphasis = ha->fw_seriallink_options[0] & (BIT_4 | BIT_3);
 	emphasis >>= 3;
 	ha->fw_options[10] = (emphasis << 14) | (swing << 8) | 0x3;
-
 	/*  2G settings */
 	swing = ha->fw_seriallink_options[0] & (BIT_7 | BIT_6 | BIT_5);
 	swing >>= 5;
@@ -818,7 +816,7 @@
 	/*  Return command IOCBs without waiting for an ABTS to complete. */
 	ha->fw_options[3] |= BIT_13;
 
-	/* Update Serial Link options. */
+	/* Update firmware options. */
 	qla2x00_set_fw_options(ha, ha->fw_options);
 }
 
@@ -869,15 +867,15 @@
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
+	/* Update any ISP specific firmware options before initialization. */
+	qla2x00_update_fw_options(ha);
+
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
 	rval = qla2x00_init_firmware(ha, sizeof(init_cb_t));
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Init firmware **** FAILED ****.\n",
 		    ha->host_no));
 	} else {
-		/* Update any ISP specific firmware options. */
-		qla2x00_update_fw_options(ha);
-
 		DEBUG3(printk("scsi(%ld): Init firmware -- success.\n",
 		    ha->host_no));
 	}
