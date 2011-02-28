From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH 0/5]: Proposal for iSCSI Network Configuration
Date: Mon, 28 Feb 2011 14:02:45 -0800
Message-ID: <B3CF718A-8F11-475B-B50C-3A452EB3F746@qlogic.com>
References: <5E4F49720D0BAD499EE1F01232234BA8722624A352@AVEXMB1.qlogic.org>
 <4D6B0781.1050403@cs.wisc.edu>
 <5E4F49720D0BAD499EE1F01232234BA87226303BCC@AVEXMB1.qlogic.org>
 <4D6B595B.4000109@cs.wisc.edu>
 <5E4F49720D0BAD499EE1F01232234BA87226303BEB@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:40126
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab1B1WCM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2011 17:02:12 -0500
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA87226303BEB@AVEXMB1.qlogic.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, James Bottomley <James.Bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>


On Feb 28, 2011, at 1:34 AM, Vikas Chaudhary wrote:

>> -----Original Message-----
>> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>> Sent: Monday, February 28, 2011 1:44 PM
>> To: Vikas Chaudhary
>> Cc: open-iscsi@googlegroups.com; James Bottomley; linux-
>> scsi@vger.kernel.org; Lalit Chandivade; Harish Zunjarrao; Manish Rangankar;
>> Ravi Anand
>> Subject: Re: [PATCH 0/5]: Proposal for iSCSI Network Configuration
>>
>> On 02/28/2011 12:02 AM, Vikas Chaudhary wrote:
>>> - We still need the BSG interface, which we are working on our side, to
>> get the
>>>   adapter FLASH related read/write operations.
>>
>> So would that be the operations to do something like store/get targets,
>> discovery info, isns, chap, iscsi settings like FirstBurst, etc?
>
> We are planning to add BSG for Vendor specific flash updates like, read/write operations of - NVRAM, firmware and bootcode.
>
> We will use Netlink interface for target discovery info, iscsi settings, login/logout of target.
>

Basically during last year discussion with you/James/Fujito , two important pieces came out of the discussion :

* Common Generic interface which will work for other H/W offload.
* iscsiadm support for H/W offload, for ex : qla4xxx in this case, so that user can configure
it using Linux native tools.

So after looking into iscsiadm interface and how our API interface works, it seemed much
more logical to use the iscsidam existing interface rather than trying to reinvent the wheel.
The additional work which will be required is to hook up our Application to *Netlink* interface
and iscsiadm will work just by extending the existing infrastrutcure for configuration for ex, which
is a key element for our flash based H/W offload.

As Vikas alluded, BSG will be strictly adhered to just for vendor specific part where we may need to pass
*bigger* blob of data in both directions or updating F/W or NVRAM etc. This is unlike what we intially proposed
for setting up iscsi settings etc using vendor specific bsg interface which was doing it in a opaque manner.

Other discovery element for ex : send target discovery / login/logout etc is being worked on so user can use iscsiadm
native interface.

So we have provided the iscsiadm+iscsi transport+qla4xxx patch for network configuration, to provide the complete overview
the direction we want to go.

Looking forward to comments/feedback to continue this discussion and come to an agreement on how to proceed further.


Thanks
Ravi

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

