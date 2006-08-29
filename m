From: Hannes Reinecke <hare@suse.de>
Subject: Re: aic79xx driver - hotswap error
Date: Tue, 29 Aug 2006 11:26:44 +0200
Message-ID: <44F40854.4050902@suse.de>
References: <20060828121542.GA13993@pc000ffe3ca343.math.ku.dk> <1156779911.28832.28.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59584 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932123AbWH2J0q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 05:26:46 -0400
In-Reply-To: <1156779911.28832.28.camel@fc6.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Martin Zuziak <zuziak@math.ku.dk>, linux-scsi@vger.kernel.org

Doug Ledford wrote:
> On Mon, 2006-08-28 at 14:15 +0200, Martin Zuziak wrote:
>> Hello all
>>
>> Hot-swapping doesn't seem to work with the aic79xx driver in kernel
>> 2.6.17.9. Removing or adding a disk from/to a running system makes i=
/o
>> to any disk on the bus fail.
>>
>> The machine is an IBM x346 server with a x86_64 cpu and a aic7902 sc=
si
>> controller.
>>
>> A copy of the system log is here:
>> http://www.math.ku.dk/~zuziak/tmp/aic79xx_error_2.6.17.9.log
>>
>> It shows the result of removing the third disk: the first disk (the =
only
>> one mounted) becomes inaccessible.
>>
>> Kernel 2.6.15.7 seems to work but I have had no luck with newer kern=
els.
>>
>> Has anyone seen hot-swapping work with the aic79xx driver in recent
>> kernels?
>=20
> Are you sure your system is hot swap safe?  The whole log mess begins
> with "someone reset channel A" which means the card detected a bus re=
set
> but it didn't initiate the reset.  That's either going to be because
> your system shouldn't be hot swap plugged and it triggered a spike on
> the reset pin, or because your hot swap drive setup resets the bus on
> unplug intentionally.  Knowing that would help.
>=20
> So, the driver managed to get into the ahd_pause_and_flushwork()
> function, probably while trying to queue the abort SCB, and while the=
re
> it detected an infinite loop and printed out the "Infinite interrupt
> loop, INTSTAT =3D 8" message.  The INTSTAT value of 0x08 maps to SCSI=
INT,
> so next you would look at the SCSIINT1 and SCSIINT2 registers to see
> just *what* is causing the loop.  There you see SSTAT1[0x20]:(SCSIRST=
I).
> This tells us the driver is *still* getting a SCSI Reset In interrupt
> from the card, even over 1 minute after you pulled the drive.  So, th=
e
> reason your SCSI bus hung is because everything on the bus is being
> subjected to an infinite bus reset condition.  The cause of this
> happening is likely either A) your bus isn't hot swap safe and you ho=
t
> swapped anyway, and in the process you disconnected the termination
> power source or termination itself or just plain flaked other devices=
 on
> the bus out or B) something in your hot swap enclosure is broken and
> throws an infinite bus reset when the drive is removed.  Either way,
> this is not what I would call expected behavior from the aic79xx driv=
er,
> I suspect that it is innocent here and that the hardware is to blame.
>=20
Thanks Doug.
I couldn't have phrased it better.

Hotswap does work, provided you don't do anything untoward.
Which translates as "might work but don't blame me if it doesn't".
And I would never ever claim that it is a supported feature.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
