From: Roland Dreier <roland@purestorage.com>
Subject: Re: rq_affinity doesn't seem to work?
Date: Thu, 14 Jul 2011 10:02:58 -0700
Message-ID: <CAL1RGDUDbEG4ypr0GJLLi_0PTjZK0HshMVwTs=aY+=hhFdjK5g@mail.gmail.com>
References: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com>
 <4E1CAEEB.8050506@kernel.dk> <20110713171011.GA11864@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog103.obsmtp.com ([74.125.245.74]:34664 "HELO
	na3sys010aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755450Ab1GNRDT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2011 13:03:19 -0400
In-Reply-To: <20110713171011.GA11864@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jens Axboe <axboe@kernel.dk>, "Jiang, Dave" <dave.jiang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Foong, Annie" <annie.foong@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>

On Wed, Jul 13, 2011 at 10:10 AM, Matthew Wilcox <matthew@wil.cx> wrote=
:
> On Tue, Jul 12, 2011 at 10:30:35PM +0200, Jens Axboe wrote:
>> It's probably the grouping, we need to do something about that. Does=
 the
>> below patch make it behave as you expect?
>
> "something", absolutely. =A0But there is benefit from doing some aggr=
egation
> (we tried disabling it entirely with the "well-known OLTP benchmark" =
and
> performance went down).
>
> Ideally we'd do something like "if the softirq is taking up more than=
 10%
> of a core, split the grouping". =A0Do we have enough stats to do that=
 kind
> of monitoring?

What platform was your "OLTP benchmark" on?  It seems that as the
number of cores per package goes up, this grouping becomes too coarse,
since almost everyone will have SCHED_MC set in the code:

	static inline int blk_cpu_to_group(int cpu)
	{
		int group =3D NR_CPUS;
	#ifdef CONFIG_SCHED_MC
		const struct cpumask *mask =3D cpu_coregroup_mask(cpu);
		group =3D cpumask_first(mask);
	#elif defined(CONFIG_SCHED_SMT)
		group =3D cpumask_first(topology_thread_cpumask(cpu));
	#else
		return cpu;
	#endif
		if (likely(group < NR_CPUS))
			return group;
		return cpu;
	}

and so we use cpumask_first(cpu_coregroup_mask(cpu)).  And from

	const struct cpumask *cpu_coregroup_mask(int cpu)
	{
	        struct cpuinfo_x86 *c =3D &cpu_data(cpu);
	        /*
	         * For perf, we return last level cache shared map.
	         * And for power savings, we return cpu_core_map
	         */
	        if ((sched_mc_power_savings || sched_smt_power_savings) &&
	            !(cpu_has(c, X86_FEATURE_AMD_DCM)))
	                return cpu_core_mask(cpu);
	        else
	                return cpu_llc_shared_mask(cpu);
	}

in the "max performance" case, we use cpu_llc_shared_mask().

The problem as we've seen it is that on a dual-socket Westmere (Xeon
56xx) system, we have two sockets with 6 cores (12 threads) each, all
sharing L3 cache, and so we end up with all block softirqs on only 2
out of 24 threads, which is not enough to handle all the IOPS that
fast storage can provide.

It's not clear to me what the right answer or tradeoffs are here.  It
might make sense to use only one hyperthread per core for block
softirqs.  As I understand the Westmere cache topology, there's not
really an obvious intermediate step -- all the cores in a package
share the L3, and then each core has its own L2.

Limiting softirqs to 10% of a core seems a bit low, since we seem to
be able to use more than 100% of a core handling block softirqs, and
anyway magic numbers like that seem to always be wrong sometimes.
Perhaps we could use the queue length on the destination CPU as a
proxy for how busy ksoftirq is?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
