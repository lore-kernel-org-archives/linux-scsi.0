From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC][PATCH 4/5] fix wide port hotplug issues
Date: Thu, 16 Jul 2009 15:34:06 -0500
Message-ID: <1247776446.6606.393.camel@mulgrave.site>
References: <BB8426D8117A437F9C3D44C89A5E6534@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33056 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933272AbZGPUeK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2009 16:34:10 -0400
In-Reply-To: <BB8426D8117A437F9C3D44C89A5E6534@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, lindar_liu@usish.com, tom_peng@usish.com, aoqingyun@usish.com

On Wed, 2009-07-01 at 20:41 +0800, jack wang wrote:
> The sas layer does not support wide port hotplug, we modified it. For
> plugging out, we un-register the device only when it is the last phy in the
> port, for other phys in this port, we just delete it from the port.For
> inserting, we do discovery when it is the first phy,for other phys in this
> port, we add it to the port to
> forming the wide-port.
> 					Jack
> >From d683c649d0ed8de69b1ffda1b87383ae13fed164 Mon Sep 17 00:00:00 2001
> From: Tom Peng <tom_peng@usish.com>
> Date: Wed, 1 Jul 2009 19:11:03 +0800
> Subject: [PATCH 4/5] fix wide port hotplug issues
> 
> Signed-off-by: Tom Peng <tom_peng@usish.com>
> Signed-off-by: Jack Wang <jack_wang@usish.com>
> Signed-off-by: Lindar Liu <lindar_liu@usish.com>
> ---
>  drivers/scsi/libsas/sas_expander.c |  190
> ++++++++++++++++++++++++------------
>  1 files changed, 126 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c
> b/drivers/scsi/libsas/sas_expander.c
> index 54fa1e4..20fa5e4 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -764,8 +764,9 @@ static int sas_ex_join_wide_port(struct domain_device
> *parent, int phy_id)
>  			continue;
>  
>  		if (!memcmp(phy->attached_sas_addr, ephy->attached_sas_addr,
> -			    SAS_ADDR_SIZE) && ephy->port) {
> +			SAS_ADDR_SIZE) && ephy->port) {

It would be really nice if you could fix up your patches to avoid
spurious white space changes like this (particularly when they're not
correct: we do line up the arguments to a split line function call under
the first arg).

>  			sas_port_add_phy(ephy->port, phy->phy);
> +			phy->port = ephy->port;

So this is an actual bug in the wide port handling routines, isn't it?
without this, an unplug of a port not the original one will do a NULL
deref on phy->port.

>  			phy->phy_state = PHY_DEVICE_DISCOVERED;
>  			return 0;
>  		}
> @@ -945,10 +946,17 @@ static int sas_ex_discover_dev(struct domain_device
> *dev, int phy_id)
>  			if (ex->ex_phy[i].phy_state == PHY_VACANT ||
>  			    ex->ex_phy[i].phy_state == PHY_NOT_PRESENT)
>  				continue;
> -
> +			/* in before discover process, it does not add the
> phy
> +			* to wide port, so we add the phy to the wide port
> here.
> +			*/
>  			if (SAS_ADDR(ex->ex_phy[i].attached_sas_addr) ==
> -			    SAS_ADDR(child->sas_addr))
> +				SAS_ADDR(child->sas_addr)) {
>  				ex->ex_phy[i].phy_state=
> PHY_DEVICE_DISCOVERED;
> +				res = sas_ex_join_wide_port(dev, i);
> +				if (!res)
> +					SAS_DPRINTK("Add ex phy %d to this "
> +						"wide port.\n", i);
> +			}

So this doesn't look right.  There's already a check for wide ports at
the top of this function.  That should pick up any port because we call
this routine for any discoverable device (regardless of phy).

