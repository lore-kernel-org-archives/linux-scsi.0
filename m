From: "IT (Donald Buczek)" <it@molgen.mpg.de>
Subject: Re: [PATCH] Revert "genirq/affinity: assign vectors to all possible
 CPUs"
Date: Mon, 8 Oct 2018 09:56:05 +0200
Message-ID: <f4424094-9d5e-b4ce-0555-0414f5be17e8@molgen.mpg.de>
References: <06ee23fe-ec9e-d67b-b533-d5151be74a11@molgen.mpg.de>
 <20180810133628.GA4131@kroah.com>
 <29b5f3ce-2c23-bf5e-fe50-29bedd4833e1@molgen.mpg.de>
 <20180810155511.GA17092@kroah.com>
 <f5c57bf7-b8c1-a560-d13a-d74e0f27adbb@molgen.mpg.de>
 <20180811135021.GA2186@kroah.com> <20180813033157.GA18254@ming.t460p>
 <89f2b622-3d2a-04ce-a6d1-ffb5d9612763@molgen.mpg.de>
 <cbd7cb64-dbfe-e085-e80b-67dad4084d69@molgen.mpg.de>
 <7c51fe1d-d591-90f2-8fb5-81990f8db0fe@molgen.mpg.de>
 <20181008021104.GB8155@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181008021104.GB8155@ming.t460p>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Paul Menzel <pmenzel+linux-scsi@molgen.mpg.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, it+linux-scsi@molgen.mpg.de, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Dave Carroll <david.carroll@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

