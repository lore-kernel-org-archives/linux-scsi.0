From: "Mark Nelson" <mdnelson8@gmail.com>
Subject: [PATCH] ahci: Add support for Promise PDC42819
Date: Thu, 23 Oct 2008 14:08:16 +1100
Message-ID: <65a6ef750810222008o139600e3o8d7c7cf50a4e4ea0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:57609 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYJWDIS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 23:08:18 -0400
Received: by gxk9 with SMTP id 9so626373gxk.13
        for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2008 20:08:17 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, mikpe@it.uu.se, linux-scsi@vger.kernel.org

Add an appropriate entry for the Promise PDC42819 controller. It has an
AHCI mode and so far works correctly with board_ahci.

This chip is found on Promise's FastTrak TX2650 (2 port) and TX4650 (4 port)
software-based RAID cards (for which there is a binary driver, t3sas) and
can be found on some motherboards, for example the MSI K9A2 Platinum,
which calls the chip a Promise T3 controller.

Although this controller also supports SAS devices, its default bootup mode
is AHCI and the binary driver has to do some magic to get the chip into the
appropriate mode to drive SAS disks.

Seeing as no documentation is provided by Promise, adding this entry to the
ahci driver allows the controller to be useful to people as a SATA
controller (with no ill effects on the system if a SAS disk is connected -
probing of the port just times out with "link online but device
misclassified"), without having to resort to using the binary driver. Users
who require SAS or the proprietary software raid can get this functionality
using the binary driver.

Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
---
 drivers/ata/ahci.c |    3 +++
 1 file changed, 3 insertions(+)

Index: libata-dev/drivers/ata/ahci.c
===================================================================
--- libata-dev.orig/drivers/ata/ahci.c
+++ libata-dev/drivers/ata/ahci.c
@@ -588,6 +588,9 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */

+	/* Promise */
+	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
