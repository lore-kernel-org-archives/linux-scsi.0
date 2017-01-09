From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Mon, 9 Jan 2017 21:30:05 +0100
Message-ID: <20170109203005.GE18524@quack2.suse.cz>
References: <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
 <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
 <20161222051322.GF4758@dastard>
 <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
 <alpine.LSU.2.11.1612221204510.4476@eggly.anvils>
 <20161223073241.GA13584@cmpxchg.org>
 <20161223083329.GA13952@cmpxchg.org>
 <20170102211136.GA3189@cmpxchg.org>
 <20170103122825.GC3780@quack2.suse.cz>
 <20170108020200.GA16312@cmpxchg.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBD5LDHXSYUMRBUHFZ7BQKGQEYZPXQ3Y-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <20170108020200.GA16312-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat 07-01-17 21:02:00, Johannes Weiner wrote:
> On Tue, Jan 03, 2017 at 01:28:25PM +0100, Jan Kara wrote:
> > On Mon 02-01-17 16:11:36, Johannes Weiner wrote:
> > > On Fri, Dec 23, 2016 at 03:33:29AM -0500, Johannes Weiner wrote:
> > > > On Fri, Dec 23, 2016 at 02:32:41AM -0500, Johannes Weiner wrote:
> > > > > On Thu, Dec 22, 2016 at 12:22:27PM -0800, Hugh Dickins wrote:
> > > > > > On Wed, 21 Dec 2016, Linus Torvalds wrote:
> > > > > > > On Wed, Dec 21, 2016 at 9:13 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> > > > > > > > I unmounted the fs, mkfs'd it again, ran the
> > > > > > > > workload again and about a minute in this fired:
> > > > > > > >
> > > > > > > > [628867.607417] ------------[ cut here ]------------
> > > > > > > > [628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461 shadow_lru_isolate+0x171/0x220
> > > > > > > 
> > > > > > > Well, part of the changes during the merge window were the shadow
> > > > > > > entry tracking changes that came in through Andrew's tree. Adding
> > > > > > > Johannes Weiner to the participants.
> 
> Okay, the below patch should address this problem. Dave Jones managed
> to reproduce it with the added WARN_ONs, and they made it obvious. He
> cannot trigger it anymore with this fix applied. Thanks Dave!

FWIW the patch looks good to me. I'd just note that the need to pass the
callback to deletion function and the fact that we do it only in cases
where we think it is needed appears errorprone. With the warning you've
added it should at least catch the cases where we got it wrong but more
robust would be if the radix tree root contained a pointer to the callback
function so that we would not rely on passing the callback to every place
which can possibly free a node. Also conceptually this would make more
sense to me since the fact that we may need to do some cleanup on node
deletion is a property of the particular radix tree and how we use it.
OTOH that would mean growing radix tree root by one pointer which would be
unpopular I guess.

								Honza

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