On 10/08/18 04:11, Ming Lei wrote:
> On Mon, Oct 01, 2018 at 02:33:07PM +0200, Paul Menzel wrote:
>> Date: Wed, 29 Aug 2018 17:28:45 +0200
>>
>> This reverts commit ef86f3a72adb8a7931f67335560740a7ad696d1d.
>>
>> See the discussion in the thread *aacraid: Regression in 4.14.56
>> with *genirq/affinity: assign vectors to all possible CPUs** on
>> the linux-scsi list.
>>
>> Reverting the commit, the aacraid driver loads correctly, and the
>> drives are visible. So revert the commit to adhere to Linux’ no
>> regression policy.
>>
>> Strangely, the issue is not reproducible with Linux 4.18.x, but
>> Ming Lei wrote, that this might only be by chance.
>>
>> Link: https://www.spinics.net/lists/linux-scsi/msg122732.html
>> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
>>
>> ---
>>   kernel/irq/affinity.c | 30 +++++++++++++++---------------
>>   1 file changed, 15 insertions(+), 15 deletions(-)
>>
>> diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
>> index a37a3b4b6342..e12d35108225 100644
>> --- a/kernel/irq/affinity.c
>> +++ b/kernel/irq/affinity.c
>> @@ -39,7 +39,7 @@ static void irq_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
>>   	}
>>   }
>>   
>> -static cpumask_var_t *alloc_node_to_possible_cpumask(void)
>> +static cpumask_var_t *alloc_node_to_present_cpumask(void)
>>   {
>>   	cpumask_var_t *masks;
>>   	int node;
>> @@ -62,7 +62,7 @@ static cpumask_var_t *alloc_node_to_possible_cpumask(void)
>>   	return NULL;
>>   }
>>   
>> -static void free_node_to_possible_cpumask(cpumask_var_t *masks)
>> +static void free_node_to_present_cpumask(cpumask_var_t *masks)
>>   {
>>   	int node;
>>   
>> @@ -71,22 +71,22 @@ static void free_node_to_possible_cpumask(cpumask_var_t *masks)
>>   	kfree(masks);
>>   }
>>   
>> -static void build_node_to_possible_cpumask(cpumask_var_t *masks)
>> +static void build_node_to_present_cpumask(cpumask_var_t *masks)
>>   {
>>   	int cpu;
>>   
>> -	for_each_possible_cpu(cpu)
>> +	for_each_present_cpu(cpu)
>>   		cpumask_set_cpu(cpu, masks[cpu_to_node(cpu)]);
>>   }
>>   
>> -static int get_nodes_in_cpumask(cpumask_var_t *node_to_possible_cpumask,
>> +static int get_nodes_in_cpumask(cpumask_var_t *node_to_present_cpumask,
>>   				const struct cpumask *mask, nodemask_t *nodemsk)
>>   {
>>   	int n, nodes = 0;
>>   
>>   	/* Calculate the number of nodes in the supplied affinity mask */
>>   	for_each_node(n) {
>> -		if (cpumask_intersects(mask, node_to_possible_cpumask[n])) {
>> +		if (cpumask_intersects(mask, node_to_present_cpumask[n])) {
>>   			node_set(n, *nodemsk);
>>   			nodes++;
>>   		}
>> @@ -109,7 +109,7 @@ irq_create_affinity_masks(int nvecs, const struct irq_affinity *affd)
>>   	int last_affv = affv + affd->pre_vectors;
>>   	nodemask_t nodemsk = NODE_MASK_NONE;
>>   	struct cpumask *masks;
>> -	cpumask_var_t nmsk, *node_to_possible_cpumask;
>> +	cpumask_var_t nmsk, *node_to_present_cpumask;
>>   
>>   	/*
>>   	 * If there aren't any vectors left after applying the pre/post
>> @@ -125,8 +125,8 @@ irq_create_affinity_masks(int nvecs, const struct irq_affinity *affd)
>>   	if (!masks)
>>   		goto out;
>>   
>> -	node_to_possible_cpumask = alloc_node_to_possible_cpumask();
>> -	if (!node_to_possible_cpumask)
>> +	node_to_present_cpumask = alloc_node_to_present_cpumask();
>> +	if (!node_to_present_cpumask)
>>   		goto out;
>>   
>>   	/* Fill out vectors at the beginning that don't need affinity */
>> @@ -135,8 +135,8 @@ irq_create_affinity_masks(int nvecs, const struct irq_affinity *affd)
>>   
>>   	/* Stabilize the cpumasks */
>>   	get_online_cpus();
>> -	build_node_to_possible_cpumask(node_to_possible_cpumask);
>> -	nodes = get_nodes_in_cpumask(node_to_possible_cpumask, cpu_possible_mask,
>> +	build_node_to_present_cpumask(node_to_present_cpumask);
>> +	nodes = get_nodes_in_cpumask(node_to_present_cpumask, cpu_present_mask,
>>   				     &nodemsk);
>>   
>>   	/*
>> @@ -146,7 +146,7 @@ irq_create_affinity_masks(int nvecs, const struct irq_affinity *affd)
>>   	if (affv <= nodes) {
>>   		for_each_node_mask(n, nodemsk) {
>>   			cpumask_copy(masks + curvec,
>> -				     node_to_possible_cpumask[n]);
>> +				     node_to_present_cpumask[n]);
>>   			if (++curvec == last_affv)
>>   				break;
>>   		}
>> @@ -160,7 +160,7 @@ irq_create_affinity_masks(int nvecs, const struct irq_affinity *affd)
>>   		vecs_per_node = (affv - (curvec - affd->pre_vectors)) / nodes;
>>   
>>   		/* Get the cpus on this node which are in the mask */
>> -		cpumask_and(nmsk, cpu_possible_mask, node_to_possible_cpumask[n]);
>> +		cpumask_and(nmsk, cpu_present_mask, node_to_present_cpumask[n]);
>>   
>>   		/* Calculate the number of cpus per vector */
>>   		ncpus = cpumask_weight(nmsk);
>> @@ -192,7 +192,7 @@ irq_create_affinity_masks(int nvecs, const struct irq_affinity *affd)
>>   	/* Fill out vectors at the end that don't need affinity */
>>   	for (; curvec < nvecs; curvec++)
>>   		cpumask_copy(masks + curvec, irq_default_affinity);
>> -	free_node_to_possible_cpumask(node_to_possible_cpumask);
>> +	free_node_to_present_cpumask(node_to_present_cpumask);
>>   out:
>>   	free_cpumask_var(nmsk);
>>   	return masks;
>> @@ -214,7 +214,7 @@ int irq_calc_affinity_vectors(int minvec, int maxvec, const struct irq_affinity
>>   		return 0;
>>   
>>   	get_online_cpus();
>> -	ret = min_t(int, cpumask_weight(cpu_possible_mask), vecs) + resv;
>> +	ret = min_t(int, cpumask_weight(cpu_present_mask), vecs) + resv;
>>   	put_online_cpus();
>>   	return ret;
>>   }
>> -- 
>> 2.17.1
>>
> 
> Hello Paul,
> 
> I have explained that this is one aacraid issue in the following link:
> 
> https://marc.info/?l=linux-kernel&m=153413115909580&w=2
> 
> So this issue should have been fixed in the driver instead of genirq
> core code, otherwise regression on other drivers can be caused too.

Dear Ming,

is your argument, that the bug existed before, because even with the IRQs spread over the present CPUs only, a driver was wrong to assume that every IRQ would be served, because of offline CPUs? So that the change to spread over all possible CPUs did not fundamentally change the API of pci_alloc_irq_vectors() but just increased the already existing chance of a failure?

When you say, reverting this can cause a regression, do you refer to performance or functional regression? I don't see the later yet, because even updated drivers have no guarantee, that all possible CPUs are used for the IRQs, so limiting this to the present CPUs again should do no harm?

Thank you

   Donald

> 
> So I suggest you to ask aacraid guys to take a look at this issue.> 
> Thanks,
> Ming
> 


-- 
Donald Buczek
it@molgen.mpg.de
Tel: +49 30 8413 1433
