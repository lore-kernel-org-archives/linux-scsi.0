From: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Subject: Re: system hung up when offlining CPUs
Date: Tue, 10 Oct 2017 12:30:56 -0400
Message-ID: <3d93387d-30eb-0434-2216-0e6435c633f8@gmail.com>
References: <c55a33b4-a886-8882-dd8d-5c488f94ee06@gmail.com>
 <20170809124213.0d9518bb@why.wild-wind.fr.eu.org>
 <cd524af7-1f20-1956-1e44-92a451053387@gmail.com>
 <c1c7e0d6-d908-b511-8418-bca288a0d20a@arm.com>
 <20170821131809.GA17564@lst.de>
 <fce0ad52-8739-09c8-ec9d-a23eb92cec5a@arm.com>
 <8e0d76cd-7cd4-3a98-12ba-815f00d4d772@gmail.com>
 <2f2ae1bc-4093-d083-6a18-96b9aaa090c9@gmail.com>
 <b3e88f4d-8ca4-e265-5e09-437285cb18f5@suse.de>
 <8cb26204cb5402824496bbb6b636e0af@mail.gmail.com>
 <alpine.DEB.2.20.1709131529400.1874@nanos>
 <3ce6837a-9aba-0ff4-64b9-7ebca5afca13@gmail.com>
 <alpine.DEB.2.20.1709161212160.2105@nanos>
 <alpine.DEB.2.20.1709161630580.2105@nanos>
 <78ce7246-c567-3f5f-b168-9bcfc659d4bd@gmail.com>
 <alpine.DEB.2.20.1710032328280.2278@nanos>
 <alpine.DEB.2.20.1710042208400.2406@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1710042208400.2406@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Hannes Reinecke <hare@suse.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, mpe@ellerman.id.au, keith.busch@intel.com, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, yasu.isimatu@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hi Thomas,

Sorry for the late reply.

I'll apply the patches and retest in this week.
Please wait a while.

Thanks,
Yasuaki Ishimatsu

