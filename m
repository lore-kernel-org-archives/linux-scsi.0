From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Mon, 03 Dec 2012 08:25:43 +0000
Message-ID: <1354523143.2307.2.camel@dabdike.int.hansenpartnership.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
	 <35648985.61QNrr0Knq@vostro.rjw.lan> <1353906191.2523.25.camel@dabdike>
	 <21511277.LLinyDpbAK@vostro.rjw.lan>
	 <20121128013928.GB15971@htj.dyndns.org> <1354092969.2276.49.camel@dabdike>
	 <20121203081321.GA9990@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20121203081321.GA9990@mint-spring.sh.intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-12-03 at 16:13 +0800, Aaron Lu wrote:
> On Wed, Nov 28, 2012 at 08:56:09AM +0000, James Bottomley wrote:
> > On Tue, 2012-11-27 at 17:39 -0800, Tejun Heo wrote:
> > > Hey, Rafael.
> > > 
> > > On Wed, Nov 28, 2012 at 01:51:00AM +0100, Rafael J. Wysocki wrote:
> > > > Having considered that a bit more I'm now thinking that in fact the power state
> > > > the device is in at the moment doesn't really matter, so the polling code need
> > > > not really know what PM is doing.  What it needs to know is that the device
> > > > will generate a hardware event when something interesting happens, so it is not
> > > > necessary to poll it.
> > > > 
> > > > In this particular case it is related to power management (apparently, hardware
> > > > events will only be generated after the device has been put into ACPI D3cold,
> > > > or so Aaron seems to be claiming), but it need not be in general, at least in
> > > > principle.
> > > > 
> > > > It looks like we need an "event driven" flag that the can be set in the lower
> > > > layers and read by the upper layers.  I suppose this means it would need to be
> > > > in struct device, but not necessarily in the PM-specific part of it.
> > > 
> > > We already have that.  That's what gendisk->async_events is for (as
> > > opposed to gendisk->events).  If all events are async_events, block
> > > won't poll for events, but I'm not sure that's the golden bullet.
> > > 
> > > * None implements async_events yet and an API is missing -
> > >   disk_check_events() - which is trivial to add, but it's the same
> > >   story.  We'll need a mechanism to shoot up notification from libata
> > >   to block layer.  It's admittedly easier to justify routing through
> > >   SCSI tho.  So, we're mostly shifting the problem.  Given that async
> > >   events is nice to have, so it isn't a bad idea.
> > 
> > Could we drive it in the polling code?  As in, if we set a flag to say
> > we're event driven and please don't bother us, we could just respond to
> > the poll with the last known state (this would probably have to be in
> > SCSI somewhere since most polls are Test Unit Readys).  That way ZPODD
> > sets this flag when the device powers down and unsets it when it powers
> > up.
> 
> Does it mean I can do something like this:
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 5fc97d2..219820c 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -578,7 +578,10 @@ static unsigned int sr_block_check_events(struct gendisk *disk,
>  					  unsigned int clearing)
>  {
>  	struct scsi_cd *cd = scsi_cd(disk);
> -	return cdrom_check_events(&cd->cdi, clearing);
> +	if (!cd->device->event_driven)
> +		return cdrom_check_events(&cd->cdi, clearing);
> +	else
> +		return 0;
>  }
>  
>  static int sr_block_revalidate_disk(struct gendisk *disk)
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index e65c62e..1756151 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -160,6 +160,7 @@ struct scsi_device {
>  	unsigned can_power_off:1; /* Device supports runtime power off */
>  	unsigned wce_default_on:1;	/* Cache is ON by default */
>  	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
> +	unsigned event_driven:1; /* No need to poll the device */
>  
>  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
>  	struct list_head event_list;	/* asserted events */

Yes, but if we can get away with doing that, it should be in genhd
because it's completely generic.

I was imagining we'd have to fake the reply to the test unit ready or
some other commands, which is why it would need to be in sr.c

The check events code is Tejun's baby, if he's OK with it then just do
it in genhd.c

> Then when ZPODD is powered off, it will set this flag; and unset it when
> it is powered up.

Right.

James


