From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: Re: [PATCH v2] scsi: be2iscsi: Use kasprintf
Date: Fri, 3 Nov 2017 20:46:14 +0530
Message-ID: <20171103151613.GA2601@himanshu-Vostro-3559>
References: <1507736174-13089-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:52735 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdKCPQY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 11:16:24 -0400
Content-Disposition: inline
In-Reply-To: <1507736174-13089-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com

On Wed, Oct 11, 2017 at 09:06:14PM +0530, Himanshu Jha wrote:

Hi James,



Just a reminder, is my patch in our queue ?

Thanks
Himanshu Jha


> Use kasprintf instead of combination of kmalloc and sprintf.
> Also, remove BEISCSI_MSI_NAME macro used to specify size of string as
> kasprintf handles size computations.
> 
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> ---
> v2:
>    -remove the unnecessary macro BEISCSI_MSI_NAME. 
> 
>  drivers/scsi/be2iscsi/be_main.c | 12 +++++-------
>  drivers/scsi/be2iscsi/be_main.h |  2 --
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index b4542e7..6a9ee0e 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -803,15 +803,14 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>  
>  	if (pcidev->msix_enabled) {
>  		for (i = 0; i < phba->num_cpus; i++) {
> -			phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME,
> -						    GFP_KERNEL);
> +			phba->msi_name[i] = kasprintf(GFP_KERNEL,
> +						      "beiscsi_%02x_%02x",
> +						      phba->shost->host_no, i);
>  			if (!phba->msi_name[i]) {
>  				ret = -ENOMEM;
>  				goto free_msix_irqs;
>  			}
>  
> -			sprintf(phba->msi_name[i], "beiscsi_%02x_%02x",
> -				phba->shost->host_no, i);
>  			ret = request_irq(pci_irq_vector(pcidev, i),
>  					  be_isr_msix, 0, phba->msi_name[i],
>  					  &phwi_context->be_eq[i]);
> @@ -824,13 +823,12 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>  				goto free_msix_irqs;
>  			}
>  		}
> -		phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME, GFP_KERNEL);
> +		phba->msi_name[i] = kasprintf(GFP_KERNEL, "beiscsi_mcc_%02x",
> +					      phba->shost->host_no);
>  		if (!phba->msi_name[i]) {
>  			ret = -ENOMEM;
>  			goto free_msix_irqs;
>  		}
> -		sprintf(phba->msi_name[i], "beiscsi_mcc_%02x",
> -			phba->shost->host_no);
>  		ret = request_irq(pci_irq_vector(pcidev, i), be_isr_mcc, 0,
>  				  phba->msi_name[i], &phwi_context->be_eq[i]);
>  		if (ret) {
> diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
> index 81ce3ff..8166de5 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -155,8 +155,6 @@
>  #define PAGES_REQUIRED(x) \
>  	((x < PAGE_SIZE) ? 1 :  ((x + PAGE_SIZE - 1) / PAGE_SIZE))
>  
> -#define BEISCSI_MSI_NAME 20 /* size of msi_name string */
> -
>  #define MEM_DESCR_OFFSET 8
>  #define BEISCSI_DEFQ_HDR 1
>  #define BEISCSI_DEFQ_DATA 0
> -- 
> 2.7.4
> 
