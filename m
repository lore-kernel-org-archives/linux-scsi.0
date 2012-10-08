From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Mon, 8 Oct 2012 17:27:04 +0800
Message-ID: <20121008092703.GA2541@mint-spring.sh.intel.com>
References: <50689794.50203@pobox.com>
 <Pine.LNX.4.44L0.1209301533280.18360-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1209301533280.18360-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oneukum@suse.de>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 30, 2012 at 03:43:27PM -0400, Alan Stern wrote:
> On Sun, 30 Sep 2012, Jeff Garzik wrote:
> 
> > The simple fact of "only ZPODD devices out there are ATA" is not the 
> > decision-maker for where the code should live.  It is more a question 
> > where ZPODD belongs in the device/command set model currently employed.
> 
> I don't really accept this argument.  It's a little like saying: The
> tty layer uses ioctl commands to control RS232 line settings; therefore
> RS232 settings should be handled in the VFS layer as part of the ioctl
> core.
> 
> Regardless, according to Aaron the ZP power-off stuff is currently
> implemented only in ACPI, tied more closely to the ATA layer than the
> SCSI layer (though not part of either).  It is not part of the SCSI
> spec in any form.

The mechanism of SATA ODD zero power model is specified in Mount Fuji
spec v8 section 15 describing what the ODD needs support, how to sense
if the ODD is ready to be powered off and on power up what needs to be
done, etc. And the actual power off and wakeup is implemented in ACPI
and SATA.

> Now it's true that determining whether a device is
> in the right state for power to be removed involves sending a TEST UNIT
> READY command, which is of course a SCSI command.  This seems to be
> incidental to the overall scheme, however.

I need to add that, there are 2 schemes to sense if the ODD is ready to
be powered off:
1 the one I used here, by checking if the door is closed and no media
  inside with test_unit_ready;
2 some ZP capable ODDs can report zero power ready(ZPReady) event to
  host when queried, eliminating the need of host checking the conditions.

Thanks,
Aaron

