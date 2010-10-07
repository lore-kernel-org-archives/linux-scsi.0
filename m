From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 05/15] qla4xxx: free_irqs on failed initialize_adapter
Date: Wed, 6 Oct 2010 22:49:08 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87129406788@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37517 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab0JGFtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:49:10 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

Since interrupts are registered in start_firmware(load_risc) for 82xx,
free them if init_firmware fails.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index b6046af..dc01fa3 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1459,6 +1459,12 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha,
 exit_init_online:
 	set_bit(AF_ONLINE, &ha->flags);
 exit_init_hba:
+	if (is_qla8022(ha) && (status == QLA_ERROR)) {
+		/* Since interrupts are registered in start_firmware for
+		 * 82xx, release them here if initialize_adapter fails */
+		qla4xxx_free_irqs(ha);
+	}
+
 	DEBUG2(printk("scsi%ld: initialize adapter: %s\n", ha->host_no,
 	    status == QLA_ERROR ? "FAILED" : "SUCCEDED"));
 	return status;
-- 
1.6.6

