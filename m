From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 1/3] hpsa: remove unneeded loop
Date: Tue, 6 Aug 2013 10:46:15 -0500
Message-ID: <20130806154615.GA1986@beardog.cce.hp.com>
References: <51FA5E7A.9050000@redhat.com> <20130801133951.GX24664@beardog.cce.hp.com> <51FA6B20.2090005@redhat.com> <20130801142123.GA24664@beardog.cce.hp.com> <51FA77E1.5010200@redhat.com> <20130801151917.GB24664@beardog.cce.hp.com> <51FA8138.1070306@redhat.com> <20130801161853.GC24664@beardog.cce.hp.com> <51FB9477.2000608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:34625 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3HFPqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Aug 2013 11:46:16 -0400
Content-Disposition: inline
In-Reply-To: <51FB9477.2000608@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

On Fri, Aug 02, 2013 at 01:13:59PM +0200, Tomas Henzl wrote:
> On 08/01/2013 06:18 PM, scameron@beardog.cce.hp.com wrote:
> > On Thu, Aug 01, 2013 at 05:39:36PM +0200, Tomas Henzl wrote:
> >> On 08/01/2013 05:19 PM, scameron@beardog.cce.hp.com wrote:
> > [...]
> >
> >>>> Btw. on line 1284 - isn't it similar to patch 2/3 ?
> > ^^^ Oh, missed this the first time around, the sop driver uses the make_request_fn()
> > interface, and it's not a stacked driver either, so there is no limit to the number
> > of bios the block layer can stuff in -- make_request_fn must succeed.
> > If we get full we just chain them together using pointers already in the struct
> > bio for that purpose, so storing them in the driver requires no memory allocation
> > on the driver's part.  So while it's somewhat similar, we already have to handle
> > the case of the block layer stuffing infinite bios into the driver, so getting
> > full is not terribly out of the ordinary in that driver.
> 
> OK.
> 
> >
> > That being said, I'm poking around other bits of code lying around here
> > looking for similar problems, so thanks again for that one.
> >
> >>> find_first_zero_bit is not atomic, but the test_and_set_bit, which is what
> >>> counts, is atomic.   That find_first_zero_bit is not atomic confused me about
> >>> this code for a long time, and is why the spin lock was there in the first
> >>> place.  But if there's a race on the find_first_zero_bit and it returns the
> >>> same bit to multiple concurrent threads, only one thread will win the
> >>> test_and_set_bit, and the other threads will go back around the loop to try
> >>> again, and get a different bit.
> >> Yes.
> >> But, let's expect just one zero bit at the end of the list. The find_first_zero_bit(ffzb)
> >> starts now,  thread+1 zeroes a new bit at the beginning, ffzb continues,
> >> thread+2 takes the zero bit at the end. The result it that ffzb hasn't found a zero bit
> >> even though that at every moment that bit was there.Ffter that the function returns -EBUSY.
> >> rc = (u16) find_first_zero_bit(qinfo->request_bits, qinfo->qdepth);
> >> if (rc >= qinfo->qdepth-1)
> >> 	return (u16) -EBUSY;
> >> Still, I think that this is almost impossible, and if it should happen
> >> a requeue is not so bad.
> > Oh, wow.  Didn't think of that.  Hmm, technically no guarantee that
> > any given thread would ever get a bit, if all the other threads keep
> > snatching them away just ahead of an unlucky thread.
> >
> > Could we, instead of giving up, go back around and try again on the theory
> > that some bits should be free in there someplace and the thread shouldn't
> > be infinitely unlucky?
> 
> In theory that gives you also no guarantee, it's likely that for a guarantee some
> kind of locking is needed, the spinlock, which already is there, gives you that. 
> Otoh, a very high likelihood is probably enough and give better overall throughput,
> maybe some statistics/testing is needed? I don't know how much faster is it
> without the spinlock.

On thinking about this a bit more, it would be a shame if we closed the
hole allowing the "cmd_alloc returned NULL" message (the scsi_done() cmd_free()
race) and then immediately opened up another different hole that permitted the
same problem to occur. 

So to be safe, I think we should go with your patch as is -- leave
the spin lock, but get rid of the unnecessary loop.

-- steve

