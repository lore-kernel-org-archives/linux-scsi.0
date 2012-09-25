From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Tue, 25 Sep 2012 23:45:34 +0200
Message-ID: <201209252345.35233.rjw@sisk.pl>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <1627578.tkYE3uqGuq@linux-lqwf.site> <5061C3AE.6030103@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <5061C3AE.6030103@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Oliver Neukum <oneukum@suse.de>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tuesday, September 25, 2012, Aaron Lu wrote:
> On 09/25/2012 10:23 PM, Oliver Neukum wrote:
> > On Tuesday 25 September 2012 22:20:21 Aaron Lu wrote:
> >> On Tue, Sep 25, 2012 at 01:47:52PM +0200, Rafael J. Wysocki wrote:
> >>> On Tuesday, September 25, 2012, Aaron Lu wrote:
> >>>> I'm thinking of enabling this GPE in sr_suspend once we decided that it
> >>>> is ready to be powered off, so the time frame between sr_suspend and
> >>>> when the power is actually removed in libata should be taken care of by
> >>>> the GPE. If GPE fires, the notification function will request a runtime
> >>>> resume of the device. Does this sound OK?
> >>>
> >>> Well, depending on the implementation.  sr_suspend() should be rather
> >>> generic, but the ACPI association (including the GPE thing) is specific to ATA.
> >>
> >> Sorry, but don't quite understand this.
> >>
> >> We have ACPI bindings for scsi devices, isn't that for us to use ACPI
> >> when needed in scsi?
> > 
> > We don't have ACPI bindings for generic SCSI devices. We have such
> > bindings for SATA drives. You can put such things only in sr if it applies
> > to all (maybe most) types of drives.
> 
> OK. Then these scsi bindings for sata drives will be pretty much of
> no use I think.
> 
> > 
> >> BTW, if sr_suspend should be generic, that would suggest I shouldn't
> >> write any ZPODD related code there, right? Any suggestion where these
> >> code should go then?
> > 
> > libata. Maybe some generic hooks can be called in sr_suspend().
> 
> Thanks for the suggestion.
> The problem is, I need to know whether the door is closed and if there
> is a medium inside. I've no way of getting such information in libata.

How does sr get to know it in the libata case?

> > PS: Are you sure sr_suspend() handles DVD-RAMs correctly?
> 
> No. Is there a spec for it?
> Considering there are many different drives sr handle, is it possible to
> write a generic sr_suspend?
> Maybe your suggestion of callback is the way to go.
> What about this idea, if we find this is a ZPODD capable drive, we
> enable runtime suspend for it and write a suspend callback according to
> ZPODD spec. For other drives that does not have a suspend callback, we
> do not enable runtime suspend.

You can enable runtime PM for all kinds of drives, but make the suspend
and resume callbacks only do something for ZPODD ones.  This may allow their
parents to use runtime PM (as Alan said earlier in this thread), even if the
drives themseleves are not really physically suspended.

> Does this sound reasonable?

First, we need to know when the drive is not in use.  That information
we can get from the sr's runtime PM and it looks like we need to notify
libata about that somehow.  I'm not sure what mechanism is the best for
that at the moment.

Second, when the device is resumed by remote wakeup, we need to notify
sr about that.  A "resume" alone is not sufficient, though, because it may
be necessary to open the tray.  Perhaps in that case we can use the same
mechanism by which user events are processed by libata and delivered to sr?

Rafael