On 10/04/2017 05:04 PM, Thomas Gleixner wrote:
> On Tue, 3 Oct 2017, Thomas Gleixner wrote:
>> Can you please apply the debug patch below.
> 
> I found an issue with managed interrupts when the affinity mask of an
> managed interrupt spawns multiple CPUs. Explanation in the changelog
> below. I'm not sure that this cures the problems you have, but at least I
> could prove that it's not doing what it should do. The failure I'm seing is
> fixed, but I can't test that megasas driver due to -ENOHARDWARE.
> 
> Can you please apply the patch below on top of Linus tree and retest?
> 
> Please send me the outputs I asked you to provide last time in any case
> (success or fail).
> 
> @block/scsi folks: Can you please run that through your tests as well?
> 
> Thanks,
> 
> 	tglx
> 
> 8<-----------------------
> Subject: genirq/cpuhotplug: Enforce affinity setting on startup of managed irqs
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 04 Oct 2017 21:07:38 +0200
> 
> Managed interrupts can end up in a stale state on CPU hotplug. If the
> interrupt is not targeting a single CPU, i.e. the affinity mask spawns
> multiple CPUs then the following can happen:
> 
> After boot:
> 
> dstate:   0x01601200
>             IRQD_ACTIVATED
>             IRQD_IRQ_STARTED
>             IRQD_SINGLE_TARGET
>             IRQD_AFFINITY_SET
>             IRQD_AFFINITY_MANAGED
> node:     0
> affinity: 24-31
> effectiv: 24
> pending:  0
> 
> After offlining CPU 31 - 24
> 
> dstate:   0x01a31000
>             IRQD_IRQ_DISABLED
>             IRQD_IRQ_MASKED
>             IRQD_SINGLE_TARGET
>             IRQD_AFFINITY_SET
>             IRQD_AFFINITY_MANAGED
>             IRQD_MANAGED_SHUTDOWN
> node:     0
> affinity: 24-31
> effectiv: 24
> pending:  0
> 
> Now CPU 25 gets onlined again, so it should get the effective interrupt
> affinity for this interruopt, but due to the x86 interrupt affinity setter
> restrictions this ends up after restarting the interrupt with:
> 
> dstate:   0x01601300
>             IRQD_ACTIVATED
>             IRQD_IRQ_STARTED
>             IRQD_SINGLE_TARGET
>             IRQD_AFFINITY_SET
>             IRQD_SETAFFINITY_PENDING
>             IRQD_AFFINITY_MANAGED
> node:     0
> affinity: 24-31
> effectiv: 24
> pending:  24-31
> 
> So the interrupt is still affine to CPU 24, which was the last CPU to go
> offline of that affinity set and the move to an online CPU within 24-31,
> in this case 25, is pending. This mechanism is x86/ia64 specific as those
> architectures cannot move interrupts from thread context and do this when
> an interrupt is actually handled. So the move is set to pending.
> 
> Whats worse is that offlining CPU 25 again results in:
> 
> dstate:   0x01601300
>             IRQD_ACTIVATED
>             IRQD_IRQ_STARTED
>             IRQD_SINGLE_TARGET
>             IRQD_AFFINITY_SET
>             IRQD_SETAFFINITY_PENDING
>             IRQD_AFFINITY_MANAGED
> node:     0
> affinity: 24-31
> effectiv: 24
> pending:  24-31
> 
> This means the interrupt has not been shut down, because the outgoing CPU
> is not in the effective affinity mask, but of course nothing notices that
> the effective affinity mask is pointing at an offline CPU.
> 
> In the case of restarting a managed interrupt the move restriction does not
> apply, so the affinity setting can be made unconditional. This needs to be
> done _before_ the interrupt is started up as otherwise the condition for
> moving it from thread context would not longer be fulfilled.
> 
> With that change applied onlining CPU 25 after offlining 31-24 results in:
> 
> dstate:   0x01600200
>             IRQD_ACTIVATED
>             IRQD_IRQ_STARTED
>             IRQD_SINGLE_TARGET
>             IRQD_AFFINITY_MANAGED
> node:     0
> affinity: 24-31
> effectiv: 25
> pending:  
> 
> And after offlining CPU 25:
> 
> dstate:   0x01a30000
>             IRQD_IRQ_DISABLED
>             IRQD_IRQ_MASKED
>             IRQD_SINGLE_TARGET
>             IRQD_AFFINITY_MANAGED
>             IRQD_MANAGED_SHUTDOWN
> node:     0
> affinity: 24-31
> effectiv: 25
> pending:  
> 
> which is the correct and expected result.
> 
> To complete that, add some debug code to catch this kind of situation in
> the cpu offline code and warn about interrupt chips which allow affinity
> setting and do not update the effective affinity mask if that feature is
> enabled.
> 
> Reported-by: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
>  kernel/irq/chip.c       |    2 +-
>  kernel/irq/cpuhotplug.c |   28 +++++++++++++++++++++++++++-
>  kernel/irq/manage.c     |   17 +++++++++++++++++
>  3 files changed, 45 insertions(+), 2 deletions(-)
> 
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -265,8 +265,8 @@ int irq_startup(struct irq_desc *desc, b
>  			irq_setup_affinity(desc);
>  			break;
>  		case IRQ_STARTUP_MANAGED:
> +			irq_do_set_affinity(d, aff, false);
>  			ret = __irq_startup(desc);
> -			irq_set_affinity_locked(d, aff, false);
>  			break;
>  		case IRQ_STARTUP_ABORT:
>  			return 0;
> --- a/kernel/irq/cpuhotplug.c
> +++ b/kernel/irq/cpuhotplug.c
> @@ -18,8 +18,34 @@
>  static inline bool irq_needs_fixup(struct irq_data *d)
>  {
>  	const struct cpumask *m = irq_data_get_effective_affinity_mask(d);
> +	unsigned int cpu = smp_processor_id();
>  
> -	return cpumask_test_cpu(smp_processor_id(), m);
> +#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
> +	/*
> +	 * The cpumask_empty() check is a workaround for interrupt chips,
> +	 * which do not implement effective affinity, but the architecture has
> +	 * enabled the config switch. Use the general affinity mask instead.
> +	 */
> +	if (cpumask_empty(m))
> +		m = irq_data_get_affinity_mask(d);
> +
> +	/*
> +	 * Sanity check. If the mask is not empty when excluding the outgoing
> +	 * CPU then it must contain at least one online CPU. The outgoing CPU
> +	 * has been removed from the online mask already.
> +	 */
> +	if (cpumask_any_but(m, cpu) < nr_cpu_ids &&
> +	    cpumask_any_and(m, cpu_online_mask) >= nr_cpu_ids) {
> +		/*
> +		 * If this happens then there was a missed IRQ fixup at some
> +		 * point. Warn about it and enforce fixup.
> +		 */
> +		pr_warn("Eff. affinity %*pbl of IRQ %u contains only offline CPUs after offlining CPU %u\n",
> +			cpumask_pr_args(m), d->irq, cpu);
> +		return true;
> +	}
> +#endif
> +	return cpumask_test_cpu(cpu, m);
>  }
>  
>  static bool migrate_one_irq(struct irq_desc *desc)
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -168,6 +168,19 @@ void irq_set_thread_affinity(struct irq_
>  			set_bit(IRQTF_AFFINITY, &action->thread_flags);
>  }
>  
> +static void irq_validate_effective_affinity(struct irq_data *data)
> +{
> +#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
> +	const struct cpumask *m = irq_data_get_effective_affinity_mask(data);
> +	struct irq_chip *chip = irq_data_get_irq_chip(data);
> +
> +	if (!cpumask_empty(m))
> +		return;
> +	pr_warn_once("irq_chip %s did not update eff. affinity mask of irq %u\n",
> +		     chip->name, data->irq);
> +#endif
> +}
> +
>  int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
>  			bool force)
>  {
> @@ -175,12 +188,16 @@ int irq_do_set_affinity(struct irq_data
>  	struct irq_chip *chip = irq_data_get_irq_chip(data);
>  	int ret;
>  
> +	if (!chip || !chip->irq_set_affinity)
> +		return -EINVAL;
> +
>  	ret = chip->irq_set_affinity(data, mask, force);
>  	switch (ret) {
>  	case IRQ_SET_MASK_OK:
>  	case IRQ_SET_MASK_OK_DONE:
>  		cpumask_copy(desc->irq_common_data.affinity, mask);
>  	case IRQ_SET_MASK_OK_NOCOPY:
> +		irq_validate_effective_affinity(data);
>  		irq_set_thread_affinity(desc);
>  		ret = 0;
>  	}
> 
