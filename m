From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 01/17] aacraid: rename check_reset
Date: Mon, 9 Jul 2007 15:04:42 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01B8E1F7@otce2k301.adaptec.com>
References: <200707091859.l69Ixwlk002482@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:57951 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbXGITEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 15:04:44 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200707091859.l69Ixwlk002482@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, AACRAID <aacraid@adaptec.com>

ACK (well, I'd prefer aac_check_reset over aacraid_check_reset, but no
matter).

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: akpm@linux-foundation.org [mailto:akpm@linux-foundation.org] 
> Sent: Monday, July 09, 2007 3:00 PM
> To: James.Bottomley@steeleye.com
> Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org; 
> James.Bottomley@steeleye.com; AACRAID
> Subject: [patch 01/17] aacraid: rename check_reset
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Too generic, clashes with ISDN.
> 
> Cc: Mark Salyzyn <aacraid@adaptec.com>
> Cc: James Bottomley <James.Bottomley@SteelEye.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/aacraid/aachba.c  |    8 ++++----
>  drivers/scsi/aacraid/aacraid.h |    2 +-
>  drivers/scsi/aacraid/commsup.c |    5 +++--
>  3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff -puN 
> drivers/scsi/aacraid/aachba.c~aacraid-rename-check_reset 
> drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c~aacraid-rename-check_reset
> +++ a/drivers/scsi/aacraid/aachba.c
> @@ -177,9 +177,9 @@ int check_interval = 24 * 60 * 60;
>  module_param(check_interval, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(check_interval, "Interval in seconds 
> between adapter health checks.");
>  
> -int check_reset = 1;
> -module_param(check_reset, int, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(check_reset, "If adapter fails health 
> check, reset the adapter.");
> +int aacraid_check_reset = 1;
> +module_param_named(check_reset, aacraid_check_reset, int, 
> S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(aacraid_check_reset, "If adapter fails 
> health check, reset the adapter.");
>  
>  int expose_physicals = -1;
>  module_param(expose_physicals, int, S_IRUGO|S_IWUSR);
> @@ -1211,7 +1211,7 @@ int aac_get_adapter_info(struct aac_dev*
>  			  
> (int)sizeof(dev->supplement_adapter_info.VpdInfo.Tsid),
>  			  dev->supplement_adapter_info.VpdInfo.Tsid);
>  		}
> -		if (!check_reset ||
> +		if (!aacraid_check_reset ||
>  		  (dev->supplement_adapter_info.SupportedOptions2 &
>  		  le32_to_cpu(AAC_OPTION_IGNORE_RESET))) {
>  			printk(KERN_INFO "%s%d: Reset Adapter 
> Ignored\n",
> diff -puN 
> drivers/scsi/aacraid/aacraid.h~aacraid-rename-check_reset 
> drivers/scsi/aacraid/aacraid.h
> --- a/drivers/scsi/aacraid/aacraid.h~aacraid-rename-check_reset
> +++ a/drivers/scsi/aacraid/aacraid.h
> @@ -1857,4 +1857,4 @@ extern int aac_reset_devices;
>  extern int aac_commit;
>  extern int update_interval;
>  extern int check_interval;
> -extern int check_reset;
> +extern int aacraid_check_reset;
> diff -puN 
> drivers/scsi/aacraid/commsup.c~aacraid-rename-check_reset 
> drivers/scsi/aacraid/commsup.c
> --- a/drivers/scsi/aacraid/commsup.c~aacraid-rename-check_reset
> +++ a/drivers/scsi/aacraid/commsup.c
> @@ -1370,8 +1370,9 @@ int aac_check_health(struct aac_dev * aa
>  
>  	printk(KERN_ERR "%s: Host adapter BLINK LED 0x%x\n", 
> aac->name, BlinkLED);
>  
> -	if (!check_reset || 
> (aac->supplement_adapter_info.SupportedOptions2 &
> -	  le32_to_cpu(AAC_OPTION_IGNORE_RESET)))
> +	if (!aacraid_check_reset ||
> +		(aac->supplement_adapter_info.SupportedOptions2 &
> +			le32_to_cpu(AAC_OPTION_IGNORE_RESET)))
>  		goto out;
>  	host = aac->scsi_host_ptr;
>  	if (aac->thread->pid != current->pid)
> _
> 
