From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] hpsa: fix redefinition of PCI_DEVICE_ID_CISSF
Date: Wed, 1 Dec 2010 14:47:48 -0800
Message-ID: <20101201144748.cd01d4d1.akpm@linux-foundation.org>
References: <20101201171607.GA17943@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240Ab0LAWx1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2010 17:53:27 -0500
In-Reply-To: <20101201171607.GA17943@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, hplk@lists.hp.com

On Wed, 1 Dec 2010 11:16:07 -0600
Mike Miller <mike.miller@hp.com> wrote:

> hpsa: a pci device ID is defined twice
> 
> From: Mike Miller <mike.miller@hp.com>
> 
> PCI_DEVICE_ID_CISSF is defined as 323b in pci_ids.h but redefined as 3fff in
> hpsa.c. The ID of 3fff will _never_ ship as a standalone controller. It is
> intended only as part a complete storage solution. As such, this patch
> removes the redefinition and the StorageWorks P1210m from the product table.
> 
> It also removes a duplicate line for the "unknown" controller support.

It is missing a signed-off-by:, and please quote the warning message
when fixing warnings.

Also, this patch fixes a bug, doesn't it?  323b controllers simply
won't work?

James, it's needed in .37 please.


From: Mike Miller <mike.miller@hp.com>

drivers/scsi/hpsa.c:93:1: warning: "PCI_DEVICE_ID_HP_CISSF" redefined
In file included from include/linux/pci.h:58,
                 from drivers/scsi/hpsa.c:25:
include/linux/pci_ids.h:746:1: warning: this is the location of the previous definition

PCI_DEVICE_ID_CISSF is defined as 323b in pci_ids.h but redefined as 3fff in
hpsa.c. The ID of 3fff will _never_ ship as a standalone controller. It is
intended only as part a complete storage solution. As such, this patch
removes the redefinition and the StorageWorks P1210m from the product table.

It also removes a duplicate line for the "unknown" controller support.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-fix-redefinition-of-pci_device_id_cissf drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-fix-redefinition-of-pci_device_id_cissf
+++ a/drivers/scsi/hpsa.c
@@ -90,11 +90,7 @@ static const struct pci_device_id hpsa_p
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
_

