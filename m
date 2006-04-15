From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Sat, 15 Apr 2006 22:03:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604152158440.16963@poirot.grange>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
 <1145054008.3520.69.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:65164 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751268AbWDOUDK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 16:03:10 -0400
In-Reply-To: <1145054008.3520.69.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Frei <Sebastian@schnapsleichen.de>, Fredrik Roubert <roubert@df.lth.se>, lenehan@twibble.org

On Fri, 14 Apr 2006, James Bottomley wrote:

> On Sun, 2006-04-02 at 21:57 +0200, Guennadi Liakhovetski wrote:
> > +                               if (fc == 0x40 && (srb->dcb->sync_period & WIDE_SYNC)) {
> > +                                       /* Read the last byte ... */
> > +                                       if (srb->total_xfer_length > 0) {
> > +                                               u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
> > +
> > +                                               *virt++ = byte;
> > +                                               srb->total_xfer_length--;
> > +                                               if (debug_enabled(DBG_PIO))
> > +                                                       printk(" % 02x", byte);
> > +                                       }
> > +
> > +                                       DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
> > +                               }
> > +
> > +                               if (srb->cmd->use_sg) {
> > +                                       scsi_kunmap_atomic_sg(base);
> 
> I put this in, but just a warning here.  You're modifying a kmapped
> page, so you need to call flush_kernel_dcache_page() before unmapping it
> otherwise user space may not see the change on VIPT or VIVT CPU (the
> data may be in a non congruent cache line).

Thanks! Ok, sure, I'll try to cook an incremental patch, perhaps, next 
week. At the same time I'll clean-up comments as suggested by Randy 
Dunlap.

Guennadi
---
Guennadi Liakhovetski
