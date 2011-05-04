From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [RFC-V2 PATCH] iscsiadm: Add netconfig support in iscsiadm and
 iscsid
Date: Wed, 4 May 2011 05:42:03 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728AC7E529@AVEXMB1.qlogic.org>
References: <1301769339-30008-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1304293717.3737.80.camel@ltirv-waie-lx1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:17261
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547Ab1EDMmO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2011 08:42:14 -0400
In-Reply-To: <1304293717.3737.80.camel@ltirv-waie-lx1>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

>-----Original Message-----
>From: Eddie Wai [mailto:eddie.wai@broadcom.com]
>Sent: Monday, May 02, 2011 5:19 AM
>To: open-iscsi@googlegroups.com
>Cc: James.Bottomley@suse.de; michaelc@cs.wisc.edu; linux-
>scsi@vger.kernel.org; Vikas Chaudhary; Lalit Chandivade; Ravi Anand; Harish
>Zunjarrao
>Subject: Re: [RFC-V2 PATCH] iscsiadm: Add netconfig support in iscsiadm and
>iscsid
>
>Hello Vikas,
>
>The patch looks good but I have a few questions/comments in relation to
>the general scheme of setting these iface net parameters:
>
>1.  As far as I understand, each iface file of the same hw must now
>incorporate an unique iface_num which will be used to key off the
>corresponding iface settings in the transport.  Iscsiadm will send a
>UEVENT along with the net contents to the transport only when it is
>explicitly asked to apply the update via the command line.  Perhaps it
>would be beneficial to have the initiator apply the changes implicitly
>like how it is currently making the call to the
>iscsi_host_set_net_params just prior to all the ep_connect calls.  This
>will allow the current iface parameters to be set for the corresponding
>ep_connect call.

Yes, it makes sense. We can add flag similar to "t->template->set_host_ip"
and allow implicit network configuration for each ep_connect.

Mike C, do you see any issues?

However, when we apply network settings for qla4xxx, it will do logout and
login all devices, so to avoid all devices getting logout and login for each
ep_connect call we do not want to apply network settings for each ep_connect.

>
>2. In the qla4xxx code changes, it looks like each Scsi_Host is only
>allowing 1 IPv4 and 2 IPv6 addresses to the applied to the HBA.  This is
>conceivable as each interface can only assume that number of addresses.
>But in the case of VLANs, how do you handle the case when the VLANs
>assume different IP addresses and subnets when they are based off of the
>same HBA?
>
>This can be resolved easily if we have a direct reference to the iface
>parameters upon the ep_connect call.  Perhaps embed this info (or
>iface_num) to the Scsi_Host struct?  Or just do as proposed in (1).
>
>3. Its probably a good idea to bump the ISCSI_UEVENT_MAX #define since
>the netlink.c in the initiator uses it to error out undefined events.
>>         ISCSI_UEVENT_PATH_UPDATE        = UEVENT_BASE + 20,
>> +       ISCSI_UEVENT_SET_NET_CONFIG     = UEVENT_BASE + 21,
>>
>>         ISCSI_UEVENT_MAX                = ISCSI_UEVENT_PATH_UPDATE,
>+       ISCSI_UEVENT_MAX                = ISCSI_UEVENT_SET_NET_CONFIG,
>>
>

Yes, we will fix this.

>4. Although the newly defined "set_net_config" to the iscsi_transport
>structure in the driver is a new augmentation, its interesting that the
>iscsi_transport_template in the initiator already has a "set_net_config"
>entry which is currently used for uip_broadcast_params.  We probably
>should change the name of one of them.

We are not able to find duplication of "set_net_config" on master branch of
open_iscsi. Can you please point out exact location?.

Thanks,
Vikas.

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

