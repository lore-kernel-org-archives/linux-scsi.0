From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Wed, 28 Nov 2012 08:56:09 +0000
Message-ID: <1354092969.2276.49.camel@dabdike>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
	 <35648985.61QNrr0Knq@vostro.rjw.lan> <1353906191.2523.25.camel@dabdike>
	 <21511277.LLinyDpbAK@vostro.rjw.lan>
	 <20121128013928.GB15971@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20121128013928.GB15971@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-11-27 at 17:39 -0800, Tejun Heo wrote:
> Hey, Rafael.
> 
> On Wed, Nov 28, 2012 at 01:51:00AM +0100, Rafael J. Wysocki wrote:
> > Having considered that a bit more I'm now thinking that in fact the power state
> > the device is in at the moment doesn't really matter, so the polling code need
> > not really know what PM is doing.  What it needs to know is that the device
> > will generate a hardware event when something interesting happens, so it is not
> > necessary to poll it.
> > 
> > In this particular case it is related to power management (apparently, hardware
> > events will only be generated after the device has been put into ACPI D3cold,
> > or so Aaron seems to be claiming), but it need not be in general, at least in
> > principle.
> > 
> > It looks like we need an "event driven" flag that the can be set in the lower
> > layers and read by the upper layers.  I suppose this means it would need to be
> > in struct device, but not necessarily in the PM-specific part of it.
> 
> We already have that.  That's what gendisk->async_events is for (as
> opposed to gendisk->events).  If all events are async_events, block
> won't poll for events, but I'm not sure that's the golden bullet.
> 
> * None implements async_events yet and an API is missing -
>   disk_check_events() - which is trivial to add, but it's the same
>   story.  We'll need a mechanism to shoot up notification from libata
>   to block layer.  It's admittedly easier to justify routing through
>   SCSI tho.  So, we're mostly shifting the problem.  Given that async
>   events is nice to have, so it isn't a bad idea.

Could we drive it in the polling code?  As in, if we set a flag to say
we're event driven and please don't bother us, we could just respond to
the poll with the last known state (this would probably have to be in
SCSI somewhere since most polls are Test Unit Readys).  That way ZPODD
sets this flag when the device powers down and unsets it when it powers
up.

James

> * Still dunno much about zpodd but IIUC the notification from
>   zero-power is via ACPI.  To advertise that the device doesn't need
>   polling, it should also be able to do async notification while
>   powered up, which isn't covered by zpodd but ATA async notification.
>   So, ummm... that's another obstacle.  If zpodd requires the device
>   to support ATA async notification, it might not be too bad tho.



