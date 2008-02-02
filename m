From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Date: Sat, 02 Feb 2008 10:01:09 -0600
Message-ID: <1201968069.3187.5.camel@localhost.localdomain>
References: <20080201231147.GA18174@suse.de>
	 <20080202111322.GA30767@elte.hu>  <47A49171.2000003@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53018 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754460AbYBBQBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Feb 2008 11:01:21 -0500
In-Reply-To: <47A49171.2000003@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, pcihpd-discuss@lists.sourceforge.net, linux-scsi <linux-scsi@vger.kernel.org>


On Sat, 2008-02-02 at 10:51 -0500, Jeff Garzik wrote:
> Ingo Molnar wrote:
> > ===================================================================
> > --- linux.orig/drivers/scsi/lpfc/lpfc_init.c
> > +++ linux/drivers/scsi/lpfc/lpfc_init.c
> > @@ -1894,7 +1894,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
> >  	uint16_t iotag;
> >  	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
> >  
> > -	if (pci_enable_device_bars(pdev, bars))
> > +	if (pci_enable_device_io(pdev))
> >  		goto out;
> 
> Look at the line right above it...  AFAICS you want 
> pci_enable_device_mem(), if the mask is selecting IORESOURCE_MEM BARs.
> 
> Also a CC to linux-scsi and the driver author would be nice, as they are 
> the ones with hardware and can verify.
> 
> This set of changes seemed like 50% guesswork to me, without consulting 
> the authors :(  And unlike many changes, you actually have to know the 
> hardware [or get clues from surrounding code] to make the change.

Jeff is right, this fix is wrong.

The correct fix is here:

http://marc.info/?l=linux-scsi&m=120196768605031

Ingo, could you please cc linux-scsi on your mails ... it would have
been a complete disaster to have this incorrect patch go in.

James


