From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Fri, 21 Apr 2006 16:54:41 -0700
Message-ID: <20060421165441.69617da9.rdunlap@xenotime.net>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
	<1145054008.3520.69.camel@mulgrave.il.steeleye.com>
	<Pine.LNX.4.60.0604212258570.3237@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:50570 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750772AbWDUXwR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Apr 2006 19:52:17 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2006 16:52:15 -0700
In-Reply-To: <Pine.LNX.4.60.0604212258570.3237@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, Sebastian@schnapsleichen.de, roubert@df.lth.se, lenehan@twibble.org

On Fri, 21 Apr 2006 23:00:14 +0200 (CEST) Guennadi Liakhovetski wrote:

> On Fri, 14 Apr 2006, James Bottomley wrote:
> 
> > On Sun, 2006-04-02 at 21:57 +0200, Guennadi Liakhovetski wrote:
> > > +                               if (fc == 0x40 &&
> > > (srb->dcb->sync_period & WIDE_SYNC)) {
> > > +                                       /* Read the last byte ... */
> > > +                                       if (srb->total_xfer_length >
> > > 0) {
> > > +                                               u8 byte =
> > > DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
> > > +
> > > +                                               *virt++ = byte;
> > > +                                               srb->total_xfer_length--;
> > > +                                               if
> > > (debug_enabled(DBG_PIO))
> > > +                                                       printk(" %
> > > 02x", byte);
> > > +                                       }
> > > +
> > > +                                       DC395x_write8(acb,
> > > TRM_S1040_SCSI_CONFIG2, 0);
> > > +                               }
> > > +
> > > +                               if (srb->cmd->use_sg) {
> > > +                                       scsi_kunmap_atomic_sg(base);
> > 
> > I put this in, but just a warning here.  You're modifying a kmapped
> > page, so you need to call flush_kernel_dcache_page() before unmapping it
> > otherwise user space may not see the change on VIPT or VIVT CPU (the
> > data may be in a non congruent cache line).
> 
> Does the patch below get it right?
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> diff -ur a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> --- a/drivers/scsi/dc395x.c	2006-04-20 00:42:12.000000000 +0200
> +++ b/drivers/scsi/dc395x.c	2006-04-20 00:41:58.000000000 +0200
> @@ -2343,6 +2343,7 @@
>  				}
>  
>  				if (srb->cmd->use_sg) {
> +					flush_kernel_dcache_page(kmap_atomic_to_page(base));
>  					scsi_kunmap_atomic_sg(base);
>  					local_irq_restore(flags);
>  				}
> -

Looks right to me, but why not have scsi_kunmap_atomic_sg() do that
instead of every caller having to do it?  Is there some good reason
not to do that?


---
~Randy
