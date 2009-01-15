From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 09:44:42 -0800
Message-ID: <20090115094442.b6394544.akpm@linux-foundation.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	<CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	<20090114163557.11e097f2.akpm@linux-foundation.org>
	<20090115012147.GW29283@parisc-linux.org>
	<20090114180431.f4a96543.akpm@linux-foundation.org>
	<1232028766.5966.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762671AbZAORqG@vger.kernel.org>
In-Reply-To: <1232028766.5966.10.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 15 Jan 2009 09:12:46 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2009-01-14 at 18:04 -0800, Andrew Morton wrote:
> > On Wed, 14 Jan 2009 18:21:47 -0700 Matthew Wilcox <matthew@wil.cx> wrote:
> > > On Wed, Jan 14, 2009 at 04:35:57PM -0800, Andrew Morton wrote:
> > > > > > Linux OLTP Performance summary
> > > > > > Kernel#            Speedup(x)   Intr/s  CtxSw/s us%  sys%   idle%  iowait%
> > > > > > 2.6.24.2                1.000   21969   43425   76   24     0      0
> > > > > > 2.6.27.2                0.973   30402   43523   74   25     0      1
> > > > > > 2.6.29-rc1              0.965   30331   41970   74   26     0      0
> > > 
> > > > But the interrupt rate went through the roof.
> > > 
> > > Yes.  I forget why that was; I'll have to dig through my archives for
> > > that.
> > 
> > Oh.  I'd have thought that this alone could account for 3.5%.
> 
> Me too.  Anecdotally, I haven't noticed this in my lab machines, but
> what I have noticed is on someone else's laptop (a hyperthreaded atom)
> that I was trying to demo powertop on was that IPI reschedule interrupts
> seem to be out of control ... they were ticking over at a really high
> rate and preventing the CPU from spending much time in the low C and P
> states.  To me this implicates some scheduler problem since that's the
> primary producer of IPI reschedules ... I think it wouldn't be a
> significant extrapolation to predict that the scheduler might be the
> cause of the above problem as well.
> 

Good point.

The context switch rate actually went down a bit.

I wonder if the Intel test people have records of /proc/interrupts for
the various kernel versions.
