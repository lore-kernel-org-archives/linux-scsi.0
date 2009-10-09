From: Sachin Sant <sachinp@in.ibm.com>
Subject: [PATCH] drivers/ata/ahci build break.
Date: Fri, 09 Oct 2009 11:57:46 +0530
Message-ID: <4ACED7E2.2010108@in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070905000207010709010504"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:38898 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbZJIG2l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2009 02:28:41 -0400
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id n996IDtg002319
	for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2009 17:18:13 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n996PPQ21769510
	for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2009 17:25:27 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n996RpN6012950
	for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2009 17:27:51 +1100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>

This is a multi-part message in MIME format.
--------------070905000207010709010504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On a Powerpc box latest git (2.6.32-rc3-git2: 36a07902...) failed to build with
following error :

drivers/ata/ahci.c: In function 'ahci_gtf_filter_workaround':
drivers/ata/ahci.c:2927: error: 'struct ata_device' has no member named
'gtf_filter'
make[2]: *** [drivers/ata/ahci.o] Error 1

The code was introduced by f80ae7e45a0e03da188494c6e947a5c8b0cdfb4a.

CONFIG_ATA_ACPI is not set in this case.

The following patch fixes the build break for me.

Signed-off-by : Sachin Sant <sachinp@in.ibm.com>
---




--------------070905000207010709010504
Content-Type: text/x-patch;
 name="fix-ata-ahci-build-break.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-ata-ahci-build-break.patch"

With !CONFIG_ATA_ACPI drivers/ata build breaks with following error

drivers/ata/ahci.c: In function 'ahci_gtf_filter_workaround':
drivers/ata/ahci.c:2927: error: 'struct ata_device' has no member named
'gtf_filter'
make[2]: *** [drivers/ata/ahci.o] Error 1

Box the function within CONFIG_ATA_ACPI.

Signed-off-by : Sachin Sant <sachinp@in.ibm.com>
---
diff -Naurp old/drivers/ata/ahci.c new/drivers/ata/ahci.c
--- old/drivers/ata/ahci.c	2009-10-09 11:34:28.000000000 +0530
+++ new/drivers/ata/ahci.c	2009-10-09 11:36:39.000000000 +0530
@@ -2884,6 +2884,7 @@ static bool ahci_broken_online(struct pc
 	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
 }
 
+#ifdef CONFIG_ATA_ACPI
 static void ahci_gtf_filter_workaround(struct ata_host *host)
 {
 	static const struct dmi_system_id sysids[] = {
@@ -2927,6 +2928,7 @@ static void ahci_gtf_filter_workaround(s
 				dev->gtf_filter |= filter;
 	}
 }
+#endif
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -3093,8 +3095,10 @@ static int ahci_init_one(struct pci_dev
 	/* apply workaround for ASUS P5W DH Deluxe mainboard */
 	ahci_p5wdh_workaround(host);
 
+#ifdef CONFIG_ATA_ACPI
 	/* apply gtf filter quirk */
 	ahci_gtf_filter_workaround(host);
+#endif
 
 	/* initialize adapter */
 	rc = ahci_configure_dma_masks(pdev, hpriv->cap & HOST_CAP_64);

--------------070905000207010709010504--
