From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 02/08] [SCSI]  mpt2sas : Increase max transfer support
 from 4MB to 16MB
Date: Tue, 20 Dec 2011 17:16:18 +0100
Message-ID: <4EF0B4D2.7070300@redhat.com>
References: <201112010928.pB19Sbpf020920@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1LTQQZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Dec 2011 11:16:25 -0500
In-Reply-To: <201112010928.pB19Sbpf020920@milmhbs0.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nagalakshmi.nandigama@lsi.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com, JBottomley@parallels.com

On 12/01/2011 03:22 AM, nagalakshmi.nandigama@lsi.com wrote:
> Increase max transfer support from 4MB to 16MB.
> This is done by changing the shost->max_sector from 8192 to 32767
>
> Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
> ---
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 8df4095..97f0997 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -100,7 +100,7 @@ MODULE_PARM_DESC(logging_level, " bits for enabling additional logging info "
>  
>  static ushort max_sectors = 0xFFFF;
>  module_param(max_sectors, ushort, 0);
> -MODULE_PARM_DESC(max_sectors, "max sectors, range 64 to 8192  default=8192");
> +MODULE_PARM_DESC(max_sectors, "max sectors, range 64 to 32767  default=32767");
>  
>  /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
>  #define MPT2SAS_MAX_LUN (16895)
> @@ -7449,7 +7449,7 @@ static struct scsi_host_template scsih_driver_template = {
>  	.can_queue			= 1,
>  	.this_id			= -1,
>  	.sg_tablesize			= MPT2SAS_SG_DEPTH,
> -	.max_sectors			= 8192,
> +	.max_sectors			= 32767,
>  	.cmd_per_lun			= 7,
>  	.use_clustering			= ENABLE_CLUSTERING,
>  	.shost_attrs			= mpt2sas_host_attrs,
> @@ -7990,11 +7990,11 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  			printk(MPT2SAS_WARN_FMT "Invalid value %d passed "
>  			    "for max_sectors, range is 64 to 8192. Assigning "
>  			    "value of 64.\n", ioc->name, max_sectors);
> -		} else if (max_sectors > 8192) {
> -			shost->max_sectors = 8192;
> +		} else if (max_sectors > 32767) {
> +			shost->max_sectors = 32767;
>  			printk(MPT2SAS_WARN_FMT "Invalid value %d passed "
>  			    "for max_sectors, range is 64 to 8192. Assigning "
I think you wanted to change the text above "is 64 to 8192" to  "is 64 to 32767" too.
That is clearly not so important and can wait for the next patch.

> -			    "default value of 8192.\n", ioc->name,
> +			    "default value of 32767.\n", ioc->name,
>  			    max_sectors);
>  		} else {
>  			shost->max_sectors = max_sectors & 0xFFFE;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

