From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Tue, 25 Sep 2012 16:01:35 +0800
Message-ID: <20120925080133.GA1629@mint-spring.sh.intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
 <201209241455.31754.rjw@sisk.pl>
 <20120924145235.GA3293@mint-spring.sh.intel.com>
 <201209242340.18318.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201209242340.18318.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 24, 2012 at 11:40:18PM +0200, Rafael J. Wysocki wrote:
> On Monday, September 24, 2012, Aaron Lu wrote:
> > On Mon, Sep 24, 2012 at 02:55:31PM +0200, Rafael J. Wysocki wrote:
> > > And I'd add a comment about the next poll.
> > > 
> > > This appears somewhat racy, though, because in theory a media may be inserted
> > > while we are removing power from the device.  Isn't that a problem?
> > 
> > Yes, this is a problem.
> > To avoid this race, I think the following needs to be done:
> > - For slot type ODD, make it such that user can't insert a disc;
> > - For tray type ODD, make it such that when user presses the eject
> >   button, the tray doesn't open.
> > I'll see if this is possible, thanks for the remind.
> 
> OK

Looks like this is not the right thing to do, if I lock the door user
will be confused.

> 
> > > > The poll runs periodically, until the device is powered off(reflected by
> > > > the powered_off flag), in which case, the poll will simply return
> > > > 0 without touching this device.
> > > 
> > > Is it useful to poll the device after it has been suspended, but not powered
> > > off?
> > 
> > Yes, it is necessary to poll the device when it has been suspended with
> > power left. The reason is, we need to check if there is a media change
> > event happened, and the way to check this is to issue a
> > GET_EVENT_STATUS_NOTIFICATION comand.
> > 
> > Please note that when the drive is not powered off, it will not send us
> > a notification when its eject button is pressed.
> 
> I'm not sure about that, actually.  If it doesn't notify us, that whole thing
> is inherently racy pretty much beyond fixing, because it is always possible
> that the user will press the eject button right after we've checked the
> status last time and right before power removal.  We're going to lose that
> event, so the user will have to push the button once again in that case.

I just checked the spec again and tested, when the ODD has power, it
will also send out notifications on pressing the eject button/inserting
a disc. So we should be able to capture such a event.

> 
> > > > That's correct.
> > > > AFAIK, user space does not care how often the device is polled, it
> > > > cares only one thing: when there is a media change event, please let me
> > > > know(through uevent).
> > > 
> > > So that's why we do the polling, right?
> > 
> > Yes.
> 
> Well, that's difficult.
> 
> If the remote wakeup is signaled through a GPE, it should be possible to
> enable it before we actually put the device into D3cold.  That may allow us
> to eliminate the races.

Thanks for the suggestion, I'll update the code.

I'm thinking of enabling this GPE in sr_suspend once we decided that it
is ready to be powered off, so the time frame between sr_suspend and
when the power is actually removed in libata should be taken care of by
the GPE. If GPE fires, the notification function will request a runtime
resume of the device. Does this sound OK?

Thanks,
Aaron
