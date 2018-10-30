From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 11/14] irq: add support for allocating (and affinitizing)
 sets of IRQs
Date: Tue, 30 Oct 2018 08:26:01 -0600
Message-ID: <20181030142601.GA18906@localhost.localdomain>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-12-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181029163738.10172-12-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 29, 2018 at 10:37:35AM -0600, Jens Axboe wrote:
> diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
> index f4f29b9d90ee..2046a0f0f0f1 100644
> --- a/kernel/irq/affinity.c
> +++ b/kernel/irq/affinity.c
> @@ -180,6 +180,7 @@ irq_create_affinity_masks(int nvecs, const struct irq_affinity *affd)
>  	int curvec, usedvecs;
>  	cpumask_var_t nmsk, npresmsk, *node_to_cpumask;
>  	struct cpumask *masks = NULL;
> +	int i, nr_sets;
>  
>  	/*
>  	 * If there aren't any vectors left after applying the pre/post
> @@ -210,10 +211,23 @@ irq_create_affinity_masks(int nvecs, const struct irq_affinity *affd)
>  	get_online_cpus();
>  	build_node_to_cpumask(node_to_cpumask);
>  
> -	/* Spread on present CPUs starting from affd->pre_vectors */
> -	usedvecs = irq_build_affinity_masks(affd, curvec, affvecs,
> -					    node_to_cpumask, cpu_present_mask,
> -					    nmsk, masks);
> +	/*
> +	 * Spread on present CPUs starting from affd->pre_vectors. If we
> +	 * have multiple sets, build each sets affinity mask separately.
> +	 */
> +	nr_sets = affd->nr_sets;
> +	if (!nr_sets)
> +		nr_sets = 1;
> +
> +	for (i = 0, usedvecs = 0; i < nr_sets; i++) {
> +		int this_vecs = affd->sets ? affd->sets[i] : affvecs;
> +		int nr;
> +
> +		nr = irq_build_affinity_masks(affd, curvec, this_vecs,
> +					      node_to_cpumask, cpu_present_mask,
> +					      nmsk, masks + usedvecs);
> +		usedvecs += nr;
> +	}


While the code below returns the appropriate number of possible vectors
when a set requested too many, the above code is still using the value
from the set, which may exceed 'nvecs' used to kcalloc 'masks', so
'masks + usedvecs' may go out of bounds.

  
>  	/*
>  	 * Spread on non present CPUs starting from the next vector to be
> @@ -258,13 +272,21 @@ int irq_calc_affinity_vectors(int minvec, int maxvec, const struct irq_affinity
>  {
>  	int resv = affd->pre_vectors + affd->post_vectors;
>  	int vecs = maxvec - resv;
> -	int ret;
> +	int set_vecs;
>  
>  	if (resv > minvec)
>  		return 0;
>  
> -	get_online_cpus();
> -	ret = min_t(int, cpumask_weight(cpu_possible_mask), vecs) + resv;
> -	put_online_cpus();
> -	return ret;
> +	if (affd->nr_sets) {
> +		int i;
> +
> +		for (i = 0, set_vecs = 0;  i < affd->nr_sets; i++)
> +			set_vecs += affd->sets[i];
> +	} else {
> +		get_online_cpus();
> +		set_vecs = cpumask_weight(cpu_possible_mask);
> +		put_online_cpus();
> +	}
> +
> +	return resv + min(set_vecs, vecs);
>  }
