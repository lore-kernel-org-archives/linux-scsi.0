From: Frederic Barrat <fbarrat@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 07/38] cxlflash: Setup function acTag range
Date: Thu, 22 Mar 2018 16:48:36 +0100
Message-ID: <ca4b383f-4da7-5b29-35ee-3e39845c8de3@linux.vnet.ibm.com>
References: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1519683651-17003-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519683651-17003-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Content-Language: en-US
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



Le 26/02/2018 à 23:20, Uma Krishnan a écrit :
> The OCXL specification supports distributing acTags amongst different
> AFUs and functions on the link. The platform-specific acTag range for the
> link is obtained using the OCXL provider services and then assigned to the
> host function based on implementation. For cxlflash devices only a single
> function per host is expected and thus the entire range is assigned.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
> Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> ---
>   drivers/scsi/cxlflash/ocxl_hw.c | 15 +++++++++++++++
>   drivers/scsi/cxlflash/ocxl_hw.h |  3 +++
>   2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
> index dc32a73..39cccb7 100644
> --- a/drivers/scsi/cxlflash/ocxl_hw.c
> +++ b/drivers/scsi/cxlflash/ocxl_hw.c
> @@ -42,6 +42,7 @@ static int ocxlflash_config_fn(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
>   {
>   	struct ocxl_fn_config *fcfg = &afu->fcfg;
>   	struct device *dev = &pdev->dev;
> +	u16 base, enabled, supported;
>   	int rc = 0;
> 
>   	/* Read DVSEC config of the function */
> @@ -56,6 +57,20 @@ static int ocxlflash_config_fn(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
>   	if (fcfg->max_afu_index != 0)
>   		dev_warn(dev, "%s: Unexpected AFU index value %d\n",
>   			 __func__, fcfg->max_afu_index);
> +
> +	rc = ocxl_config_get_actag_info(pdev, &base, &enabled, &supported);
> +	if (unlikely(rc)) {
> +		dev_err(dev, "%s: ocxl_config_get_actag_info failed rc=%d\n",
> +			__func__, rc);
> +		goto out;
> +	}
> +
> +	afu->fn_actag_base = base;
> +	afu->fn_actag_enabled = enabled;
> +

Since you know your configuration (only 1 function with AFU, all actags 
to that AFU), you could even have a warning if supported != enabled, to 
detect suspicious AFU images.

Reviewed-by: Frederic Barrat <fbarrat@linux.vnet.ibm.com>


> +	ocxl_config_set_actag(pdev, fcfg->dvsec_function_pos, base, enabled);
> +	dev_dbg(dev, "%s: Function acTag range base=%u enabled=%u\n",
> +		__func__, base, enabled);
>   out:
>   	return rc;
>   }
> diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
> index 658f420..190d71a 100644
> --- a/drivers/scsi/cxlflash/ocxl_hw.h
> +++ b/drivers/scsi/cxlflash/ocxl_hw.h
> @@ -18,4 +18,7 @@ struct ocxl_hw_afu {
>   	struct device *dev;		/* Generic device */
> 
>   	struct ocxl_fn_config fcfg;	/* DVSEC config of the function */
> +
> +	int fn_actag_base;		/* Function acTag base */
> +	int fn_actag_enabled;		/* Function acTag number enabled */
>   };
> 
