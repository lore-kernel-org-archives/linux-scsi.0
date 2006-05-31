From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi_transport_sas: introduce a sas_port entity
Date: Wed, 31 May 2006 11:10:20 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70141DC9@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41701 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751739AbWEaRKX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 13:10:23 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tuesday, May 30, 2006 10:05 PM, James Bottomley wrote: 

> +void sas_port_add_phy(struct sas_port *port, struct sas_phy *phy)
> +{
> +	BUG_ON(!list_empty(&phy->port_siblings));
> +	mutex_lock(&port->phy_list_mutex);
> +	sas_port_create_link(port, phy);
> +	list_add_tail(&phy->port_siblings, &port->phy_list);
> +	port->num_phys++;
> +	mutex_unlock(&port->phy_list_mutex);
> +}
> +EXPORT_SYMBOL(sas_port_add_phy);
> +
> +void sas_port_delete_phy(struct sas_port *port, struct sas_phy *phy)
> +{
> +	mutex_lock(&port->phy_list_mutex);
> +	sas_port_delete_link(port, phy);
> +	list_del_init(&port->phy_list);
> +	port->num_phys--;
> +	mutex_unlock(&port->phy_list_mutex);
> +}
> +EXPORT_SYMBOL(sas_port_delete_phy);
> +


Just want to confirm whether these two API is for handling
adding/deleting phys to the sas_port object once the wide port is
formed?

During the cable push case, I will be reporting a narrow port
first, then later needing to populate the transport sas_port 
object with the rest of my phys that form the wide port. It doesn't
all happen all at once, probably requiring about 2 seconds for 
each link to come up, thus several calls to my hotplug_work thread.

If that is the case, I will begin adding your new API today into
the fusion driver.   I've already added support in the fusion driver
for forming wide ports in sas_topology tree, that done in my internal
source a couple weeks back.  I will provide you my sotd ( source of the
day) before I go on vacation.

Eric Moore 


    
