From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v2 06/38] cxlflash: Read host function configuration
Date: Wed, 7 Mar 2018 17:37:32 +1100
Message-ID: <85739e8f-e114-a185-1ff5-586651c65c39@au1.ibm.com>
References: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1519683641-16967-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519683641-16967-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Content-Language: en-AU
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
Cc: linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 27/02/18 09:20, Uma Krishnan wrote:
> Per the OCXL specification, the underlying host can have multiple AFUs
> per function with each function supporting its own configuration. The host
> function configuration is read on the initialization path to evaluate the
> number of functions present and identify the features and configuration of
> the functions present. This data is cached for use in later configuration
> steps. Note that for the OCXL hardware supported by the cxlflash driver,
> only one AFU per function is expected.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
> Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Nitpick below

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

> ---
>   drivers/scsi/cxlflash/ocxl_hw.c | 41 +++++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/cxlflash/ocxl_hw.h |  2 ++
>   2 files changed, 43 insertions(+)
> 
> diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
> index e3a0a9b..dc32a73 100644
> --- a/drivers/scsi/cxlflash/ocxl_hw.c
> +++ b/drivers/scsi/cxlflash/ocxl_hw.c
> @@ -32,6 +32,35 @@ static void ocxlflash_destroy_afu(void *afu_cookie)
>   }
> 
>   /**
> + * ocxlflash_config_fn() - configure the host function
> + * @pdev:	PCI device associated with the host.
> + * @afu:	AFU associated with the host.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int ocxlflash_config_fn(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
> +{
> +	struct ocxl_fn_config *fcfg = &afu->fcfg;
> +	struct device *dev = &pdev->dev;
> +	int rc = 0;
> +
> +	/* Read DVSEC config of the function */
> +	rc = ocxl_config_read_function(pdev, fcfg);
> +	if (unlikely(rc)) {
> +		dev_err(dev, "%s: ocxl_config_read_function failed rc=%d\n",
> +			__func__, rc);
> +		goto out;
> +	}
> +
> +	/* Only one AFU per function is supported by ocxlflash */
> +	if (fcfg->max_afu_index != 0)
> +		dev_warn(dev, "%s: Unexpected AFU index value %d\n",
> +			 __func__, fcfg->max_afu_index);
> +out:
> +	return rc;
> +}
> +
> +/**
>    * ocxlflash_create_afu() - create the AFU for OCXL
>    * @pdev:	PCI device associated with the host.
>    *
> @@ -41,6 +70,7 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
>   {
>   	struct device *dev = &pdev->dev;
>   	struct ocxl_hw_afu *afu;
> +	int rc;
> 
>   	afu = kzalloc(sizeof(*afu), GFP_KERNEL);
>   	if (unlikely(!afu)) {
> @@ -50,8 +80,19 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
> 
>   	afu->pdev = pdev;
>   	afu->dev = dev;
> +
> +	rc = ocxlflash_config_fn(pdev, afu);
> +	if (unlikely(rc)) {
> +		dev_err(dev, "%s: Function configuration failed rc=%d\n",
> +			__func__, rc);
> +		goto err1;
> +	}
>   out:
>   	return afu;
> +err1:
> +	kfree(afu);
> +	afu = NULL;
> +	goto out;

I think it would be cleaner to just write return NULL here

>   }
> 
>   /* Backend ops to ocxlflash services */
> diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
> index c7e5c4d..658f420 100644
> --- a/drivers/scsi/cxlflash/ocxl_hw.h
> +++ b/drivers/scsi/cxlflash/ocxl_hw.h
> @@ -16,4 +16,6 @@
>   struct ocxl_hw_afu {
>   	struct pci_dev *pdev;		/* PCI device */
>   	struct device *dev;		/* Generic device */
> +
> +	struct ocxl_fn_config fcfg;	/* DVSEC config of the function */
>   };
> 

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
