From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Fri, 21 Apr 2006 16:20:37 -0700
Message-ID: <20060421162037.418cb843.rdunlap@xenotime.net>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
	<20060413132932.31871824.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604132256490.4711@poirot.grange>
	<20060419172733.d61e3365.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604212341260.3237@poirot.grange>
	<20060421150423.1416908a.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604220024540.3237@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:41684 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750750AbWDUXSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Apr 2006 19:18:11 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2006 16:18:10 -0700
In-Reply-To: <Pine.LNX.4.60.0604220024540.3237@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, Sebastian@schnapsleichen.de, roubert@df.lth.se, lenehan@twibble.org

On Sat, 22 Apr 2006 00:30:34 +0200 (CEST) Guennadi Liakhovetski wrote:

> On Fri, 21 Apr 2006, Randy.Dunlap wrote:
> 
> > My current (ugly, debug) patch is at
> >   http://www.xenotime.net/linux/patches/aha152x-sg-pio.patch 
> 
> A couple of quick notes:
> 
> 1. You have to disable local interrupts before (scsi_)kmap_atomic(_sg)() 
> and restore them after (scsi_)kunmap_atomic(_sg)() (didn't check the 
> context of your patch, so, maybe it is already the case, if not, please, 
> fix)

It wasn't there but I saw other recent patches like that, so I
was aware of it.  Fixed now.

> 2. You have to initialise your sg_len variable before calling 
> scsi_kmap_atomic_sg()

Oops, fixing that one.

and added the flush_kernel_dcache_page() call too.

Thanks.
---
~Randy
