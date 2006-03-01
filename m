From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Wed, 1 Mar 2006 21:43:45 +0100
Message-ID: <20060301204345.GP4816@suse.de>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local> <20060301152929.GZ4816@suse.de> <Pine.LNX.4.63.0603012230370.5789@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:35431 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751172AbWCAUoF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 15:44:05 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0603012230370.5789@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Wed, Mar 01 2006, Kai Makisara wrote:
> On Wed, 1 Mar 2006, Jens Axboe wrote:
> 
> > On Tue, Feb 28 2006, Kai Makisara wrote:
> > > This patch enables clustering and sets max_sectors to 0xffff to enable 
> > > reading and writing of large blocks with tapes (and large transfers with 
> > > sg). This change is needed after the sg and st drivers started using 
> > > chained bios through scsi_request_async() in 2.6.16.
> > > 
> > > Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
> > > 
> > > --- linux-2.6.16-rc5/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-04 13:25:48.000000000 +0200
> > > +++ linux-2.6.16-rc5-k1/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-18 09:45:24.000000000 +0200
> > > @@ -1978,7 +1978,8 @@ static struct scsi_host_template sym2_te
> > >  	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
> > >  	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
> > >  	.this_id		= 7,
> > > -	.use_clustering		= DISABLE_CLUSTERING,
> > > +	.use_clustering		= ENABLE_CLUSTERING,
> > > +	.max_sectors		= 0xFFFF,
> > 
> > Strictly speaking, the clustering bit is unrelated.
> 
> It is related. The number of scatter/gather segments in the SCSI HBAs is 
> limited. In order to fit the large requests into these limits, the 
> adjacent pages (that have been split to bios) have to be recombined.

As James also described, you cannot rely on clustering at all to get you
bigger requests. I'm thinking you are perhaps misunderstanding what that
option does - it only potentially limits the number of sg segments in a
request, if the pages happen to be physically contig. So it'll only help
you to a certain degree, IFF the pages are indeed adjacent in memory.
It's an extra optimization that isn't deterministic at all.

And it definitely is unrelated to how many sectors you can support. As
such, these two unrelated patches should submitted seperately. The
clustering bit is potentially more dangerous, as the hardware can have
all sorts of 'issues' related to the size and alignment of sg segments.

> >                                                     I seem to recall
> > Gerard years ago talking about some sym chips that did not like
> > clustering, hence it was disabled.
> > 
> Facts?

I'm just reporting what Gerald (who definitely knows this hardware very
well) told me, when I submitted a patch to him enabling clustering a
long time ago. This might have been about 5 years ago, I seem to recall
it happening when I used a un ultra10 workstation which had a sym scsi
board.

-- 
Jens Axboe

