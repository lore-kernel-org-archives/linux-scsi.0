From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
Date: Thu,  1 May 2008 17:56:02 +0200
Message-ID: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.wellnetcz.com ([212.24.148.102]:59293 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758071AbYEAP4b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 May 2008 11:56:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>

megaraid_sas suspend and resume are inappropriatelly placed in
__devinit section. Remove those placements and make the stuff
dependent on CONFIG_PM.

While at it, mark remove function as __devexit.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
---
 drivers/scsi/megaraid/megaraid_sas.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index b937e9c..a90944c 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -2650,12 +2650,13 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 	return;
 }
 
+#ifdef CONFIG_PM
 /**
  * megasas_suspend -	driver suspend entry point
  * @pdev:		PCI device structure
  * @state:		PCI power state to suspend routine
  */
-static int __devinit
+static int
 megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct Scsi_Host *host;
@@ -2687,7 +2688,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
  * megasas_resume-      driver resume entry point
  * @pdev:               PCI device structure
  */
-static int __devinit
+static int
 megasas_resume(struct pci_dev *pdev)
 {
 	int rval;
@@ -2782,12 +2783,16 @@ fail_ready_state:
 
 	return -ENODEV;
 }
+#else
+#define megasas_suspend	NULL
+#define megasas_resume	NULL
+#endif
 
 /**
  * megasas_detach_one -	PCI hot"un"plug entry point
  * @pdev:		PCI device structure
  */
-static void megasas_detach_one(struct pci_dev *pdev)
+static void __devexit megasas_detach_one(struct pci_dev *pdev)
 {
 	int i;
 	struct Scsi_Host *host;
-- 
1.5.4.5

