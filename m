From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] sr: fix multi-drive performance, remove BKL
 replacement
Date: Tue, 28 Feb 2012 09:00:01 -0600
Message-ID: <1330441201.2822.126.camel@dabdike.int.hansenpartnership.com>
References: <20120228153244.70413d34@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120228153244.70413d34@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-02-28 at 15:32 +0100, Stefan Richter wrote:
> Commit 2a48fc0ab242 "block: autoconvert trivial BKL users to private
> mutex" and other commits at the time mechanically swapped BKL for
> per-driver global mutexes.  If the sr driver is any indication, these
> replacements have still not been checked by anybody for their
> necessessity, removed where possible, or the sections they serialize
> reduced to a necessary minimum.
> 
> The sr_mutex in particular very noticably degraded performance of
> CD-DA ripping with multiple drives in parallel.  When several
> instances of "grip" are used with two or more drives, their GUIs
> became laggier, as did the KDE file manager GUI, and drive utilization
> was reduced.  (During ripping, drive lights flicker instead of staying
> on most of the time.)  IOW time to rip a stack of CDs was increased.
> I didn't measure this but it is highly noticeable.
> 
> On the other hand, I don't see what state sr_mutex would protect.
> So I removed it entirely and that works fine for me.
> 
I'm afraid you can't do that:  The problem is that we have an entangled
set of reference counts that need to be taken and released atomically.
If we don't surround them with a mutex you get undefined results from
racing last release with new acquire.  You can see this usage in sd.c.

The sr.c use case looks like bd_mutex would mediate ... but that's
because it doesn't use driver shutdown and has no power management
functions ... I think I have vague memories that someone is working on
pm for cdroms?

I don't think the mutex needs to be on the ioctls, though, which is
what's causing your performance problems, right?

James
