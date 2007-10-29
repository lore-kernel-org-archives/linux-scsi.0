From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v4 0/2] [SCSI] Asynchronous event	notification	infrastructure
Date: Mon, 29 Oct 2007 12:24:59 -0400
Message-ID: <4726095B.6030508@garzik.org>
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>	 <1193672624.3383.25.camel@localhost.localdomain>	 <47260326.9050701@garzik.org> <1193674253.3383.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:53910 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbXJ2QZB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 12:25:01 -0400
In-Reply-To: <1193674253.3383.38.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>, akpm@linux-foundation.org

James Bottomley wrote:
> Ah, OK; I haven't communicated what we need very clearly.  We need a way
> to see if the event is supported by the device, as well as a way to turn
> it off.  For some of the events (possibly not the SATA AN one, since I
> know all SATA devices will be well behaved) there's going to be a need
> to deal with berserk or broken devices that become trigger happy, so
> turning off the event will be a useful (and possibly essential) way of
> coping.


That's possible with the presented interface[1]:

	# see if event is supported
	cat $path/evt_media_change

	# turn off event to deal with broken/beserk devices
	echo 0 > $path/evt_media_change

Some sillyhead can always do

	echo 1 > $path/evt_some_event_my_device_does_not_support

but that will be obviously be a no-op because their device simply will 
not send such events.

Granted ls(1) is no longer a method for viewing supported-at-boot-time 
list of events -- ls(1) in the presented interface lists what events the 
_kernel_ supports, and cat(1) is used to discover which events are 
actually enabled.

I think that is the only difference between our two positions:  [if I 
understand you correctly] you want ls(1) to be able to list the device's 
supported events.  However, I feel that is inconsistent:  for your 
proposal, userspace must perform two checks in order to determine a 
feature's availability: 1) does the file exist? 2) is the file context 
non-zero?

Regards,

	Jeff


[1] modulo my comment from the original email in this thread:
> * I was slack and did not bother to implement the 'set' operation
>   for the attributes.  This can easily be done at a later time in a
>   separate patch.

