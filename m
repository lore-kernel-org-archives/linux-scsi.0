From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/9] hpsa: Make "hpsa_allow_any=1" boot param enable Compaq
	Smart Arrays.
Date: Wed, 16 Jun 2010 13:51:20 -0500
Message-ID: <20100616185120.22798.84581.stgit@beardog.cce.hp.com>
References: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22726 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab0FPSqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:46:21 -0400
In-Reply-To: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andriusb@redhat.com, James.Bottomley@HansenPartnership.com, dab@hp.com, thenzl@redhat.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: Make "hpsa_allow_any=1" boot param enable Compaq Smart Arrays.
We were previously only accepting HP boards.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 00b5397..661a320 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -95,6 +95,8 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x333F},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
+	{PCI_VENDOR_ID_COMPAQ,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
 };
 
@@ -3293,7 +3295,9 @@ static int __devinit hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 		if (*board_id == products[i].board_id)
 			return i;
 
-	if (subsystem_vendor_id != PCI_VENDOR_ID_HP || !hpsa_allow_any) {
+	if ((subsystem_vendor_id != PCI_VENDOR_ID_HP &&
+		subsystem_vendor_id != PCI_VENDOR_ID_COMPAQ) ||
+		!hpsa_allow_any) {
 		dev_warn(&pdev->dev, "unrecognized board ID: "
 			"0x%08x, ignoring.\n", *board_id);
 			return -ENODEV;

