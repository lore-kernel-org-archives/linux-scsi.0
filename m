From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and usb-storage
Date: Thu, 20 Nov 2003 17:28:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311201728.51200.oliver@neukum.org>
References: <20031120065353.GW1106@suse.de> <Pine.LNX.4.44L0.0311201015030.878-100000@ida.rowland.org> <20031120153026.GB1106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.kontent.de ([81.88.34.36]:54170 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S261956AbTKTQaL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 11:30:11 -0500
In-Reply-To: <20031120153026.GB1106@suse.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, Alan Stern <stern@rowland.harvard.edu>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

 
> > The answer seems very simple.  There should be a host template entry for
> > dma buffer alignment (there's already a dma_boundary member).  It would be
> > copied into the device's request queue stucture if it is nonzero,
> > overriding the default value of 512.  sg and st should check the user
> > buffer against the request queue's dma_alignment mask and avoid doing
> > direct I/O if the alignment is wrong -- just fall back to normal I/O.
> > 
> > Any objections to this scheme?
> 
> Well yes, that's what my objection is against - adding that member. Did
> you not read any of my mails? And it's quite simple why - basically
> noone will add it, so it'll end up being 512 anyways.

But neither sg nor st currently honor the 512 byte alignment requirement.
Whether this really hurts st in terms of performance is another question.

	Regards
		Oliver

