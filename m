From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Wed, 28 Nov 2012 10:24:04 +0800
Message-ID: <50B575C4.2040204@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <35648985.61QNrr0Knq@vostro.rjw.lan> <1353906191.2523.25.camel@dabdike> <21511277.LLinyDpbAK@vostro.rjw.lan> <20121128013928.GB15971@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54508 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab2K1CXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Nov 2012 21:23:46 -0500
In-Reply-To: <20121128013928.GB15971@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On 11/28/2012 09:39 AM, Tejun Heo wrote:
> Hey, Rafael.
> 
> On Wed, Nov 28, 2012 at 01:51:00AM +0100, Rafael J. Wysocki wrote:
>> Having considered that a bit more I'm now thinking that in fact the power state
>> the device is in at the moment doesn't really matter, so the polling code need
>> not really know what PM is doing.  What it needs to know is that the device
>> will generate a hardware event when something interesting happens, so it is not
>> necessary to poll it.
>>
>> In this particular case it is related to power management (apparently, hardware
>> events will only be generated after the device has been put into ACPI D3cold,
>> or so Aaron seems to be claiming), but it need not be in general, at least in
>> principle.
>>
>> It looks like we need an "event driven" flag that the can be set in the lower
>> layers and read by the upper layers.  I suppose this means it would need to be
>> in struct device, but not necessarily in the PM-specific part of it.
> 
> We already have that.  That's what gendisk->async_events is for (as
> opposed to gendisk->events).  If all events are async_events, block
> won't poll for events, but I'm not sure that's the golden bullet.

Right. For ZPODD, the problem is, during power up time, it needs
gendisk->events to be set to get poll; and after powered off, it will
need to clear the gendisk->events field so that the poll work will stop.
I'm not sure if the gendisk->async_events should be set here, as the
interrupt only says that user pressed the eject button for the tray type
ODD but he may not insert any disc. The whole point of the interrupt is
to re-power the ODD, it is not designed to give notification of media
change. This is my understanding of ZPODD.

> 
> * None implements async_events yet and an API is missing -

That's what I'm confused when reading the sata async support code, the
SCSI sr driver will unconditionally set gendisk->events, so how the sata
async can benefit? But this is another story.

>   disk_check_events() - which is trivial to add, but it's the same
>   story.  We'll need a mechanism to shoot up notification from libata
>   to block layer.  It's admittedly easier to justify routing through
>   SCSI tho.  So, we're mostly shifting the problem.  Given that async
>   events is nice to have, so it isn't a bad idea.
> 
> * Still dunno much about zpodd but IIUC the notification from
>   zero-power is via ACPI.  To advertise that the device doesn't need

Yes, when powered off, if users press the eject button of a tray type
ODD or inserts a disc of the slot type ODD, the SATA ODD will generate a
DEVICE ATTENTION signal, which will cause ACPI to emit an interrupt.

On my test system, when I insert a disc into the slot type ODD to wake
it up, it will continue to generate DEVICE ATTENTION signal, and thus,
ACPI interrupts are coming all the time if I do not disable the ACPI GPE
that controls the interrupt. I guess the behaviour is device by device,
and the SPEC only states what ODD needs to do when in powered off state.
And I don't think a tray type ODD will generate DEVICE ATTENTION signal
when its eject button is pressed after powered up, but Jeff Wu from AMD
may be able to test this behaviour as he has some tray type ODDs if this
is meaningful to know.

>   polling, it should also be able to do async notification while
>   powered up, which isn't covered by zpodd but ATA async notification.

Agree. For powered up media change notification, that's SATA async
notification's job.

>   So, ummm... that's another obstacle.  If zpodd requires the device
>   to support ATA async notification, it might not be too bad tho.

This doesn't seem to be the case, since ZPODD is for how ODD to get
notified when it is powered off, so there is no words stating if the ODD
should also support sata async notification.

Thanks,
Aaron

