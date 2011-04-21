From: <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Thu, 21 Apr 2011 15:10:37 -0700
Message-ID: <50725EF61B96174EB1803401F1A2E37335097CBF8F@EXMAIL.ad.emulex.com>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
 <4DA52525.3020405@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:33342 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752998Ab1DUWK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2011 18:10:59 -0400
In-Reply-To: <4DA52525.3020405@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, vikas.chaudhary@qlogic.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

Pl see inline

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Tuesday, April 12, 2011 9:23 PM
To: vikas.chaudhary@qlogic.com
Cc: James.Bottomley@suse.de; linux-scsi@vger.kernel.org; open-iscsi@googlegroups.com; lalit.chandivade@qlogic.com; ravi.anand@qlogic.com; Kallickal, Jayamohan
Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration in sysfs

ccing Jay from Emulex to answer question below about lots of ips in his 
card.

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


My only issue with this is that in userpsace we have the iscsi_iface 
abstraction and that handles hw, software, scsi, and net abstractions. 
This patch adds a iscsi_iface abstraction that seems more related to 
just network interfaces.

For example with the userspace iscsi_iface abstraction we can create 
virtual iscsi initiator ports by having each iface set its own initiator 
name (or we could also set the ISID or both but we do not allow that 
right now). And then for the same host you can also define userspace 
iscsi ifaces with different net settings like ip addresses, and you can 
go crazy and define those with different iscsi initiator port settings 
if you wanted to too.

With the kernel iscsi iface it seems we are just supporting net settings.

Do we want to make the kernel iscsi iface more generic or maybe just 
rename it to reflect it is just based on net settings?

The issue with making it more generic is that with the current drivers, 
we do not care what info like the initiatorname in the kernel code. That 
is all handled in userspace because all the session management is there, 
so there is no point in adding that complexity here. But will Qlogic 
need this? Will we have to tell the firmware to create a virtual iscsi 
port, then pass it the initiator name or part of the isid to use? If so 
then maybe it would be good to have a kernel interface in place to 
set/get those values on per initiator port basis.



I think you want to link the iscsi_session to the iface it is being 
accessed through, right?

Jay, for be2iscsi if you support multiple ips per host, can you end up 
with a case where a session is running through IP1, but then something 
happens to that, and you end up running through IP2? Or do the 
interfaces for the different IPs not know anything about each other 
(there is not common route table)?

The failover from one IP to another must be done outside the chip/driver .
We need to be able to setup multiple IP's per host and either  use that for
Login or find out the best path using internal routing tables in the chip.




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


It looks like we can just kill id, because it is never used.
