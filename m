From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH 5/5] mpt2sas: Add a module parameter that permits
 overriding protection capabilities
Date: Wed, 29 Aug 2012 15:43:35 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E20ADBF3@inbmail02.lsi.com>
References: <1346178577-28628-1-git-send-email-martin.petersen@oracle.com>
 <1346178577-28628-5-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:59322 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911Ab2H2KNo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Aug 2012 06:13:44 -0400
In-Reply-To: <1346178577-28628-5-git-send-email-martin.petersen@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>
Cc: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>

James,

This patch seem to be fine. Please consider this patch as Acked-by: "Sreekanth Reddy" <Sreekanth.reddy@lsi.com>

Regards,
Sreekanth

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen
> Sent: Wednesday, August 29, 2012 12:00 AM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@hansenpartnership.com; Martin K. Petersen;
> Nandigama, Nagalakshmi; Moore, Eric
> Subject: [PATCH 5/5] mpt2sas: Add a module parameter that permits
> overriding protection capabilities
> 
> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> Add a parameter that allows the host protection capabilities mask to be
> provided at module load time.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Nagalakshmi.Nandigama@lsi.com
> Cc: Eric.Moore@lsi.com
> ---
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index bfda0ec..96f4d1f 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -123,6 +123,11 @@ static int disable_discovery = -1;
>  module_param(disable_discovery, int, 0);
>  MODULE_PARM_DESC(disable_discovery, " disable discovery ");
> 
> +/* permit overriding the host protection capabilities mask (EEDP/T10
> PI) */
> +static int prot_mask = 0;
> +module_param(prot_mask, int, 0);
> +MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7
> ");
> +
>  /**
>   * struct sense_info - common structure for obtaining sense keys
>   * @skey: sense key
> @@ -8088,8 +8093,14 @@ _scsih_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
>  		goto out_add_shost_fail;
>  	}
> 
> -	scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
> -	    | SHOST_DIF_TYPE2_PROTECTION | SHOST_DIF_TYPE3_PROTECTION);
> +	/* register EEDP capabilities with SCSI layer */
> +	if (prot_mask)
> +		scsi_host_set_prot(shost, prot_mask);
> +	else
> +		scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
> +				   | SHOST_DIF_TYPE2_PROTECTION
> +				   | SHOST_DIF_TYPE3_PROTECTION);
> +
>  	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
> 
>  	/* event thread */
> --
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
