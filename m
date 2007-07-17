From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 14:52:52 -0500
Message-ID: <1184701972.3378.23.camel@localhost.localdomain>
References: <20070717065940.GZ5195@kernel.dk>
	 <20070717160816K.fujita.tomonori@lab.ntt.co.jp>
	 <20070717071045.GD5195@kernel.dk>
	 <20070717190705T.fujita.tomonori@lab.ntt.co.jp>
	 <20070717101928.GK5195@kernel.dk>
	 <1184698434.3378.15.camel@localhost.localdomain>
	 <20070717124810.cdf54572.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S936146AbXGQTxe@vger.kernel.org>
In-Reply-To: <20070717124810.cdf54572.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2007-07-17 at 12:48 -0700, Andrew Morton wrote:
> On Tue, 17 Jul 2007 13:53:54 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Tue, 2007-07-17 at 12:19 +0200, Jens Axboe wrote:
> > > > > Since Linus is happily snoring by now, could you test and see if the
> > > > > tree works for you?
> > > > 
> > > > It works for me. I'll submit some minor patches against your bsg
> > > > branch to scsi-ml. Can you push them together?
> > > 
> > > Certainly, I'll pull them into the bsg branch.
> > 
> > While you're at it, here's a patch to separate BSG and SCSI again (so
> > SCSI can be built modular).  The way I did it was simply to move the
> > SCSI specific logic into SCSI.  When you come up with a generic way to
> > register the bsg requiring drivers, then we can move it out again.
> 
> I note that block/scsi_ioctl.c is geting compiled with CONFIG_SCSI=n. 
> Seems odd.

No, that's fine ... the reason scsi_ioctl.c moved to block was precisely
so that non SCSI devices could use the ioctls, thus it should be there
even if SCSI is not.

> (Actually, it's failing to compile (in the middle of the bsg series) so I need
> to fix it by hand somehow to continue this bisect)

I generally use quilt to help with this (just quilt up the fix and apply
and remove it around the bisects).  I seem to get tons of trees with
unrelated breakage right around where the voyager failures are.

James
