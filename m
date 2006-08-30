From: Martin Zuziak <zuziak@math.ku.dk>
Subject: Re: aic79xx driver - hotswap error
Date: Wed, 30 Aug 2006 15:23:45 +0200
Message-ID: <20060830132345.GA9100@pc000ffe3ca343.math.ku.dk>
References: <20060828121542.GA13993@pc000ffe3ca343.math.ku.dk> <1156779911.28832.28.camel@fc6.xsintricity.com> <44F40854.4050902@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imf.math.ku.dk ([130.225.103.32]:27520 "EHLO mail.math.ku.dk")
	by vger.kernel.org with ESMTP id S1750766AbWH3NXx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Aug 2006 09:23:53 -0400
Content-Disposition: inline
In-Reply-To: <44F40854.4050902@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org

On Tue, Aug 29, 2006 at 11:26:44AM +0200, Hannes Reinecke wrote:
> Doug Ledford wrote:
> >On Mon, 2006-08-28 at 14:15 +0200, Martin Zuziak wrote:
> >>Hello all
> >>
> >>Hot-swapping doesn't seem to work with the aic79xx driver in kernel
> >>2.6.17.9. Removing or adding a disk from/to a running system makes i/o
> >>to any disk on the bus fail.
> >>
> >>The machine is an IBM x346 server with a x86_64 cpu and a aic7902 scsi
> >>controller.
> >>
> >>A copy of the system log is here:
> >>http://www.math.ku.dk/~zuziak/tmp/aic79xx_error_2.6.17.9.log
> >>
> >>It shows the result of removing the third disk: the first disk (the only
> >>one mounted) becomes inaccessible.
> >>
> >>Kernel 2.6.15.7 seems to work but I have had no luck with newer kernels.
> >>
> >>Has anyone seen hot-swapping work with the aic79xx driver in recent
> >>kernels?
> >
> >Are you sure your system is hot swap safe?  The whole log mess begins
> >with "someone reset channel A" which means the card detected a bus reset
> >but it didn't initiate the reset.  That's either going to be because
> >your system shouldn't be hot swap plugged and it triggered a spike on
> >the reset pin, or because your hot swap drive setup resets the bus on
> >unplug intentionally.  Knowing that would help.
> >
> >So, the driver managed to get into the ahd_pause_and_flushwork()
> >function, probably while trying to queue the abort SCB, and while there
> >it detected an infinite loop and printed out the "Infinite interrupt
> >loop, INTSTAT = 8" message.  The INTSTAT value of 0x08 maps to SCSIINT,
> >so next you would look at the SCSIINT1 and SCSIINT2 registers to see
> >just *what* is causing the loop.  There you see SSTAT1[0x20]:(SCSIRSTI).
> >This tells us the driver is *still* getting a SCSI Reset In interrupt
> >from the card, even over 1 minute after you pulled the drive.  So, the
> >reason your SCSI bus hung is because everything on the bus is being
> >subjected to an infinite bus reset condition.  The cause of this
> >happening is likely either A) your bus isn't hot swap safe and you hot
> >swapped anyway, and in the process you disconnected the termination
> >power source or termination itself or just plain flaked other devices on
> >the bus out or B) something in your hot swap enclosure is broken and
> >throws an infinite bus reset when the drive is removed.  Either way,
> >this is not what I would call expected behavior from the aic79xx driver,
> >I suspect that it is innocent here and that the hardware is to blame.
> >
> Thanks Doug.
> I couldn't have phrased it better.
> 
> Hotswap does work, provided you don't do anything untoward.
> Which translates as "might work but don't blame me if it doesn't".
> And I would never ever claim that it is a supported feature.

Thank you both for your replies.

First off all the hardware (both server and disks) does support hot
swap. And I have tried on three different machines (same model) to rule
out a hardware fault.

I have never had any problems with hot swap before. And indeed hot swap
on these machines work with the 2.6.15.7 kernel. But something has
changed since 2.6.16 so it no longer works.

However if hot swap isn't supported then that's just the way it is.

Sincerely,

Martin Zuziak <zuziak@math.ku.dk>

