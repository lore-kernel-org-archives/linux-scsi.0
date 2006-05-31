From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [PATCH] aic94xx: make use of the new sas_port
Date: Wed, 31 May 2006 12:46:37 -0700
Message-ID: <1149104797.7543.64.camel@localhost.localdomain>
References: <1149048555.3545.64.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:4833 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S965126AbWEaTqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 15:46:45 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4VJkimH003494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 15:46:45 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k4VJkixk178598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 13:46:44 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4VJkifK021541
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 13:46:44 -0600
In-Reply-To: <1149048555.3545.64.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

These patches look good and are running on our x260 and the ppc64
(power).  I was just wondering about a few things under the sys/class/:

there is a sas_device, sas_end_device, and a sas_expander dir.
sas_device contains the same info as sas_end_device, and a sas_expander
can we eliminate one or the other?  Or was this a design choice?

Also during the boot process on the x260 with an expander we see these
printk's:
sas: phy[n] matched wide port0
If we are going to print this then we better be sure that this is truly
a wide port.  It seems under the sys/class/ we have both a single
port0:0 and then also port-0:0:[n]-- a port[n] for each phy[n].  and
although each phy seems to have the same sas_address the end_device
attached to that phy have unique addresses.  My understanding is that a
wide port has multiple phys with the same sas address and are attached
to one end device.  I believe that the expander situation is not the
same as wide port.  If this is the case then it is as simple as changing
the printk statement to not say "wide port"

I am more than happy to make these changes if everyone agrees that they
should be made.

Thanks,

Alexis 


