From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [REPOST] SCSI and FC Transport: add netlink support for
 posting of transport events
Date: Sun, 20 Aug 2006 18:35:04 -0400
Message-ID: <44E8E398.8070904@cs.wisc.edu>
References: <1155936609.12933.5.camel@localhost.localdomain> <44E68F65.2000701@cs.wisc.edu> <44E6FC57.5050502@emulex.com> <44E7C86E.1030302@cs.wisc.edu> <44E8605B.1070102@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:6814 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932092AbWHTXfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 19:35:13 -0400
In-Reply-To: <44E8605B.1070102@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> Mike Christie wrote:
>> James Smart wrote:
>>> How big of a number do you need ?  48 bits ?
>>> We can up to 64bits, but I'd reserve 8bits for a "type" field.
>>> (ugh, sounds like I'm redefining naming authorities...)
>>>
>>> On a side thought - is the mac address really the right thing to
>>> use for a vendor id. Wouldn't you be extracting the vendor id from
>>> the mac address ?
>>>
>>
>> I was looking for a persistent per hba value for some other long reason
>> that we can work around in userspace so I take back that comment.
> 
> Ok - does that mean you want more than 24 bits for a vendor id ?
> Seems reasonable...

No. I meant to say below I do not need it. I thought that is what you
were telling me :) Given the host no I can find the mac address or pci
vendor or device id in sysfs

> 
>> Are you only sending the vendor id to match some vendor specific
>> userspace code with the event?
> 
> I'm only passing vendor id on events that are vendor specific. Thus, match
> on vendor id to decode the vendor event. All other events are "well-known"
> by the transport, so vendor id is irrelevant. For well-known events,
> host no
> should be all you need.
> 
> If you need to find the vendor matched to the host no, then you follow the
> other sysfs links appropriately (and should eventually resolve this from
> the general driver framework attributes).
> 
> The passing of the vendor id in the vendor messages is simply to make
> application code simpler - so it doesn't have to following all the sysfs
> links, or know the nuances of different i/o busses and their sysfs
> attributes if the vendor supports more than just pci.
> 
>> Currently, for iscsi we only send the
>> host no then match the driver, host and some driver or vendor specific
>> code by using the host no and proc_name attr.
> 
> Yep this is what I would expect - except that proc_name won't always be
> there (it's deprecated).

Are you sure it is depreciated? I thought the proc name for proc was
depreciated but then we added it to sysfs so we could figure out which
module goes with which host or something didn't we?

> 
>> This is because for
>> software iscsi and iser we do not know the pci device that will be used.
>> For software iscsi it could be a bonded device or multiple devices
>> depending on tables getting updated. What would we use for the vendor id
>> in this case?
> 
> Well - in this case, it's not a vendor-specific event being generated.
> It's an event by the iscsi/iser layer. This should fit the "well-known
> to the iscsi/iser transport" event definition and not require a vendor id.
> 

It is not vendor specific but it is driver specific and so we need a way
to route the message to the proper userspace handler for similar reasons
you may need a vendor id? For example qlogic handling may be slightly
different in userspace then broadcom. So what I am saying is I thought
the driver and vendor ids are similar, but vendor id may not work for
iscsi_tcp/iser?
