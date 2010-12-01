From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/1] hpsa: fix redefinition of PCI_DEVICE_ID_CISSF
Date: Wed, 1 Dec 2010 11:16:07 -0600
Message-ID: <20101201171607.GA17943@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, hplk@lists.hp.com
List-Id: linux-scsi@vger.kernel.org

Patch 1 of 1

hpsa: a pci device ID is defined twice

From: Mike Miller <mike.miller@hp.com>

PCI_DEVICE_ID_CISSF is defined as 323b in pci_ids.h but redefined as 3fff in
hpsa.c. The ID of 3fff will _never_ ship as a standalone controller. It is
intended only as part a complete storage solution. As such, this patch
removes the redefinition and the StorageWorks P1210m from the product table.

It also removes a duplicate line for the "unknown" controller support.
---
 drivers/scsi/hpsa.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b2fb2b2..a6dea08 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -90,11 +90,7 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
-#define PCI_DEVICE_ID_HP_CISSF 0x333f
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x333F},
-	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
-	{PCI_VENDOR_ID_COMPAQ,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
+	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
 };
@@ -113,8 +109,6 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324a103C, "Smart Array P712m", &SA5_access},
 	{0x324b103C, "Smart Array P711m", &SA5_access},
-	{0x3233103C, "StorageWorks P1210m", &SA5_access},
-	{0x333F103C, "StorageWorks P1210m", &SA5_access},
 	{0x3250103C, "Smart Array", &SA5_access},
 	{0x3250113C, "Smart Array", &SA5_access},
 	{0x3250123C, "Smart Array", &SA5_access},
