From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
Date: Tue, 3 Jan 2012 09:59:22 -0800
Message-ID: <20120103175922.GC31746@google.com>
References: <20111222234639.GS17084@google.com>
 <20111223004244.GU17084@google.com>
 <alpine.LSU.2.00.1112232058550.3225@eggly.anvils>
 <20111225010238.GA6013@htj.dyndns.org>
 <alpine.LSU.2.00.1112280010550.1398@eggly.anvils>
 <20111228164836.GP17712@google.com>
 <alpine.LSU.2.00.1112280939390.3320@eggly.anvils>
 <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com>
 <20111228211918.GA3516@google.com>
 <20120103173500.GB31746@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120103173500.GB31746@google.com>
Sender: linux-next-owner@vger.kernel.org
To: Hugh Dickins <hughd@google.com>, Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, again.

Adding Shaohua Li as he fixed a similar issue in 4a0b75c7d0 "block,
cfq: fix empty queue crash caused by request merge".  The original
thread can be read from

  http://thread.gmane.org/gmane.linux.kernel.next/20064/focus=3D20159

On Tue, Jan 03, 2012 at 09:35:00AM -0800, Tejun Heo wrote:
> Happy new year, guys.
>=20
> On Wed, Dec 28, 2011 at 01:19:18PM -0800, Tejun Heo wrote:
> > > On Wed, Dec 28, 2011 at 9:50 AM, Hugh Dickins <hughd@google.com> =
wrote:
> > > > "It's the tmpfs swapping test that I've been running, with vari=
ations,
> > > > for years. =A0System booted with mem=3D700M and 1.5G swap, two =
repetitious
> > > > make -j20 kernel builds (of a 2.6.24 kernel: I stuck with that =
because
> > > > the balance of built to unbuilt source grows smaller with later=
 kernels),
> > > > one directly in a tmpfs, the other in a 1k-block ext2 (that I d=
rive with
> > > > ext4's CONFIG_EXT4_USE_FOR_EXT23) on /dev/loop0 on a 450MB tmpf=
s file."
> > > >
> > > > I doubt much of that (quoted from an older mail to someone else=
 about
> > > > one of the many other bugs it's found) is relevant: maybe just =
plenty
> > > > of file I/O and swapping.
> > >=20
> > > Plain -j4 build isn't triggering anything.  I'll try to replicate=
 the condition.
> >=20
> > It's not too reliable but I can reproduce it with -j 22 allmodconfi=
g
> > build inside qemu w/ 512M of memory.  I'll try to find out what's
> > going on.
>=20
> I misread the code, the problem is empty cfqq on the cfq prio tree.  =
I
> don't think this is caused by recent io_context changes.  It looks
> like somebody is forgetting to remove cfqq from the dispatch prio tre=
e
> after emptying a cfqq by removing a request from it.  Jens, any ideas=
?

That should have been service tree.  I couldn't find more missing
removals other than the one Shaohua's patch already fixed.  Close
cooperator selection in cfq_select_queue() seems suspicious tho.  I
can't see what prevents it from returning an empty coopeator cfqq.
I'm trying to verify whether that's the case.  Will update when I know
more.

Thanks.

--=20
tejun
