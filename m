From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] target: NULL dereference on error path
Date: Fri, 20 Jul 2012 11:38:07 -0700
Message-ID: <1342809487.25472.35.camel@haakon2.linux-iscsi.org>
References: <20120720070733.GD11710@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59595 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2GTSiJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2012 14:38:09 -0400
In-Reply-To: <20120720070733.GD11710@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Fri, 2012-07-20 at 10:07 +0300, Dan Carpenter wrote:
> We called destroy_workqueue(dev->tmr_wq) before ->tmr_wq was allocated
> which leads to an oops.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 


Looks good.  Applied to for-next w/ a comment pointing to:

commit af8772926f019b7bddd7477b8de5f3b0f12bad21
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sun Jul 8 15:58:49 2012 -0400

    target: replace the processing thread with a TMR work queue


Thanks DanC!

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 7647eca..0eaae23 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1098,7 +1098,7 @@ struct se_device *transport_add_device_to_core_hba(
>  	 * Setup the Asymmetric Logical Unit Assignment for struct se_device
>  	 */
>  	if (core_setup_alua(dev, force_pt) < 0)
> -		goto out;
> +		goto err_dev_list;
>  
>  	/*
>  	 * Startup the struct se_device processing thread
> @@ -1108,7 +1108,7 @@ struct se_device *transport_add_device_to_core_hba(
>  	if (!dev->tmr_wq) {
>  		pr_err("Unable to create tmr workqueue for %s\n",
>  			dev->transport->name);
> -		goto out;
> +		goto err_dev_list;
>  	}
>  	/*
>  	 * Setup work_queue for QUEUE_FULL
> @@ -1126,7 +1126,7 @@ struct se_device *transport_add_device_to_core_hba(
>  		if (!inquiry_prod || !inquiry_rev) {
>  			pr_err("All non TCM/pSCSI plugins require"
>  				" INQUIRY consts\n");
> -			goto out;
> +			goto err_wq;
>  		}
>  
>  		strncpy(&dev->se_sub_dev->t10_wwn.vendor[0], "LIO-ORG", 8);
> @@ -1136,9 +1136,10 @@ struct se_device *transport_add_device_to_core_hba(
>  	scsi_dump_inquiry(dev);
>  
>  	return dev;
> -out:
> -	destroy_workqueue(dev->tmr_wq);
>  
> +err_wq:
> +	destroy_workqueue(dev->tmr_wq);
> +err_dev_list:
>  	spin_lock(&hba->device_lock);
>  	list_del(&dev->dev_list);
>  	hba->dev_count--;
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


