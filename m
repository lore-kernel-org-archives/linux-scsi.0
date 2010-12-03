From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 06/12] qla4xxx: put device in FAILED state for 82XX
 initialization failure
Date: Thu, 2 Dec 2010 22:12:36 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F411D@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3249 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab0LCGMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:39 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Lalit Chandivade <lalit.chandivade@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0d48fb4..fa5ddad 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1721,6 +1721,14 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	if (!test_bit(AF_ONLINE, &ha->flags)) {
 		ql4_printk(KERN_WARNING, ha, "Failed to initialize adapter\n");
 
+		if (is_qla8022(ha) && ql4xdontresethba) {
+			/* Put the device in failed state. */
+			DEBUG2(printk(KERN_ERR "HW STATE: FAILED\n"));
+			qla4_8xxx_idc_lock(ha);
+			qla4_8xxx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+			    QLA82XX_DEV_FAILED);
+			qla4_8xxx_idc_unlock(ha);
+		}
 		ret = -ENODEV;
 		goto probe_failed;
 	}
-- 
1.7.3.2

