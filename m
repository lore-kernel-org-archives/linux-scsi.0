From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Mon, 26 Nov 2012 02:11:54 +0100
Message-ID: <1543239.67ZUIKlEE3@vostro.rjw.lan>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <3650037.tRRn9I6XAb@vostro.rjw.lan> <50B2C076.3070201@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <50B2C076.3070201@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday, November 26, 2012 09:05:58 AM Aaron Lu wrote:
> On 11/26/2012 09:03 AM, Rafael J. Wysocki wrote:
> > On Monday, November 26, 2012 08:48:51 AM Aaron Lu wrote:
> >> On 11/26/2012 08:50 AM, Rafael J. Wysocki wrote:
> >>> On Tuesday, November 20, 2012 04:59:57 PM Aaron Lu wrote:
> >>>> On 11/20/2012 02:00 PM, Aaron Lu wrote:
> >>>>> On 11/19/2012 10:56 PM, Tejun Heo wrote:
> >>>>>> I really think we need a way for (auto)pm and event polling to talk to
> >>>>>> each other so that autopm can tell event poll to sod off while pm is
> >>>>>> in effect.  Trying to solve this from inside libata doesn't seem
> >>>>>> right.  The problem, again, seems to be figuring out which hardware
> >>>>>> device maps to which block device.  Hmmm... Any good ideas?
> >>>>>
> >>>>> A possible way of doing this is using pm qos.
> >>>>>
> >>>>> We currently have 2 pm qos flags, NO_POWER_OFF and REMOTE_WAKEUP, and we
> >>>>> can add another one: NO_POLL, use it like the following:
> >>>>> 1 Set the NO_POLL pm qos flag when the underlying driver thinks it is no
> >>>>>   longer necessary. In the ZPODD's case, it should be set when the
> >>>>>   device is to be powered off;
> >>>>> 2 Clear it when poll is necessary again. In the ZPODD's case, when power
> >>>>>   is re-gained, this flag will be cleared.
> >>>>
> >>>>
> >>>>> 3 In the disk_events_workfn, check if this flag is set, if so, simply
> >>>>>   return.
> >>>>
> >>>> It should be, skip calling disk->fops->check_events, but still queue the
> >>>> work for next time's poll.
> >>>>
> >>>> -Aaron
> >>>>
> >>>>>
> >>>>> The disk->driverfs_dev can be used to host the pm qos flag, ATA layer
> >>>>> can access it through ata_device->sdev->sdev_gendev.
> >>>>>
> >>>>> Is this OK?
> >>>
> >>> No, I don't think so.  PM QoS is about telling the layer that will put the
> >>> device into low-power states what states are to be taken into consideration.
> >>> In this case, however, we need to tell someone else that the device has been
> >>> turned off.  Clearly, we need a way to do that, but not through PM QoS.
> >>>
> >>> Did you consider using pm_runtime_suspended() to check the device status?
> >>
> >> The problem is, a device can be in runtime suspended state while still
> >> needs to be polled...
> > 
> > Well, maybe this is the problem, then?  Why does it need to be polled when
> > suspended?
> 
> For ODDs, poll is not necessary only when ZP capable ODD is powered off.
> For other ODDs, poll still needs to go on.
> 
> ZP capable ODDs:
>   - runtime suspended, power remained(due to NO_POWER_OFF qos flag)
>     poll is needed
>   -- runtime suspended, power removed
>     poll is not needed
> 
> Non ZP capable ODDs:
>   -- runtime suspended, power remained (power will never be removed)
>     poll is needed
> 
> If we do not poll for the powered on case, we will lose media change
> event.

But the media change event should change the status from suspended to active,
shouldn't it?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
