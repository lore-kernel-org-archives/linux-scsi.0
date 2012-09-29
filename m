From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Sun, 30 Sep 2012 00:44:50 +0200
Message-ID: <201209300044.51017.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1209291024380.29902-100000@netrider.rowland.org> <50670DC4.7020105@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([193.178.161.156]:51795 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2I2WiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2012 18:38:15 -0400
In-Reply-To: <50670DC4.7020105@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Saturday, September 29, 2012, Aaron Lu wrote:
> On 09/29/2012 10:29 PM, Alan Stern wrote:
> > On Sat, 29 Sep 2012, Aaron Lu wrote:
> > 
> >>> I don't think this is a good idea, quite frankly.  sr seems to be a too
> >>> generic place for that.
> >>
> >> Does this mean sr can only have code that is useful to all devices it
> >> manages? i.e. If a piece of code enables a feature for a special kind of
> >> ODD(like the sata based ZPODD), it shouldn't be done in sr?
> > 
> > Drivers are allowed to have special features and quirks that apply only 
> > to some devices.
> 
> I think SATA based zero power capable ODDs are the "some devices".
> 
> > 
> >> There is nothing in theory stopping us from doing this in ata layer.
> >> For the loading mechanism, we can always send an ATAPI command to figure
> >> it out.
> >>
> >> So gentlemen, I need your opinions on where this ZPODD code should live
> >> before I can continue this work, thanks.
> > 
> > Can arbitrary SCSI devices be ZP, or does this notion apply only to
> > ATAPI-based drives?  That's the key question, and the answer determines
> > where the ZP support belongs.
> 
> I don't know if arbitrary SCSI devices can be ZP or not, the SPC spec
> doesn't seem to define such a power state.
> 
> ZPODD is defined for sata based ATAPI ODD which supports device
> attention, but doesn't specify how the ODD is powered off and how the
> device attention pin notifies OS. On x86 systems, these are implemented
> by ACPI.
> 
> Though SCSI devices may not have a general notion of ZP, the fact that
> ZPODD are managed by sr driver is enough to make the decision that ZPODD
> code can live in sr?

Well, only a part of it is handled by sr, the high-level part so to speak.
The low-level handling is done by the ATA layer.  Now, since sr is the
high-level part and is supposed to be generic, I don't think it's appropriate
to make it care about some low-level things specific to ATA (because there is
another layer of code supposed to handle those).

> > On the other hand, the sr driver certainly deserves to have some form 
> > of runtime PM support, even for devices that aren't ZP.
> 
> Agree.
> 
> And the following codes need to find a home:
> - Code used to handle ACPI wake notification(currently done in ATA, but
>   causes the "annoying" need_eject flag in scsi_device);

And quite frankly I'd more and more convinced that this flag isn't really
necessary.

What you really want to achieve is to eject the tray of a tray-type ODD
if the eject is signaled through a GPE.  I don't see anything for sr to
do in that.  Moreover, you probably would like to do that even if the
drive is not powered down, right?

I wonder if this mechanism can be used for user space notification
without polling regardless of whether or not the zero-power feature is
used?

> - Code to check if the ODD is ready to be powered off per the ZPODD
>   spec.

If that can be done at the ATA level, I'd prefer it too.

Thanks,
Rafael
