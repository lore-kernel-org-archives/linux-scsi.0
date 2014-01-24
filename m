From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 6/6] megaraid_sas: check return value for
 megasas_get_pd_list()
Date: Fri, 24 Jan 2014 08:38:11 +0000
Message-ID: <4ead396a332c4974bf9459e1d916ca05@BN1PR07MB247.namprd07.prod.outlook.com>
References: <1389867936-118685-1-git-send-email-hare@suse.de>
 <1389867936-118685-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1lp0149.outbound.protection.outlook.com ([207.46.163.149]:33203
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbaAXIiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 03:38:14 -0500
In-Reply-To: <1389867936-118685-7-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adam Radford <aradford@gmail.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>

ACK this patch.

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, January 16, 2014 3:56 PM
> To: James Bottomley
> Cc: linux-scsi@vger.kernel.org; Hannes Reinecke; Desai, Kashyap; Adam
> Radford
> Subject: [PATCH 6/6] megaraid_sas: check return value for
> megasas_get_pd_list()
> 
> When megasas_get_pd_list() fails we cannot detect any drives, so we should
> be checking the return value accordingly.
> 
> Cc: Kashyap Desai <kashyap.desai@lsi.com>
> Cc: Adam Radford <aradford@gmail.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index d17a097..6b4c4b7 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3769,7 +3769,10 @@ static int megasas_init_fw(struct
> megasas_instance *instance)
> 
>  	memset(instance->pd_list, 0 ,
>  		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
> -	megasas_get_pd_list(instance);
> +	if (megasas_get_pd_list(instance) < 0) {
> +		printk(KERN_ERR "megasas: failed to get PD list\n");
> +		goto fail_init_adapter;
> +	}
> 
>  	memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
>  	if (megasas_ld_list_query(instance,
> @@ -5600,7 +5603,7 @@ megasas_aen_polling(struct work_struct *work)
> 
>  	if (doscan) {
>  		printk(KERN_INFO "scanning ...\n");
> -		megasas_get_pd_list(instance);
> +		if (megasas_get_pd_list(instance) == 0) {
>  		for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
>  			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL;
> j++) {
>  				pd_index =
> i*MEGASAS_MAX_DEV_PER_CHANNEL + j; @@ -5620,6 +5623,7 @@
> megasas_aen_polling(struct work_struct *work)
>  				}
>  			}
>  		}
> +		}
> 
>  		if (megasas_ld_list_query(instance,
> 
> MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
> --
> 1.7.12.4
> 

