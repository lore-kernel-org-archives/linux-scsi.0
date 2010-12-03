From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 10/12] qla4xxx: do not reset hba if ql4xdontresethba is set
Date: Thu, 2 Dec 2010 22:12:47 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F4121@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3261 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab0LCGMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:49 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a1ba085..3cb74c9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -711,15 +711,17 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 	    test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags))) {
 		if (dev_state == QLA82XX_DEV_NEED_RESET &&
 		    !test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
-			printk("scsi%ld: %s: HW State: NEED RESET!\n",
-			    ha->host_no, __func__);
-			set_bit(DPC_RESET_HA, &ha->dpc_flags);
-			qla4xxx_wake_dpc(ha);
-			qla4xxx_mailbox_premature_completion(ha);
+			if (!ql4xdontresethba) {
+				ql4_printk(KERN_INFO, ha, "%s: HW State: "
+				    "NEED RESET!\n", __func__);
+				set_bit(DPC_RESET_HA, &ha->dpc_flags);
+				qla4xxx_wake_dpc(ha);
+				qla4xxx_mailbox_premature_completion(ha);
+			}
 		} else if (dev_state == QLA82XX_DEV_NEED_QUIESCENT &&
 		    !test_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags)) {
-			printk("scsi%ld: %s: HW State: NEED QUIES!\n",
-			    ha->host_no, __func__);
+			ql4_printk(KERN_INFO, ha, "%s: HW State: NEED QUIES!\n",
+			    __func__);
 			set_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags);
 			qla4xxx_wake_dpc(ha);
 		} else  {
-- 
1.7.3.2

