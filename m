From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: LSI MegaRAID not recognised correctly in 64-bit.  2.6.29.6
Date: Mon, 21 Sep 2009 22:51:16 +0900
Message-ID: <20090921225015B.fujita.tomonori@lab.ntt.co.jp>
References: <4AB48254.4000404@attglobal.net>
	<20090919165404D.fujita.tomonori@lab.ntt.co.jp>
	<4AB4F792.8020308@attglobal.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:45543 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbZIUNvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Sep 2009 09:51:25 -0400
In-Reply-To: <4AB4F792.8020308@attglobal.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stunnel@attglobal.net, James.Bottomley@suse.de
Cc: fujita.tomonori@lab.ntt.co.jp, matthew@wil.cx, linux-scsi@vger.kernel.org, bo.yang@lsi.com

On Sat, 19 Sep 2009 08:24:02 -0700
Eddie <stunnel@attglobal.net> wrote:

> FUJITA Tomonori wrote:
> > Thanks, now the problem is clear; the driver uses 64bit dma_mask but
> > the hardware is not capable of 64bit dma according to James. Seems
> > that hardware lies about the dma capability.
> >
> > Can you try the following patch?
> >
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> > index 234f0b7..9ead856 100644
> > --- a/drivers/scsi/megaraid/megaraid_mbox.c
> > +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> > @@ -888,6 +888,8 @@ megaraid_init_mbox(adapter_t *adapter)
> >  	if (((magic64 == HBA_SIGNATURE_64_BIT) &&
> >  		((adapter->pdev->subsystem_device !=
> >  		PCI_SUBSYS_ID_MEGARAID_SATA_150_6) &&
> > +		(adapter->pdev->device !=
> > +		PCI_DEVICE_ID_AMI_MEGARAID3) &&
> >  		(adapter->pdev->subsystem_device !=
> >  		PCI_SUBSYS_ID_MEGARAID_SATA_150_4))) ||
> >  		(adapter->pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC &&
> >
> >   
> OK, that appears to have done the trick.

Thanks for the confirmation.

James, here's a patch in the proper format.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] megaraid: use 32bit DMA mask for AMI Megaraid3

The hardware says that it supports 64bit DMA however it doesn't. This
patch always uses 32bit DMA mask.

Reported-by: Eddie <stunnel@attglobal.net>
Tested-by: Eddie <stunnel@attglobal.net>
Cc: stable@kernel.org
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/megaraid/megaraid_mbox.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 234f0b7..9ead856 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -888,6 +888,8 @@ megaraid_init_mbox(adapter_t *adapter)
 	if (((magic64 == HBA_SIGNATURE_64_BIT) &&
 		((adapter->pdev->subsystem_device !=
 		PCI_SUBSYS_ID_MEGARAID_SATA_150_6) &&
+		(adapter->pdev->device !=
+		PCI_DEVICE_ID_AMI_MEGARAID3) &&
 		(adapter->pdev->subsystem_device !=
 		PCI_SUBSYS_ID_MEGARAID_SATA_150_4))) ||
 		(adapter->pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC &&
-- 
1.6.0.6

