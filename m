From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Mon, 08 Oct 2012 11:21:56 +0100
Message-ID: <1349691716.2615.34.camel@dabdike.int.hansenpartnership.com>
References: <50689794.50203@pobox.com>
	 <Pine.LNX.4.44L0.1209301533280.18360-100000@netrider.rowland.org>
	 <20121008092703.GA2541@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20121008092703.GA2541@mint-spring.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oneukum@suse.de>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-10-08 at 17:27 +0800, Aaron Lu wrote:
> On Sun, Sep 30, 2012 at 03:43:27PM -0400, Alan Stern wrote:
> > On Sun, 30 Sep 2012, Jeff Garzik wrote:
> > 
> > > The simple fact of "only ZPODD devices out there are ATA" is not the 
> > > decision-maker for where the code should live.  It is more a question 
> > > where ZPODD belongs in the device/command set model currently employed.
> > 
> > I don't really accept this argument.  It's a little like saying: The
> > tty layer uses ioctl commands to control RS232 line settings; therefore
> > RS232 settings should be handled in the VFS layer as part of the ioctl
> > core.
> > 
> > Regardless, according to Aaron the ZP power-off stuff is currently
> > implemented only in ACPI, tied more closely to the ATA layer than the
> > SCSI layer (though not part of either).  It is not part of the SCSI
> > spec in any form.
> 
> The mechanism of SATA ODD zero power model is specified in Mount Fuji
> spec v8 section 15 describing what the ODD needs support, how to sense
> if the ODD is ready to be powered off and on power up what needs to be
> done, etc. And the actual power off and wakeup is implemented in ACPI
> and SATA.
> 
> > Now it's true that determining whether a device is
> > in the right state for power to be removed involves sending a TEST UNIT
> > READY command, which is of course a SCSI command.  This seems to be
> > incidental to the overall scheme, however.
> 
> I need to add that, there are 2 schemes to sense if the ODD is ready to
> be powered off:
> 1 the one I used here, by checking if the door is closed and no media
>   inside with test_unit_ready;
> 2 some ZP capable ODDs can report zero power ready(ZPReady) event to
>   host when queried, eliminating the need of host checking the conditions.

The way I read the standard is that ZP ODD is a hack to try and get to
off and ZPready is the same hack but integrated into the standardised
power management states (and hence available to normal power saving).
The standard even implies ZP ODD is a less desirable hack by
recommending the use of ZPready.

The ZPready method, being an extension of the usual SCSI power
management model, is pretty much what we support today (especially as
the whole thing is timer driven from values in the mode page and happens
pretty much invisibly to us).

Since the object is to make this as painless as possible, why don't we
just implement ZPODD the way the spec recommends?  i.e. emulate the
timers at an incredibly low level and intercept and emulate the non-disk
commands listed in table 321.  I bet, in Linux, since we moved basically
to GET_EVENT_STATUS_NOTIFICATION, that's the only one that actually
needs an emulation.

The state model seems to work if you snoop the polled media event, so
you wait for no media, then set your internal timer, stop it if we get a
media change and power off the device after interval expiry.  Thereafter
you emulate media event with no change keeping the device powered off.
If a disc gets inserted or the eject button is pressed, you see that via
the SATA PHY events (so wake the drive) and if the Upper Layer sends an
unexpected command, you also power on the drive.

That way all of this should be nicely containable within SATA/ACPI.

James


