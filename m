From: Laurence Oberman <loberman@redhat.com>
Subject: Re: HP ProLiant DL360p Gen8 hangs with Linux 4.13+.
Date: Mon, 15 Jan 2018 07:51:19 -0500
Message-ID: <1516020679.21554.1.camel@redhat.com>
References: <CACKvgLEtPRpAS58kn-Skjn65-ZkDK17_cE+OzJodxQ=XvtQPGg@mail.gmail.com>
         <1515973240.8994.2.camel@redhat.com> <20180115121659.GA17687@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:44590 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967216AbeAOMvW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2018 07:51:22 -0500
Received: by mail-qt0-f193.google.com with SMTP id m59so13986037qte.11
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2018 04:51:21 -0800 (PST)
In-Reply-To: <20180115121659.GA17687@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Vinson Lee <vlee@freedesktop.org>, linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>, "Hellwig, Christoph" <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org

On Mon, 2018-01-15 at 20:17 +0800, Ming Lei wrote:
> On Sun, Jan 14, 2018 at 06:40:40PM -0500, Laurence Oberman wrote:
> > On Thu, 2018-01-04 at 14:32 -0800, Vinson Lee wrote:
> > > Hi.
> > > 
> > > HP ProLiant DL360p Gen8 with Smart Array P420i boots to the login
> > > prompt and hangs with Linux 4.13 or later. I cannot log in on
> > > console
> > > or SSH into the machine. Linux 4.12 and older boot fine.
> > > 
> > > 
> > 
> > ...
> > 
> > ...
> > 
> > This issue bit me for for two straight days.
> > I was testing Mike Snitzers combined tree and this commit crept
> > into
> > the latest combined tree.
> > 
> > commit 84676c1f21e8ff54befe985f4f14dc1edc10046b
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Fri Jan 12 10:53:05 2018 +0800
> > 
> >     genirq/affinity: assign vectors to all possible CPUs
> >    
> >     Currently we assign managed interrupt vectors to all present
> > CPUs.  This
> >     works fine for systems were we only online/offline CPUs.  But
> > in
> > case of
> >     systems that support physical CPU hotplug (or the virtualized
> > version of
> >     it) this means the additional CPUs covered for in the ACPI
> > tables
> > or on
> >     the command line are not catered for.  To fix this we'd either
> > need
> > to
> >     introduce new hotplug CPU states just for this case, or we can
> > start
> >     assining vectors to possible but not present CPUs.
> >    
> >     Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >     Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >     Tested-by: Stefan Haberland <sth@linux.vnet.ibm.com>
> >     Fixes: 4b855ad37194 ("blk-mq: Create hctx for each present
> > CPU")
> >     Cc: linux-kernel@vger.kernel.org
> >     Cc: Thomas Gleixner <tglx@linutronix.de>
> >     Signed-off-by: Christoph Hellwig <hch@lst.de>
> >     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > 
> > Reason I never thought about this being my reason for the latest
> > hang
> > is I have used Linus' tree all the way to 4.15-rc7 with no issues.
> > 
> > Vinson reporting it against 4.13 or later was not making sense
> > because
> > I had not seen the hang until this weekend.
> > 
> > I checked  and its in Linus's tree but its not an issue in the
> > generic
> > 4.15-rc7 for me.
> 
> Hi Laurence,
> 
> Wrt. your issue, I have investigated a bit and found that it is
> because
> one irq vector may be assigned to all offline CPUs, and it may not be
> same with Vinson's.
> 
> And the following patch can address your issue, I may prepare a
> formal
> version if no one objects this approach.
> 
> Thomas, Christoph, could you take a look this patch?
> 
> ---
>  kernel/irq/affinity.c | 69 +++++++++++++++++++++++++++++++++++----
> ------------
>  1 file changed, 47 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
> index a37a3b4b6342..dfc1f6a9c488 100644
> --- a/kernel/irq/affinity.c
> +++ b/kernel/irq/affinity.c
> @@ -94,6 +94,39 @@ static int get_nodes_in_cpumask(cpumask_var_t
> *node_to_possible_cpumask,
>  	return nodes;
>  }
>  
> +/*
> + * Spread the affinity of @nmsk into @nr_vecs irq vectors, and the
> + * result is stored to @start_irqmsk.
> + */
> +static int irq_vecs_spread_affinity(struct cpumask *irqmsk,
> +				    int max_irqmsks,
> +				    struct cpumask *nmsk,
> +				    int max_ncpus)
> +{
> +	int v, ncpus;
> +	int vecs_to_assign, extra_vecs;
> +
> +	/* Calculate the number of cpus per vector */
> +	ncpus = cpumask_weight(nmsk);
> +	vecs_to_assign = min(max_ncpus, ncpus);
> +
> +	/* Account for rounding errors */
> +	extra_vecs = ncpus - vecs_to_assign * (ncpus /
> vecs_to_assign);
> +
> +	for (v = 0; v < min(max_irqmsks, vecs_to_assign); v++) {
> +		int cpus_per_vec = ncpus / vecs_to_assign;
> +
> +		/* Account for extra vectors to compensate rounding
> errors */
> +		if (extra_vecs) {
> +			cpus_per_vec++;
> +			--extra_vecs;
> +		}
> +		irq_spread_init_one(irqmsk + v, nmsk, cpus_per_vec);
> +	}
> +
> +	return v;
> +}
> +
>  /**
>   * irq_create_affinity_masks - Create affinity masks for multiqueue
> spreading
>   * @nvecs:	The total number of vectors
> @@ -104,7 +137,7 @@ static int get_nodes_in_cpumask(cpumask_var_t
> *node_to_possible_cpumask,
>  struct cpumask *
>  irq_create_affinity_masks(int nvecs, const struct irq_affinity
> *affd)
>  {
> -	int n, nodes, cpus_per_vec, extra_vecs, curvec;
> +	int n, nodes, curvec;
>  	int affv = nvecs - affd->pre_vectors - affd->post_vectors;
>  	int last_affv = affv + affd->pre_vectors;
>  	nodemask_t nodemsk = NODE_MASK_NONE;
> @@ -154,33 +187,25 @@ irq_create_affinity_masks(int nvecs, const
> struct irq_affinity *affd)
>  	}
>  
>  	for_each_node_mask(n, nodemsk) {
> -		int ncpus, v, vecs_to_assign, vecs_per_node;
> +		int vecs_per_node;
>  
>  		/* Spread the vectors per node */
>  		vecs_per_node = (affv - (curvec - affd-
> >pre_vectors)) / nodes;
>  
> -		/* Get the cpus on this node which are in the mask
> */
> -		cpumask_and(nmsk, cpu_possible_mask,
> node_to_possible_cpumask[n]);
>  
> -		/* Calculate the number of cpus per vector */
> -		ncpus = cpumask_weight(nmsk);
> -		vecs_to_assign = min(vecs_per_node, ncpus);
> -
> -		/* Account for rounding errors */
> -		extra_vecs = ncpus - vecs_to_assign * (ncpus /
> vecs_to_assign);
> -
> -		for (v = 0; curvec < last_affv && v <
> vecs_to_assign;
> -		     curvec++, v++) {
> -			cpus_per_vec = ncpus / vecs_to_assign;
> -
> -			/* Account for extra vectors to compensate
> rounding errors */
> -			if (extra_vecs) {
> -				cpus_per_vec++;
> -				--extra_vecs;
> -			}
> -			irq_spread_init_one(masks + curvec, nmsk,
> cpus_per_vec);
> -		}
> +		/* spread non-online possible cpus */
> +		cpumask_andnot(nmsk, node_to_possible_cpumask[n],
> cpu_online_mask);
> +		irq_vecs_spread_affinity(&masks[curvec], last_affv -
> curvec,
> +					 nmsk, vecs_per_node);
>  
> +		/*
> +		 * spread online possible cpus to make sure each
> vector
> +		 * can get one online cpu to handle
> +		 */
> +		cpumask_and(nmsk, node_to_possible_cpumask[n],
> cpu_online_mask);
> +		curvec += irq_vecs_spread_affinity(&masks[curvec],
> +						   last_affv -
> curvec,
> +						   nmsk,
> vecs_per_node);
>  		if (curvec >= last_affv)
>  			break;
>  		--nodes;
> -- 
> 2.9.5
> 
> 

Hello Ming

I will test the patch. I did not spend a lot of time seeing if this
weekends stalls were an exact match to Vinson, I just knew pulling that
patch resolved it.
Perhaps this explains why I was not seeing this on generic 4.15-rc7.

Thanks
Laurence
