From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Tue, 25 Apr 2006 11:46:49 -0700
Message-ID: <20060425114649.1086b5b7.rdunlap@xenotime.net>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
	<1145054008.3520.69.camel@mulgrave.il.steeleye.com>
	<Pine.LNX.4.60.0604212258570.3237@poirot.grange>
	<20060421165441.69617da9.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604222138300.3186@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:4241 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751172AbWDYSo1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 14:44:27 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2006 11:44:23 -0700
In-Reply-To: <Pine.LNX.4.60.0604222138300.3186@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, Sebastian@schnapsleichen.de, roubert@df.lth.se, lenehan@twibble.org

On Sat, 22 Apr 2006 21:41:53 +0200 (CEST) Guennadi Liakhovetski wrote:

> On Fri, 21 Apr 2006, Randy.Dunlap wrote:
> 
> > On Fri, 21 Apr 2006 23:00:14 +0200 (CEST) Guennadi Liakhovetski wrote:
> > 
> > > diff -ur a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> > > --- a/drivers/scsi/dc395x.c	2006-04-20 00:42:12.000000000 +0200
> > > +++ b/drivers/scsi/dc395x.c	2006-04-20 00:41:58.000000000 +0200
> > > @@ -2343,6 +2343,7 @@
> > >  				}
> > >  
> > >  				if (srb->cmd->use_sg) {
> > > +					flush_kernel_dcache_page(kmap_atomic_to_page(base));
> > >  					scsi_kunmap_atomic_sg(base);
> > >  					local_irq_restore(flags);
> > >  				}
> > > -
> > 
> > Looks right to me, but why not have scsi_kunmap_atomic_sg() do that
> > instead of every caller having to do it?  Is there some good reason
> > not to do that?
> 
> I wouldn't do it for a couple of reasons:
> 
> 1. kmap_atomic / kunmap_atomic pair doesn't do that
> 
> 2. You only need it if you write to the newly-mapped page. Not if you read 
> from it.

That's a very good reason.

> You could add a new function line unmap_flush() or an extra parameter, but 
> that would just obfuscate things?

Yes.

---
~Randy
