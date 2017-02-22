From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch] scsi_dh_emc: return success in clariion_std_inquiry()
Date: Wed, 22 Feb 2017 07:47:56 +0100
Message-ID: <cbee4bad-ea00-1c2b-4e0d-c925e35cd45c@suse.de>
References: <20170221183050.GB28595@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37775 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751349AbdBVGsA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 01:48:00 -0500
In-Reply-To: <20170221183050.GB28595@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 02/21/2017 07:46 PM, Dan Carpenter wrote:
> We accidentally return an uninitialized variable on success.
> 
> Fixes: b6ff1b14cdf4 ("[SCSI] scsi_dh: Update EMC handler")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
> index 4a7679f6c73d..f1578832ec7a 100644
> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -358,7 +358,7 @@ static int clariion_prep_fn(struct scsi_device *sdev, struct request *req)
>  static int clariion_std_inquiry(struct scsi_device *sdev,
>  				struct clariion_dh_data *csdev)
>  {
> -	int err;
> +	int err = SCSI_DH_OK;
>  	char *sp_model;
>  
>  	sp_model = parse_sp_model(sdev, sdev->inquiry);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
