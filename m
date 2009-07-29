From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC][PATCH v2] fix wide port hotplug issues
Date: Wed, 29 Jul 2009 10:54:40 -0500
Message-ID: <1248882880.3900.45.camel@mulgrave.site>
References: <BB8426D8117A437F9C3D44C89A5E6534@usish.com.cn>
	 <1247776446.6606.393.camel@mulgrave.site>
	 <0CA78CAB92684CE9A090AEB3B871BD20@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33726 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692AbZG2Pyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 11:54:44 -0400
In-Reply-To: <0CA78CAB92684CE9A090AEB3B871BD20@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, lindar_liu@usish.com, tom_peng@usish.com, aoqingyun@usish.com

On Fri, 2009-07-17 at 16:20 +0800, jack wang wrote:
> Hi, James
> As your comments ,we resend this patch again. All comments & style issue
> have fixed.
> Best regards!

This looks much better thanks.

It still could do with a description; I created one this time, but I
can't keep on doing that.

> Jack Wang
> >From 2b269e6d73fae3a7c83171e97d894fc84798c35a Mon Sep 17 00:00:00 2001
> From: Tom Peng <tom_peng@usish.com>
> Date: Fri, 17 Jul 2009 16:02:04 +0800
> Subject: [PATCH] fix libsas wide port hotplug issue v2
> 
> Signed-off-by: Tom Peng <tom_peng@usish.com>
> Signed-off-by: Jack Wang <jack_wang@usish.com>
> Signed-off-by: Lindar Liu <lindar_liu@usish.com>
> Signed-off-by: Kevin Ao <aoqingyun@usish.com>
> ---
>  drivers/scsi/libsas/sas_expander.c |  149
> ++++++++++++++++++++++++++----------
>  1 files changed, 108 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c
> b/drivers/scsi/libsas/sas_expander.c
> index 54fa1e4..24d108f 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -766,6 +766,7 @@ static int sas_ex_join_wide_port(struct domain_device
> *parent, int phy_id)
>  		if (!memcmp(phy->attached_sas_addr, ephy->attached_sas_addr,
>  			    SAS_ADDR_SIZE) && ephy->port) {
>  			sas_port_add_phy(ephy->port, phy->phy);
> +			phy->port = ephy->port;
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
> +			    SAS_ADDR(child->sas_addr)) {
>  				ex->ex_phy[i].phy_state=
> PHY_DEVICE_DISCOVERED;
> +				res = sas_ex_join_wide_port(dev, i);
> +				if (!res)
> +					SAS_DPRINTK("Add ex phy %d to this "
> +						    "wide port.\n", i);

For consistency, I made this message the same as the prior one

> +			}

And added a missing res = 0 here.  Without this, we exit the loop with
res = -ENODEV and then return that to the caller, which is wrong.

