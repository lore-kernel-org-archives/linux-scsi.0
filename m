From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 03:39:05 +0100
Message-ID: <874p01fg3a.fsf@basil.nowhere.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	<CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	<20090114163557.11e097f2.akpm@linux-foundation.org>
	<20090115012147.GW29283@parisc-linux.org>
	<20090114180431.f4a96543.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:48157 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZAOCjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2009 21:39:44 -0500
In-Reply-To: <20090114180431.f4a96543.akpm@linux-foundation.org> (Andrew Morton's message of "Wed, 14 Jan 2009 18:04:31 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Andrew Morton <akpm@linux-foundation.org> writes:


>>    some of that back, but not as much as taking them out (even when
>>    the sysctl'd variable is in a __read_mostly section).  We tried a
>>    patch from Jens to speed up the search for a new partition, but it
>>    had no effect.
>
> I find this surprising.

The test system has thousands of disks/LUNs which it writes to
all the time, in addition to a workload which is a real cache pig. 
So any increase in the per LUN overhead directly leads to a lot
more cache misses in the kernel because it increases the working set
there sigificantly.

>
>>  - The RT scheduler changes.  They're better for some RT tasks, but not
>>    the database benchmark workload.  Chinang has posted about
>>    this before, but the thread didn't really go anywhere.
>>    http://marc.info/?t=122903815000001&r=1&w=2
>
> Well.  It's more a case that it wasn't taken anywhere.  I appear to
> have recently been informed that there have never been any
> CPU-scheduler-caused regressions.  Please persist!

Just to clarify: the non RT scheduler has never performed well on this
workload (although it seems to get slightly worse too), mostly 
because of log writer starvation.

RT at some point performed significantly better, but then as 
the RT behaviour was improved to be more fair on MP there were signficant
regressions when running under RT.
I wouldn't really advocate to make RT less fair again, it would
be better to just fix the non RT scheduler to perform reasonably. 
Unfortunately the thread above which was supposed to do that
didn't go anywhere.

>> SLUB would have had a huge negative effect if we were using it -- on the
>> order of 7% iirc.  SLQB is at least performance-neutral with SLAB.
>
> We really need to unblock that problem somehow.  I assume that
> enterprise distros are shipping slab?

The released ones all do.

-Andi
-- 
ak@linux.intel.com
