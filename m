From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for December 29 (fcoe)
Date: Mon, 29 Dec 2008 14:21:45 -0800
Message-ID: <49594D79.30806@oracle.com>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>	 <20081229123115.9a255fa8.randy.dunlap@oracle.com>	 <1230586520.3302.61.camel@localhost.localdomain> <1230587141.3302.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:55003 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbYL2WWB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Dec 2008 17:22:01 -0500
In-Reply-To: <1230587141.3302.64.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> 
> Actually, I deduce the problem is owner->name and your build has
> CONFIG_MODULE=n ... the definition of struct module is enclosed in a
> #ifdef CONFIG_MODULE.
> 
> This should fix it.
> 
> James

Ack.  Thanks.

> ---
> 
> diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
> index 1cb549c..fec38f6 100644
> --- a/drivers/scsi/fcoe/libfcoe.c
> +++ b/drivers/scsi/fcoe/libfcoe.c
> @@ -992,7 +992,7 @@ static int fcoe_ethdrv_get(const struct net_device *netdev)
>  	owner = fcoe_netdev_to_module_owner(netdev);
>  	if (owner) {
>  		printk(KERN_DEBUG "foce:hold driver module %s for %s\n",
> -		       owner->name, netdev->name);
> +		       module_name(owner), netdev->name);
>  		return  try_module_get(owner);
>  	}
>  	return -ENODEV;
> @@ -1012,7 +1012,7 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
>  	owner = fcoe_netdev_to_module_owner(netdev);
>  	if (owner) {
>  		printk(KERN_DEBUG "foce:release driver module %s for %s\n",
> -		       owner->name, netdev->name);
> +		       module_name(owner), netdev->name);
>  		module_put(owner);
>  		return 0;
>  	}
> 
> 


-- 
~Randy
