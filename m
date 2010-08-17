From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
Date: Tue, 17 Aug 2010 18:31:45 -0400
Message-ID: <20100817223145.GC4641@Krystal>
References: <20100817220917.GA5268@Krystal> <4C6B097E.7060505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C6B097E.7060505@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

* Jiri Slaby (jirislaby@gmail.com) wrote:
> On 08/18/2010 12:09 AM, Mathieu Desnoyers wrote:
> > This is with these changes applied:
> 
> Hi, these are very wrong. Please use ones from:
> http://lkml.org/lkml/2010/8/12/98

Yep, my system boot fine now.

Any plans to fast-track these fixes to mainline ?

Thanks,

Mathieu

> 
> (there are three of them)
> 
> > --- linux.trees.git.orig/drivers/md/raid1.c	2010-08-17 17:40:52.000000000 -0400
> > +++ linux.trees.git/drivers/md/raid1.c	2010-08-17 17:42:59.000000000 -0400
> > @@ -787,7 +787,7 @@ static int make_request(mddev_t *mddev,
> >  	struct bio_list bl;
> >  	struct page **behind_pages = NULL;
> >  	const int rw = bio_data_dir(bio);
> > -	const bool do_sync = (bio->bi_rw & REQ_SYNC);
> > +	const bool do_sync = (bio->bi_rw & REQ_SYNC) != 0;
> >  	bool do_barriers;
> >  	mdk_rdev_t *blocked_rdev;
> >  
> ...
> 
> regards,
> -- 
> js

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
