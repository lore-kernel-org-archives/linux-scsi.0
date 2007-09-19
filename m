From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH] Use legacy driver for NetRAID 1M/2M controllers
Date: Wed, 19 Sep 2007 12:46:02 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229C97E9E@NAMAIL2.ad.lsil.com>
References: <20070919010441.GA4802@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61615 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760667AbXISSqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Sep 2007 14:46:12 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070919010441.GA4802@ldl.fc.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dann frazier <dannf@hp.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>
Cc: linux-scsi@vger.kernel.org

NACK.

ID being added is already supported in megaraid_mbox driver.
Please use megaraid_mbox driver. 

--Sumant

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of dann frazier
Sent: Tuesday, September 18, 2007 6:05 PM
To: DL-MegaRAID Linux
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] Use legacy driver for NetRAID 1M/2M controllers

Debian has had a long-standing bug concerning certain NetRAID
controllers that were moved over to the megaraid driver:
  http://bugs.debian.org/317258

The reporters claim that the legacy driver works just fine for
them. I've been unable to reproduce this with the 2M cards I have
access to, which use the following firmware revs:

BIOS     Firmware
-----------------
G.02.03  H.02.00
J.01.01  K.01.03

As these cards work fine with both the new and legacy drivers, and
there are cards known to only work with the legacy driver, please
consider the following patch which moves the support of these cards
back to the legacy driver.

Signed-off-by: dann frazier <dannf@hp.com>

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 3907f67..ac96dbb 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -24,6 +24,7 @@
  *
  * Supported controllers: MegaRAID 418, 428, 438, 466, 762, 467, 471,
490, 493
  *					518, 520, 531, 532
+ *			  NetRAID 1M, 2M
  *
  * This driver is supported by LSI Logic, with assistance from Red Hat,
Dell,
  * and others. Please send updates to the mailing list
@@ -4967,6 +4968,10 @@ static struct pci_device_id megaraid_pci_tbl[] =
{
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
+		HP_SUBSYS_VID, PCI_SUBSYS_ID_HP_NETRAID_1M, 0, 0, 0},
+	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
+		HP_SUBSYS_VID, PCI_SUBSYS_ID_HP_NETRAID_2M, 0, 0, 0},
 	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index ee70bd4..697276a 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -84,6 +84,10 @@
 #define LSI_SUBSYS_VID			0x1000
 #define INTEL_SUBSYS_VID		0x8086
 
+/* Sub-System Device IDs */
+#define PCI_SUBSYS_ID_HP_NETRAID_1M	0x60E7
+#define PCI_SUBSYS_ID_HP_NETRAID_2M	0x60E8
+
 #define HBA_SIGNATURE	      		0x3344
 #define HBA_SIGNATURE_471	  	0xCCCC
 #define HBA_SIGNATURE_64BIT		0x0299
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c
b/drivers/scsi/megaraid/megaraid_mbox.c
index 4963b96..0d74241 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -443,6 +443,14 @@ megaraid_probe_one(struct pci_dev *pdev, const
struct pci_device_id *id)
 	con_log(CL_ANN, ("bus %d:slot %d:func %d\n", pdev->bus->number,
 		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn)));
 
+	/* Some NetRAID 1M and 2M controllers still need the legacy
driver */
+	if (pdev->vendor == PCI_VENDOR_ID_AMI && \
+		    pdev->device == PCI_DEVICE_ID_AMI_MEGARAID3 && \
+		    pdev->subsystem_vendor == PCI_VENDOR_ID_HP && \
+		    (pdev->subsystem_device ==
PCI_SUBSYS_ID_HP_NETRAID_1M || \
+		     pdev->subsystem_device ==
PCI_SUBSYS_ID_HP_NETRAID_2M))
+		return -ENODEV;
+
 	if (pci_enable_device(pdev)) {
 		con_log(CL_ANN, (KERN_WARNING
 				"megaraid: pci_enable_device
failed\n"));
diff --git a/drivers/scsi/megaraid/megaraid_mbox.h
b/drivers/scsi/megaraid/megaraid_mbox.h
index 2e760c2..c66d107 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.h
+++ b/drivers/scsi/megaraid/megaraid_mbox.h
@@ -89,6 +89,8 @@
 #define PCI_SUBSYS_ID_PERC3_DC				0x0493
 #define PCI_SUBSYS_ID_PERC3_SC				0x0475
 
+#define PCI_SUBSYS_ID_HP_NETRAID_1M			0x60E7
+#define PCI_SUBSYS_ID_HP_NETRAID_2M			0x60E8
 
 #define MBOX_MAX_SCSI_CMDS	128	// number of cmds reserved for
kernel
 #define MBOX_MAX_USER_CMDS	32	// number of cmds for
applications
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
