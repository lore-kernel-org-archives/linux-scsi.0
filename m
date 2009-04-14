From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
	blk_rq_map_kern_sgl()
Date: Wed, 15 Apr 2009 08:44:31 +0900
Message-ID: <20090415084431H.fujita.tomonori@lab.ntt.co.jp>
References: <20090413125912.GA16337@liondog.tnic>
	<20090414093401V.fujita.tomonori@lab.ntt.co.jp>
	<20090414100131.GA14646@liondog.tnic>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:58847 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbZDNXpq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2009 19:45:46 -0400
In-Reply-To: <20090414100131.GA14646@liondog.tnic>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: petkovbb@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, tj@kernel.org, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, bzolnier@gmail.com, linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 12:01:31 +0200
Borislav Petkov <petkovbb@googlemail.com> wrote:

> (adding Bart to CC)
> 
> On Tue, Apr 14, 2009 at 09:44:31AM +0900, FUJITA Tomonori wrote:
> > On Mon, 13 Apr 2009 14:59:12 +0200
> > Borislav Petkov <petkovbb@googlemail.com> wrote:
> > 
> > > Hi,
> > > 
> > > On Mon, Apr 13, 2009 at 07:07:58PM +0900, FUJITA Tomonori wrote:
> > > > On Mon, 13 Apr 2009 18:38:23 +0900
> > > > Tejun Heo <tj@kernel.org> wrote:
> > > > 
> > > > > FUJITA Tomonori wrote:
> > > > > >> I thought that was agreed and done? What is left to do for that to go
> > > > > >> in.
> > > > > > 
> > > > > > I've converted all the users (sg, st, osst). Nothing is left. So we
> > > > > > don't need this.
> > > > > 
> > > > > Yeah, pulled it.  Okay, so we can postpone diddling with request
> > > > > mapping for now.  I'll re-post fixes only from this and the previous
> > > > > patchset and proceed with other patchsets.
> > > > 
> > > > To be honest, I don't think that we can clean up the block
> > > > mapping. For example, blk_rq_map_kern_prealloc() in your patchset
> > > > doesn't look cleanup to me. It's just moving a hack from ide to the
> > > > block (well, I have to admit that I did the same thing when I
> > > > converted sg/st/osst...).
> > > 
> > > Well, since blk_rq_map_kern_prealloc() is going to be used only in
> > > ide-cd (driver needs it to queue a sense request from within the irq
> > > handler) and since it is considered a hack I could try to move it out of
> > > the irq handler
> > 
> > It's quite nice if you could do that.
> > 
> > But I think that ide-atapi also needs blk_rq_map_kern_prealloc().
> 
> I'll look into that too.

Great, thanks!


> > > and do away only with blk_rq_map_kern() if that is more
> > > of an agreeable solution?
> > 
> > Yeah, blk_rq_map_kern() is much proper.
> 
> How's that for starters? I know, it is rough but it seems to work
> according to my initial testing.
> 
> Basically, I opted for preallocating a sense request in the ->do_request
> routine and do that only on demand, i.e. I reinitialize it only if it
> got used in the irq handler. So in case you want to shove a rq sense in
> front of the queue, you simply use the already prepared one. Then in the
> irq handler it is being finished the usual ways (blk_end_request). Next
> time around you ->do_request, you reallocate it again since it got eaten
> in the last round.

Sounds a workable solution.


> The good thing is that now I don't need all those static block layer
> structs in the driver (bio, bio_vec, etc) and do the preferred dynamic
> allocation instead.

That's surely good.

Well, if you could remove the usage of request structure that are not
came from blk_get_request, it will be super. But it's a different
topic and Tejun can go forward without such change.


> The patch is ontop of Tejun's series at
> http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=ide-phase1
> with some small modifications in commit 15783b1443f810ae72cb5ccb3a3a3ccc3aeb8729
> wrt proper sense buffer length.

I think that Tejun will drop some of the patchset. At least, we don't
need blk_rq_map_kern_prealloc stuff. I think that Tejun doesn't need
to play with the mapping API. Well, we need to play with the mapping
API for OSD but it's not directly related with the block layer
cleanups necessary for the libata SCSI separation.

Tejun?
