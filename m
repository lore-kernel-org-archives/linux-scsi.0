From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] fusion - mptspi - reset handler shouldn't be called	for
 other bus protocals
Date: Thu, 18 May 2006 09:45:24 -0500
Message-ID: <446C8884.4030102@sgi.com>
References: <20060517221724.GA8700@lsil.com> <1147907212.3463.99.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:57487 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1750831AbWEROpb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 10:45:31 -0400
In-Reply-To: <1147907212.3463.99.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

This patch looks as though it will result in not calling
the reset handler for MPTBASE_DRIVER, MPTCTL_DRIVER, or
MPTLAN_DRIVER.  The base and control drivers aren't
associated with any particular board type.

The other registered reset handlers, i.e., not mptspi_ioc_reset,
already properly determine if they should execute.

NACK.  (As If I get to make this decision!)

Thanks,
 Mike


James Bottomley wrote:
> On Wed, 2006-05-17 at 16:17 -0600, Eric Moore wrote:
>> All registered reset callback handlers are called during reset processing.
>> The mptspi modules has its own reset callback handler, just recently
>> added for issuing domain validation after host reset.  If either the mptsas or
>> mptfc driver are loaded, this callback could be called. Thus resulting
>> in domain validation being issued for sas or fibre end devices.
>> This patch insures domain validation is only occuring on spi end devices
>>
>> This is urgent bug fix. Pls apply this to scsi-rc-fixes-2.6,
>> as well as this patch posted yesterday:
>> http://marc.theaimsgroup.com/?l=linux-scsi&m=114782261719616&w=2
> 
> That's a pretty nasty bug ... and it will bite on the other reset
> handlers, won't it as well?  Shouldn't we be fixing it this way instead:
> 
> James
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 9080853..a300840 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1605,6 +1605,21 @@ mpt_resume(struct pci_dev *pdev)
>  }
>  #endif
>  
> +static int
> +mpt_signal_reset(int index, MPT_ADAPTER *ioc, int reset_phase)
> +{
> +	if ((MptDriverClass[index] == MPTSPI_DRIVER &&
> +	     ioc->bus_type != SPI) ||
> +	    (MptDriverClass[index] == MPTFC_DRIVER &&
> +	     ioc->bus_type != FC) ||
> +	    (MptDriverClass[index] == MPTSAS_DRIVER &&
> +	     ioc->bus_type != SAS))
> +		/* make sure we only call the relevant reset handler
> +		 * for the bus */
> +		return 0;
> +	return (MptResetHandlers[index])(ioc, reset_phase);
> +}
> +
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /*
>   *	mpt_do_ioc_recovery - Initialize or recover MPT adapter.
> @@ -1885,14 +1900,14 @@ #endif
>  			if ((ret == 0) && MptResetHandlers[ii]) {
>  				dprintk((MYIOC_s_INFO_FMT "Calling IOC post_reset handler #%d\n",
>  						ioc->name, ii));
> -				rc += (*(MptResetHandlers[ii]))(ioc, MPT_IOC_POST_RESET);
> +				rc += mpt_signal_reset(ii, ioc, MPT_IOC_POST_RESET);
>  				handlers++;
>  			}
>  
>  			if (alt_ioc_ready && MptResetHandlers[ii]) {
>  				drsprintk((MYIOC_s_INFO_FMT "Calling alt-%s post_reset handler #%d\n",
>  						ioc->name, ioc->alt_ioc->name, ii));
> -				rc += (*(MptResetHandlers[ii]))(ioc->alt_ioc, MPT_IOC_POST_RESET);
> +				rc += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_POST_RESET);
>  				handlers++;
>  			}
>  		}
> @@ -3267,11 +3282,11 @@ #endif
>  				if (MptResetHandlers[ii]) {
>  					dprintk((MYIOC_s_INFO_FMT "Calling IOC pre_reset handler #%d\n",
>  							ioc->name, ii));
> -					r += (*(MptResetHandlers[ii]))(ioc, MPT_IOC_PRE_RESET);
> +					r += mpt_signal_reset(ii, ioc, MPT_IOC_PRE_RESET);
>  					if (ioc->alt_ioc) {
>  						dprintk((MYIOC_s_INFO_FMT "Calling alt-%s pre_reset handler #%d\n",
>  								ioc->name, ioc->alt_ioc->name, ii));
> -						r += (*(MptResetHandlers[ii]))(ioc->alt_ioc, MPT_IOC_PRE_RESET);
> +						r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_PRE_RESET);
>  					}
>  				}
>  			}
> @@ -5706,11 +5721,11 @@ #endif
>  			if (MptResetHandlers[ii]) {
>  				dtmprintk((MYIOC_s_INFO_FMT "Calling IOC reset_setup handler #%d\n",
>  						ioc->name, ii));
> -				r += (*(MptResetHandlers[ii]))(ioc, MPT_IOC_SETUP_RESET);
> +				r += mpt_signal_reset(ii, ioc, MPT_IOC_SETUP_RESET);
>  				if (ioc->alt_ioc) {
>  					dtmprintk((MYIOC_s_INFO_FMT "Calling alt-%s setup reset handler #%d\n",
>  							ioc->name, ioc->alt_ioc->name, ii));
> -					r += (*(MptResetHandlers[ii]))(ioc->alt_ioc, MPT_IOC_SETUP_RESET);
> +					r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
>  				}
>  			}
>  		}
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
