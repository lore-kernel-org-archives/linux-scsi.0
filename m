From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 3/4] scsi: megaraid_sas - Add the new controller Support to
	Driver
Date: Mon, 17 Mar 2008 04:13:07 -0400
Message-ID: <1205741587.7479.17.camel@pcp021067pcs.se.lsil.com>
References: <9738BCBE884FDB42801FAD8A7769C26501CE50E4@NAMAIL1.ad.lsil.com>
	 <1195251505.3407.30.camel@localhost.localdomain>
	 <9738BCBE884FDB42801FAD8A7769C26501C9A4AF@NAMAIL1.ad.lsil.com>
	 <1205824386.7238.7.camel@pcp021067pcs.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51264 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbYCQUdy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 16:33:54 -0400
In-Reply-To: <1205824386.7238.7.camel@pcp021067pcs.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, neela.kolli@lsi.com, bo.yang@lsi.com

Add the new Controller (ID: 007C) support to driver.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |    7 +++++--
 drivers/scsi/megaraid/megaraid_sas.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -rupN linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.c	2008-03-17 13:53:49.000000000 -0400
+++ linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.c	2008-03-17 13:53:10.000000000 -0400
@@ -68,6 +68,8 @@ static struct pci_device_id megasas_pci_
 	/* xscale IOP */
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1078R)},
 	/* ppc IOP */
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1078DE)},
+	/* ppc IOP */
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_VERDE_ZCR)},
 	/* xscale IOP, vega */
 	{PCI_DEVICE(PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DELL_PERC5)},
@@ -1471,7 +1473,7 @@ megasas_transition_to_ready(struct megas
 			instance->instancet->disable_intr(instance->reg_set);
 			writel(MFI_RESET_FLAGS, &instance->reg_set->inbound_doorbell);
 
-			max_wait = 10;
+			max_wait = 60;
 			cur_state = MFI_STATE_OPERATIONAL;
 			break;
 
@@ -1991,7 +1993,8 @@ static int megasas_init_mfi(struct megas
 
 	switch(instance->pdev->device)
 	{
-		case PCI_DEVICE_ID_LSI_SAS1078R:	
+		case PCI_DEVICE_ID_LSI_SAS1078R:
+		case PCI_DEVICE_ID_LSI_SAS1078DE:
 			instance->instancet = &megasas_instance_template_ppc;
 			break;
 		case PCI_DEVICE_ID_LSI_SAS1064R:
diff -rupN linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.h	2008-03-07 14:29:14.000000000 -0500
+++ linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.h	2008-03-07 14:10:12.000000000 -0500
@@ -26,6 +26,7 @@
  * Device IDs
  */
 #define	PCI_DEVICE_ID_LSI_SAS1078R		0x0060
+#define	PCI_DEVICE_ID_LSI_SAS1078DE		0x007C
 #define	PCI_DEVICE_ID_LSI_VERDE_ZCR		0x0413
 
 /*

