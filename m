From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/8] exofs: Kbuild, Headers and osd utils
Date: Tue, 17 Feb 2009 09:20:55 +0900
Message-ID: <20090217092042C.fujita.tomonori@lab.ntt.co.jp>
References: <49992F99.1060404@panasas.com>
	<20090216183750H.fujita.tomonori@lab.ntt.co.jp>
	<49993FF2.9050200@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49993FF2.9050200@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, avishay@gmail.com, jeff@garzik.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 16 Feb 2009 12:29:06 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> >>>> exofs is not the first and only file system who is using bios. Proof of
> >>>> the matter is that block exports a bio submit routine.
> >>> Seems that exofs just passes pages and the ULD sends a SCSI command
> >>> including these pages. I don't see how exofs needs to handle bio
> >>> directly.
> >>>
> >> How do you propose to collect these pages? and keep them without allocating
> >> an extra list? without pre-allocating a struct request? and without re-inventing
> >> the bio structure?
> > 
> > I don't think that allocating an extra list (or something) to keep
> > them hurts performance. We can talk about it when you have the real
> > performance results.
> 
> So you are the one that starts to invent the wheel here. I thought I was
> the one that does that, only you only called me by names, because you never showed
> me where.
> 
> But please only answer one question for me: Please don't write back if you do not
> answer this question:
> 
> Why do other filesystems allow to use bios? are they going to stop? Who is going
> to remove that?

Can you stop the argument, "exofs is similar to the existing
traditional file systems hence it should be treated equally". It's
simply untrue. Does anyone except for panasas people insist the same
argument?

We are talking about the design of exofs, which also affects the
design of OSD ULD (including the library) living in SCSI
mid-layer. It's something completely different from existing
traditional file systems that work nicely on the top of the block
layer.

As discussed in another thread, now OSD ULD reinvents the bio handling
infrastructure because of the design of exofs. But OSD ULD can use the
block layer helper functions to avoid the re-invention if we change
the exofs design to take pages instead of bios. For now, it works
perfectly for exofs. In the future, we might change it but we don't
know until you submit patches (or the performance results) that show
taking pages doesn't work for exofs nicely.

I guess that we need to evolve the block layer to support OSD stuff
cleanly than we've discussed recently. But again we can do when we
definitely need to do.