>  		}
>  	}
>  
> @@ -1598,7 +1606,7 @@ static int sas_get_phy_attached_sas_addr(struct
> domain_device *dev,
>  }
>  
>  static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
> -			      int from_phy)
> +			      int from_phy, bool update)
>  {
>  	struct expander_device *ex = &dev->ex_dev;
>  	int res = 0;
> @@ -1611,7 +1619,9 @@ static int sas_find_bcast_phy(struct domain_device
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
> @@ -1653,31 +1663,52 @@ out:
>  	kfree(rg_req);
>  	return res;
>  }
> +/**
> + * sas_find_bcast_dev -  find the device issue BROADCAST(CHANGE).
> + * @dev:domain device to be detect.
> + * @src_dev: the device which originated BROADCAST(CHANGE).
> + *
> + * Add self-configuration expander suport. Suppose two expander cascading,
> + * when the first level expander is self-configuring, hotplug the disks in
> + * second level expander, BROADCAST(CHANGE) will not only be originated
> + * in the second level expander, but also be originated in the first level
> + * expander (see SAS protocol SAS 2r-14, 7.11 for detail), it is to say,
> + * expander changed count in two level expanders will all increment at
> least
> + * once, but the phy which chang count has changed is the source device
> which
> + * we concerned.
> + */
>  
>  static int sas_find_bcast_dev(struct domain_device *dev,
>  			      struct domain_device **src_dev)
>  {
>  	struct expander_device *ex = &dev->ex_dev;
>  	int ex_change_count = -1;
> -	int res;
> +	int phy_id = -1;
> +	int res, i = 0;

This i=0 is superfluous, you only use it to carry zero into
sas_find_bcast_phy()

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
> @@ -1700,24 +1731,26 @@ static void sas_unregister_ex_tree(struct
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
> @@ -1770,15 +1803,31 @@ static int sas_discover_new(struct domain_device
> *dev, int phy_id)
>  {
>  	struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy_id];
>  	struct domain_device *child;
> -	int res;
> +	bool found = FALSE;
> +	int res, i = 0;

No need to zero initialise i ... it's only used in a for loop where it
gets initialised.

>  
>  	SAS_DPRINTK("ex %016llx phy%d new device attached\n",
>  		    SAS_ADDR(dev->sas_addr), phy_id);
>  	res = sas_ex_phy_discover(dev, phy_id);
>  	if (res)
>  		goto out;
> +	/* to support the wide port inserted */
> +	for (i = 0; i < dev->ex_dev.num_phys; i++) {
> +		struct ex_phy *ex_phy_temp = &dev->ex_dev.ex_phy[i];
> +		if (i == phy_id)
> +			continue;
> +		if (SAS_ADDR(ex_phy_temp->attached_sas_addr) ==
> +		    SAS_ADDR(ex_phy->attached_sas_addr)) {
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
>  	list_for_each_entry(child, &dev->ex_dev.children, siblings) {
>  		if (SAS_ADDR(child->sas_addr) ==
> @@ -1793,7 +1842,8 @@ out:
>  	return res;
>  }
>  
> -static int sas_rediscover_dev(struct domain_device *dev, int phy_id)
> +static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
> +				bool last)

Should be lined up under the first arg, but actually it will fit on one
line without going over 80 characters.

>  {
>  	struct expander_device *ex = &dev->ex_dev;
>  	struct ex_phy *phy = &ex->ex_phy[phy_id];
> @@ -1804,11 +1854,11 @@ static int sas_rediscover_dev(struct domain_device
> *dev, int phy_id)
>  	switch (res) {
>  	case SMP_RESP_NO_PHY:
>  		phy->phy_state = PHY_NOT_PRESENT;
> -		sas_unregister_devs_sas_addr(dev, phy_id);
> +		sas_unregister_devs_sas_addr(dev, phy_id, last);
>  		goto out; break;
>  	case SMP_RESP_PHY_VACANT:
>  		phy->phy_state = PHY_VACANT;
> -		sas_unregister_devs_sas_addr(dev, phy_id);
> +		sas_unregister_devs_sas_addr(dev, phy_id, last);
>  		goto out; break;
>  	case SMP_RESP_FUNC_ACC:
>  		break;
> @@ -1816,7 +1866,7 @@ static int sas_rediscover_dev(struct domain_device
> *dev, int phy_id)
>  
>  	if (SAS_ADDR(attached_sas_addr) == 0) {
>  		phy->phy_state = PHY_EMPTY;
> -		sas_unregister_devs_sas_addr(dev, phy_id);
> +		sas_unregister_devs_sas_addr(dev, phy_id, last);
>  	} else if (SAS_ADDR(attached_sas_addr) ==
>  		   SAS_ADDR(phy->attached_sas_addr)) {
>  		SAS_DPRINTK("ex %016llx phy 0x%x broadcast flutter\n",
> @@ -1828,12 +1878,28 @@ out:
>  	return res;
>  }
>  
> +/**
> + * sas_rediscover -- revalidate the domain.

single - for docbook, not double.

> + * @dev:domain device to be detect.
> + * @phy_id: the phy id will be detected.
> + * NOTE: this process _must_ quit (return) as soon as any connection
> + * errors are encountered.  Connection recovery is done elsewhere.
> + * Discover process only interrogates devices in order to discover the
> + * domain.For plugging out, we un-register the device only when it is
> + * the last phy in the port, for other phys in this port, we just delete it
> + * from the port.For inserting, we do discovery when it is the
> + * first phy,for other phys in this port, we add it to the port to
> + * forming the wide-port.
> + */
>  static int sas_rediscover(struct domain_device *dev, const int phy_id)
>  {
>  	struct expander_device *ex = &dev->ex_dev;
>  	struct ex_phy *changed_phy = &ex->ex_phy[phy_id];
>  	int res = 0;
>  	int i;
> +	/* To check whether the last phy of a port determining whether or
> not
> +	delete devices*/
> +	bool last = TRUE;
>  
>  	SAS_DPRINTK("ex %016llx phy%d originated BROADCAST(CHANGE)\n",
>  		    SAS_ADDR(dev->sas_addr), phy_id);
> @@ -1848,13 +1914,13 @@ static int sas_rediscover(struct domain_device *dev,
> const int phy_id)
>  			    SAS_ADDR(changed_phy->attached_sas_addr)) {
>  				SAS_DPRINTK("phy%d part of wide port with "
>  					    "phy%d\n", phy_id, i);
> -				goto out;
> +				last = FALSE;
> +				break;
>  			}
>  		}
> -		res = sas_rediscover_dev(dev, phy_id);
> +		res = sas_rediscover_dev(dev, phy_id, last);
>  	} else
>  		res = sas_discover_new(dev, phy_id);
> -out:
>  	return res;
>  }
>  
> @@ -1881,7 +1947,7 @@ int sas_ex_revalidate_domain(struct domain_device
> *port_dev)
>  
>  		do {
>  			phy_id = -1;
> -			res = sas_find_bcast_phy(dev, &phy_id, i);
> +			res = sas_find_bcast_phy(dev, &phy_id, i, TRUE);
>  			if (phy_id == -1)
>  				break;
>  			res = sas_rediscover(dev, phy_id);
> @@ -1946,3 +2012,4 @@ int sas_smp_handler(struct Scsi_Host *shost, struct
> sas_rphy *rphy,
>  
>  	return ret;
>  }
> +

This is a spurious newline at the end of the file.

James


