From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/12] qla2xxx: Correct MSI-X vector allocation for single queue mode.
Date: Thu, 22 Jan 2009 09:45:33 -0800
Message-ID: <1232646339-32503-7-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233AbZAVRpq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:46 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 789fc57..e28ad81 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1868,6 +1868,7 @@ qla24xx_disable_msix(struct qla_hw_data *ha)
 static int
 qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
+#define MIN_MSIX_COUNT	2
 	int i, ret;
 	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
@@ -1883,12 +1884,16 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 
 	ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
 	if (ret) {
+		if (ret < MIN_MSIX_COUNT)
+			goto msix_failed;
+
 		qla_printk(KERN_WARNING, ha,
 			"MSI-X: Failed to enable support -- %d/%d\n"
 			" Retry with %d vectors\n", ha->msix_count, ret, ret);
 		ha->msix_count = ret;
 		ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
 		if (ret) {
+msix_failed:
 			qla_printk(KERN_WARNING, ha, "MSI-X: Failed to enable"
 				" support, giving up -- %d/%d\n",
 				ha->msix_count, ret);
-- 
1.6.1.48.ge9b8

