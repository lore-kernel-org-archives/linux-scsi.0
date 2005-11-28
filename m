From: James.Smart@Emulex.Com
Subject: RE: [PATCH 7/11]  lpfc 8.1.1 : Add support for more members of the Light Pulse 11xxx (4Gb) family
Date: Mon, 28 Nov 2005 12:08:46 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B73@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:28666 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932126AbVK1RI7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 12:08:59 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

There's a couple of other references that can be removed as well.

Rather than back this out of the patch - we'll submit another short patch
which addresses this comment. Patch is done, just need to quickly test it.

Please note: there will be 2 other areas where we will still be accessing
config space:
  - We need the bar value, as the hardware sees it, to program a base
    address it can decode to keep ring accesses on-chip. The current pci
    infrastructure doesn't provide this. (we've talked about this on this
    reflector before).
  - If we reset the card, there were hardware-isms that may erroneously
    drive perr/serr. So, we need to temporarily turn them off while we
    reset. (I believe we went through this as well on this list early on).

-- james

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, November 28, 2005 11:52 AM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 7/11] lpfc 8.1.1 : Add support for more members of
> the Light Pulse 11xxx (4Gb) family
> 
> 
> On Mon, Nov 28, 2005 at 11:42:12AM -0500, 
> James.Smart@Emulex.Com wrote:
> > -	pci_read_config_dword(phba->pcidev, PCI_VENDOR_ID, &id);
> > +	pci_read_config_word(phba->pcidev, PCI_DEVICE_ID, &dev_id);
> 
> please don't read the pci id directly, alway use pdev->device
> 
> 
