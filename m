From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 0/3] cciss rmmod/scan-thread fixes
Date: Thu, 16 Jul 2009 05:45:42 +0000
Message-ID: <1247723142.25954.86.camel@grinch>
References: <20090714220239.22282.44414.stgit@bob.kio>
	 <20090715150809.8fd350b9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757531AbZGPFpt@vger.kernel.org>
In-Reply-To: <20090715150809.8fd350b9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-07-15 at 15:08 -0700, Andrew Morton wrote:
> On Tue, 14 Jul 2009 16:02:40 -0600
> Andrew Patterson <andrew.patterson@hp.com> wrote:
> 
> > The following series fixes several problems causing hangs while
> > rmmoding the cciss driver. In the process of fixing these hangs, I
> > also reworked the the logical drive scanning kernel thread to use one
> > thread per driver rather than one thread per controller. I also added
> > a sysfs attribute to kick off a controller scan.
> > 
> >  .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +
> >  drivers/block/cciss.c                              |  198 ++++++++++++++++++--
> >  drivers/block/cciss.h                              |    7 +
> >  3 files changed, 188 insertions(+), 24 deletions(-)
> > 
> > Andrew Patterson (3):
> >       cciss: remove logical drive sysfs entries during driver cleanup.
> >       cciss: use only one scan thread
> >       cciss: kick off logical drive topology rescan through sysfs
> > 
> 
> So I assume that these are intended to fix the problem which
> cciss-fix-the-termination-of-the-scanning-thread.patch didn't fix?

Correct. As well as a lot of the race conditions during cleanup.

> 
> Once we get this all sorted out, which kernel version(s) are we
> targetting and why?

The current problems this patchset tries to solve is that rmmod of the
module hangs along with logical hot remove.

I was hoping to get these in as soon as possible. It looks like the
sysfs additions and the scan_thread patches initially went into 2.6.30
(if my limited git-fu is telling me correctly), so I can't call this a
regression.  I guess 2.6.32 then.

> 
> Thanks.
> 
-- 
Andrew Patterson
Hewlett-Packard
