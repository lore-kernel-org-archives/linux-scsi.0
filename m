From: Hannes Reinecke <hare@suse.de>
Subject: Re: aic79xx driver - hotswap error
Date: Wed, 30 Aug 2006 15:41:22 +0200
Message-ID: <44F59582.6000609@suse.de>
References: <20060828121542.GA13993@pc000ffe3ca343.math.ku.dk> <1156779911.28832.28.camel@fc6.xsintricity.com> <44F40854.4050902@suse.de> <20060830132345.GA9100@pc000ffe3ca343.math.ku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:48598 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751036AbWH3NlY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Aug 2006 09:41:24 -0400
In-Reply-To: <20060830132345.GA9100@pc000ffe3ca343.math.ku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Zuziak <zuziak@math.ku.dk>
Cc: Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org

Martin Zuziak wrote:
> On Tue, Aug 29, 2006 at 11:26:44AM +0200, Hannes Reinecke wrote:
>> Doug Ledford wrote:
>>> On Mon, 2006-08-28 at 14:15 +0200, Martin Zuziak wrote:
>>>> Hello all
>>>>
>>>> Hot-swapping doesn't seem to work with the aic79xx driver in kerne=
l
>>>> 2.6.17.9. Removing or adding a disk from/to a running system makes=
 i/o
>>>> to any disk on the bus fail.
>>>>
>>>> The machine is an IBM x346 server with a x86_64 cpu and a aic7902 =
scsi
>>>> controller.
>>>>
>>>> A copy of the system log is here:
>>>> http://www.math.ku.dk/~zuziak/tmp/aic79xx_error_2.6.17.9.log
>>>>
>>>> It shows the result of removing the third disk: the first disk (th=
e only
>>>> one mounted) becomes inaccessible.
>>>>
>>>> Kernel 2.6.15.7 seems to work but I have had no luck with newer ke=
rnels.
>>>>
>>>> Has anyone seen hot-swapping work with the aic79xx driver in recen=
t
>>>> kernels?
>>> Are you sure your system is hot swap safe?  The whole log mess begi=
ns
>>> with "someone reset channel A" which means the card detected a bus =
reset
>>> but it didn't initiate the reset.  That's either going to be becaus=
e
>>> your system shouldn't be hot swap plugged and it triggered a spike =
on
>>> the reset pin, or because your hot swap drive setup resets the bus =
on
>>> unplug intentionally.  Knowing that would help.
>>>
>>> So, the driver managed to get into the ahd_pause_and_flushwork()
>>> function, probably while trying to queue the abort SCB, and while t=
here
>>> it detected an infinite loop and printed out the "Infinite interrup=
t
>>> loop, INTSTAT =3D 8" message.  The INTSTAT value of 0x08 maps to SC=
SIINT,
>>> so next you would look at the SCSIINT1 and SCSIINT2 registers to se=
e
>>> just *what* is causing the loop.  There you see SSTAT1[0x20]:(SCSIR=
STI).
>>> This tells us the driver is *still* getting a SCSI Reset In interru=
pt
>> >from the card, even over 1 minute after you pulled the drive.  So, =
the
>>> reason your SCSI bus hung is because everything on the bus is being
>>> subjected to an infinite bus reset condition.  The cause of this
>>> happening is likely either A) your bus isn't hot swap safe and you =
hot
>>> swapped anyway, and in the process you disconnected the termination
>>> power source or termination itself or just plain flaked other devic=
es on
>>> the bus out or B) something in your hot swap enclosure is broken an=
d
>>> throws an infinite bus reset when the drive is removed.  Either way=
,
>>> this is not what I would call expected behavior from the aic79xx dr=
iver,
>>> I suspect that it is innocent here and that the hardware is to blam=
e.
>>>
>> Thanks Doug.
>> I couldn't have phrased it better.
>>
>> Hotswap does work, provided you don't do anything untoward.
>> Which translates as "might work but don't blame me if it doesn't".
>> And I would never ever claim that it is a supported feature.
>=20
> Thank you both for your replies.
>=20
> First off all the hardware (both server and disks) does support hot
> swap. And I have tried on three different machines (same model) to ru=
le
> out a hardware fault.
>=20
> I have never had any problems with hot swap before. And indeed hot sw=
ap
> on these machines work with the 2.6.15.7 kernel. But something has
> changed since 2.6.16 so it no longer works.
>=20
Hmm. But you should see something in the logs for 2.6.15, too.
Ideally some aic79xx stack dump. Can you dig it out?
If a aic79xx state dump is available for 2.6.15 we might be able to=20
figure out the difference and fix the driver if possible.

But saying that 'hotswap is supported' simply doesn't cut it.
The spec actually allows you to claim 'hotswap is supported' when you=20
have to power-cycle the entire cabinet.
Or the HBA.

Hmm. I wonder whether this is related to the infamous bus polling=20
mechanism the original driver did ...
Anyway, can you get the logs?

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
