From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 18:24:36 +1100
Message-ID: <200901151824.38658.nickpiggin@yahoo.com.au>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756460AbZAOHZn@vger.kernel.org>
In-Reply-To: <20090114180431.f4a96543.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday 15 January 2009 13:04:31 Andrew Morton wrote:
> On Wed, 14 Jan 2009 18:21:47 -0700 Matthew Wilcox <matthew@wil.cx> wrote:

> > SLUB would have had a huge negative effect if we were using it -- on the
> > order of 7% iirc.  SLQB is at least performance-neutral with SLAB.
>
> We really need to unblock that problem somehow.  I assume that
> enterprise distros are shipping slab?

SLES11 will ship with SLAB, FWIW. As I said in the SLQB thread, this was
not due to my input. But I think it was probably the right choice to make
in that situation.

The biggest problem with SLAB for SGI I think is alien caches bloating the
kmem cache footprint to many GB each on their huge systems, but SLAB has a
parameter to turn off alien caches anyway so I think that is a reasonable
workaround.

Given the OLTP regression, and also I'd hate to have to deal with even
more reports of people's order-N allocations failing... basically with the
regression potential there, I don't think there was a compelling case
found to use SLUB (ie. where does it actually help?).

I'm going to propose to try to unblock the problem by asking to merge SLQB
with a plan to end up picking just one general allocator (and SLOB).

Given that SLAB and SLUB are fairly mature, I wonder what you'd think of
taking SLQB into -mm and making it the default there for a while, to see
if anybody reports a problem?
