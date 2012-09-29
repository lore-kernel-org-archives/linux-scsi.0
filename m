From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Sun, 30 Sep 2012 00:27:41 +0200
Message-ID: <201209300027.41533.rjw@sisk.pl>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209282346.15872.rjw@sisk.pl> <50665882.8020104@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([193.178.161.156]:51775 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab2I2WVE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2012 18:21:04 -0400
In-Reply-To: <50665882.8020104@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Oliver Neukum <oneukum@suse.de>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Saturday, September 29, 2012, Aaron Lu wrote:
> [Adding more people and list back in]
> 
> On 09/29/2012 05:46 AM, Rafael J. Wysocki wrote:
> > On Friday, September 28, 2012, Aaron Lu wrote:
> >> On 09/28/2012 07:15 AM, Rafael J. Wysocki wrote:
> >>> On Thursday, September 27, 2012, Aaron Lu wrote:
> >>>> On 09/27/2012 05:37 AM, Rafael J. Wysocki wrote:
> >>>>>
> >>>>> Say the user has pressed the eject button.  What does need to happen so that
> >>>>> the tray is physically ejected?
> >>>>
> >>>> The tray is ejected by the ODD itself, host does not have to do anything.
> >>>>
> >>>> There is a command(PREVENT_MEDIUM_REMOVAL) to lock the door so that when
> >>>> user presses the eject button, the tray will not be ejected. This command
> >>>> is usually sent when we have a disc inside and a user space program
> >>>> opened the underlying block device(e.g. /dev/sr0) to read/write data.
> >>>>
> >>>> And host can also eject the tray by sending a START_STOP_UNIT command
> >>>> with param LoEj set to 1 and we have a function called sr_tray_move to
> >>>> do just this. And this is also what I've used to eject the tray after
> >>>> user wakes up the ODD, as when user presses the eject button when the
> >>>> ODD is in zero power state, it can't eject the tray as usual, so host
> >>>> software will need to do this, that's the reason I need to know such
> >>>> information:
> >>>> When ODD is resumed, is it because user wakes it up?
> >>>
> >>> But START_STOP_UNIT eventually causes ata_scsi_start_stop_xlat() to be
> >>
> >> You are following ata case, while the ODD is an atapi device :-)
> >> The translation function is atapi_xlat, but that doesn't affect the idea
> >> here.
> >>
> >>> executed, so I wonder if we really need to go up through the SCSI stack
> >>> to send that command to the drive from there?  It should be possible
> >>> to issue STANDBY/READ VERIFY to the device directly from libata if
> >>> an eject event is signaled through a GPE.
> >>
> >> Yes, this is possible.
> >> Though it doesn't feel very cool, since I have no idea if the ODD is a
> >> tray type or slot type in ATA layer and I'll blindly send this command
> >> to it then, not a problem maybe.
> > 
> > It would be good to verify if that works for slot devices, if possible.
> 
> The ACPI GPE event is triggered when user inserts a disc into a slot
> type ODD, and if I send an eject command to it, the disc will be
> ejected, which is wrong.
> 
> I need to know the loading mechanism(tray type or slot type) of the ODD
> to decide if I should send this command.
> 
> > 
> >> And what do you think of moving the acpi notification code to sr?
> >> http://marc.info/?l=linux-pm&m=134873904332704&w=4
> > 
> > I don't think this is a good idea, quite frankly.  sr seems to be a too
> > generic place for that.
> 
> Does this mean sr can only have code that is useful to all devices it
> manages? i.e. If a piece of code enables a feature for a special kind of
> ODD(like the sata based ZPODD), it shouldn't be done in sr?

If the feature is specific to one special kind of ODD only, then I don't
think sr is the right place to add support for it.

> > Ideally, the whole ZPODD handling should not be visible to the SCSI layer,
> 
> I can see 2 problems:
> - Don't know its loading machanism so we have the problem above;

Does using the need_eject flag address this problem somehow?

> - Need to send command to find out if ODD is zero power ready somewhere
>   in ata layer, this implies the device is doing IO after it is runtime
>   suspended in scsi layer.

There's nothing wrong with accessig suspended devices as long as we know
that they will respond. :-)

> > perhaps except the "no_polling" flag disabling the polling that may be
> > useful for other purposes in principle.
> 
> I hope so, let's hear what other people has to say.
> 
> > 
> > I'm not sure if it's possible at this point, but if not we need to know
> > very precisely why not.
> 
> There is nothing in theory stopping us from doing this in ata layer.
> For the loading mechanism, we can always send an ATAPI command to figure
> it out.
> 
> So gentlemen, I need your opinions on where this ZPODD code should live
> before I can continue this work, thanks.

I would _try_ to add it at the ATA level.

Thanks,
Rafael
