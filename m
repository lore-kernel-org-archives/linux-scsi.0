From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 19/24] aacraid: Added new IWBR reset
Date: Mon, 30 Jan 2017 12:39:58 +0100
Message-ID: <20170130113958.GN3603@linux-x5ow.site>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-20-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53564 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751360AbdA3LkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 06:40:03 -0500
Content-Disposition: inline
In-Reply-To: <20170127192853.10082-20-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On Fri, Jan 27, 2017 at 11:28:48AM -0800, Raghava Aditya Renukunta wrote:
> Added a new IWBR soft reset type, reworked the IOP reset interface for
> a bit.
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> 
> ---

[...]

> @@ -1488,7 +1489,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
>  	 *	If a positive health, means in a known DEAD PANIC
>  	 * state and the adapter could be reset to `try again'.
>  	 */
> -	retval = aac_adapter_restart(aac, forced ? 0 : aac_adapter_check_health(aac));
> +	bled = forced ? 0 : aac_adapter_check_health(aac);
> +	retval = aac_adapter_restart(aac, bled, reset_type);
>  
>  	if (retval)
>  		goto out;
> @@ -1598,7 +1600,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
>  	return retval;
>  }
>  
> -int aac_reset_adapter(struct aac_dev * aac, int forced)
> +int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
>  {
>  	unsigned long flagv = 0;
>  	int retval;
> @@ -1651,7 +1653,9 @@ int aac_reset_adapter(struct aac_dev * aac, int forced)
>  	if (forced < 2)
>  		aac_send_shutdown(aac);
>  	spin_lock_irqsave(host->host_lock, flagv);
> -	retval = _aac_reset_adapter(aac, forced ? forced : ((aac_check_reset != 0) && (aac_check_reset != 1)));
> +	retval = _aac_reset_adapter(aac,
> +		forced ? forced : ((aac_check_reset != 0) &&
> +		(aac_check_reset != 1)), reset_type);
>  	spin_unlock_irqrestore(host->host_lock, flagv);

Can you please add a local bled here as well, like you did in
_aac_reset_adapter() instead of doing the 'forced ? forced : ((aac_check_reset
!= 0) && aac_check_reset != 1))' dance in the function call.

>  
>  	if ((forced < 2) && (retval == -ENODEV)) {
> @@ -1814,7 +1818,8 @@ int aac_check_health(struct aac_dev * aac)
>  	host = aac->scsi_host_ptr;
>  	if (aac->thread->pid != current->pid)
>  		spin_lock_irqsave(host->host_lock, flagv);
> -	BlinkLED = _aac_reset_adapter(aac, aac_check_reset != 1);
> +	BlinkLED = _aac_reset_adapter(aac,
> +		aac_check_reset != 1, IOP_HWSOFT_RESET);

Arguably here as well.

>  	if (aac->thread->pid != current->pid)
>  		spin_unlock_irqrestore(host->host_lock, flagv);
>  	return BlinkLED;
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 2ead5c7..a0f26f6 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c

[...]

> @@ -1162,7 +1162,9 @@ static ssize_t aac_store_reset_adapter(struct device *device,
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return retval;

struct aac_dev *adap = shost_priv(class_to_shost(device));
int bled = buf[0] == "!";

retval = aac_reset_adapter(adap, bled, IOP_HWSOFT_RESET);

> -	retval = aac_reset_adapter((struct aac_dev*)class_to_shost(device)->hostdata, buf[0] == '!');
> +	retval = aac_reset_adapter((struct aac_dev *)
> +		class_to_shost(device)->hostdata,
> +		buf[0] == '!', IOP_HWSOFT_RESET);
>  	if (retval >= 0)
>  		retval = count;
>  	return retval;

[...]

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
