From: Jens Axboe <axboe@kernel.dk>
Subject: Re: rq_affinity doesn't seem to work?
Date: Wed, 13 Jul 2011 20:00:46 +0200
Message-ID: <4E1DDD4E.6040100@kernel.dk>
References: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com> <4E1CAEEB.8050506@kernel.dk> <20110713171011.GA11864@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110713171011.GA11864@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Foong, Annie" <annie.foong@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 2011-07-13 19:10, Matthew Wilcox wrote:
> On Tue, Jul 12, 2011 at 10:30:35PM +0200, Jens Axboe wrote:
>> It's probably the grouping, we need to do something about that. Does the
>> below patch make it behave as you expect?
> 
> "something", absolutely.  But there is benefit from doing some aggregation
> (we tried disabling it entirely with the "well-known OLTP benchmark" and
> performance went down).

Yep, that's why the current solution is somewhat middle of the road...

> Ideally we'd do something like "if the softirq is taking up more than 10%
> of a core, split the grouping".  Do we have enough stats to do that kind
> of monitoring?

I don't think we have those stats, though it could/should be pulled from
the ksoftirqX threads. We could have some metric, ala

        dest_cpu = get_group_completion_cpu(rq->cpu);
        if (ksoftirqd_of(dest_cpu) >= 90% busy)
                dest_cpu = rq->cpu;

to send things completely local to the submitter of the IO, IFF the
current CPU is close to running at full tilt.

-- 
Jens Axboe
