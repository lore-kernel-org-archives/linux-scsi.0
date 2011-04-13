From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network
 configuration in sysfs
Date: Wed, 13 Apr 2011 15:53:45 -0700
Message-ID: <1302735225.10843.307.camel@nseg_linux_HP1.broadcom.com>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
 <4DA5D690.3040501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1353 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758168Ab1DMW72 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2011 18:59:28 -0400
In-Reply-To: <4DA5D690.3040501@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "vikas.chaudhary@qlogic.com" <vikas.chaudhary@qlogic.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, "lalit.chandivade@qlogic.com" <lalit.chandivade@qlogic.com>, "ravi.anand@qlogic.com" <ravi.anand@qlogic.com>, Eddie Wai <eddie.wai@broadcom.com>


On Wed, 2011-04-13 at 10:00 -0700, Mike Christie wrote:
> ccing Broadcom devs, Some questions for you guys below
> 
> 
> On 04/02/2011 01:34 PM, vikas.chaudhary@qlogic.com wrote:
> > From: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> >
> > To support multiple network addresses per adapter need to have a new way to
> > represent network interface (net iface) in sysfs.
> >
> > Currently only one ipaddress and hwaddress is displayed
> >
> > \# ls /sys/class/iscsi_host/host18
> > device  hwaddress  initiatorname  ipaddress  power  subsystem  uevent
> >
> > In this patch the net iface is presented as a separate class device.
> > The one that can be added/removed dynamically or statically, based on how
> > the user configures the multiple net iface on the adapter.
> >
> > The new sysfs directory would look like this
> > \# /sys/class/iscsi_iface/
> > |
> > |- ipv4-iface-<host_no>-<iface_no>/<-- for ipv4
> >                                  |- ipaddress
> >                                  |- subnet
> >                                  |- gateway
> >                                  |- bootproto
> >                                  |- state
> > |- ipv6-iface-<host_no>-<iface_no>/<-- for ipv6
> >                                  |- ipaddress
> >                                  |- link_local_addr
> >                                  |- router_addr
> >                                  |- ipaddr_autocfg
> >                                  |- linklocal_autocfg
> >                                  |- state
> >
> 
> 
> With patch "[RFC-V2 PATCH 1/5] iscsi_transport: add support for 
> set_net_config" userspace would send down the vlan info.
> 
> If we add a vlan sysfs file to the iscsi_iface, to export the info was 
> bnx2i going call iscsi_create_iface for each vlan? If so I am not sure 
> what bnx2i will use for the iface_num. It is supposed to be persistent, 
> right?

bnx2i doesn't need to know the IP addresses and VLANs for each HBA.  It
is all handled in userspace by uIP.  So if we add this sysfs,
iscsi_transport can handle sysfs creation for devices generically,
right?

> 
> For bnx2i, when doing iscsi offload and vlans, do you have to have a 
> netdev like ethX.Y setup for each vlan or can bnx2i operate without it 
> (the call to cnic_get_vlan always throws me and I cannot remember if we 
> were going to still do that or change something in the driver so you did 
> not need it).

For now, cnic_get_vlan will try to get a matching VLAN from netdev with
a route to the target.  But it is not required.  Once we have VLAN
attribute in iface, uIP can override and use the VLAN specified in
iface.


> 
> And just to confirm for vlans and bnx2i, when we make a ep and session, 
> cnic_get_route/cnic_cm_select_dev will do the magic to figure out what 
> vlan to use?

Yes for now.  The plan is for uIP to override if a VLAN is specified in
iface.

This is the flow:

-> ep_connect

    -> cnic_cm_connect
           /* Try to get route/MTU/VLAN from netdev if available */
        -> cnic_get_route
        -> send nl message to uIP to get next hop
        -> recv nl message from uIP
           /* at this point we may get a new VLAN ID from uIP */
        -> make connection to target




