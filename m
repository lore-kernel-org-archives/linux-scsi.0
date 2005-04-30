From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] scsi_transport_iscsi.c contexts
Date: Fri, 29 Apr 2005 19:30:49 -0700
Message-ID: <4272EDD9.5040607@us.ibm.com>
References: <1114646147.20844.37.camel@haakon> <42705449.1030706@us.ibm.com>	 <1114803919.16658.8.camel@haakon>  <4272A506.7020405@us.ibm.com> <1114812812.19139.23.camel@haakon> <4272E301.1070504@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:25535 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263129AbVD3Ca6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 22:30:58 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j3U2Uv9w003829
	for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2005 22:30:57 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3U2Uv01100798
	for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2005 22:30:57 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j3U2UvA0013636
	for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2005 22:30:57 -0400
In-Reply-To: <4272E301.1070504@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>, open-iscsi <open-iscsi@googlegroups.com>

Mike Christie wrote:
> Nicholas A. Bellinger wrote:
> 
>> On Fri, 2005-04-29 at 14:20 -0700, Mike Christie wrote:
>>
>>>>> The reason all the settings are stuck on the session was becuase we 
>>>>> couldn't
>>>>> come to an agreement on the layout. We wanted to do something like 
>>>>> this:
>>>>>
>>>>> /sys/class/iscsi_session/iscsi_connection
>>>>>
>>>>> or even
>>>>>
>>>>> /sys/class/iscsi_session
>>>>> /sys/class/iscsi_connection
>>>>>
>>>>
>>>>
>>>> I am still thinking on this one.  First and foremost I think that we
>>>> need to get move towards a single class for iSCSI Initiators instead of
>>>> what is currently registered (/sys/class/iscsi_transport
>>>> and /sys/class/iscsi_host).  Let me keep working on this some more 
>>>> and I
>>>> will draft up a prosposal in the near future.  Any futher input is
>>>> welcomed. :-)
>>>>
>>>
>>> get everyone to agree (or force them) on how to set the initiarname 
>>> and alias
>>> and the iscsi_host can be chopped. the iscsi_host is only there 
>>> becuase sfnet
>>> used a /etc file and I think you can set the initiatorname on some HW 
>>> cards
>>> from a BIOS/OF prompt (or you will not have control over it) so if 
>>> they ever
>>> end up on the same box and wanted to konw what each one ended up as 
>>> you could.
>>>
>>
>>
>> Ok, one possible solution is when the iSCSI Template structure gets
>> registered with the iSCSI Transport, the LLD can tell the transport what
>> values are already defined.   I think this point really goes back to
>> previous points about different class attributes need to be dynamicly
>> registered within the iSCSI Stack when certain events occur.
> 
> 
> I am not arguing with that. We sent a patch to break the session
> stuff from the target (sfnet did not need the channel abstraction) and
> from there to add a connection beneath it is a matter of getting hold
> of the correct kobject to stick things under (when you use the
> transport class/container stuff it is not as simple as before though).
> 
> We are also not using sysfs for creation anymore though. Maybe we need
> to discuss that point too. We are using netlinks for this so
> open-iscsi/linux-iscsi/whatever-name-it-is-called-today:) and pyx have some
> confliting points.
> 
> As far as filesystem based creation stuff goes it also seems our sysfs
> masters may prefer configfs for things like software iscsi, dm or bonding
> where userspace is driving the device creation and not the kernel. Do
> the scsi maintainers care about this?
> 

One clarifcation for that last paragraph. I mean configfs for just the
creation part. And sysfs would still be used to export info to userspace.

Or netlink for all or parts or some other fun combo :)

