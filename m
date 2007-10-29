From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v4 0/2] [SCSI] Asynchronous	event	notification	infrastructure
Date: Mon, 29 Oct 2007 12:48:40 -0400
Message-ID: <47260EE8.2040403@garzik.org>
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>	 <1193672624.3383.25.camel@localhost.localdomain>	 <47260326.9050701@garzik.org>	 <1193674253.3383.38.camel@localhost.localdomain>	 <4726095B.6030508@garzik.org> <1193675651.3383.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:42485 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbXJ2Qso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 12:48:44 -0400
In-Reply-To: <1193675651.3383.49.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>, akpm@linux-foundation.org

James Bottomley wrote:
> On Mon, 2007-10-29 at 12:24 -0400, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> Ah, OK; I haven't communicated what we need very clearly.  We need a way
>>> to see if the event is supported by the device, as well as a way to turn
>>> it off.  For some of the events (possibly not the SATA AN one, since I
>>> know all SATA devices will be well behaved) there's going to be a need
>>> to deal with berserk or broken devices that become trigger happy, so
>>> turning off the event will be a useful (and possibly essential) way of
>>> coping.
>>
>> That's possible with the presented interface[1]:
>>
>> 	# see if event is supported
>> 	cat $path/evt_media_change
>>
>> 	# turn off event to deal with broken/beserk devices
>> 	echo 0 > $path/evt_media_change
>>
>> Some sillyhead can always do
>>
>> 	echo 1 > $path/evt_some_event_my_device_does_not_support
>>
>> but that will be obviously be a no-op because their device simply will 
>> not send such events.
>>
>> Granted ls(1) is no longer a method for viewing supported-at-boot-time 
>> list of events -- ls(1) in the presented interface lists what events the 
>> _kernel_ supports, and cat(1) is used to discover which events are 
>> actually enabled.
>>
>> I think that is the only difference between our two positions:  [if I 
>> understand you correctly] you want ls(1) to be able to list the device's 
>> supported events.  However, I feel that is inconsistent:  for your 
>> proposal, userspace must perform two checks in order to determine a 
>> feature's availability: 1) does the file exist? 2) is the file context 
>> non-zero?
> 
> Yes, I agree ... however, open file is one op for the user -ENXIO means
> device doesn't support the event; value indicates whether the event is
> currently triggering.
> 
> I just would rather we use the file exists if device supports event,
> because it's consistent with all the rest of our SCSI interfaces.

Two problems with what you just described:

1) "value indicates current event state" is a new concept in this thread 
(maybe you were thinking this all along, but I didn't get that from your 
writing).

Watching the sysfs node for event activity is definitely outside the 
scope of this work, and IMO not very useful.  The time from when LLDD 
calls sdev_evt_notify() until uevent completion is very short, so the 
time window for actually receiving a useful value in your scenario is 
also short.

My patch presented the attributes purely as control nodes, only affected 
sdev->supported_events and nothing more.  You seem to be suggesting 
exporting the true-for-only-a-few-milliseconds activity state, rather 
then enable/disable state.


2) Event support itself is dynamic, which causes me to revisit the 
"complexity" argument.  In libata, for example, we only note that the 
media-change event is supported after some time passes -- not in the 
initial slave_config.  Or error handler may disable it at runtime 
because that event is problematic.

As such, that implies that the LLDD (with help from scsi_lib) is 
dynamically adding and removing these attributes at runtime -- a lot 
more complexity than is really needed AFAICS.

It is easy and straightforward for the driver to set a bit.

We cannot assume the state of event support bits are constant from 
modprobe/slave_config time.

	Jeff


