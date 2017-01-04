From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Wed, 4 Jan 2017 10:26:09 -0500 (EST)
Message-ID: <584380074.12440338.1483543569131.JavaMail.zimbra@redhat.com>
References: <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org> <20161222051322.GF4758@dastard> <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com> <alpine.LSU.2.11.1612221204510.4476@eggly.anvils> <20161223073241.GA13584@cmpxchg.org> <20161223083329.GA13952@cmpxchg.org> <20170102211136.GA3189@cmpxchg.org> <20170103122825.GC3780@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170103122825.GC3780@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Chris Leech <cleech@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrea Arcangeli <aarcange@redhat.com>
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Jan Kara" <jack@suse.cz>
> To: "Johannes Weiner" <hannes@cmpxchg.org>
> Cc: "Hugh Dickins" <hughd@google.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner"
> <david@fromorbit.com>, "Chris Leech" <cleech@redhat.com>, "Linux Kernel Mailing List"
> <linux-kernel@vger.kernel.org>, "Lee Duncan" <lduncan@suse.com>, open-iscsi@googlegroups.com, "Linux SCSI List"
> <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, "Christoph Hellwig" <hch@lst.de>, "Jan Kara"
> <jack@suse.cz>, "Andrea Arcangeli" <aarcange@redhat.com>
> Sent: Tuesday, January 3, 2017 7:28:25 AM
> Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at iscsi_tcp_segment_done+0x20d/0x2e0
> 
> On Mon 02-01-17 16:11:36, Johannes Weiner wrote:
> > On Fri, Dec 23, 2016 at 03:33:29AM -0500, Johannes Weiner wrote:
> > > On Fri, Dec 23, 2016 at 02:32:41AM -0500, Johannes Weiner wrote:
> > > > On Thu, Dec 22, 2016 at 12:22:27PM -0800, Hugh Dickins wrote:
> > > > > On Wed, 21 Dec 2016, Linus Torvalds wrote:
> > > > > > On Wed, Dec 21, 2016 at 9:13 PM, Dave Chinner <david@fromorbit.com>
> > > > > > wrote:
> > > > > > > I unmounted the fs, mkfs'd it again, ran the
> > > > > > > workload again and about a minute in this fired:
> > > > > > >
> > > > > > > [628867.607417] ------------[ cut here ]------------
> > > > > > > [628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461
> > > > > > > shadow_lru_isolate+0x171/0x220
> > > > > > 
> > > > > > Well, part of the changes during the merge window were the shadow
> > > > > > entry tracking changes that came in through Andrew's tree. Adding
> > > > > > Johannes Weiner to the participants.
> > > > > > 
> > > > > > > Now, this workload does not touch the page cache at all - it's
> > > > > > > entirely an XFS metadata workload, so it should not really be
> > > > > > > affecting the working set code.
> > > > > > 
> > > > > > Well, I suspect that anything that creates memory pressure will end
> > > > > > up
> > > > > > triggering the working set code, so ..
> > > > > > 
> > > > > > That said, obviously memory corruption could be involved and result
> > > > > > in
> > > > > > random issues too, but I wouldn't really expect that in this code.
> > > > > > 
> > > > > > It would probably be really useful to get more data points - is the
> > > > > > problem reliably in this area, or is it going to be random and all
> > > > > > over the place.
> > > > > 
> > > > > Data point: kswapd got WARNING on mm/workingset.c:457 in
> > > > > shadow_lru_isolate,
> > > > > soon followed by NULL pointer deref in list_lru_isolate, one time
> > > > > when
> > > > > I tried out Sunday's git tree.  Not seen since, I haven't had time to
> > > > > investigate, just set it aside as something to worry about if it
> > > > > happens
> > > > > again.  But it looks like shadow_lru_isolate() has issues beyond
> > > > > Dave's
> > > > > case (I've no XFS and no iscsi), suspect unrelated to his other
> > > > > problems.
> > > > 
> > > > This seems consistent with what Dave observed: we encounter regular
> > > > pages in radix tree nodes on the shadow LRU that should only contain
> > > > nodes full of exceptional shadow entries. It could be an issue in the
> > > > new slot replacement code and the node tracking callback.
> > > 
> > > Both encounters seem to indicate use-after-free. Dave's node didn't
> > > warn about an unexpected node->count / node->exceptional state, but
> > > had entries that were inconsistent with that. Hugh got the counter
> > > warning but crashed on a list_head that's not NULLed in a live node.
> > > 
> > > workingset_update_node() should be called on page cache radix tree
> > > leaf nodes that go empty. I must be missing an update_node callback
> > > where a leaf node gets freed somewhere.
> > 
> > Sorry for dropping silent on this. I'm traveling over the holidays
> > with sporadic access to my emails and no access to real equipment.
> > 
> > The times I managed to sneak away to look at the code didn't turn up
> > anything useful yet.
> > 
> > Andrea encountered the warning as well and I gave him a debugging
> > patch (attached below), but he hasn't been able to reproduce this
> > condition. I've personally never seen the warning trigger, even though
> > the patches have been running on my main development machine for quite
> > a while now. Albeit against an older base; I've updated to Linus's
> > master branch now in case it's an interaction with other new code.
> > 
> > If anybody manages to reproduce this, that would be helpful. Any extra
> > eyes on this would be much appreciated too until I'm back at my desk.
> 
> I was looking into this but I didn't find a way how we could possibly leave
> radix tree node on LRU. So your debug patch looks like a good way forward.
> 
> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Running on 4.10.0-rc2+ and days of ISCSI served XFS load have not reproduced this yet for me with an 4-core (hyper 8) system.
Using ISCSI over Ethernet controller: Intel Corporation Ethernet Connection I217-LM

I will now try with a full offload ISCSI HBA and see if if  have any luck.
