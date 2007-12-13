From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
Date: Thu, 13 Dec 2007 21:05:25 +0100
Message-ID: <20071213200524.GJ10104@kernel.dk>
References: <47617E72.6080504@rtr.ca> <20071213185326.GQ26334@parisc-linux.org> <4761821F.3050602@rtr.ca> <20071213192633.GD10104@kernel.dk> <4761883A.7050908@rtr.ca> <476188C4.9030802@rtr.ca> <20071213193937.GG10104@kernel.dk> <47618B0B.8020203@rtr.ca> <20071213195350.GH10104@kernel.dk> <47618F27.6020906@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47618F27.6020906@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Mark Lord <lkml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 13 2007, Mark Lord wrote:
> Jens Axboe wrote:
> >On Thu, Dec 13 2007, Mark Lord wrote:
> >>Jens Axboe wrote:
> >>>On Thu, Dec 13 2007, Mark Lord wrote:
> >>>>Mark Lord wrote:
> >>>>>Jens Axboe wrote:
> >>>>>>On Thu, Dec 13 2007, Mark Lord wrote:
> >>>>>>>Matthew Wilcox wrote:
> >>>>>>>>On Thu, Dec 13, 2007 at 01:48:18PM -0500, Mark Lord wrote:
> >>>>>>>>>Problem confirmed.  2.6.23.8 regularly generates segments up to 
> >>>>>>>>>64KB for libata,
> >>>>>>>>>but 2.6.24 uses only 4KB segments and a *few* 8KB segments.
> >>>>>>>>Just a suspicion ... could this be slab vs slub?  ie check your 
> >>>>>>>>configs
> >>>>>>>>are the same / similar between the two kernels.
> >>>>>>>..
> >>>>>>>
> >>>>>>>Mmmm.. a good thought, that one.
> >>>>>>>But I just rechecked, and both have CONFIG_SLAB=y
> >>>>>>>
> >>>>>>>My guess is that something got changed around when Jens
> >>>>>>>reworked the block layer for 2.6.24.
> >>>>>>>I'm going to dig around in there now.
> >>>>>>I didn't rework the block layer for 2.6.24 :-). The core block layer
> >>>>>>changes since 2.6.23 are:
> >>>>>>
> >>>>>>- Support for empty barriers. Not a likely candidate.
> >>>>>>- Shared tag queue fixes. Totally unlikely.
> >>>>>>- sg chaining support. Not likely.
> >>>>>>- The bio changes from Neil. Of the bunch, the most likely suspects in
> >>>>>>this area, since it changes some of the code involved with merges and
> >>>>>>blk_rq_map_sg().
> >>>>>>- Lots of simple stuff, again very unlikely.
> >>>>>>
> >>>>>>Anyway, it sounds odd for this to be a block layer problem if you do 
> >>>>>>see
> >>>>>>occasional segments being merged. So it sounds more like the input 
> >>>>>>data
> >>>>>>having changed.
> >>>>>>
> >>>>>>Why not just bisect it?
> >>>>>..
> >>>>>
> >>>>>Because the early 2.6.24 series failed to boot on this machine
> >>>>>due to bugs in the block layer -- so the code that caused this 
> >>>>>regression
> >>>>>is probably in the stuff from before the kernels became usable here.
> >>>>..
> >>>>
> >>>>That sounds more harsh than intended --> the earlier 2.6.24 kernels (up 
> >>>>to
> >>>>the first couple of -rc* ones failed here because of incompatibilities
> >>>>between the block/bio changes and libata.
> >>>>
> >>>>That's better, I think! 
> >>>No worries, I didn't pick it up as harsh just as an odd conclusion :-)
> >>>
> >>>If I were you, I'd just start from the first -rc that booted for you. If
> >>>THAT has the bug, then we'll think of something else. If you don't get
> >>>anywhere, I can run some tests tomorrow and see if I can reproduce it
> >>>here.
> >>..
> >>
> >>I believe that *anyone* can reproduce it, since it's broken long before
> >>the requests ever get to SCSI or libata.  Which also means that *anyone*
> >>who wants to can bisect it, as well.
> >>
> >>I don't do "bisects".
> >
> >It was just a suggestion on how to narrow it down, do as you see fit.
> >
> >>But I will dig a bit more and see if I can find the culprit.
> >
> >Sure, I'll dig around as well.
> ..
> 
> I wonder if it's 9dfa52831e96194b8649613e3131baa2c109f7dc:
>     "Merge blk_recount_segments into blk_recalc_rq_segments" ?
> 
> That particular commit does some rather innocent code-shuffling,
> but also introduces a couple of new "if (nr_hw_segs == 1" conditions
> that were not there before.

You can try and revert it of course, but I think you are looking at the
wrong bits. If the segment counts were totally off, you'd never be
anywhere close to reaching the set limit. Your problems seems to be
missed contig segment merges.

> Okay git experts:  how do I pull out a kernel at the point of this exact 
> commit ?

Dummy approach - git log and grep for
9dfa52831e96194b8649613e3131baa2c109f7dc, then see what commit is before
that. Then do a git checkout commit.

-- 
Jens Axboe

