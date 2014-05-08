From: Govindarajulu Varadarajan <gvaradar@cisco.com>
Subject: Re: [PATCH 10/19] hpsa: set irq affinity hints to route MSI-X vectors
 across CPUs
Date: Fri, 9 May 2014 02:41:54 +0530 (IST)
Message-ID: <alpine.LNX.2.03.1405090221590.1977@cisco.com>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com> <20140508192814.13481.56930.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:16822 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaEHVWR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 17:22:17 -0400
In-Reply-To: <20140508192814.13481.56930.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com



On Thu, 8 May 2014, Stephen M. Cameron wrote:

> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
> drivers/scsi/hpsa.c |   17 ++++++++++++++++-
> 1 files changed, 16 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 9c44f26..e8090e2 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6608,6 +6608,17 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
> 			h->ioaccel_cmd_pool, h->ioaccel_cmd_pool_dhandle);
> }
>
> +static void hpsa_irq_affinity_hints(struct ctlr_info *h)
> +{
> +	int i, cpu, rc;
> +
> +	cpu = cpumask_first(cpu_online_mask);

May be consider setting cpu affinity hint based on numa locality of pcie device
and cpu? Instead of blindly assigning all online cpu in order.

Some thing like

 	cpu = cpumask_first(cpumask_of_node(numa_node))

> +	for (i = 0; i < h->msix_vector; i++) {
> +		rc = irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));

You are not using return value rc. Why declare it?

Thanks
Govind
> +		cpu = cpumask_next(cpu, cpu_online_mask);
> +	}
> +}
> +
> static int hpsa_request_irq(struct ctlr_info *h,
> 	irqreturn_t (*msixhandler)(int, void *),
> 	irqreturn_t (*intxhandler)(int, void *))
> @@ -6627,6 +6638,7 @@ static int hpsa_request_irq(struct ctlr_info *h,
> 			rc = request_irq(h->intr[i], msixhandler,
> 					0, h->devname,
> 					&h->q[i]);
> +		hpsa_irq_affinity_hints(h);
> 	} else {
> 		/* Use single reply pool */
> 		if (h->msix_vector > 0 || h->msi_vector) {
> @@ -6678,12 +6690,15 @@ static void free_irqs(struct ctlr_info *h)
> 	if (!h->msix_vector || h->intr_mode != PERF_MODE_INT) {
> 		/* Single reply queue, only one irq to free */
> 		i = h->intr_mode;
> +		irq_set_affinity_hint(h->intr[i], NULL);
> 		free_irq(h->intr[i], &h->q[i]);
> 		return;
> 	}
>
> -	for (i = 0; i < h->msix_vector; i++)
> +	for (i = 0; i < h->msix_vector; i++) {
> +		irq_set_affinity_hint(h->intr[i], NULL);
> 		free_irq(h->intr[i], &h->q[i]);
> +	}
> }
>
> static void hpsa_free_irqs_and_disable_msix(struct ctlr_info *h)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
