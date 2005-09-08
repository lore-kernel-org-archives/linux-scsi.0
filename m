From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Thu, 08 Sep 2005 12:07:17 -0400
Message-ID: <432061B5.1000407@adaptec.com>
References: <Pine.LNX.4.44L0.0509081057430.4607-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:44687 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964887AbVIHQHX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 12:07:23 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509081057430.4607-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 09/08/05 11:19, Alan Stern wrote:
> On Wed, 7 Sep 2005, Luben Tuikov wrote:
> 
> 
>>Is it possible to implement LU Reset TMF for USB storage devices?
>>If so, then you do not need to do a "bus reset".
> 
> 
> Sorry, I don't know that acronym.  What is TMF?

Good morning Alan,

I meant Task Management Function. (SAM from T10.org, section 7).

All newer storage transports are requred to have a direct mapping
of TMFs to transport units, e.g. SAS.

>>*General note:* It is very bad to have to punish all devices on the
>>"bus" just because one device failed.  Isn't there a better way
>>to recover(*) a failed USB Storage device?
> 
> No.  There are only two reset mechanisms available for USB Mass Storage.  

I see.

> One is a class-specific reset command (which usb-storage issues when asked 
> to do a device reset),

So as far as I can see it sends a reset on the wire to the device?

> and the other is a USB port reset (which 
> usb-storage issues when asked to do a bus reset).

As far as I see this resets the port on the host side and then
rediscovers the devices?

> In practice, it turns out that many (perhaps even most) USB Storage 
> devices don't implement the class-specific reset command correctly.  
> Windows doesn't use it at all, so far as I know.  This means our only 
> realistic option is the USB port reset.
> 
> 
>>(*) That doesn't necessarily mean "bring back to life", it could
>>also mean "remove".
> 
> 
> Well, usb-storage doesn't need to "remove" a failed device.  The SCSI core 
> does a perfectly good job just by setting it off-line.  And since there 
> aren't other targets sharing the bus, that's good enough.

Well what happens when I just unplug the device?
 
>>That is, a "bus reset" means that also any other device on the "bus" is
>>unreachable.  If this is _not_ the case, then a "bus" reset must _not_
>>take place.
> 
> I'm not sure what that first sentence is intended to mean.  The SCSI error 
> handler _does_ issue bus resets even when other devices on the bus are 
> still reachable, doesn't it?  Provided the others are idle at the time, 
> there shouldn't be any harm in it.

Ok, I see where the confusion is.

>>If you have the means to do transport checking of the state of the
>>device, (and it seems like you can for USB Storage, since it is USB after
>>all), then you _must_ implement your own eh handler.  This is what
>>it is for.  Please, consider.
>>
>>	Luben
>>
>>P.S. It may actually simplify things in the USB transport layer _and_ in
>>SCSI Core (i.e. no need for those patches).
> 
> 
> We are sort of moving in that direction.  usb-storage already does its 
> own unsolicited resets when unexpected error occur.  But we don't have 
> anything like the error-handler's mechanism for recovering from timeouts 
> (TUR, then device reset, then TUR, then bus reset, ...).  There doesn't 
> seem to be any point in reinventing all that code.

What code?  What reinvention?

You _need_ to implement a timeout and eh hook if you want to do this
in any sane way.

You also need to implement kref via kobject for the devices which you/USB Storage
represent to SCSI Core.  You also need to get rid of that horrible patchwork
of a solution: dev_semaphore.  Maybe you can take a look in the SAS code and
see how this is all done?

	Luben

