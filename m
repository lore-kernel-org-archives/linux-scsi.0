From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Date: Fri, 10 Sep 2010 16:06:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1009101554300.5286@hs20-bc2-1.build.redhat.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
 <1283509796-1510-24-git-send-email-tj@kernel.org>
 <Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com>
 <20100910184652.GA24470@redhat.com> <Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com>
 <20100910192403.GA24582@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab0IJUGh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2010 16:06:37 -0400
In-Reply-To: <20100910192403.GA24582@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, agk@redhat.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, k-ueda@ct.jp.nec.com



On Fri, 10 Sep 2010, Mike Snitzer wrote:

> On Fri, Sep 10 2010 at  3:05pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Fri, 10 Sep 2010, Mike Snitzer wrote:
> > > And in fact, this first patch basically is as minimal as it gets
> > > relative to bio-based DM's conversion to FLUSH+FUA.
> > > 
> > > Please direct your energy and talent in a positive way rather than
> > > starting a potential flame.
> > > 
> > > Thanks,
> > > Mike
> > 
> > I don't want to flame. I mean this:
> > 
> > * person X writes a patch P.
> > * person Y reads P, sees that the condition C is true and writes patch Q 
> > that dependes on condition C.
> > * person X changes a patch P, so that the patch is correct but condition C 
> > is no longer true.
> > 
> > Now, there is a bug in the patch Q and NEITHER X NOR Y can find out about 
> > that bug.
> > 
> > That's why parallel development doesn't work.
> > 
> > If you develop on things in the kernel, it is different.
> > * person X writes a patch P and puts it in the kernel.
> > * person Y reads the kernel code, sees that the condition C is true and 
> > writes a patch Q that assumes that the condition C is true. He puts this 
> > patch to the kernel too.
> > * person X wants to change his code so that the condition C isn't true, 
> > but it is now his responsibility to search the rest of the kernel to see 
> > if it depends on the condition C. He searches the code and finds Q.
> > 
> > This is not a flamewar, just a technical explanation, why I don't want to 
> > develop on interfaces that are not in the kernel.
> 
> We're reasonable people and can certainly prevent a flamewar but what
> you're doing is an elaborate distraction.  The energy it took you to
> write and reason through your logic above could've been used to just
> review the DM FLUSH+FUA patches.

No. If I reviewed 40 patches perfectly, I would take long long time (the 
previous 2-line patch that I reviewed took me a week to review --- but I 
found a flaw that the other people who reviewed it quickly didn't find). 

So I reviewed only "dm" patch and found out that it is too big.

Make a smaller patch with barrier -> FLUSH logic only. And then you can 
make additional patches with function/variable renames or logic changes.

> The various interfaces are hardened now and staged for inclussion in
> 2.6.37.  Jens has already pulled the entire 40+ patchset into his
> for-next branch for wider linux-next testing.
> 
> Tejun, Christoph and others have done an amazing job with this
> conversion.  The fact that Tejun tackled the heavy lifting of DM's
> conversion was unexpected but 100% appreciated (by me and I assume
> others).  Please don't dismiss, or misrepresent the status of, this
> FLUSH+FUA work.

I am not dismissing anything. I agree with barrier -> flush change. It 
simplifies things a lot.

But I have my work rules that I learned: I use no git kernels and no 
external patches (except Alasdair's patchset that I want to test). I only 
use -rc or final kernels. I need a stable computer --- I don't want to 
solve problems like "does it crash because I pulled something or does it 
crash because I made a bug in my code?" So, put that into 2.6.37-rc1 and 
I'll optimize flushes in dm for -rc2 or -rc3.

Mikulas
