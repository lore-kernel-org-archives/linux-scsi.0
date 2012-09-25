From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Tue, 25 Sep 2012 13:47:52 +0200
Message-ID: <201209251347.52407.rjw@sisk.pl>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209242340.18318.rjw@sisk.pl> <20120925080133.GA1629@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([193.178.161.156]:43428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab2IYLlS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2012 07:41:18 -0400
In-Reply-To: <20120925080133.GA1629@mint-spring.sh.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Tuesday, September 25, 2012, Aaron Lu wrote:
> On Mon, Sep 24, 2012 at 11:40:18PM +0200, Rafael J. Wysocki wrote:
> > On Monday, September 24, 2012, Aaron Lu wrote:
> > > On Mon, Sep 24, 2012 at 02:55:31PM +0200, Rafael J. Wysocki wrote:
> > > > And I'd add a comment about the next poll.
> > > > 
> > > > This appears somewhat racy, though, because in theory a media may be inserted
> > > > while we are removing power from the device.  Isn't that a problem?
> > > 
> > > Yes, this is a problem.
> > > To avoid this race, I think the following needs to be done:
> > > - For slot type ODD, make it such that user can't insert a disc;
> > > - For tray type ODD, make it such that when user presses the eject
> > >   button, the tray doesn't open.
> > > I'll see if this is possible, thanks for the remind.
> > 
> > OK
> 
> Looks like this is not the right thing to do, if I lock the door user
> will be confused.
> 
> > 
> > > > > The poll runs periodically, until the device is powered off(reflected by
> > > > > the powered_off flag), in which case, the poll will simply return
> > > > > 0 without touching this device.
> > > > 
> > > > Is it useful to poll the device after it has been suspended, but not powered
> > > > off?
> > > 
> > > Yes, it is necessary to poll the device when it has been suspended with
> > > power left. The reason is, we need to check if there is a media change
> > > event happened, and the way to check this is to issue a
> > > GET_EVENT_STATUS_NOTIFICATION comand.
> > > 
> > > Please note that when the drive is not powered off, it will not send us
> > > a notification when its eject button is pressed.
> > 
> > I'm not sure about that, actually.  If it doesn't notify us, that whole thing
> > is inherently racy pretty much beyond fixing, because it is always possible
> > that the user will press the eject button right after we've checked the
> > status last time and right before power removal.  We're going to lose that
> > event, so the user will have to push the button once again in that case.
> 
> I just checked the spec again and tested, when the ODD has power, it
> will also send out notifications on pressing the eject button/inserting
> a disc. So we should be able to capture such a event.

Good!

> > > > > That's correct.
> > > > > AFAIK, user space does not care how often the device is polled, it
> > > > > cares only one thing: when there is a media change event, please let me
> > > > > know(through uevent).
> > > > 
> > > > So that's why we do the polling, right?
> > > 
> > > Yes.
> > 
> > Well, that's difficult.
> > 
> > If the remote wakeup is signaled through a GPE, it should be possible to
> > enable it before we actually put the device into D3cold.  That may allow us
> > to eliminate the races.
> 
> Thanks for the suggestion, I'll update the code.
> 
> I'm thinking of enabling this GPE in sr_suspend once we decided that it
> is ready to be powered off, so the time frame between sr_suspend and
> when the power is actually removed in libata should be taken care of by
> the GPE. If GPE fires, the notification function will request a runtime
> resume of the device. Does this sound OK?

Well, depending on the implementation.  sr_suspend() should be rather
generic, but the ACPI association (including the GPE thing) is specific to ATA.

Thanks,
Rafael
