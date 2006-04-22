From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Sat, 22 Apr 2006 21:41:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604222138300.3186@poirot.grange>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
 <1145054008.3520.69.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.60.0604212258570.3237@poirot.grange> <20060421165441.69617da9.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38791 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751396AbWDWMcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Apr 2006 08:32:07 -0400
In-Reply-To: <20060421165441.69617da9.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Sebastian@schnapsleichen.de, roubert@df.lth.se, lenehan@twibble.org

On Fri, 21 Apr 2006, Randy.Dunlap wrote:

> On Fri, 21 Apr 2006 23:00:14 +0200 (CEST) Guennadi Liakhovetski wrote:
> 
> > diff -ur a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> > --- a/drivers/scsi/dc395x.c	2006-04-20 00:42:12.000000000 +0200
> > +++ b/drivers/scsi/dc395x.c	2006-04-20 00:41:58.000000000 +0200
> > @@ -2343,6 +2343,7 @@
> >  				}
> >  
> >  				if (srb->cmd->use_sg) {
> > +					flush_kernel_dcache_page(kmap_atomic_to_page(base));
> >  					scsi_kunmap_atomic_sg(base);
> >  					local_irq_restore(flags);
> >  				}
> > -
> 
> Looks right to me, but why not have scsi_kunmap_atomic_sg() do that
> instead of every caller having to do it?  Is there some good reason
> not to do that?

I wouldn't do it for a couple of reasons:

1. kmap_atomic / kunmap_atomic pair doesn't do that

2. You only need it if you write to the newly-mapped page. Not if you read 
from it.

You could add a new function line unmap_flush() or an extra parameter, but 
that would just obfuscate things?

Thanks
Guennadi
---
Guennadi Liakhovetski
