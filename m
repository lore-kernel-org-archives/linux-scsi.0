From: "Hugh Daschbach" <hdasch@broadcom.com>
Subject: RE: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
Date: Wed, 3 Mar 2010 11:16:57 -0800
Message-ID: <233671224A0FED4688218FFDBED26E1A517AC38AB8@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <233671224A0FED4688218FFDBED26E1A517AC38638@IRVEXCHCCR01.corp.ad.broadcom.com>
 <20100303045433.GA27847@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1466 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab0CCTRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 14:17:17 -0500
In-Reply-To: <20100303045433.GA27847@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, james Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>

+ James Bottomley
+ James Smart

As the discussion tilts toward SCSI device shutdown.

Greg KH [mailto:gregkh@suse.de] writes:

> On Tue, Mar 02, 2010 at 04:47:01PM -0800, Hugh Daschbach wrote:
>> The system may fail to boot when the kernel's devices_kset->list gets
>> written by another thread while device_shutdown() is traversing the
>> list.  Though not common, this is fairly reproducible for some SCSI
>> Fibre Channel topologies; particularly so with FCoE configurations.
>
> Really?  What a mess :(
>
>> The reboot thread calls device_shutdown() as part of system shutdown.
>> device_shutdown() loops through devices_kset->list, shutting down each
>> system device.  But devices_kset->list isn't protected from other
>> writers while device_shutdown() traverses the list.
>
> Can't we just protect the list?  What is wanting to write to the list
> while shutdown is happening?

Indeed, Alan suggested holding the kset spinlock while iterating the
list.  Unfortunately, the device shutdown routines may sleep.  At least
the SCSI sd_shutdown routine issues I/O to the device as part of
flushing device caches.  I would guess other subsystems sleep as well.

>> One such secondary writer is the SCI Fibre Channel workqueue.  When
>> fc_wq_N removes a device that device_shutdown() holds in it's "devn"
>> (list traversal iterator) variable, device_shutdown() stalls, chasing
>> what is essentially a broken link.
>> 
>> This is not a common occurrence.  But FC SCSI devices associated with a
>> link that has gone down cause a race between device_shutdown() running
>> in reboot's process and scsi_remove_target() running in a SCSI FC
>> workqueue (fc_wq_N).
>> 
>> Network attached FC devices are particularly vulnerable because SysV
>> init scripts shut network interfaces down before proceeding with the
>> reboot request.  So by the time reboot is called, the link to the FC
>> devices is already down.
>> 
>> When the link is down device_shutdown() stalls (in sd_shutdown() --
>> which issues cache flush CDBs to what are, by that time, inaccessible
>> devices).  The stall ends when the fc rport timer expires.  But the
>> timer expiration also initiates fc_starget_delete() in the fc workqueue,
>> causing the race with device_shutdown().
>
> Can't you just not do this?

I'm not sure.  I'd punt this question to the SCSI maintainers.  From the
FC transport point of view, the rport timeout simply looks like a device
unplug event.  Should the unplug be handled differently if the system
is already shutting down?

Presumably any other subsystem that supports device unplug (usb, for
example) could enter the same race.  But, FCoE devices seem uniquely
poised to provoke the issue in a semi-repeatable fashion.

...

>> Does anyone have any guidance for what would make a more appropriate
>> fix?
>
> So the scsi core is trying to remove a device at the same time shutdown
> is happening, right?  So we need to protect the list somehow, maybe just
> switch it over to use a klist which should handle this for us instead?
> Can you try that?

I'll try klist.  That looks like a good mediator between traversal and
removal.

Thanks,
Hugh
