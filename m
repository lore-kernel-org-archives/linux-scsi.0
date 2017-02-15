From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi, block: fix memory leak of sdpk on when gd fails
 to allocate
Date: Wed, 15 Feb 2017 18:03:09 +0000
Message-ID: <1487181776.2666.7.camel@sandisk.com>
References: <20170203193854.6782-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:21661 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdBOSLl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 13:11:41 -0500
In-Reply-To: <20170203193854.6782-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <2DA25FC9E4D29546A76B8CA45B3A0C83@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "colin.king@canonical.com" <colin.king@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

On Fri, 2017-02-03 at 19:38 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> On an allocation failure of gd, the current exit path is via out_free_devt
> which leaves sdpk still allocated and hence it gets leaked. Fix this by
> correcting the order of resource free'ing with a change in the error exit
> path labels.
> 
> Detected by CoverityScan, CID#1399519 ("Resource Leak")
> 
> Fixes: 0dba1314d4f81115dc ("scsi, block: fix duplicate bdi name registration crashes")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/sd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index cb6e68d..99e1206 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3213,10 +3213,10 @@ static int sd_probe(struct device *dev)
>  	sd_devt = NULL;
>   out_put:
>  	put_disk(gd);
> - out_free:
> -	kfree(sdkp);
>   out_free_devt:
>  	kfree(sd_devt);
> + out_free:
> +	kfree(sdkp);
>   out:
>  	scsi_autopm_put_device(sdp);
>  	return error;

Hello Colin,

This patch looks fine to me. But since it is a fix for a patch that exists
in Jens' tree and that is not yet upstream, please resubmit it to Jens.

Bart.
