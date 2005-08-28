From: Jens Axboe <axboe@suse.de>
Subject: Re: libata: clustering on or off?
Date: Sun, 28 Aug 2005 20:01:56 +0200
Message-ID: <20050828180154.GW4018@suse.de>
References: <20050828094218.GA29145@havoc.gtf.org> <1125224541.3219.13.camel@laptopd505.fenrus.org> <20050828142018.GS4018@suse.de> <4311F519.5050300@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:9399 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1750723AbVH1SCC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Aug 2005 14:02:02 -0400
Content-Disposition: inline
In-Reply-To: <4311F519.5050300@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Sun, Aug 28 2005, Jeff Garzik wrote:
> Jens Axboe wrote:
> >On Sun, Aug 28 2005, Arjan van de Ven wrote:
> >
> >>On Sun, 2005-08-28 at 05:42 -0400, Jeff Garzik wrote:
> >>
> >>>The constant ATA_SHT_USE_CLUSTERING in include/linux/libata.h controls
> >>>the use of SCSI layer's use_clustering feature, for a great many libata
> >>>drivers.
> >>>
> >>>The current setup has clustering disabled, which in theory causes the
> >>>block layer to do less work, at the expense of a greater number of
> >>>scatter/gather table entries used.
> >>>
> >>>Any opinions WRT turning on clustering for libata?
> >>
> >>in 2.4 clustering was expensive due to a large number of checks that
> >>were done (basically the number of fragments got recounted a gazilion
> >>times). In 2.6 Jens fixed that afaik to make it basically free...
> >>at which point it's a win always.
> 
> >Yeah, it wont cost any extra cycles,
> 
> A simple grep for QUEUE_FLAG_CLUSTER-related code shows that it -does- 
> cost extra cycles.

Well yes, none is not true of course. But it's not a lot, like extra
iterations of the request mappings like it used to. So in by far the
most cases, it should be a win overall.

> >>Imo clustering on the driver level should announce driver capabilities.
> >>If clustering for some arch/kernel makes it slower, that should be
> >>decided at a midlayer level and not in each driver; eg the midlayer
> >>would chose to ignore the drivers capabilities.
> >>So .. my opinion would be that libata should announce the capability (it
> >>seems the code/hw can do it). 
> >
> >
> >Agree, we should just remove the ability to control clustering, as it
> >really overlaps with the segment settings anyways.
> 
> OK, I guess the consensus is to use clustering :)
> 
> We'll see if anything blows up in 2.6.14...

;-)

-- 
Jens Axboe

