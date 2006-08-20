From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [REPOST] SCSI and FC Transport: add netlink support for
 posting of transport events
Date: Sun, 20 Aug 2006 18:46:33 -0400
Message-ID: <44E8E649.5050007@cs.wisc.edu>
References: <1155936609.12933.5.camel@localhost.localdomain> <44E68F65.2000701@cs.wisc.edu> <44E6FC57.5050502@emulex.com> <44E7C86E.1030302@cs.wisc.edu> <44E8605B.1070102@emulex.com> <44E8E398.8070904@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:11934 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932100AbWHTXqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 19:46:42 -0400
In-Reply-To: <44E8E398.8070904@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Mike Christie wrote:
> James Smart wrote:
>> Mike Christie wrote:
>>> James Smart wrote:
>>>> How big of a number do you need ?  48 bits ?
>>>> We can up to 64bits, but I'd reserve 8bits for a "type" field.
>>>> (ugh, sounds like I'm redefining naming authorities...)
>>>>
>>>> On a side thought - is the mac address really the right thing to
>>>> use for a vendor id. Wouldn't you be extracting the vendor id from
>>>> the mac address ?
>>>>
>>> I was looking for a persistent per hba value for some other long reason
>>> that we can work around in userspace so I take back that comment.
>> Ok - does that mean you want more than 24 bits for a vendor id ?
>> Seems reasonable...
> 
> No. I meant to say below I do not need it. I thought that is what you
> were telling me :) Given the host no I can find the mac address or pci
> vendor or device id in sysfs
> 
>>> Are you only sending the vendor id to match some vendor specific
>>> userspace code with the event?
>> I'm only passing vendor id on events that are vendor specific. Thus, match
>> on vendor id to decode the vendor event. All other events are "well-known"
>> by the transport, so vendor id is irrelevant. For well-known events,
>> host no
>> should be all you need.
>>
>> If you need to find the vendor matched to the host no, then you follow the
>> other sysfs links appropriately (and should eventually resolve this from
>> the general driver framework attributes).
>>
>> The passing of the vendor id in the vendor messages is simply to make
>> application code simpler - so it doesn't have to following all the sysfs
>> links, or know the nuances of different i/o busses and their sysfs
>> attributes if the vendor supports more than just pci.
>>
>>> Currently, for iscsi we only send the
>>> host no then match the driver, host and some driver or vendor specific
>>> code by using the host no and proc_name attr.
>> Yep this is what I would expect - except that proc_name won't always be
>> there (it's deprecated).
> 
> Are you sure it is depreciated? I thought the proc name for proc was
> depreciated but then we added it to sysfs so we could figure out which
> module goes with which host or something didn't we?
> 

I think maybe a link from the scsi host to the driver's /sys/module
would be better. I will try to send something if proc_name is depreciated.
