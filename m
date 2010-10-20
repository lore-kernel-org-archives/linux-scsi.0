From: Benjamin LaHaise <bcrl@kvack.org>
Subject: [RFC/PATCH] add PCI id for HighPoint RocketRAID 2720 to mvsas
Date: Wed, 20 Oct 2010 18:31:10 -0400
Message-ID: <20101020223110.GT2315@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:33224 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab0JTXFD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2010 19:05:03 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi folks,

I recently built a system using the HighPoint 2720 SAS controller, which 
is based on the Marvell 88SE9485.  In my limited testing (read: it boots), 
the following patch is needed to get mvsas to recognize the board.  With 
this patch, the system boots without issue and SATA passthrough seems to 
work.  Note that I have not tested the board with any SAS drives, as I 
only have SATA drives at present.  Any thoughts/comments on if anything 
further is needed for this board?

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 19ad34f..4590faa 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -648,6 +648,15 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
 	{ PCI_VDEVICE(MARVELL, 0x6320), chip_6320 },
 	{ PCI_VDEVICE(MARVELL, 0x6340), chip_6440 },
+	{	/* HighPoint RocketRAID 2720 */
+		.vendor 	= 0x1103,
+		.device 	= 0x2720,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= 0x0000,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_1320,
+	},
 	{
 		.vendor 	= PCI_VENDOR_ID_MARVELL,
 		.device 	= 0x6440,
 		.subvendor	= PCI_ANY_ID,
