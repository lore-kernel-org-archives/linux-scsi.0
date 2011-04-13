From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Wed, 13 Apr 2011 12:00:00 -0500
Message-ID: <4DA5D690.3040501@cs.wisc.edu>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com> <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32948 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab1DMRAN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2011 13:00:13 -0400
In-Reply-To: <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Eddie Wai <waie@broadcom.com>, Michael Chan <mchan@broadcom.com>

ccing Broadcom devs, Some questions for you guys below


On 04/02/2011 01:34 PM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
>
> To support multiple network addresses per adapter need to have a new way to
> represent network interface (net iface) in sysfs.
>
> Currently only one ipaddress and hwaddress is displayed
>
> \# ls /sys/class/iscsi_host/host18
> device  hwaddress  initiatorname  ipaddress  power  subsystem  uevent
>
> In this patch the net iface is presented as a separate class device.
> The one that can be added/removed dynamically or statically, based on how
> the user configures the multiple net iface on the adapter.
>
> The new sysfs directory would look like this
> \# /sys/class/iscsi_iface/
> |
> |- ipv4-iface-<host_no>-<iface_no>/<-- for ipv4
>                                  |- ipaddress
>                                  |- subnet
>                                  |- gateway
>                                  |- bootproto
>                                  |- state
> |- ipv6-iface-<host_no>-<iface_no>/<-- for ipv6
>                                  |- ipaddress
>                                  |- link_local_addr
>                                  |- router_addr
>                                  |- ipaddr_autocfg
>                                  |- linklocal_autocfg
>                                  |- state
>


With patch "[RFC-V2 PATCH 1/5] iscsi_transport: add support for 
set_net_config" userspace would send down the vlan info.

If we add a vlan sysfs file to the iscsi_iface, to export the info was 
bnx2i going call iscsi_create_iface for each vlan? If so I am not sure 
what bnx2i will use for the iface_num. It is supposed to be persistent, 
right?

For bnx2i, when doing iscsi offload and vlans, do you have to have a 
netdev like ethX.Y setup for each vlan or can bnx2i operate without it 
(the call to cnic_get_vlan always throws me and I cannot remember if we 
were going to still do that or change something in the driver so you did 
not need it).

And just to confirm for vlans and bnx2i, when we make a ep and session, 
cnic_get_route/cnic_cm_select_dev will do the magic to figure out what 
vlan to use?




> +
> +struct iscsi_iface *
> +iscsi_create_iface(struct Scsi_Host *shost, struct iscsi_transport *transport,
> +		   uint32_t iface_type, uint32_t iface_num, int dd_size)
> +{
> +	struct iscsi_iface *iface;
> +	int id;
> +	int err;
> +
> +	iface = kzalloc(sizeof(*iface) + dd_size, GFP_KERNEL);
> +	if (!iface)
> +		return NULL;
> +
> +iface_idr_again:
> +	if (!idr_pre_get(&iscsi_iface_idr, GFP_KERNEL))
> +		goto free_iface;
> +
> +	spin_lock(&iscsi_iface_lock);
> +	err = idr_get_new(&iscsi_iface_idr, iface,&id);
> +	if (err == -EAGAIN) {
> +		spin_unlock(&iscsi_iface_lock);
> +		goto iface_idr_again;
> +	}
> +	spin_unlock(&iscsi_iface_lock);
> +
> +	if (err)
> +		goto free_iface;
> +
> +	iface->id = id;
> +	iface->transport = transport;
> +	iface->iface_type = iface_type;
> +	iface->iface_num = iface_num;
> +	iface->dev.class =&iscsi_iface_class;
> +	/* parent reference */
> +	iface->dev.parent = get_device(&shost->shost_gendev);
> +	if (iface_type == IFACE_TYPE_IPV4)
> +		dev_set_name(&iface->dev, "ipv4-iface-%u-%u", shost->host_no,
> +			     iface_num);
> +	else if (iface_type == IFACE_TYPE_IPV6)
> +		dev_set_name(&iface->dev, "ipv6-iface-%u-%u", shost->host_no,
> +			     iface_num);
> +	else
> +		goto free_iface;
> +
> +	err = device_register(&iface->dev);
> +	if (err)
> +		goto free_iface;
> +
> +	if (iface_type == IFACE_TYPE_IPV4)
> +		err = sysfs_create_group(&iface->dev.kobj,
> +					&iscsi_ipv4_iface_group);
> +	else if (iface_type == IFACE_TYPE_IPV6)
> +		err = sysfs_create_group(&iface->dev.kobj,
> +					&iscsi_ipv6_iface_group);
> +
> +	if (err)
> +		goto iface_unregister_dev;
> +
> +	if (dd_size)
> +		iface->dd_data =&iface[1];
> +	return iface;
> +
> +iface_unregister_dev:
> +	idr_remove(&iscsi_iface_idr, id);
> +	device_unregister(&iface->dev);
> +
> +free_iface:
> +	kfree(iface);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(iscsi_create_iface);
