From: <Shyam_Iyer@Dell.com>
Subject: RE: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Wed, 13 Apr 2011 15:47:32 -0700
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D1570265AEAF2E@BLRX7MCDC203.AMER.DELL.COM>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
 <4DA5D690.3040501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:40381 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964779Ab1DMWsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2011 18:48:09 -0400
In-Reply-To: <4DA5D690.3040501@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, vikas.chaudhary@qlogic.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, waie@broadcom.com, mchan@broadcom.com



> -----Original Message-----
> From: open-iscsi@googlegroups.com [mailto:open-iscsi@googlegroups.com]
> On Behalf Of Mike Christie


<snip>

> ccing Broadcom devs, Some questions for you guys below
> 
> 
> On 04/02/2011 01:34 PM, vikas.chaudhary@qlogic.com wrote:
> > From: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> >
> > To support multiple network addresses per adapter need to have a new
> way to
> > represent network interface (net iface) in sysfs.
> >
> > Currently only one ipaddress and hwaddress is displayed
> >
> > \# ls /sys/class/iscsi_host/host18
> > device  hwaddress  initiatorname  ipaddress  power  subsystem  uevent
> >
> > In this patch the net iface is presented as a separate class device.
> > The one that can be added/removed dynamically or statically, based on
> how
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

How can this converged adapter separate vlans created via ip on the network function from vlans created via iSCSI function vs vlan created on the FCoE function?

> 
> If we add a vlan sysfs file to the iscsi_iface, to export the info was
> bnx2i going call iscsi_create_iface for each vlan? If so I am not sure
> what bnx2i will use for the iface_num. It is supposed to be persistent,
> right?
> 

Would iscsiadm be used to create the vlan.. This would be introducing another way to create vlans..

