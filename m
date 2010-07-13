From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 08/20] be2iscsi: Fix to handle request_irq failure
Date: Tue, 13 Jul 2010 11:32:28 -0700
Message-ID: <20100713183228.257d7ab0@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail192.messagelabs.com ([216.82.241.243]:40271 "EHLO
	mail192.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab0GMSdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2010 14:33:02 -0400
In-Reply-To: 4C3C19F1.7080600@cs.wisc.edu
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

_____  
From: Mike Christie [mailto:michaelc@cs.wisc.edu]
To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de
Sent: Tue, 13 Jul 2010 00:46:57 -0700
Subject: Re: [PATCH 08/20] be2iscsi: Fix to handle request_irq failure

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

Yes, that's what I wanted. I want the num_cpus to not exceed MAX_CPUS-1.


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

Agreed

> +		free_irq(msix_vec,&phwi_context->be_eq[j]);
> +	return ret;
>   }
>
>   static void hwi_ring_cq_db(struct beiscsi_hba *phba,

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

