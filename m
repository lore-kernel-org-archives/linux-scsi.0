From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Date: Fri, 10 Sep 2010 15:05:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
 <1283509796-1510-24-git-send-email-tj@kernel.org>
 <Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com>
 <20100910184652.GA24470@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100910184652.GA24470@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, agk@redhat.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, k-ueda@ct.jp.nec.com
List-Id: linux-scsi@vger.kernel.org



On Fri, 10 Sep 2010, Mike Snitzer wrote:

> On Fri, Sep 10 2010 at  2:25pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > I quite disagree with the patch. It changes too many things.
> > 
> > What I said and what I want to see:
> > 
> > Take dm code as is. Treat FLUSH requests as empty barriers.
> > 
> > 
> > So I want to see a patch that only changes:
> > 
> > bio_empty_barrier(bio)  ->  bio->bi_rw & REQ_FLUSH
> > WRITE_BARRIER -> WRITE_FLUSH
> > etc.
> > 
> > so that the code compiles and works.
> > 
> > DON'T CHANGE ANYTHING ELSE.
> > 
> > Requirements of flushes are subset of requirements of barriers, so if you 
> > send flush and it is treated as a barrier inside DM, there's no problem. 
> > DM code that I wrote only sends out zero-data barriers and already treats 
> > them as flushes (it doesn't rely on ordering), so there's no problem with 
> > sent requests too.
> > 
> > Once fluges get into kernel, I'll clean it up to allow parallel flushes 
> > and requests, etc. But not before. I don't want to work on an interface 
> > that is under development and may be changed.
> 
> Mikulas,
> 
> I agree that it is unfortunate that we're having to explore this level
> of change to DM's flush support.  Especially given how recently your
> barrier code was added.
> 
> But the work has already been done.  Rather than putting up artificial
> barriers (no pun intended) it'd be great if you took the time to just
> review the changes.
>
> The patch header enumerates and describes the various changes quite
> clearly.
> 
> And in fact, this first patch basically is as minimal as it gets
> relative to bio-based DM's conversion to FLUSH+FUA.
> 
> Please direct your energy and talent in a positive way rather than
> starting a potential flame.
> 
> Thanks,
> Mike

I don't want to flame. I mean this:

* person X writes a patch P.
* person Y reads P, sees that the condition C is true and writes patch Q 
that dependes on condition C.
* person X changes a patch P, so that the patch is correct but condition C 
is no longer true.

Now, there is a bug in the patch Q and NEITHER X NOR Y can find out about 
that bug.

That's why parallel development doesn't work.

If you develop on things in the kernel, it is different.
* person X writes a patch P and puts it in the kernel.
* person Y reads the kernel code, sees that the condition C is true and 
writes a patch Q that assumes that the condition C is true. He puts this 
patch to the kernel too.
* person X wants to change his code so that the condition C isn't true, 
but it is now his responsibility to search the rest of the kernel to see 
if it depends on the condition C. He searches the code and finds Q.

This is not a flamewar, just a technical explanation, why I don't want to 
develop on interfaces that are not in the kernel.

Mikulas
