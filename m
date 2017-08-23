From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: sg: off by one in sg_ioctl()
Date: Tue, 22 Aug 2017 21:50:23 -0400
Message-ID: <7356ab9f-1f9e-e879-8c95-52caa6802ca4@interlog.com>
References: <20170817070954.d4gg7hqgg2qjf6d3@mwanda>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36241 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753193AbdHWBu3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Aug 2017 21:50:29 -0400
In-Reply-To: <20170817070954.d4gg7hqgg2qjf6d3@mwanda>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 2017-08-17 03:09 AM, Dan Carpenter wrote:
> If "val" is SG_MAX_QUEUE then we are one element beyond the end of the
> "rinfo" array so the > should be >=.
> 
> Fixes: 109bade9c625 ("scsi: sg: use standard lists for sg_requests")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index d7ff71e0c85c..84e782d8e7c3 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1021,7 +1021,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>   			read_lock_irqsave(&sfp->rq_list_lock, iflags);
>   			val = 0;
>   			list_for_each_entry(srp, &sfp->rq_list, entry) {
> -				if (val > SG_MAX_QUEUE)
> +				if (val >= SG_MAX_QUEUE)
>   					break;
>   				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
>   				rinfo[val].req_state = srp->done + 1;
> 
