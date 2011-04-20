From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 2/3] scsi_dh_rdac : Detect the different RDAC operating
 modes
Date: Wed, 20 Apr 2011 09:10:45 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FFC0B9A7@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4FFAC9626@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:36631 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280Ab1DTPJt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2011 11:09:49 -0400
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4FFAC9626@cosmail01.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: "Cummins, Charles" <Charles.Cummins@lsi.com>, James Bottomley <James.Bottomley@suse.de>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Moger, Babu
> Sent: Friday, April 08, 2011 12:39 PM
> To: linux-scsi@vger.kernel.org; device-mapper development
> Cc: Qi, Yanling; Chauhan, Vijay; Stankey, Robert; Arumugam, Anburaja;
> Krishnasamy, Somasundaram; Dachepalli, Sudhir
> Subject: [PATCH 2/3] scsi_dh_rdac : Detect the different RDAC operating
> modes
> 
> This patch detects different operating RDAC modes during the discovery.
> It also collects the information about
> the preferred path.
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Yanling Qi <yanling.qi@lsi.com>
> Reviewed-by: Sudhir Dachepalli <Sudhir.Dachepalli@lis.com>
> Reviewed-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>
> Reviewed-by: Bob Stankey <Robert.Stankey@lsi.com>
> Reviewed-by: Vijay Chauhan <Vijay.Chauhan@lsi.com>

Tested-by: Charles Cummins <Charles.cummins@lsi.com>

> 
> ---
> --- linux-2.6.38/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-
> 03-17 16:51:40.000000000 -0500
> +++ linux-2.6.38/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-03-17
> 16:53:33.000000000 -0500
> @@ -194,7 +194,6 @@ struct rdac_dh_data {
> 
>  #define RDAC_LUN_UNOWNED	0
>  #define RDAC_LUN_OWNED		1
> -#define RDAC_LUN_AVT		2
>  	char			lun_state;
> 
>  #define RDAC_PREFERRED		0
> @@ -473,25 +472,33 @@ static int check_ownership(struct scsi_d
>  	int err;
>  	struct c9_inquiry *inqp;
> 
> -	h->lun_state = RDAC_LUN_UNOWNED;
>  	h->state = RDAC_STATE_ACTIVE;
>  	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
>  	if (err == SCSI_DH_OK) {
>  		inqp = &h->inq.c9;
> -		if ((inqp->avte_cvp >> 7) == 0x1) {
> -			/* LUN in AVT mode */
> -			sdev_printk(KERN_NOTICE, sdev,
> -				    "%s: AVT mode detected\n",
> -				    RDAC_NAME);
> -			h->lun_state = RDAC_LUN_AVT;
> -		} else if ((inqp->avte_cvp & 0x1) != 0) {
> -			/* LUN was owned by the controller */
> +		/* detect the operating mode */
> +		if ((inqp->avte_cvp >> 5) & 0x1)
> +			h->mode = RDAC_MODE_IOSHIP; /* LUN in IOSHIP mode */
> +		else if (inqp->avte_cvp >> 7)
> +			h->mode = RDAC_MODE_AVT; /* LUN in AVT mode */
> +		else
> +			h->mode = RDAC_MODE; /* LUN in RDAC mode */
> +
> +		/* Update ownership */
> +		if (inqp->avte_cvp & 0x1)
>  			h->lun_state = RDAC_LUN_OWNED;
> +		else {
> +			h->lun_state = RDAC_LUN_UNOWNED;
> +			if (h->mode == RDAC_MODE)
> +				h->state = RDAC_STATE_PASSIVE;
>  		}
> -	}
> 
> -	if (h->lun_state == RDAC_LUN_UNOWNED)
> -		h->state = RDAC_STATE_PASSIVE;
> +		/* Update path prio*/
> +		if (inqp->path_prio & 0x1)
> +			h->preferred = RDAC_PREFERRED;
> +		else
> +			h->preferred = RDAC_NON_PREFERRED;
> +	}
> 
>  	return err;
>  }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
