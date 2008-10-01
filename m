From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: mac scsi, ncr5380
Date: Wed, 1 Oct 2008 18:04:07 +1000 (EST)
Message-ID: <Pine.LNX.4.64.0810011725330.19896@loopy.telegraphics.com.au>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
 <48DF8398.30000@panasas.com> <20080930084536.GA28524@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loopy.telegraphics.com.au ([202.45.126.152]:38698 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYJAIEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 04:04:09 -0400
In-Reply-To: <20080930084536.GA28524@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>



On Tue, 30 Sep 2008, Christoph Hellwig wrote:

> On Sun, Sep 28, 2008 at 04:16:08PM +0300, Boaz Harrosh wrote:
> > From a SCSI generic point of view. The current xxx_NCR5380 remind me 
> > allot of the old ESP drivers stack. At-least at the surface level of 
> > the patches I sent for both these drivers. I was lucky, at the end, to 
> > only send the xxx_NCR5380 patches, because, as strongly recommended by 
> > Christoph Hellwig (CCed), the old ESP stack was brilliantly replaced 
> > by a new one. That is 1/10 the size of the old one, and currently 
> > supports most of the interesting devices out there. My unsent patches 
> > was a catalyst, for the now broken old-driver-stack, to be removed 
> > quickly. And it seems every one is happy.
> > 
> > My point being, If you are looking to do a major cleanup work, on all 
> > these 1/2 forks. Maybe give a hard thought on just trashing the all 
> > thing and crafting a completely new stack, 1/10 the size and much 
> > simpler, modern, and maintainable.
> 
> That would we very nice.  All 5380 drivers are in a really sorry state, 
> and a new one even if only working for sun3 and atari for now would be a 
> great change.  I'm not even sure if we have any users left for the PC 
> and arm 5380 drivers.

Me neither. And I'd prefer not to worry about the PC and arm drivers. I've 
bitten off more than enough already.

If I follow the ESP model, we'd get something like this:

-atari_NCR5380.c
-atari_scsi.c
-atari_scsi.h
-mac_scsi.c
-mac_scsi.h
-sun3_NCR5380.c
-sun3_scsi.c
-sun3_scsi.c 
-sun3_scsi.h
-sun3_scsi_vme.c
+ncr5380_scsi.c
+ncr5380_scsi.h
+mac_ncr5380.c
+atari_ncr5380.c
+sun3_ncr5380.c
+sun3_vme_ncr5380.c

Which would eliminate some of the duplication. I'd leave the other files 
untouched and let someone else worry about what to do with them -- in the 
hope that a rewrite that meets the needs of atari/sun/mac will at least 
approximate an alternative for the others.

Finn
