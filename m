From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] reroll of sas ports patch
Date: Wed, 28 Jun 2006 13:28:46 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701BDE93@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:8131 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751064AbWF1T2t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 15:28:49 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wednesday, June 28, 2006 10:23 AM, James Bottomley wrote: 

> This one corrects a few errors in the prior version several of which
> caused panics (missing remove children) and updates the port 
> add phy api
> (now it's legal to add a phy that's already part of the port).  I've
> also fixed the naming scheme.
> 
> expanders are now expander-<h>:<e>
> 
> where <h> host is the host number and <e> is a unique expander number
> (one per host).
> 
> ports are port-<h>:<n> for ports on the hba or port-<h>:<e>:<n> for
> ports on an expander (and phys follow the same naming pattern).
> 

Thanks, but can we have a better way in keeping track of the unique
expander numbers than using rphy->scsi_target_id?  I get confused when
I see the target id there in the code.


> +/** sas_port_alloc - allocate and initialize a SAS port structure
> + *
> + * @parent:	parent device
> + * @port_id:	port number
> + *
> + * Allocates a SAS port structure.  It will be added to the 
> device tree
> + * below the device specified by @parent which must be 
> either a Scsi_Host
> + * or a sas_expander_device.
> + *
> + * Returns %NULL on error
> + */
> +struct sas_port *sas_port_alloc(struct device *parent, int port_id)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(parent);
> +	struct sas_port *port;

Thanks for changing the port_id to int.  However the 
struct sas_port->port_identifier is still u8.  Can you
change this to unsigned int in both places?  The port_identifier
is passed to scsi_scan_target as the channel, and its uinit.
That way we are not limited to 255 ports.


>  
> @@ -920,7 +1195,7 @@
>  		break;
>  	case SAS_EDGE_EXPANDER_DEVICE:
>  	case SAS_FANOUT_EXPANDER_DEVICE:
> -		device_for_each_child(dev, NULL, do_sas_phy_delete);
> +		sas_remove_children(dev);
>  		break;
>  	default:
>  		break;

This new patch is not working for cable pull case.  Its hanging
right here inside this call to sas_remove_children().   I have
devices attached to across two expanders.  In your previous wide port 
patch's I don't have this hang, and in the older patch its
calling sas_remove_children.

Are there other changes in the patch is effecting this?



> +struct sas_port {
> +	struct device		dev;
> +
> +	u8			port_identifier;
> +	int			num_phys;
> +
> +	/* the other end of the link */
> +	struct sas_rphy		*rphy;
> +
> +	struct mutex		phy_list_mutex;
> +	struct list_head	phy_list;
> +};

Pls change port_identifier to uint or u32.


> @@ -141,13 +160,21 @@
>  extern void sas_phy_delete(struct sas_phy *);
>  extern int scsi_is_sas_phy(const struct device *);
>  
> -extern struct sas_rphy *sas_end_device_alloc(struct sas_phy *);
> -extern struct sas_rphy *sas_expander_alloc(struct sas_phy *, 
> enum sas_device_type);
> +extern struct sas_rphy *sas_end_device_alloc(struct sas_port *);
> +extern struct sas_rphy *sas_expander_alloc(struct sas_port 
> *, enum sas_device_type);
>  void sas_rphy_free(struct sas_rphy *);
>  extern int sas_rphy_add(struct sas_rphy *);
>  extern void sas_rphy_delete(struct sas_rphy *);
>  extern int scsi_is_sas_rphy(const struct device *);
>  
> +struct sas_port *sas_port_alloc(struct device *, int);
> +int sas_port_add(struct sas_port *);
> +void sas_port_free(struct sas_port *);
> +void sas_port_delete(struct sas_port *);
> +void sas_port_add_phy(struct sas_port *, struct sas_phy *);
> +void sas_port_delete_phy(struct sas_port *, struct sas_phy *);
> +int scsi_is_sas_port(const struct device *);
> +

Pls add extern in front of all the calls that do EXPORT_SYMBOL; e.g
sas_port_alloc, sas_port_add, sas_port_delete, sas_port_add_phy, and
sas_port_delete_phy.
