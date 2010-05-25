From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 1/7] qla4xxx: added BSG support
Date: Mon, 24 May 2010 21:08:19 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA870D36FB637@AVEXMB1.qlogic.org>
References: <20100511075526.GA30474@sles11sp1b1.qlogic.org>
 <4BE97CEE.8060404@cs.wisc.edu>
 <39177E34-293B-47ED-864A-1304477375EC@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:48729 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab0EYEIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2010 00:08:22 -0400
In-Reply-To: <39177E34-293B-47ED-864A-1304477375EC@qlogic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Looks like Ravi's posting never made to the reflector.
Resending Ravi's original posting again.

We wanted to conform from you whether passing data blob through bsg interface is agreeable to with you?
If we go through this approach we will provide user-space library which will allow iscsiadm
to configure HBA. We will work with Mike Christie to integrate user-space library with iscsiadm.

Looking forward for your feedback.

Thanks,
Vikas.

>-----Original Message-----
>From: Ravi Anand
>Sent: Tuesday, May 11, 2010 7:15 PM
>To: Mike Christie
>Cc: Vikas Chaudhary; james.bottomley@suse.de; linux-scsi@vger.kernel.org
>Subject: Re: [PATCH 1/7] qla4xxx: added BSG support
>
>
>On May 11, 2010, at 8:51 AM, Mike Christie wrote:
>
>
>> I think we need James's comments on this one. I am not sure what is
>> right.
>>
>> On 05/11/2010 02:55 AM, Vikas Chaudhary wrote:
>>
>>> This BSG interface is on top of patch :
>>> http://marc.info/?l=linux-scsi&m=126884917217355&w=2
>>>
>>>
>>
>>
>> All I want to be able to do is allow any app to be able to config any
>> iscsi cards. I want to support Qlogic apps, but then I also want to
>> support iscsiadm, virt tools, installers, boot tools, etc.
>>
>>
>
>Completely agree. Supporting our  Qlogic app's is one part of the
>puzzle.
>But our goal is to allow end user's to manage our cards using *iscsiadm*
>and seamlessly integrate it with other tools which you have listed.
>
>
>>
>>
>>> +	case ISCSI_BSG_HST_VENDOR:
>>> +		rval = qla4xxx_process_vendor_specific(job);
>>> +		break;
>>>
>>
>>
>> I like the idea of allowing you to use the ISCSI_BSG_HST_VENDOR for
>> all
>> your commands, because it makes the kernel code so very very
>> simple. If
>> you guys can provide a userspace gpl friendly lib or plugin to a lib
>> like IMA that allows distros tools to manage your card, then I am
>> happy
>> with this approach.
>>
>
>Definitely. We will work internally to figure out on how to move forward
>interms of providing a plugin for userspace which can be integrated with
>iscsiadm - most probably it will be an IMA plugin.
>
>But  I would say we need few weeks to figure this out.
>Let me get back to you on this one  as we need to work with another
>group who handles the API part internally.
>
>
>> My concern with this is that, it takes you guys so long to get things
>> out. We have no idea when or if it will ever be done.
>>
>>
>
>Let me just say that, we will get this effort going ASAP once we get
>the basic pieces done which will allow our API/Application to
>configure the card using
>bsg interface.
>
>And btw we need to do this bsg piece anyway - it does not matter whether
>its Qlogic App's or iscsiadm as it will require change in our API.
>
>
>>
>>
>>> +	case ISCSI_BSG_HST_NET_CONFIG:
>>> +		printk(KERN_ERR "ISCSI_BSG_HST_NET_CONFIG Commands "
>>> +		    "NOT Supported\n");
>>> +		rval = -ENOSYS;
>>> +		break;
>>>
>>
>> OTOH, I like the idea of ethtool like interface where for common
>> operations there is a command command. Then the driver takes that
>> info/cmd and does its vendor specifics.
>>
>>
>> James, someone mentioned that in the past you might have said it is ok
>> to pass blobs around if it gets passed down directly to hardware. This
>> is the case for qla4xxx here. Is it ok to let them just use the
>> HST_VENDOR command?
>>
>
>Looking forward to James comment.
>
>Thanks
>Ravi

