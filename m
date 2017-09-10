From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 1/3] fcoe: move fcoe_interface_remove() out of
 fcoe_interface_cleanup()
Date: Sun, 10 Sep 2017 10:37:30 -0700
Message-ID: <0c67667b-c2b8-6048-c89d-bd8e31b0856e@suse.com>
References: <1504171174-37989-1-git-send-email-hare@suse.de>
 <1504171174-37989-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750902AbdIJRhg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Sep 2017 13:37:36 -0400
In-Reply-To: <1504171174-37989-2-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.com>

On 08/31/2017 02:19 AM, Hannes Reinecke wrote:
> No functional change.

Nit: Then why do it? Perhaps the description can say why such a change
is being done?

> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/fcoe/fcoe.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 85f9a3e..135bdcf 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -501,11 +501,6 @@ static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
>  	struct net_device *netdev = fcoe->netdev;
>  	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
>  
> -	rtnl_lock();
> -	if (!fcoe->removed)
> -		fcoe_interface_remove(fcoe);
> -	rtnl_unlock();
> -
>  	/* Release the self-reference taken during fcoe_interface_create() */
>  	/* tear-down the FCoE controller */
>  	fcoe_ctlr_destroy(fip);
> @@ -2140,6 +2135,11 @@ static void fcoe_destroy_work(struct work_struct *work)
>  	cdev = fcoe_ctlr_to_ctlr_dev(ctlr);
>  
>  	fcoe_if_destroy(port->lport);
> +
> +	rtnl_lock();
> +	if (!fcoe->removed)
> +		fcoe_interface_remove(fcoe);
> +	rtnl_unlock();
>  	fcoe_interface_cleanup(fcoe);
>  
>  	mutex_unlock(&fcoe_config_mutex);
> @@ -2254,6 +2254,8 @@ static int _fcoe_create(struct net_device *netdev, enum fip_mode fip_mode,
>  		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
>  		       netdev->name);
>  		rc = -EIO;
> +		if (!fcoe->removed)
> +			fcoe_interface_remove(fcoe);
>  		rtnl_unlock();
>  		fcoe_interface_cleanup(fcoe);
>  		mutex_unlock(&fcoe_config_mutex);
> 

Looks good to me (other than the comment nit).

Reviewed-by: Lee Duncan <lduncan@suse.com>
-- 
Lee Duncan
SUSE Labs
