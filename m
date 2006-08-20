From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] [REPOST] SCSI and FC Transport: add netlink support for
 posting of transport events
Date: Sun, 20 Aug 2006 09:15:07 -0400
Message-ID: <44E8605B.1070102@emulex.com>
References: <1155936609.12933.5.camel@localhost.localdomain> <44E68F65.2000701@cs.wisc.edu> <44E6FC57.5050502@emulex.com> <44E7C86E.1030302@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:6830 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1750751AbWHTNaV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 09:30:21 -0400
In-Reply-To: <44E7C86E.1030302@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> James Smart wrote:
>> How big of a number do you need ?  48 bits ?
>> We can up to 64bits, but I'd reserve 8bits for a "type" field.
>> (ugh, sounds like I'm redefining naming authorities...)
>>
>> On a side thought - is the mac address really the right thing to
>> use for a vendor id. Wouldn't you be extracting the vendor id from
>> the mac address ?
>>
> 
> I was looking for a persistent per hba value for some other long reason
> that we can work around in userspace so I take back that comment.

Ok - does that mean you want more than 24 bits for a vendor id ?
Seems reasonable...

> Are you only sending the vendor id to match some vendor specific
> userspace code with the event?

I'm only passing vendor id on events that are vendor specific. Thus, match
on vendor id to decode the vendor event. All other events are "well-known"
by the transport, so vendor id is irrelevant. For well-known events, host no
should be all you need.

If you need to find the vendor matched to the host no, then you follow the
other sysfs links appropriately (and should eventually resolve this from
the general driver framework attributes).

The passing of the vendor id in the vendor messages is simply to make
application code simpler - so it doesn't have to following all the sysfs
links, or know the nuances of different i/o busses and their sysfs
attributes if the vendor supports more than just pci.

 > Currently, for iscsi we only send the
> host no then match the driver, host and some driver or vendor specific
> code by using the host no and proc_name attr.

Yep this is what I would expect - except that proc_name won't always be
there (it's deprecated).

 > This is because for
> software iscsi and iser we do not know the pci device that will be used.
> For software iscsi it could be a bonded device or multiple devices
> depending on tables getting updated. What would we use for the vendor id
> in this case?

Well - in this case, it's not a vendor-specific event being generated.
It's an event by the iscsi/iser layer. This should fit the "well-known
to the iscsi/iser transport" event definition and not require a vendor id.

If we expected to have multiple iscsi/iser stacks present (vs the 1 and only
1 implementation we have for the other transports), then either that gets
built into the event message (as a stack identifier) or you could munge the
same thing into the vendor id (e.g. define a "type" that indicates s/w
assigned - and the vendor id is the stack identifier (but this method seems
hoaky)).

 > Is there a null value or some special unused one we can
> abuse or why do you need the vendor id value if you can look that up in
> sysfs by just following the host no to the scsi host dir then going to
> the pci device?

Hope above is clear.

-- james s