>  		}
>  	}
>  
> @@ -1589,16 +1597,14 @@ static int sas_get_phy_attached_sas_addr(struct
> domain_device *dev,
>  
>  	res = sas_get_phy_discover(dev, phy_id, disc_resp);
>  	if (!res) {
> -
> memcpy(attached_sas_addr,disc_resp->disc.attached_sas_addr,8);
> -		if (dr->attached_dev_type == 0)
> -			memset(attached_sas_addr, 0, 8);
> +		memcpy(attached_sas_addr, disc_resp->disc.attached_sas_addr,
> 8);

So what the removed code is doing is trying to stop scanning of
initiators ... they appear with a routing address but no actual device
attached.

>  	}
>  	kfree(disc_resp);
>  	return res;
>  }
>  
>  static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
> -			      int from_phy)
> +			      int from_phy, bool update)
>  {
>  	struct expander_device *ex = &dev->ex_dev;
>  	int res = 0;
> @@ -1611,7 +1617,9 @@ static int sas_find_bcast_phy(struct domain_device
> *dev, int *phy_id,
>  		if (res)
>  			goto out;
>  		else if (phy_change_count != ex->ex_phy[i].phy_change_count)
> {
> -			ex->ex_phy[i].phy_change_count = phy_change_count;
> +			if (update)
> +				ex->ex_phy[i].phy_change_count =
> +					phy_change_count;
>  			*phy_id = i;
>  			return 0;
>  		}
> @@ -1653,31 +1661,50 @@ out:
>  	kfree(rg_req);
>  	return res;
>  }
> -
> +/**
> + * sas_find_bcast_dev -  in before version, it does not consider
> + * SAS self-configuration expander. Suppose two expander cascading,
> + * while the first level expander is self-configuring, hotplug the disks in
> + * second level expander, BROADCAST(CHANGE) will not only be originated
> + * in the second level expander, but also be originated in the first level
> + * expander (see SAS protocol SAS 2r-14, 7.11 for detail), it is to say,
> + * expander changed count in two level expanders will all increment at
> least
> + * once, but the phy which chang count has changed is the source device
> which
> + * we concerned.
> + * @dev:domain device to be detect.
> + * @src_dev: the device which originated BROADCAST(CHANGE).

This isn't actually DocBook; it needs to be

/**
* function - one line summary
* @arg: argument descriptions
* ...
*
* Body
*/

> + */
>  static int sas_find_bcast_dev(struct domain_device *dev,
>  			      struct domain_device **src_dev)
>  {
>  	struct expander_device *ex = &dev->ex_dev;
>  	int ex_change_count = -1;
> -	int res;
> +	int phy_id = -1;
> +	int res, i = 0;
> +	struct domain_device *ch;
>  
>  	res = sas_get_ex_change_count(dev, &ex_change_count);
>  	if (res)
>  		goto out;
> -	if (ex_change_count != -1 &&
> -	    ex_change_count != ex->ex_change_count) {
> -		*src_dev = dev;
> -		ex->ex_change_count = ex_change_count;
> -	} else {
> -		struct domain_device *ch;
> -
> -		list_for_each_entry(ch, &ex->children, siblings) {
> -			if (ch->dev_type == EDGE_DEV ||
> -			    ch->dev_type == FANOUT_DEV) {
> -				res = sas_find_bcast_dev(ch, src_dev);
> -				if (src_dev)
> -					return res;
> -			}
> +	if (ex_change_count != -1 && ex_change_count != ex->ex_change_count)
> {
> +		/* Just detect if this expander phys phy change count
> changed,
> +		* in order to determine if this expander originate
> BROADCAST,
> +		* and do not update phy change count field in our structure.
> +		*/
> +		res = sas_find_bcast_phy(dev, &phy_id, i, FALSE);
> +		if (phy_id != -1) {
> +			*src_dev = dev;
> +			ex->ex_change_count = ex_change_count;
> +			SAS_DPRINTK("Expander phy change count has changed
> \n");
> +			return res;
> +		} else
> +			SAS_DPRINTK("Expander phys DID NOT changed \n");
> +	}
> +	list_for_each_entry(ch, &ex->children, siblings) {
> +		if (ch->dev_type == EDGE_DEV || ch->dev_type == FANOUT_DEV)
> {
> +			res = sas_find_bcast_dev(ch, src_dev);
> +			if (src_dev)
> +				return res;
>  		}
>  	}
>  out:
> @@ -1700,24 +1727,26 @@ static void sas_unregister_ex_tree(struct
> domain_device *dev)
>  }
>  
>  static void sas_unregister_devs_sas_addr(struct domain_device *parent,
> -					 int phy_id)
> +					int phy_id, bool last)
>  {
>  	struct expander_device *ex_dev = &parent->ex_dev;
>  	struct ex_phy *phy = &ex_dev->ex_phy[phy_id];
>  	struct domain_device *child, *n;
> -
> -	list_for_each_entry_safe(child, n, &ex_dev->children, siblings) {
> -		if (SAS_ADDR(child->sas_addr) ==
> -		    SAS_ADDR(phy->attached_sas_addr)) {
> -			if (child->dev_type == EDGE_DEV ||
> -			    child->dev_type == FANOUT_DEV)
> -				sas_unregister_ex_tree(child);
> -			else
> -				sas_unregister_dev(child);
> -			break;
> +	if (last) {
> +		list_for_each_entry_safe(child, n,
> +			&ex_dev->children, siblings) {
> +			if (SAS_ADDR(child->sas_addr) ==
> +				SAS_ADDR(phy->attached_sas_addr)) {
> +				if (child->dev_type == EDGE_DEV ||
> +					child->dev_type == FANOUT_DEV)
> +					sas_unregister_ex_tree(child);
> +				else
> +					sas_unregister_dev(child);
> +				break;
> +			}
>  		}
> +		sas_disable_routing(parent, phy->attached_sas_addr);
>  	}
> -	sas_disable_routing(parent, phy->attached_sas_addr);
>  	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
>  	sas_port_delete_phy(phy->port, phy->phy);
>  	if (phy->port->num_phys == 0)
> @@ -1770,21 +1799,37 @@ static int sas_discover_new(struct domain_device
> *dev, int phy_id)
>  {
>  	struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy_id];
>  	struct domain_device *child;
> -	int res;
> +	bool found = FALSE;
> +	int res, i = 0;
>  
>  	SAS_DPRINTK("ex %016llx phy%d new device attached\n",
> -		    SAS_ADDR(dev->sas_addr), phy_id);
> +		SAS_ADDR(dev->sas_addr), phy_id);
>  	res = sas_ex_phy_discover(dev, phy_id);
>  	if (res)
>  		goto out;
> +	/* to support the wide port inserted */
> +	for (i = 0; i < dev->ex_dev.num_phys; i++) {
> +		struct ex_phy *ex_phy_temp = &dev->ex_dev.ex_phy[i];
> +		if (i == phy_id)
> +			continue;
> +		if (SAS_ADDR(ex_phy_temp->attached_sas_addr) ==
> +			SAS_ADDR(ex_phy->attached_sas_addr)) {
> +			found = TRUE;
> +			break;
> +		}
> +	}
> +	if (found == TRUE) {
> +		sas_ex_join_wide_port(dev, phy_id);
> +		return 0;
> +	}
>  	res = sas_ex_discover_devices(dev, phy_id);
> -	if (res)
> +	if (!res)
>  		goto out;


Why did this logic get inverted here?

James


