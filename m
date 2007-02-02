From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6.20-rc6] pktcdvd doesn't work
Date: Fri, 2 Feb 2007 06:32:00 +0100
Message-ID: <20070202053200.GZ3754@stusta.de>
References: <20070130195319.GA10994@dreamland.darkstar.lan> <20070131233044.GX3754@stusta.de> <20070201230752.GA17679@dreamland.darkstar.lan> <20070201182147.2835668e.akpm@osdl.org> <20070202023343.GY3754@stusta.de> <20070201200712.3b48311a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57275 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423121AbXBBFby (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 00:31:54 -0500
Content-Disposition: inline
In-Reply-To: <20070201200712.3b48311a.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Feb 01, 2007 at 08:07:12PM -0800, Andrew Morton wrote:
> On Fri, 2 Feb 2007 03:33:43 +0100 Adrian Bunk <bunk@stusta.de> wrote:
> 
> > On Thu, Feb 01, 2007 at 06:21:47PM -0800, Andrew Morton wrote:
> > > On Fri, 2 Feb 2007 00:07:52 +0100 Luca Tettamanti <kronos.it@gmail.com> wrote:
> > > 
> > > > Il Thu, Feb 01, 2007 at 12:30:44AM +0100, Adrian Bunk ha scritto: 
> > > > > On Tue, Jan 30, 2007 at 08:53:19PM +0100, Luca Tettamanti wrote:
> > > > > > Hi,
> > > > > > pktcdvd on kernel 2.6.20-rc6 is not working as expected. Any file that
> > > > > > is written to the device is lost after umount.
> > > > > > I rarely use pktcdvd but at some point it used to work on my system.
> > > > > > 
> > > > > > This is what I'm doing:
> > > > > > 
> > > > > > root@dreamland:/tmp# cdrwtool -d /dev/scd0 -q
> > > > > > using device /dev/scd0
> > > > > > 1029KB internal buffer
> > > > > > setting write speed to 12x
> > > > > > Settings for /dev/scd0:
> > > > > >         Fixed packets, size 32
> > > > > >         Mode-2 disc
> > > > > >...
> > > > > 
> > > > > Does 2.6.20-rc7 work?
> > > > > If no, does it work after applying the attached patch?
> > > > > If no, does 2.6.19.2 work?
> > > > 
> > > > Git current + the following patch works.
> > > > 
> > > > > diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> > > > > index 6246219..7c95c76 100644
> > > > > --- a/drivers/block/pktcdvd.c
> > > > > +++ b/drivers/block/pktcdvd.c
> > > > > @@ -765,34 +765,47 @@ static inline struct bio *pkt_get_list_first(struct bio **list_head, struct bio
> > > > >   */
> > > > >  static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *cgc)
> > > > >  {
> > > > > -	request_queue_t *q = bdev_get_queue(pd->bdev);
> > > > > +	char sense[SCSI_SENSE_BUFFERSIZE];
> > > 
> > > Where did this patch come from?
> > 
> > It's a revert of the commits 3b00315799d78f76531b71435fbc2643cd71ae4c 
> > and 406c9b605cbc45151c03ac9a3f95e9acf050808c
> > 
> 
> Oh.  That's
> 
>  [SCSI] untangle scsi_prep_fn
> and	
>  [PATCH] Fix BUG at drivers/scsi/scsi_lib.c:1118 caused by "pktsetup dvd /dev
> 
> so this is a post-2.6.18 regression, yes?

No, a post-2.6.19 regression.

> do we know why this is happening?

No.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

