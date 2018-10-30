From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 11/14] irq: add support for allocating (and affinitizing)
 sets of IRQs
Date: Tue, 30 Oct 2018 08:53:37 -0600
Message-ID: <46dbcbcd-799f-9970-a68f-de7e96b1a6bb@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-12-axboe@kernel.dk>
 <20181030142601.GA18906@localhost.localdomain>
 <c11c95ae-5e10-38bd-d2c2-e2407634f52a@kernel.dk>
 <20181030144527.GB18906@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181030144527.GB18906@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On 10/30/18 8:45 AM, Keith Busch wrote:
> On Tue, Oct 30, 2018 at 08:36:35AM -0600, Jens Axboe wrote:
>> On 10/30/18 8:26 AM, Keith Busch wrote:
>>> On Mon, Oct 29, 2018 at 10:37:35AM -0600, Jens Axboe wrote:
>>>> diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
>>>> index f4f29b9d90ee..2046a0f0f0f1 100644
>>>> --- a/kernel/irq/affinity.c
>>>> +++ b/kernel/irq/affinity.c
>>>> @@ -180,6 +180,7 @@ irq_create_affinity_masks(int nvecs, const struct irq_affinity *affd)
>>>>  	int curvec, usedvecs;
>>>>  	cpumask_var_t nmsk, npresmsk, *node_to_cpumask;
>>>>  	struct cpumask *masks = NULL;
>>>> +	int i, nr_sets;
>>>>  
>>>>  	/*
>>>>  	 * If there aren't any vectors left after applying the pre/post
>>>> @@ -210,10 +211,23 @@ irq_create_affinity_masks(int nvecs, const struct irq_affinity *affd)
>>>>  	get_online_cpus();
>>>>  	build_node_to_cpumask(node_to_cpumask);
>>>>  
>>>> -	/* Spread on present CPUs starting from affd->pre_vectors */
>>>> -	usedvecs = irq_build_affinity_masks(affd, curvec, affvecs,
>>>> -					    node_to_cpumask, cpu_present_mask,
>>>> -					    nmsk, masks);
>>>> +	/*
>>>> +	 * Spread on present CPUs starting from affd->pre_vectors. If we
>>>> +	 * have multiple sets, build each sets affinity mask separately.
>>>> +	 */
>>>> +	nr_sets = affd->nr_sets;
>>>> +	if (!nr_sets)
>>>> +		nr_sets = 1;
>>>> +
>>>> +	for (i = 0, usedvecs = 0; i < nr_sets; i++) {
>>>> +		int this_vecs = affd->sets ? affd->sets[i] : affvecs;
>>>> +		int nr;
>>>> +
>>>> +		nr = irq_build_affinity_masks(affd, curvec, this_vecs,
>>>> +					      node_to_cpumask, cpu_present_mask,
>>>> +					      nmsk, masks + usedvecs);
>>>> +		usedvecs += nr;
>>>> +	}
>>>
>>>
>>> While the code below returns the appropriate number of possible vectors
>>> when a set requested too many, the above code is still using the value
>>> from the set, which may exceed 'nvecs' used to kcalloc 'masks', so
>>> 'masks + usedvecs' may go out of bounds.
>>
>> How so? nvecs must the max number of vecs, the sum of the sets can't
>> exceed that value.
> 
> 'nvecs' is what irq_calc_affinity_vectors() returns, which is the min
> of either the requested max or the sum of the set, and the sum of the set
> isn't guaranteed to be the smaller value.

The sum of the set can't exceed the nvecs passed in, the nvecs passed in
should be the less than or equal to nvecs. Granted this isn't enforced,
and perhaps that should be the case.

-- 
Jens Axboe
