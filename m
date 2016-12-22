From: Hugh Dickins <hughd@google.com>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Thu, 22 Dec 2016 12:22:27 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1612221204510.4476@eggly.anvils>
References: <20161214222411.GH4326@dastard> <20161214222953.GI4326@dastard> <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org> <20161221221638.GD4758@dastard> <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
 <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org> <20161222051322.GF4758@dastard> <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Johannes Weiner <hannes@cmpxchg.org>, Chris Leech <cleech@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 21 Dec 2016, Linus Torvalds wrote:
> On Wed, Dec 21, 2016 at 9:13 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > There may be deeper issues. I just started running scalability tests
> > (e.g. 16-way fsmark create tests) and about a minute in I got a
> > directory corruption reported - something I hadn't seen in the dev
> > cycle at all.
> 
> By "in the dev cycle", do you mean your XFS changes, or have you been
> tracking the merge cycle at least for some testing?
> 
> > I unmounted the fs, mkfs'd it again, ran the
> > workload again and about a minute in this fired:
> >
> > [628867.607417] ------------[ cut here ]------------
> > [628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461 shadow_lru_isolate+0x171/0x220
> 
> Well, part of the changes during the merge window were the shadow
> entry tracking changes that came in through Andrew's tree. Adding
> Johannes Weiner to the participants.
> 
> > Now, this workload does not touch the page cache at all - it's
> > entirely an XFS metadata workload, so it should not really be
> > affecting the working set code.
> 
> Well, I suspect that anything that creates memory pressure will end up
> triggering the working set code, so ..
> 
> That said, obviously memory corruption could be involved and result in
> random issues too, but I wouldn't really expect that in this code.
> 
> It would probably be really useful to get more data points - is the
> problem reliably in this area, or is it going to be random and all
> over the place.

Data point: kswapd got WARNING on mm/workingset.c:457 in shadow_lru_isolate,
soon followed by NULL pointer deref in list_lru_isolate, one time when
I tried out Sunday's git tree.  Not seen since, I haven't had time to
investigate, just set it aside as something to worry about if it happens
again.  But it looks like shadow_lru_isolate() has issues beyond Dave's
case (I've no XFS and no iscsi), suspect unrelated to his other problems.

Hugh

> 
> That said:
> 
> > And worse, on that last error, the /host/ is now going into meltdown
> > (running 4.7.5) with 32 CPUs all burning down in ACPI code:
> 
> The obvious question here is how much you trust the environment if the
> host ends up also showing problems. Maybe you do end up having hw
> issues pop up too.
> 
> The primary suspect would presumably be the development kernel you're
> testing triggering something, but it has to be asked..
> 
>                      Linus
