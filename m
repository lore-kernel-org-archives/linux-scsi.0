From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Date: Fri, 10 Sep 2010 14:46:52 -0400
Message-ID: <20100910184652.GA24470@redhat.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
 <1283509796-1510-24-git-send-email-tj@kernel.org>
 <Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab0IJSrT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2010 14:47:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, agk@redhat.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, k-ueda@ct.jp.nec.com

On Fri, Sep 10 2010 at  2:25pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> I quite disagree with the patch. It changes too many things.
> 
> What I said and what I want to see:
> 
> Take dm code as is. Treat FLUSH requests as empty barriers.
> 
> 
> So I want to see a patch that only changes:
> 
> bio_empty_barrier(bio)  ->  bio->bi_rw & REQ_FLUSH
> WRITE_BARRIER -> WRITE_FLUSH
> etc.
> 
> so that the code compiles and works.
> 
> DON'T CHANGE ANYTHING ELSE.
> 
> Requirements of flushes are subset of requirements of barriers, so if you 
> send flush and it is treated as a barrier inside DM, there's no problem. 
> DM code that I wrote only sends out zero-data barriers and already treats 
> them as flushes (it doesn't rely on ordering), so there's no problem with 
> sent requests too.
> 
> Once fluges get into kernel, I'll clean it up to allow parallel flushes 
> and requests, etc. But not before. I don't want to work on an interface 
> that is under development and may be changed.

Mikulas,

I agree that it is unfortunate that we're having to explore this level
of change to DM's flush support.  Especially given how recently your
barrier code was added.

But the work has already been done.  Rather than putting up artificial
barriers (no pun intended) it'd be great if you took the time to just
review the changes.

The patch header enumerates and describes the various changes quite
clearly.

And in fact, this first patch basically is as minimal as it gets
relative to bio-based DM's conversion to FLUSH+FUA.

Please direct your energy and talent in a positive way rather than
starting a potential flame.

Thanks,
Mike
