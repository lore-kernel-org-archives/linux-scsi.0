From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 08/20] be2iscsi: Fix to handle request_irq failure
Date: Tue, 13 Jul 2010 02:46:57 -0500
Message-ID: <4C3C19F1.7080600@cs.wisc.edu>
References: <20100712175304.GA11541@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45520 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab0GMHnm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2010 03:43:42 -0400
In-Reply-To: <20100712175304.GA11541@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 07/12/2010 12:53 PM, Jayamohan Kallickal wrote:
>   This patch handles request_irq failures  by properly cleaning up
>
> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
> ---
>   drivers/scsi/be2iscsi/be_main.c |   20 +++++++++++++++++++-
>   1 files changed, 19 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 89fe7e4..d7bfa5e 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -616,7 +616,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>   	struct pci_dev *pcidev = phba->pcidev;
>   	struct hwi_controller *phwi_ctrlr;
>   	struct hwi_context_memory *phwi_context;
> -	int ret, msix_vec, i = 0;
> +	int ret, msix_vec, i, j;
>   	char desc[32];
>
>   	phwi_ctrlr = phba->phwi_ctrlr;
> @@ -628,10 +628,24 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>   			msix_vec = phba->msix_entries[i].vector;
>   			ret = request_irq(msix_vec, be_isr_msix, 0, desc,
>   					&phwi_context->be_eq[i]);
> +			if (ret) {
> +				shost_printk(KERN_ERR, phba->shost,
> +					     "beiscsi_init_irqs-Failed to"
> +					     "register msix for i = %d\n", i);
> +				if (!i)
> +					return ret;
> +				goto free_msix_irqs;
> +			}
>   		}
>   		msix_vec = phba->msix_entries[i].vector;
>   		ret = request_irq(msix_vec, be_isr_mcc, 0, "beiscsi_msix_mcc",
>   				&phwi_context->be_eq[i]);

Is that loop and indexing right if num_online_cpus == MAX_CPUS. It looks 
like you would have only MAX_CPUS - 1 where other times you would have 
num_online_cpus. Is that what you wanted or did you want to allocate the 
be_eq array MAX_CPUS + 1 and then set phba->num_cpus = MAX_CPUS in the 
case they are equal or greater than.

> +		if (ret) {
> +			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
> +				     "Failed to register beiscsi_msix_mcc\n");
> +			goto free_msix_irqs;
> +		}
> +
>   	} else {
>   		ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED,
>   				  "beiscsi", phba);
> @@ -642,6 +656,10 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>   		}
>   	}
>   	return 0;
> +free_msix_irqs:
> +	for (j = i; j == 0; j++)


I think that should be j = i - 1, because be_eq[i] was the one failed to 
get setup.


> +		free_irq(msix_vec,&phwi_context->be_eq[j]);
> +	return ret;
>   }
>
>   static void hwi_ring_cq_db(struct beiscsi_hba *phba,

