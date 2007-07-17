From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] libsas: fix lockdep issue with ATA
Date: Tue, 17 Jul 2007 13:29:56 +0200
Message-ID: <20070717112955.GR5195@kernel.dk>
References: <1184609751.3447.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:7092 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbXGQLab (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 07:30:31 -0400
Content-Disposition: inline
In-Reply-To: <1184609751.3447.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jul 16 2007, James Bottomley wrote:
> lockdep noticed that with ATA support the port->dev_list_lock was
> entangled at irq context, so it now needs to become IRQ safe
> 
> ---
> This applies against the aic94xx-sas-2.6 tree
> 
> James
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index a18c0f6..ce3385c 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -292,9 +292,9 @@ static int sas_get_port_device(struct asd_sas_port *port)
>  	port->disc.max_level = 0;
>  
>  	dev->rphy = rphy;
> -	spin_lock(&port->dev_list_lock);
> +	spin_lock_irqsave(&port->dev_list_lock, flags);
>  	list_add_tail(&dev->dev_list_node, &port->dev_list);
> -	spin_unlock(&port->dev_list_lock);
> +	spin_unlock_irqrestore(&port->dev_list_lock, flags);
>  
>  	return 0;
>  }

already uses GFP_KERNEL, so spin_lock_irq() suffices.

> @@ -688,12 +688,14 @@ static void sas_discover_domain(struct work_struct *work)
>  	}
>  
>  	if (error) {
> +		unsigned long flags;
> +
>  		sas_rphy_free(dev->rphy);
>  		dev->rphy = NULL;
>  
> -		spin_lock(&port->dev_list_lock);
> +		spin_lock_irqsave(&port->dev_list_lock, flags);
>  		list_del_init(&dev->dev_list_node);
> -		spin_unlock(&port->dev_list_lock);
> +		spin_unlock_irqrestore(&port->dev_list_lock, flags);
>  
>  		kfree(dev); /* not kobject_register-ed yet */
>  		port->port_dev = NULL;

process context, no need to save flags here either.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index d05fc23..1c15f37 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -628,6 +628,7 @@ static struct domain_device *sas_ex_discover_end_dev(
>  	struct domain_device *child = NULL;
>  	struct sas_rphy *rphy;
>  	int res;
> +	unsigned long flags;
>  
>  	if (phy->attached_sata_host || phy->attached_sata_ps)
>  		return NULL;
> @@ -677,9 +678,9 @@ static struct domain_device *sas_ex_discover_end_dev(
>  
>  		child->rphy = rphy;
>  
> -		spin_lock(&parent->port->dev_list_lock);
> +		spin_lock_irqsave(&parent->port->dev_list_lock, flags);
>  		list_add_tail(&child->dev_list_node, &parent->port->dev_list);
> -		spin_unlock(&parent->port->dev_list_lock);
> +		spin_unlock_irqrestore(&parent->port->dev_list_lock, flags);
>  
>  		res = sas_discover_sata(child);
>  		if (res) {

ditto

> @@ -701,9 +702,9 @@ static struct domain_device *sas_ex_discover_end_dev(
>  		child->rphy = rphy;
>  		sas_fill_in_rphy(child, rphy);
>  
> -		spin_lock(&parent->port->dev_list_lock);
> +		spin_lock_irqsave(&parent->port->dev_list_lock, flags);
>  		list_add_tail(&child->dev_list_node, &parent->port->dev_list);
> -		spin_unlock(&parent->port->dev_list_lock);
> +		spin_unlock_irqrestore(&parent->port->dev_list_lock, flags);
>  
>  		res = sas_discover_end_dev(child);
>  		if (res) {

ditto

> @@ -767,6 +768,7 @@ static struct domain_device *sas_ex_discover_expander(
>  	struct sas_expander_device *edev;
>  	struct asd_sas_port *port;
>  	int res;
> +	unsigned long flags;
>  
>  	if (phy->routing_attr == DIRECT_ROUTING) {
>  		SAS_DPRINTK("ex %016llx:0x%x:D <--> ex %016llx:0x%x is not "
> @@ -816,9 +818,9 @@ static struct domain_device *sas_ex_discover_expander(
>  	sas_fill_in_rphy(child, rphy);
>  	sas_rphy_add(rphy);
>  
> -	spin_lock(&parent->port->dev_list_lock);
> +	spin_lock_irqsave(&parent->port->dev_list_lock, flags);
>  	list_add_tail(&child->dev_list_node, &parent->port->dev_list);
> -	spin_unlock(&parent->port->dev_list_lock);
> +	spin_unlock_irqrestore(&parent->port->dev_list_lock, flags);
>  
>  	res = sas_discover_expander(child);
>  	if (res) {

ditto :-)

-- 
Jens Axboe

