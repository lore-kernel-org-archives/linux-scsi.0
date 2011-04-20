From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 3/3] scsi_dh_rdac : decide on whether to send mode
 select or not based on operating mode
Date: Wed, 20 Apr 2011 09:11:37 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FFC0B9A8@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4FFAC9628@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33201 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709Ab1DTPKj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2011 11:10:39 -0400
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4FFAC9628@cosmail01.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: "Cummins, Charles" <Charles.Cummins@lsi.com>, James Bottomley <James.Bottomley@suse.de>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Moger, Babu
> Sent: Friday, April 08, 2011 12:40 PM
> To: linux-scsi@vger.kernel.org; device-mapper development
> Cc: Dachepalli, Sudhir; Qi, Yanling; Chauhan, Vijay; Stankey, Robert;
> Arumugam, Anburaja; Krishnasamy, Somasundaram
> Subject: [PATCH 3/3] scsi_dh_rdac : decide on whether to send mode
> select or not based on operating mode
> 
> Based on the operating modes, handler decides whether to send mode
> select or not. Purpose here is to reduce
> io-shipping as much as possible whenever there is an option.
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
> 03-17 16:57:51.000000000 -0500
> +++ linux-2.6.38/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-03-17
> 16:59:11.000000000 -0500
> @@ -670,12 +670,27 @@ static int rdac_activate(struct scsi_dev
>  {
>  	struct rdac_dh_data *h = get_rdac_data(sdev);
>  	int err = SCSI_DH_OK;
> +	int act = 0;
> 
>  	err = check_ownership(sdev, h);
>  	if (err != SCSI_DH_OK)
>  		goto done;
> 
> -	if (h->lun_state == RDAC_LUN_UNOWNED) {
> +	switch (h->mode) {
> +	case RDAC_MODE:
> +		if (h->lun_state == RDAC_LUN_UNOWNED)
> +			act = 1;
> +		break;
> +	case RDAC_MODE_IOSHIP:
> +		if ((h->lun_state == RDAC_LUN_UNOWNED) &&
> +		    (h->preferred == RDAC_PREFERRED))
> +			act = 1;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (act) {
>  		err = queue_mode_select(sdev, fn, data);
>  		if (err == SCSI_DH_OK)
>  			return 0;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
