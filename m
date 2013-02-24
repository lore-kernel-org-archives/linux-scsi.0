From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND][PATCH 2/8][SCSI] mpt2sas : Fix for issue Missing delay
 not getting set during system bootup
Date: Sun, 24 Feb 2013 08:56:16 +0000
Message-ID: <1361696176.2457.7.camel@dabdike.int.hansenpartnership.com>
References: <20130201192448.GA23994@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45965 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478Ab3BXI4V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2013 03:56:21 -0500
In-Reply-To: <20130201192448.GA23994@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: Nagalakshmi.Nandigama@lsi.com, linux-scsi@vger.kernel.org, sathya.prakash@lsi.com, stable@vger.kernel.org

On Sat, 2013-02-02 at 00:54 +0530, Sreekanth Reddy wrote:
> Missing delay is not getting set properly. The reason is it is not defined in the same file from where it is being invoked.
> 
> The fix is to move the missing delay module parameter from mpt2sas_base.c to mpt2sas_scsh.c.
> 
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Cc: stable@vger.kernel.org
> ---  
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 0bb2b30..ce89b14 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -80,10 +80,6 @@ static int msix_disable = -1;
>  module_param(msix_disable, int, 0);
>  MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
>  
> -static int missing_delay[2] = {-1, -1};
> -module_param_array(missing_delay, int, NULL, 0);
> -MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
> -
>  static int mpt2sas_fwfault_debug;
>  MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of firmware fault "
>  	"and halt firmware - (default=0)");
> @@ -2183,7 +2179,7 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
>  }
>  
>  /**
> - * _base_update_missing_delay - change the missing delay timers
> + * mpt2sas_base_update_missing_delay - change the missing delay timers
>   * @ioc: per adapter object
>   * @device_missing_delay: amount of time till device is reported missing
>   * @io_missing_delay: interval IO is returned when there is a missing device
> @@ -2194,8 +2190,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
>   * delay, as well as the io missing delay. This should be called at driver
>   * load time.
>   */
> -static void
> -_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
> +void
> +mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
>  	u16 device_missing_delay, u8 io_missing_delay)
>  {
>  	u16 dmd, dmd_new, dmd_orignal;
> @@ -4391,10 +4387,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
>  	if (r)
>  		goto out_free_resources;
>  
> -	if (missing_delay[0] != -1 && missing_delay[1] != -1)
> -		_base_update_missing_delay(ioc, missing_delay[0],
> -		    missing_delay[1]);
> -
>  	return 0;
>  
>   out_free_resources:
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
> index b46024c..ee7a030 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -1054,6 +1054,9 @@ void mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_ty
>  
>  void mpt2sas_halt_firmware(struct MPT2SAS_ADAPTER *ioc);
>  
> +void mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
> +	u16 device_missing_delay, u8 io_missing_delay);
> +
>  int mpt2sas_port_enable(struct MPT2SAS_ADAPTER *ioc);
>  
>  /* scsih shared API */
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index af4e6c4..ab89b2d 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -101,6 +101,10 @@ static ushort max_sectors = 0xFFFF;
>  module_param(max_sectors, ushort, 0);
>  MODULE_PARM_DESC(max_sectors, "max sectors, range 64 to 32767  default=32767");
>  
> +static int missing_delay[2] = {-1, -1};
> +module_param_array(missing_delay, int, NULL, 0);
> +MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
> +
>  /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
>  #define MPT2SAS_MAX_LUN (16895)
>  static int max_lun = MPT2SAS_MAX_LUN;
> @@ -7303,7 +7307,9 @@ _firmware_event_work(struct work_struct *work)
>  	case MPT2SAS_PORT_ENABLE_COMPLETE:
>  		ioc->start_scan = 0;
>  
> -
> +		if (missing_delay[0] != -1 && missing_delay[1] != -1)
> +			mpt2sas_base_update_missing_delay(ioc, missing_delay[0],
> +				missing_delay[1]);

This patch is rejecting here.  It looks to be because a previous patch
of yours:

commit b4730fb6e54a634a145c9c71c5cf856f00beb5cd
Author: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Date:   Tue Dec 18 14:45:30 2012 +0100

    [SCSI] mpt2sas: fix for driver fails EEH, recovery from injected pci
bus error

Added

@@ -4386,6 +4402,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
        if (missing_delay[0] != -1 && missing_delay[1] != -1)
                _base_update_missing_delay(ioc, missing_delay[0],
                    missing_delay[1]);
+       ioc->non_operational_loop = 0;
 
        return 0;
 
I'm stopping here because correct resolution doesn't look trivial.

James


