From: James.Smart@Emulex.Com
Subject: RE: [PATCH] updated: suspending I/Os to a device
Date: Tue, 10 Aug 2004 17:00:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02D7D3@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:28083 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267700AbUHJVAy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 17:00:54 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

All the comments on names, etc are fine - I'll send an updated patch.

> > +struct device_recover_template {
> > +	/* Device recovery template. */
> > +	unsigned int nodev_timeout;		/* Device 
> suspend timeout value
> > +						 * in seconds. */
> > +	struct timer_list eh_nodev_timeout;	/* Used to 
> timeout the suspend 
> > +						 * state. */
> > +};
> 
> I'm not so sue the separate allocation is worth it or whether 
> we should just
> sick it into the fc transport data.

Well - it's not necessarily fc-specific, as I would assume USB, iSCSI, etc also would like to do the same thing. But, as far as just putting it in the device structure - I had the same thoughts. One thing that influenced this was JamesB's comments on not wanting all devices to have the structure, just those being on LLDD's that need to deal with this.  Note - "recovery" as a name was just randomly picked based on this 1 element. Are there perhaps other things that may fit this same definition (cross transport, but optional) ?  If so - is it better to rename this template ?

Also - does it really make sense to have the midlayer own the timer and calling cancel when it expires ? Or is it better to have the LLDD own it, calling continue when it expires, and letting the subsequent i/o failures take the device offline ?  The midlayer owning the timer seems more protectionist, but is it better ?

-- James S
