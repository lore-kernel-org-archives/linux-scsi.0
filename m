From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 23:35:52 -0400
Message-ID: <20181027033552.GA29237@thunk.org>
References: <20181025213144.GB24709@flashbox>
 <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
 <20181025225548.GA10326@flashbox>
 <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
 <1540576908.66186.103.camel@acm.org>
 <CAKwvOdnYx60JkJHJkD7CYA9yx5Oa7Tn9q4aZ3-tcZGx++yoduQ@mail.gmail.com>
 <1540589437.66186.124.camel@acm.org>
 <CAKwvOdm-xYRqCBXhLC1ceC44_rEmggW4qiSgGpRkpL+p-NadVg@mail.gmail.com>
 <1540591147.66186.127.camel@acm.org>
 <CAKwvOdmUhtK10cbYFoEJJp4O8LA_F-+f68A_NcL_fm_FH6QodA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOdmUhtK10cbYFoEJJp4O8LA_F-+f68A_NcL_fm_FH6QodA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: bvanassche@acm.org, Linus Torvalds <torvalds@linux-foundation.org>, ooo@electrozaur.com, Nathan Chancellor <natechancellor@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 26, 2018 at 03:07:39PM -0700, Nick Desaulniers wrote:
> > That's not completely correct. The standard approach to check whether or not
> > a driver is still being used is to check its git history. If the number of
> > contributors is low and it was several years ago that a new feature was added
> > or a bug has been fixed it is likely that nobody is using that driver anymore.
> 
> I don't disagree with you, I just don't see how what you state can be
> reconciled with Linus' response in
> https://lkml.org/lkml/2018/10/27/44.  Those two viewpoints seem
> incompatible to me, but maybe there's a nuance I'm missing?

So a couple of observations.  Obviously, drivers, file systems and
architectures *have* been removed.  It can be done; sometimes if it
can be demonstrate that it can't possibly work (for example, due to
bitrot, the kernel would immediately crashed if anyone tried to use
the code in question :-).

In other cases, drivers has been removed through the staging
subsystem, sometimes by adding a "depends on BROKEN" in the Kconfig
file, and seeing if anyone complains --- since removing a "depends on
BROKEN" line in Kconfig is even easier than doing reverting a git
commit (especially if the user downloaded a tarball instead of doing a
git clone).

If you've done your due diligence then the chances that you have to
revert a change which disables and later removes the dead code can be
pushed close to zero.  The question is whether it's worth the effort.

> Nathan and I are just pointing out a small fix to eliminate a small
> warning, deleting all this code does kind of feels like "throwing out
> the baby with the bath water." A nuclear option for what would be a
> small change otherwise.  Maybe it's good to discuss the EOL for
> exofs/osd, but can we please decouple that conversation from the small
> change Nathan and I are proposing?

The second observation I'll make is that if someone is proposing a
cleanup patch, it's unfair to dump on the person proposing the cleanup
patch the (non-trivial) effort to drop a driver/file system/subsystem.

If the maintainer wants to drop a driver/file system, that should be
the maintainer's responsibiltiy; not someone proposing a
cleanup/maintenance patch.

						- Ted
