From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 1/3] ipr: Remove extended delay bit on GSCSI
 reads/writes ops
Date: Wed, 05 Mar 2014 14:17:56 -0500
Message-ID: <20140305141756.Horde.MRfnwZir309TF3hkPSC0MMA@imap.linux.ibm.com>
References: <20140121181638.007394972@linux.vnet.ibm.com>
 <20140121181746.363863847@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42668 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbaCETSC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2014 14:18:02 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Wed, 5 Mar 2014 14:18:01 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id CCC5F6E8040
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2014 14:17:52 -0500 (EST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s25JHwgD8257812
	for <linux-scsi@vger.kernel.org>; Wed, 5 Mar 2014 19:17:58 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s25JHv2h018323
	for <linux-scsi@vger.kernel.org>; Wed, 5 Mar 2014 14:17:57 -0500
In-Reply-To: <20140121181746.363863847@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

Hi James,

I didn't see these patches got merged yet. Do you want me to re-submit them?

Thanks for your help!
Wendy

Quoting wenxiong@linux.vnet.ibm.com:

> This patch removes extended delay bit on GSCSI reads/writes ops, the
> performance will be significanly better.
>
> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
>
> ---
>  drivers/scsi/ipr.c |    6 +++++-
>  drivers/scsi/ipr.h |    1 +
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c	2014-01-21 11:31:51.747454658 -0600
> +++ b/drivers/scsi/ipr.c	2014-01-21 11:32:14.949015785 -0600
> @@ -1143,6 +1143,7 @@ static void ipr_init_res_entry(struct ip
>  	res->add_to_ml = 0;
>  	res->del_from_ml = 0;
>  	res->resetting_device = 0;
> +	res->reset_occurred = 0;
>  	res->sdev = NULL;
>  	res->sata_port = NULL;
>
> @@ -5015,6 +5016,7 @@ static int __ipr_eh_dev_reset(struct scs
>  	} else
>  		rc = ipr_device_reset(ioa_cfg, res);
>  	res->resetting_device = 0;
> +	res->reset_occurred = 1;
>
>  	LEAVE;
>  	return rc ? FAILED : SUCCESS;
> @@ -6183,8 +6185,10 @@ static int ipr_queuecommand(struct Scsi_
>  			ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
>
>  		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
> -		if (ipr_is_gscsi(res))
> +		if (ipr_is_gscsi(res) && res->reset_occurred) {
> +			res->reset_occurred = 0;
>  			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_DELAY_AFTER_RST;
> +		}
>  		ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_ALIGNED_BFR;
>  		ioarcb->cmd_pkt.flags_lo |= ipr_get_task_attributes(scsi_cmd);
>  	}
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2014-01-21 11:31:55.587764485 -0600
> +++ b/drivers/scsi/ipr.h	2014-01-21 11:32:14.957453279 -0600
> @@ -1252,6 +1252,7 @@ struct ipr_resource_entry {
>  	u8 add_to_ml:1;
>  	u8 del_from_ml:1;
>  	u8 resetting_device:1;
> +	u8 reset_occurred:1;
>
>  	u32 bus;		/* AKA channel */
>  	u32 target;		/* AKA id */
>
> --



