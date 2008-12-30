From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] fcoe: fix incorrect use of struct module
Date: Tue, 30 Dec 2008 08:42:46 -0800
Message-ID: <495A4F86.30603@oracle.com>
References: <1230652112.3296.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:36525 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYL3Qmy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2008 11:42:54 -0500
In-Reply-To: <1230652112.3296.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Love, Robert W" <robert.w.love@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> This structure may not be defined if CONFIG_MODULE=n, so never deref
> it.  Change uses of module->name to module_name(module) and corrects
> some dyslexic printks and docbook comments.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Ack again.

> ---
>  drivers/scsi/fcoe/libfcoe.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
> index 1cb549c..e419f48 100644
> --- a/drivers/scsi/fcoe/libfcoe.c
> +++ b/drivers/scsi/fcoe/libfcoe.c
> @@ -166,7 +166,7 @@ static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
>  #endif /* CONFIG_HOTPLUG_CPU */
>  
>  /**
> - * foce_rcv - this is the fcoe receive function called by NET_RX_SOFTIRQ
> + * fcoe_rcv - this is the fcoe receive function called by NET_RX_SOFTIRQ
>   * @skb: the receive skb
>   * @dev: associated net device
>   * @ptype: context
> @@ -991,8 +991,8 @@ static int fcoe_ethdrv_get(const struct net_device *netdev)
>  
>  	owner = fcoe_netdev_to_module_owner(netdev);
>  	if (owner) {
> -		printk(KERN_DEBUG "foce:hold driver module %s for %s\n",
> -		       owner->name, netdev->name);
> +		printk(KERN_DEBUG "fcoe:hold driver module %s for %s\n",
> +		       module_name(owner), netdev->name);
>  		return  try_module_get(owner);
>  	}
>  	return -ENODEV;
> @@ -1011,8 +1011,8 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
>  
>  	owner = fcoe_netdev_to_module_owner(netdev);
>  	if (owner) {
> -		printk(KERN_DEBUG "foce:release driver module %s for %s\n",
> -		       owner->name, netdev->name);
> +		printk(KERN_DEBUG "fcoe:release driver module %s for %s\n",
> +		       module_name(owner), netdev->name);
>  		module_put(owner);
>  		return 0;
>  	}


-- 
~Randy
