From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Multiple CDRW's on one bus blocking each other
Date: Thu, 2 May 2002 15:40:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020502154011.A28102@eng2.beaverton.ibm.com>
References: <5.0.2.1.2.20020502145414.0354c230@pop.puretec.de> <5.0.2.1.2.20020502145414.0354c230@pop.puretec.de> <20020502092726.A14365@eng2.beaverton.ibm.com> <5.0.2.1.2.20020502221132.03224090@pop.puretec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <5.0.2.1.2.20020502221132.03224090@pop.puretec.de>; from sancho@dauskardt.de on Thu, May 02, 2002 at 11:17:15PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Sancho Dauskardt <sancho@dauskardt.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

It looks like the NCR53c800 uses the old error handling code - I don't
know much about that code, but it does not use the scsi logging. It looks
like you must be getting some sense code back, since there are bunch of:

> May  2 21:22:59 ice kernel: Ioctl returned  0x28000000

The above is a SUGGEST_ABORT | DRIVER_SENSE

You could try turning on debug printk's or such in scsi_obosolete.c.

Were you running with old or new aic driver before? Make sure you use
try the new one.

It looks like some timer is added twice, I don't know what causes this:

> May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
> May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 50 (c01e22e0)
> May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000

I can't tell if you hit a timeout or not from the log output. 

-- Patrick

On Thu, May 02, 2002 at 11:17:15PM +0200, Sancho Dauskardt wrote:
> At 09:27 02.05.02 -0700, Patrick Mansfield wrote:
> >Have you tried using scsi logging? That might give a better idea of what
> >is happening in linux scsi layers.
> 
> Great idea, thanks. Luckly my disks were on a ide bus, so no logging problems.
> 
> 
> In the mean time I've tried following different scenarios:
> a) 3 CDRW on a NCR53c800 --> exactly the same as the adaptec (tray opens 
> are independant, tray closes are 'serialized')
> b) 2 CDROM's on ONE IDE bus via ide-scsi --> tray opens AND closes are 
> serialized !
> 
> I'll stick with the IDE setup for now.
> 
> Following different software approaches tried:
> - 'eject & eject -t'
> - ioctl CDROMEJECT & ioctl CDROMCLOSETRAY on /dev/srX
> - ioctl CDROM_SEND_PACKET with GPCMD_START_STOP_UNIT, as sr_ioctl.c / 
> sr_tray_move does.
>    As one would guess, all behave the same.
> 
> 
> 
> Now if i'm reading the logs correctly, it not the START STOP UNIT (0x1b) 
> command that's causing the problems, but more the PREVENT ALLOW MEDIUM 
> REMOVAL command...
> 
> Where's this delay coming from / did the timer fire / were are we sleeping ???
>          May  2 21:23:00 ice kernel: Leaving scsi_do_req()
>                   -- here --
>          May  2 21:23:06 ice kernel: Clearing timer for command cff33400 1
> 
> 
> Just a nother silly idea: could it be possible, that the problem is 
> triggered somwhere down in the VFS - i.e. that the VFA locks the bus while 
> trying to detect the new media ??
> 
> 
> btw. he '--sda-- blabla' crap was just an idea in 
> scsi_block_when_processing_errors()..
> 
> - sda
