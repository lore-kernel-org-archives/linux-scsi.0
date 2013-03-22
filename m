From: vikas.chaudhary@qlogic.com
Subject: [PATCH 3/4] qla4xxx: Skip retry of initialize_adapter for ISP80XX
Date: Fri, 22 Mar 2013 07:22:42 -0400
Message-ID: <1363951362-15671-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:24321 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932939Ab3CVLpY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Mar 2013 07:45:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

While probe Skip retry of initialize_adapter only for ISP82XX and ISP83XX.
We need to retry initialize_adapter for ISP40XX.

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 18f857a..f3cf04e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5345,8 +5345,11 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	status = qla4xxx_initialize_adapter(ha, INIT_ADAPTER);
 
 	/* Dont retry adapter initialization if IRQ allocation failed */
-	if (!test_bit(AF_IRQ_ATTACHED, &ha->flags))
+	if (is_qla80XX(ha) && !test_bit(AF_IRQ_ATTACHED, &ha->flags)) {
+		ql4_printk(KERN_WARNING, ha, "%s: Skipping retry of adapter initialization\n",
+			   __func__);
 		goto skip_retry_init;
+	}
 
 	while ((!test_bit(AF_ONLINE, &ha->flags)) &&
 	    init_retry_count++ < MAX_INIT_RETRIES) {
-- 
1.8.2.GIT

