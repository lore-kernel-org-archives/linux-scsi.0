From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
Date: Thu, 1 May 2008 13:51:19 -0600
Message-ID: <9738BCBE884FDB42801FAD8A7769C265021C41D7@NAMAIL1.ad.lsil.com>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36038 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969AbYEATwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 15:52:13 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org

ACK.

Thanks.

Bo Yang 

-----Original Message-----
From: Jiri Slaby [mailto:jirislaby@gmail.com] 
Sent: Thursday, May 01, 2008 11:56 AM
To: DL-MegaRAID Linux
Cc: linux-scsi@vger.kernel.org; James.Bottomley@HansenPartnership.com;
akpm@linux-foundation.org; linux-kernel@vger.kernel.org; Jiri Slaby
Subject: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections

megaraid_sas suspend and resume are inappropriatelly placed in __devinit
section. Remove those placements and make the stuff dependent on
CONFIG_PM.

While at it, mark remove function as __devexit.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
---
 drivers/scsi/megaraid/megaraid_sas.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c
b/drivers/scsi/megaraid/megaraid_sas.c
index b937e9c..a90944c 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -2650,12 +2650,13 @@ static void megasas_shutdown_controller(struct
megasas_instance *instance,
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
 megasas_suspend(struct pci_dev *pdev, pm_message_t state)  {
 	struct Scsi_Host *host;
@@ -2687,7 +2688,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t
state)
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