On Tue, 2006-05-30 at 23:09 -0500, James Bottomley wrote:
> This one is slightly tricky.  The aic94xx driver has a natural sas_port
> at the HBA level, but it doesn't have any concept of a sas_port at the
> expander level.  Since this is just a proof of concept I just rammed one
> in there; however a bit more careful work will have to be done to make
> this clean.
> 
> James
> 
> diff --git a/drivers/scsi/sas/sas_discover.c b/drivers/scsi/sas/sas_discover.c
> index 9dd72c5..b9018b7 100644
> --- a/drivers/scsi/sas/sas_discover.c
> +++ b/drivers/scsi/sas/sas_discover.c
> @@ -237,13 +237,15 @@ static int sas_get_port_device(struct as
>  
>  	switch (dev->dev_type) {
>  	case SAS_END_DEV:
> -		rphy = sas_end_device_alloc(phy->phy);
> +		rphy = sas_end_device_alloc(port->port);
>  		break;
>  	case EDGE_DEV:
> -		rphy = sas_expander_alloc(phy->phy, SAS_EDGE_EXPANDER_DEVICE);
> +		rphy = sas_expander_alloc(port->port,
> +					  SAS_EDGE_EXPANDER_DEVICE);
>  		break;
>  	case FANOUT_DEV:
> -		rphy = sas_expander_alloc(phy->phy, SAS_FANOUT_EXPANDER_DEVICE);
> +		rphy = sas_expander_alloc(port->port,
> +					  SAS_FANOUT_EXPANDER_DEVICE);
>  		break;
>  	default:
>  		printk("ERROR: Unidentified device type %d\n", dev->dev_type);
> @@ -580,10 +582,6 @@ int sas_discover_end_dev(struct domain_d
>  	if (res)
>  		return res;
>  
> -
> -	if (!res) {
> -	}
> -
>  	res = sas_rphy_add(dev->rphy);
>  	if (res)
>  		goto out_err;
> diff --git a/drivers/scsi/sas/sas_expander.c b/drivers/scsi/sas/sas_expander.c
> index e716d50..5e3ba2f 100644
> --- a/drivers/scsi/sas/sas_expander.c
> +++ b/drivers/scsi/sas/sas_expander.c
> @@ -151,7 +151,6 @@ static void sas_set_ex_phy(struct domain
>  	struct sas_rphy *rphy = dev->rphy;
>  
>  	phy->phy = sas_phy_alloc(&rphy->dev, phy_id);
> -	dev_printk(KERN_ERR, &phy->phy->dev, "ALLOCATED\n\n");
>  
>  	/* FIXME: error_handling */
>  	BUG_ON(!phy->phy);
> @@ -271,18 +270,24 @@ out_err:
>  static int sas_expander_discover(struct domain_device *dev)
>  {
>  	struct expander_device *ex = &dev->ex_dev;
> -	int res;
> +	int res = -ENOMEM;
>  
>  	ex->ex_phy = kzalloc(sizeof(*ex->ex_phy)*ex->num_phys, GFP_KERNEL);
>  	if (!ex->ex_phy)
>  		return -ENOMEM;
> +	ex->ex_port = kzalloc(sizeof(void *)*ex->num_phys, GFP_KERNEL);
> +	if (!ex->ex_port)
> +		goto out_free_phys;
>  
>  	res = sas_ex_phy_discover(dev, -1);
>  	if (res)
>  		goto out_err;
>  
>  	return 0;
> -out_err:
> + out_err:
> +	kfree(ex->ex_port);
> +	ex->ex_port = NULL;
> + out_free_phys:
>  	kfree(ex->ex_phy);
>  	ex->ex_phy = NULL;
>  	return res;
> @@ -513,10 +518,20 @@ static inline void sas_ex_get_linkrate(s
>  				       struct ex_phy *parent_phy)
>  {
>  	struct expander_device *parent_ex = &parent->ex_dev;
> +	struct sas_port *port;
>  	int i;
>  
>  	child->pathways = 0;
>  
> +	for (i = 0; i < parent_ex->num_phys; i++)
> +		if (!parent_ex->ex_port[i])
> +			break;
> +
> +	parent_ex->ex_port[i] = port = sas_port_alloc(&parent->rphy->dev, i);
> +	BUG_ON(!port);
> +	/* FIXME: better error handling */
> +	BUG_ON(sas_port_add(port) != 0);
> +		
>  	for (i = 0; i < parent_ex->num_phys; i++) {
>  		struct ex_phy *phy = &parent_ex->ex_phy[i];
>  
> @@ -532,6 +547,9 @@ static inline void sas_ex_get_linkrate(s
>  			child->max_linkrate = max(parent->max_linkrate,
>  						  phy->linkrate);
>  			child->pathways++;
> +			BUG_ON(phy->port != NULL);
> +			phy->port = port;
> +			sas_port_add_phy(port, phy->phy);
>  		}
>  	}
>  	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
> @@ -590,7 +608,7 @@ static struct domain_device *sas_ex_disc
>  		}
>  	} else if (phy->attached_tproto & SAS_PROTO_SSP) {
>  		child->dev_type = SAS_END_DEV;
> -		rphy = sas_end_device_alloc(phy->phy);
> +		rphy = sas_end_device_alloc(phy->port);
>  		/* FIXME: error handling */
>  		BUG_ON(!rphy);
>  		child->tproto = phy->attached_tproto;
> @@ -613,7 +631,8 @@ static struct domain_device *sas_ex_disc
>  				    "at %016llx:0x%x returned 0x%x\n",
>  				    SAS_ADDR(child->sas_addr),
>  				    SAS_ADDR(parent->sas_addr), phy_id, res);
> -			kfree(child);
> +			/* FIXME: this kfrees list elements without removing them */
> +			//kfree(child);
>  			return NULL;
>  		}
>  	} else {
> @@ -649,10 +668,12 @@ static struct domain_device *sas_ex_disc
>  		return NULL;
>  	switch (phy->attached_dev_type) {
>  	case EDGE_DEV:
> -		rphy = sas_expander_alloc(phy->phy, SAS_EDGE_EXPANDER_DEVICE);
> +		rphy = sas_expander_alloc(phy->port,
> +					  SAS_EDGE_EXPANDER_DEVICE);
>  		break;
>  	case FANOUT_DEV:
> -		rphy = sas_expander_alloc(phy->phy, SAS_FANOUT_EXPANDER_DEVICE);
> +		rphy = sas_expander_alloc(phy->port,
> +					  SAS_FANOUT_EXPANDER_DEVICE);
>  		break;
>  	default:
>  		rphy = NULL;	/* shut gcc up */
> diff --git a/drivers/scsi/sas/sas_port.c b/drivers/scsi/sas/sas_port.c
> index 1a042f9..da4599d 100644
> --- a/drivers/scsi/sas/sas_port.c
> +++ b/drivers/scsi/sas/sas_port.c
> @@ -84,13 +84,19 @@ static void sas_form_port(struct asd_sas
>  		return;
>  	}
>  
> +	if (!port->port) {
> +		port->port = sas_port_alloc(phy->phy->dev.parent, port->id);
> +		BUG_ON(!port->port);
> +		sas_port_add(port->port);
> +	}
> +	sas_port_add_phy(port->port, phy->phy);
> +
>  	/* add the phy to the port */
>  	list_add_tail(&phy->port_phy_el, &port->phy_list);
>  	phy->port = port;
>  	port->num_phys++;
>  	port->phy_mask |= (1U << phy->id);
>  
> -	phy->phy->port_identifier = port->id;
>  	if (!port->phy)
>  		port->phy = phy->phy;
>  
> @@ -141,6 +147,7 @@ void sas_deform_port(struct asd_sas_phy 
>  		port->port_dev->pathways--;
>  
>  	if (port->num_phys == 1) {
> +		sas_port_delete(port->port);
>  		init_completion(&port->port_gone_completion);
>  		sas_discover_event(port, DISCE_PORT_GONE);
>  		wait_for_completion(&port->port_gone_completion);
> @@ -149,6 +156,8 @@ void sas_deform_port(struct asd_sas_phy 
>  	if (si->dft->lldd_port_deformed)
>  		si->dft->lldd_port_deformed(phy);
>  
> +	sas_port_delete_phy(port->port, phy->phy);
> +
>  	spin_lock(&sas_ha->phy_port_lock);
>  	spin_lock(&port->phy_list_lock);
>  
> diff --git a/include/scsi/sas/sas_class.h b/include/scsi/sas/sas_class.h
> index 0c3aae5..4b56259 100644
> --- a/include/scsi/sas/sas_class.h
> +++ b/include/scsi/sas/sas_class.h
> @@ -180,6 +180,8 @@ struct asd_sas_port {
>  
>  	struct sas_ha_struct *ha;
>  
> +	struct sas_port	*port;
> +
>  	void *lldd_port;	  /* not touched by the sas class code */
>  };
>  
> diff --git a/include/scsi/sas/sas_expander.h b/include/scsi/sas/sas_expander.h
> index e83b41c..6ce6163 100644
> --- a/include/scsi/sas/sas_expander.h
> +++ b/include/scsi/sas/sas_expander.h
> @@ -72,6 +72,7 @@ struct ex_phy {
>  	int  last_da_index;
>  
>  	struct sas_phy *phy;
> +	struct sas_port *port;
>  };
>  
>  struct expander_device {
> @@ -85,6 +86,7 @@ struct expander_device {
>  	u8     enclosure_logical_id[8];
>  
>  	struct ex_phy *ex_phy;
> +	struct sas_port **ex_port;
>  };
>  
>  int  sas_discover_root_expander(struct domain_device *dev);
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

