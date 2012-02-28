From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] [SCSI] sr: fix multi-drive performance, remove BKL
 replacement
Date: Tue, 28 Feb 2012 17:09:30 +0100
Message-ID: <20120228170930.132f7c1e@stein>
References: <20120228153244.70413d34@stein>
	<1330441201.2822.126.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330441201.2822.126.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

On Feb 28 James Bottomley wrote:
> On Tue, 2012-02-28 at 15:32 +0100, Stefan Richter wrote:
> > Commit 2a48fc0ab242 "block: autoconvert trivial BKL users to private
> > mutex" and other commits at the time mechanically swapped BKL for
> > per-driver global mutexes.  If the sr driver is any indication, these
> > replacements have still not been checked by anybody for their
> > necessessity, removed where possible, or the sections they serialize
> > reduced to a necessary minimum.
> > 
> > The sr_mutex in particular very noticably degraded performance of
> > CD-DA ripping with multiple drives in parallel.  When several
> > instances of "grip" are used with two or more drives, their GUIs
> > became laggier, as did the KDE file manager GUI, and drive utilization
> > was reduced.  (During ripping, drive lights flicker instead of staying
> > on most of the time.)  IOW time to rip a stack of CDs was increased.
> > I didn't measure this but it is highly noticeable.
> > 
> > On the other hand, I don't see what state sr_mutex would protect.
> > So I removed it entirely and that works fine for me.
> > 
> I'm afraid you can't do that:  The problem is that we have an entangled
> set of reference counts that need to be taken and released atomically.
> If we don't surround them with a mutex you get undefined results from
> racing last release with new acquire.  You can see this usage in sd.c.

While I do remove sr_mutex aroud scsi_cd_get/put() calls, these ones
internally use another lock: sr_ref_mutex.  Always did, still do, since
neither Arnd's mechanical BKL pushdown and BKL-to-mutex conversions
patches nor my patch changed that.  This sr_ref_mutex also protects sr's
reference counting outside of the three block_device_operations methods
which I changed.

I suppose I could have mentioned right away in the changelog that the
sr driver's own reference counting serialization remains in place, via that
other mutex.

> The sr.c use case looks like bd_mutex would mediate ... but that's
> because it doesn't use driver shutdown and has no power management
> functions ... I think I have vague memories that someone is working on
> pm for cdroms?
> 
> I don't think the mutex needs to be on the ioctls, though, which is
> what's causing your performance problems, right?

I guess sr_block_open/release are less of an issue; after all they are
still partly serialized across all sr devices (the sections which are
under the mentioned sr_ref_mutex protection).
-- 
Stefan Richter
-=====-===-- --=- ===--
http://arcgraph.de/sr/
