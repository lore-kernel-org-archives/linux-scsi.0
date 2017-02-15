From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 03/16] aacraid: Fix for excessive prints on EEH
Date: Wed, 15 Feb 2017 09:07:33 +0100
Message-ID: <b28c9ca8-8046-7db0-6a2d-64853ec3cce4@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-4-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51835 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdBOIHf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 03:07:35 -0500
In-Reply-To: <20170214204446.14808-4-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, dan.carpenter@oracle.com

On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> This issue showed up on a kdump debug(single CPU on powerkvm), when EEH
> errors rendered the adapter unusable. The driver correctly detected the
> issue and attempted to restart the controller, in doing so the driver
> attempted to read the status registers of the controller. This triggered
> additional eeh errors which continued for a good 6 minutes.
> 
> Fixed by returning without waiting when EEH error is reported.
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> ---
>  drivers/scsi/aacraid/commsup.c | 38 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index 56090f5..6220b47 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -461,6 +461,30 @@ int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct hw_fib * hw
>  	return 0;
>  }

Please do

> +#ifdef CONFIG_EEH
> +static inline int aac_check_eeh_failure(struct aac_dev *dev)
> +{
> +	/* Check for an EEH failure for the given
> +	 * device node. Function eeh_dev_check_failure()
> +	 * returns 0 if there has not been an EEH error
> +	 * otherwise returns a non-zero value.
> +	 *
> +	 * Need to be called before any PCI operation,
> +	 * i.e.,before aac_adapter_check_health()
> +	 */
> +	struct eeh_dev *edev = pci_dev_to_eeh_dev(dev->pdev);
> +
> +	if (eeh_dev_check_failure(edev)) {
> +		/* The EEH mechanisms will handle this
> +		 * error and reset the device if
> +		 * necessary.
> +		 */
> +		return 1;
> +	}
> +	return 0;
> +}

  #else
  static inline int aac_check_eeh_failure(struct aac_dev *dev)
  {
  	return 0;
  }

> +#endif
> +

[...]

> +
> +#if defined(CONFIG_EEH)
> +				if (aac_check_eeh_failure(dev))
> +					return -EFAULT;
> +#endif
> +

So the #if defined() blocks become unnecessary.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
