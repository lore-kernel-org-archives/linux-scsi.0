From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] cleanup after a discovery error
Date: Thu, 19 Oct 2006 15:08:58 -0400
Message-ID: <1161284938.11219.22.camel@mulgrave.il.steeleye.com>
References: <20061019031910.GA16855@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45444 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1946135AbWJSTJE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 15:09:04 -0400
In-Reply-To: <20061019031910.GA16855@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-10-18 at 20:19 -0700, malahal@us.ibm.com wrote:
> Domain device is freed but the port dev list is not adjusted on some
> discovery errors. Module unload will Oops if this happens.
> 
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> 
> diff -r 4e1720b3c71b drivers/scsi/libsas/sas_discover.c
> --- a/drivers/scsi/libsas/sas_discover.c	Thu Oct 05 10:02:13 2006 -0700
> +++ b/drivers/scsi/libsas/sas_discover.c	Fri Oct 13 19:58:54 2006 -0700
> @@ -684,7 +684,23 @@ static void sas_discover_domain(void *da
>  	}
>  
>  	if (error) {
> -		kfree(port->port_dev); /* not kobject_register-ed yet */
> +		struct domain_device *dev = port->port_dev;
> +		
> +		if (dev->rphy) {
> +			sas_remove_children(&dev->rphy->dev);
> +			sas_rphy_delete(dev->rphy);
> +			dev->rphy = NULL;
> +		}
> +		if (dev->dev_type == EDGE_DEV || dev->dev_type == FANOUT_DEV) {
> +			if (dev->ex_dev.ex_phy) {
> +				kfree(dev->ex_dev.ex_phy);
> +				dev->ex_dev.ex_phy = NULL;
> +			}
> +		}
> +		spin_lock(&port->dev_list_lock);
> +		list_del_init(&dev->dev_list_node);
> +		spin_unlock(&port->dev_list_lock);
> +		kfree(dev); /* not kobject_register-ed yet */

This is a bit of a layering violation

if the various discover functions are going to return an error, I think
it's their job to clean up whatever they did before returning.

James


