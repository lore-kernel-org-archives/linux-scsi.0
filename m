From: vikas.chaudhary@qlogic.com
Subject: [PATCH 07/13] qla4xxx: Fail probe_adapter if IRQ allocation fails
Date: Thu, 20 Sep 2012 07:35:07 -0400
Message-ID: <1348140913-11828-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:29345 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754184Ab2ITLxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 07:53:05 -0400
In-Reply-To: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Poornima Vonti <poornima.vonti@qlogic.com>

From: Poornima Vonti <poornima.vonti@qlogic.com>

If IRQ allocation fails, it means system has run out of interrupt
vectors, so fail probe_adapter in case of IRQ allocation failure
and dont retry adapter initialization.

Signed-off-by: Poornima Vonti <poornima.vonti@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 81b3038..29bd225 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5240,6 +5240,11 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	 * NOTE: interrupts enabled upon successful completion
 	 */
 	status = qla4xxx_initialize_adapter(ha, INIT_ADAPTER);
+
+	/* Dont retry adapter initialization if IRQ allocation failed */
+	if (!test_bit(AF_IRQ_ATTACHED, &ha->flags))
+		goto skip_retry_init;
+
 	while ((!test_bit(AF_ONLINE, &ha->flags)) &&
 	    init_retry_count++ < MAX_INIT_RETRIES) {
 
@@ -5264,6 +5269,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 		status = qla4xxx_initialize_adapter(ha, INIT_ADAPTER);
 	}
 
+skip_retry_init:
 	if (!test_bit(AF_ONLINE, &ha->flags)) {
 		ql4_printk(KERN_WARNING, ha, "Failed to initialize adapter\n");
 
-- 
1.7.1

