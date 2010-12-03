From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 09/12] qla4xxx: do not check for fw hung if reset retry is
 in progress
Date: Thu, 2 Dec 2010 22:12:45 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F4120@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3259 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab0LCGMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:46 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index fa5ddad..a1ba085 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -706,7 +706,9 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 	dev_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
 
 	/* don't poll if reset is going on */
-	if (!test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags)) {
+	if (!(test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags) ||
+	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
+	    test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags))) {
 		if (dev_state == QLA82XX_DEV_NEED_RESET &&
 		    !test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
 			printk("scsi%ld: %s: HW State: NEED RESET!\n",
-- 
1.7.3.2

