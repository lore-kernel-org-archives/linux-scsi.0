From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [RFC-V2 PATCH] iscsiadm: Add netconfig support in iscsiadm and
 iscsid
Date: Fri, 6 May 2011 05:49:44 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728AC7EA41@AVEXMB1.qlogic.org>
References: <1301769339-30008-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1304293717.3737.80.camel@ltirv-waie-lx1>
 <5E4F49720D0BAD499EE1F01232234BA8728AC7E529@AVEXMB1.qlogic.org>
 <4DC22FD9.4000908@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:49249 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755197Ab1EFMtv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 08:49:51 -0400
In-Reply-To: <4DC22FD9.4000908@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eddie Wai <eddie.wai@broadcom.com>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Thursday, May 05, 2011 10:34 AM
>To: Vikas Chaudhary
>Cc: Eddie Wai; open-iscsi@googlegroups.com; James.Bottomley@suse.de; linux-
>scsi@vger.kernel.org; Lalit Chandivade; Ravi Anand; Harish Zunjarrao
>Subject: Re: [RFC-V2 PATCH] iscsiadm: Add netconfig support in iscsiadm and
>iscsid
>
>On 05/04/2011 07:42 AM, Vikas Chaudhary wrote:
>>> -----Original Message-----
>>> From: Eddie Wai [mailto:eddie.wai@broadcom.com]
>>> Sent: Monday, May 02, 2011 5:19 AM
>>> To: open-iscsi@googlegroups.com
>>> Cc: James.Bottomley@suse.de; michaelc@cs.wisc.edu; linux-
>>> scsi@vger.kernel.org; Vikas Chaudhary; Lalit Chandivade; Ravi Anand;
>Harish
>>> Zunjarrao
>>> Subject: Re: [RFC-V2 PATCH] iscsiadm: Add netconfig support in iscsiadm
>and
>>> iscsid
>>>
>>> Hello Vikas,
>>>
>>> The patch looks good but I have a few questions/comments in relation to
>>> the general scheme of setting these iface net parameters:
>>>
>>> 1.  As far as I understand, each iface file of the same hw must now
>>> incorporate an unique iface_num which will be used to key off the
>>> corresponding iface settings in the transport.  Iscsiadm will send a
>>> UEVENT along with the net contents to the transport only when it is
>>> explicitly asked to apply the update via the command line.  Perhaps it
>>> would be beneficial to have the initiator apply the changes implicitly
>>> like how it is currently making the call to the
>>> iscsi_host_set_net_params just prior to all the ep_connect calls.  This
>>> will allow the current iface parameters to be set for the corresponding
>>> ep_connect call.
>>
>> Yes, it makes sense. We can add flag similar to "t->template-
>>set_host_ip"
>> and allow implicit network configuration for each ep_connect.
>>
>> Mike C, do you see any issues?
>
>No.
>
>And for the iface_num, I was also think working on just making the iface
>number more of a string or something. Userspace could then just pass
>down any value it wanted, so drivers like bnx2i/cxgbi/be2iscsi would not
>have to worry about the value. It could just be the userpace iface name
>since that is unique, and it would allow us to match the iface to the
>kernel object. Still working on it though. I have not completely
>convince myself. Do you guys have any issues with it or any comments?

I don't see issue if we make iface number as string, we are ok as long
as we are getting correct iface number in qla4xxx.

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

