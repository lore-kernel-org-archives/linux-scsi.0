From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] [SCSI] sd: Do not return success from init_sd if DIF
 mempool allocation fails
Date: Fri, 05 Apr 2013 11:02:24 -0400
Message-ID: <1365174144.9027.27.camel@localhost.localdomain>
References: <1360859795-30448-1-git-send-email-emilne@redhat.com>
	 <1360859795-30448-3-git-send-email-emilne@redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161875Ab3DEPCZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Apr 2013 11:02:25 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r35F2Pvb005318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 5 Apr 2013 11:02:25 -0400
Received: from [10.16.185.251] (dhcp-185-251.bos.redhat.com [10.16.185.251])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r35F2PWs029798
	for <linux-scsi@vger.kernel.org>; Fri, 5 Apr 2013 11:02:25 -0400
In-Reply-To: <1360859795-30448-3-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, 2013-02-14 at 11:36 -0500, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> init_sd() was returning 0 if sd_cdb_cache or sd_cdb_pool could
> not be allocated.  Return -ENOMEM instead, since the sd_disk_class
> and the blkdevs will be unregistered if this happens.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/sd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8551f3e..4943a4f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2931,12 +2931,14 @@ static int __init init_sd(void)
>  					 0, 0, NULL);
>  	if (!sd_cdb_cache) {
>  		printk(KERN_ERR "sd: can't init extended cdb cache\n");
> +		err = -ENOMEM;
>  		goto err_out_class;
>  	}
>  
>  	sd_cdb_pool = mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cache);
>  	if (!sd_cdb_pool) {
>  		printk(KERN_ERR "sd: can't init extended cdb pool\n");
> +		err = -ENOMEM;
>  		goto err_out_cache;
>  	}
>  

Would someone mind looking at this patch and ACKing it if you
feel it is appropriate?

Thanks.

-Ewan D. Milne <emilne@redhat.com>


