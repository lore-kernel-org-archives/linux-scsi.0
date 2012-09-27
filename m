From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Thu, 27 Sep 2012 12:46:41 +0200
Message-ID: <3158525.rj2S1Jvnll@linux-lqwf.site>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209242340.18318.rjw@sisk.pl> <20120925080133.GA1629@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20120925080133.GA1629@mint-spring.sh.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 25 September 2012 16:01:35 Aaron Lu wrote:
> On Mon, Sep 24, 2012 at 11:40:18PM +0200, Rafael J. Wysocki wrote:
> > On Monday, September 24, 2012, Aaron Lu wrote:
> > > On Mon, Sep 24, 2012 at 02:55:31PM +0200, Rafael J. Wysocki wrote:

> I just checked the spec again and tested, when the ODD has power, it
> will also send out notifications on pressing the eject button/inserting
> a disc. So we should be able to capture such a event.

In this case there's no need to poll for disk change unless the button has
been pressed.

> I'm thinking of enabling this GPE in sr_suspend once we decided that it
> is ready to be powered off, so the time frame between sr_suspend and
> when the power is actually removed in libata should be taken care of by
> the GPE. If GPE fires, the notification function will request a runtime
> resume of the device. Does this sound OK?

This sounds terribly, needlessly complicated. Just enable it when
you detect the presence of a disk drive that supports it.

Furthermore we have a device which can detect that a button has
been pressed. It is fundamentally wrong to poll for medium change in
such devices. You know that it hasn't been changed.
We should notify the upper layers that we can do medium change
detection on our own.

	Regards
		Oliver

