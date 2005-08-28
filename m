From: Jens Axboe <axboe@suse.de>
Subject: Re: libata: clustering on or off?
Date: Sun, 28 Aug 2005 16:20:19 +0200
Message-ID: <20050828142018.GS4018@suse.de>
References: <20050828094218.GA29145@havoc.gtf.org> <1125224541.3219.13.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1125224541.3219.13.camel@laptopd505.fenrus.org>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 28 2005, Arjan van de Ven wrote:
> On Sun, 2005-08-28 at 05:42 -0400, Jeff Garzik wrote:
> > The constant ATA_SHT_USE_CLUSTERING in include/linux/libata.h controls
> > the use of SCSI layer's use_clustering feature, for a great many libata
> > drivers.
> > 
> > The current setup has clustering disabled, which in theory causes the
> > block layer to do less work, at the expense of a greater number of
> > scatter/gather table entries used.
> > 
> > Any opinions WRT turning on clustering for libata?
> 
> in 2.4 clustering was expensive due to a large number of checks that
> were done (basically the number of fragments got recounted a gazilion
> times). In 2.6 Jens fixed that afaik to make it basically free...
> at which point it's a win always.

Yeah, it wont cost any extra cycles, so there's no point in keeping it
turned off for that reason.

> Imo clustering on the driver level should announce driver capabilities.
> If clustering for some arch/kernel makes it slower, that should be
> decided at a midlayer level and not in each driver; eg the midlayer
> would chose to ignore the drivers capabilities.
> So .. my opinion would be that libata should announce the capability (it
> seems the code/hw can do it). 

Agree, we should just remove the ability to control clustering, as it
really overlaps with the segment settings anyways.

-- 
Jens Axboe

