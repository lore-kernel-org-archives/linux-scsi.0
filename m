From: Frederic Barrat <fbarrat@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 21/38] cxlflash: Setup function OCXL link
Date: Thu, 22 Mar 2018 18:31:40 +0100
Message-ID: <a1583744-b347-240f-272a-15bfa5ded2bb@linux.vnet.ibm.com>
References: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1519683777-17510-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519683777-17510-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Content-Language: fr
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
List-Id: linux-scsi@vger.kernel.org



Le 26/02/2018 à 23:22, Uma Krishnan a écrit :
> After reading and modifying the function configuration, setup the OCXL
> link using the OCXL provider services. The link is released when the
> adapter is unconfigured.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
> Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> ---


Reviewed-by: Frederic Barrat <fbarrat@linux.vnet.ibm.com>


>   drivers/scsi/cxlflash/ocxl_hw.c | 25 ++++++++++++++++++++++---
>   drivers/scsi/cxlflash/ocxl_hw.h |  1 +
>   2 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
> index a1d58fc..ea2906d 100644
> --- a/drivers/scsi/cxlflash/ocxl_hw.c
> +++ b/drivers/scsi/cxlflash/ocxl_hw.c
> @@ -412,11 +412,28 @@ static int ocxlflash_config_fn(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
>   	ocxl_config_set_actag(pdev, fcfg->dvsec_function_pos, base, enabled);
>   	dev_dbg(dev, "%s: Function acTag range base=%u enabled=%u\n",
>   		__func__, base, enabled);
> +
> +	rc = ocxl_link_setup(pdev, 0, &afu->link_token);
> +	if (unlikely(rc)) {
> +		dev_err(dev, "%s: ocxl_link_setup failed rc=%d\n",
> +			__func__, rc);
> +		goto out;
> +	}
>   out:
>   	return rc;
>   }
> 
>   /**
> + * ocxlflash_unconfig_fn() - unconfigure the host function
> + * @pdev:	PCI device associated with the host.
> + * @afu:	AFU associated with the host.
> + */
> +static void ocxlflash_unconfig_fn(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
> +{
> +	ocxl_link_release(pdev, afu->link_token);
> +}
> +
> +/**
>    * ocxlflash_map_mmio() - map the AFU MMIO space
>    * @afu: AFU associated with the host.
>    *
> @@ -552,7 +569,7 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
>   	if (unlikely(rc)) {
>   		dev_err(dev, "%s: AFU configuration failed rc=%d\n",
>   			__func__, rc);
> -		goto err1;
> +		goto err2;
>   	}
> 
>   	ctx = ocxlflash_dev_context_init(pdev, afu);
> @@ -560,15 +577,17 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
>   		rc = PTR_ERR(ctx);
>   		dev_err(dev, "%s: ocxlflash_dev_context_init failed rc=%d\n",
>   			__func__, rc);
> -		goto err2;
> +		goto err3;
>   	}
> 
>   	idr_init(&afu->idr);
>   	afu->ocxl_ctx = ctx;
>   out:
>   	return afu;
> -err2:
> +err3:
>   	ocxlflash_unconfig_afu(afu);
> +err2:
> +	ocxlflash_unconfig_fn(pdev, afu);
>   err1:
>   	kfree(afu);
>   	afu = NULL;
> diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
> index 18f402a..4d43650 100644
> --- a/drivers/scsi/cxlflash/ocxl_hw.h
> +++ b/drivers/scsi/cxlflash/ocxl_hw.h
> @@ -31,6 +31,7 @@ struct ocxl_hw_afu {
>   	phys_addr_t gmmio_phys;		/* Global AFU MMIO space */
>   	void __iomem *gmmio_virt;	/* Global MMIO map */
> 
> +	void *link_token;		/* Link token for the SPA */
>   	struct idr idr;			/* IDR to manage contexts */
>   	int max_pasid;			/* Maximum number of contexts */
>   };
> 
