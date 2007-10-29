From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v4 0/2] [SCSI] Asynchronous
	event	notification	infrastructure
Date: Mon, 29 Oct 2007 11:34:10 -0500
Message-ID: <1193675651.3383.49.camel@localhost.localdomain>
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
	 <1193672624.3383.25.camel@localhost.localdomain>
	 <47260326.9050701@garzik.org>
	 <1193674253.3383.38.camel@localhost.localdomain>
	 <4726095B.6030508@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56312 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754884AbXJ2QeN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 12:34:13 -0400
In-Reply-To: <4726095B.6030508@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>, akpm@linux-foundation.org

On Mon, 2007-10-29 at 12:24 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > Ah, OK; I haven't communicated what we need very clearly.  We need a way
> > to see if the event is supported by the device, as well as a way to turn
> > it off.  For some of the events (possibly not the SATA AN one, since I
> > know all SATA devices will be well behaved) there's going to be a need
> > to deal with berserk or broken devices that become trigger happy, so
> > turning off the event will be a useful (and possibly essential) way of
> > coping.
> 
> 
> That's possible with the presented interface[1]:
> 
> 	# see if event is supported
> 	cat $path/evt_media_change
> 
> 	# turn off event to deal with broken/beserk devices
> 	echo 0 > $path/evt_media_change
> 
> Some sillyhead can always do
> 
> 	echo 1 > $path/evt_some_event_my_device_does_not_support
> 
> but that will be obviously be a no-op because their device simply will 
> not send such events.
> 
> Granted ls(1) is no longer a method for viewing supported-at-boot-time 
> list of events -- ls(1) in the presented interface lists what events the 
> _kernel_ supports, and cat(1) is used to discover which events are 
> actually enabled.
> 
> I think that is the only difference between our two positions:  [if I 
> understand you correctly] you want ls(1) to be able to list the device's 
> supported events.  However, I feel that is inconsistent:  for your 
> proposal, userspace must perform two checks in order to determine a 
> feature's availability: 1) does the file exist? 2) is the file context 
> non-zero?

Yes, I agree ... however, open file is one op for the user -ENXIO means
device doesn't support the event; value indicates whether the event is
currently triggering.

I just would rather we use the file exists if device supports event,
because it's consistent with all the rest of our SCSI interfaces.

> Regards,
> 
> 	Jeff
> 
> 
> [1] modulo my comment from the original email in this thread:
> > * I was slack and did not bother to implement the 'set' operation
> >   for the attributes.  This can easily be done at a later time in a
> >   separate patch.

James


