From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: blk-mq vs kmemleak
Date: Tue, 7 Jul 2015 11:33:23 +0100
Message-ID: <20150707103323.GA13228@e104818-lin.cambridge.arm.com>
References: <20150703161137.GA10438@codemonkey.org.uk>
 <5596C080.4050009@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu-smtp-delivery-143.mimecast.com ([207.82.80.143]:28046 "EHLO
	eu-smtp-delivery-143.mimecast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbbGGKd1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jul 2015 06:33:27 -0400
In-Reply-To: <5596C080.4050009@sandisk.com>
Content-Language: en-US
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jul 03, 2015 at 06:04:00PM +0100, Bart Van Assche wrote:
> On 07/03/15 09:11, Dave Jones wrote:
> > After a fuzzing run recently, I noticed that the machine had oom'd, and
> > killed everything, but there was still 3GB of memory still in use, that
> > I couldn't even reclaim with /proc/sys/vm/drop_caches
> >
> > So I enabled kmemleak. After applying this..
> >
> > diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> > index cf79f110157c..6dc18dbad9ec 100644
> > --- a/mm/kmemleak.c
> > +++ b/mm/kmemleak.c
> > @@ -553,8 +553,8 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
> >
> >          object = kmem_cache_alloc(object_cache, gfp_kmemleak_mask(gfp));
> >          if (!object) {
> > -               pr_warning("Cannot allocate a kmemleak_object structure\n");
> > -               kmemleak_disable();
> > +               //pr_warning("Cannot allocate a kmemleak_object structure\n");
> > +               //kmemleak_disable();
> >                  return NULL;
> >          }
> >
> > otherwise it would disable itself within a minute of runtime.
> >
> > I notice now that I'm seeing a lot of traces like this..
> >
> >
> > unreferenced object 0xffff8800ba8202c0 (size 320):
> >    comm "kworker/u4:1", pid 38, jiffies 4294741176 (age 46887.690s)
> >    hex dump (first 32 bytes):
> >      21 43 65 87 00 00 00 00 00 00 00 00 00 00 00 00  !Ce.............
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

If kmemleak fails to allocate its metadata, the object referencing graph
is broken, so whatever kmemleak prints afterwards can no longer be
trusted (e.g. objects in a linked list and there is a block in the
middle of the list that kmemleak doesn't know about and won't scan; the
blocks referenced by it will be reported as leaks).

After kmemleak disables itself, does it still show any potential leaks?
Even that is not entirely to be trusted. A better start would be to look
at /proc/slabinfo.

> Catalin, can you recommend which patches Dave Jones should apply to 
> kmemleak ?

All kmemleak patches I had are in mainline (as of 4.2-rc1) but none of
them targets leaks (or false positives).

> A few weeks ago I had noticed similar kmemleak reports. 
> However, when I reran my test with kmemleak disabled memory usage was 
> stable. See also 
> https://www.redhat.com/archives/dm-devel/2015-May/msg00198.html.

Further down in this thread it gets interesting with kmalloc-96 objects
disappearing in /proc/slabinfo with kmemleak disabled. Kmemleak does not
allocate such objects, the two types it allocates are in separate
kmem_cache as kmemleak_object and kmemleak_scan_area. However, the 96
size is reported by kmemleak as well, so maybe it was fixed by some
other patch in the meantime?

If you manage to reproduce it again please let me know. Thanks.

-- 
Catalin

