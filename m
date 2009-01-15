From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Mainline kernel OLTP performance update
Date: Wed, 14 Jan 2009 18:21:47 -0700
Message-ID: <20090115012147.GW29283@parisc-linux.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com> <20090114163557.11e097f2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39823 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZAOBWG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2009 20:22:06 -0500
Content-Disposition: inline
In-Reply-To: <20090114163557.11e097f2.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

On Wed, Jan 14, 2009 at 04:35:57PM -0800, Andrew Morton wrote:
> On Tue, 13 Jan 2009 15:44:17 -0700
> "Wilcox, Matthew R" <matthew.r.wilcox@intel.com> wrote:
> >
> 
> (top-posting repaired.  That @intel.com address is a bad influence ;))

Alas, that email address goes to an Outlook client.  Not much to be done
about that.

> (cc linux-scsi)
> 
> > > This is latest 2.6.29-rc1 kernel OLTP performance result. Compare to
> > > 2.6.24.2 the regression is around 3.5%.
> > > 
> > > Linux OLTP Performance summary
> > > Kernel#            Speedup(x)   Intr/s  CtxSw/s us%  sys%   idle%  iowait%
> > > 2.6.24.2                1.000   21969   43425   76   24     0      0
> > > 2.6.27.2                0.973   30402   43523   74   25     0      1
> > > 2.6.29-rc1              0.965   30331   41970   74   26     0      0

> But the interrupt rate went through the roof.

Yes.  I forget why that was; I'll have to dig through my archives for
that.

> A 3.5% slowdown in this workload is considered pretty serious, isn't it?

Yes.  Anything above 0.3% is statistically significant.  1% is a big
deal.  The fact that we've lost 3.5% in the last year doesn't make
people happy.  There's a few things we've identified that have a big
effect:

 - Per-partition statistics.  Putting in a sysctl to stop doing them gets
   some of that back, but not as much as taking them out (even when
   the sysctl'd variable is in a __read_mostly section).  We tried a
   patch from Jens to speed up the search for a new partition, but it
   had no effect.

 - The RT scheduler changes.  They're better for some RT tasks, but not
   the database benchmark workload.  Chinang has posted about
   this before, but the thread didn't really go anywhere.
   http://marc.info/?t=122903815000001&r=1&w=2

SLUB would have had a huge negative effect if we were using it -- on the
order of 7% iirc.  SLQB is at least performance-neutral with SLAB.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
