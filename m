From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: fix hang in scsi error handling
Date: Mon, 27 Jul 2015 12:38:35 +0200
Message-ID: <55B60A2B.1040905@suse.de>
References: <1436964449-31447-1-git-send-email-kgroeneveld@lenbrook.com> <55A79156.3060307@suse.de> <BF6B9AADDDF11740967545E971C7C0DE02234A@MAIL1.pickering.lenbrook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbbG0Kii (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2015 06:38:38 -0400
In-Reply-To: <BF6B9AADDDF11740967545E971C7C0DE02234A@MAIL1.pickering.lenbrook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kevin Groeneveld <KGroeneveld@lenbrook.com>, "JBottomley@odin.com" <JBottomley@odin.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "festevam@gmail.com" <festevam@gmail.com>, "richard.zhu@freescale.com" <richard.zhu@freescale.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>

On 07/16/2015 08:55 PM, Kevin Groeneveld wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: July-16-15 7:11 AM
>>> When the hang occurs shost->host_busy =3D=3D 2 and shost->host_fail=
ed =3D=3D 1
>>> in the scsi_eh_wakeup function. However this function only wakes th=
e
>>> error handler if host_busy =3D=3D host_failed.
>>>
>> Which just means that one command is still outstanding, and we need =
to wait
>> for it to complete.
>> But see below...
>=20
> So the root cause of the hang is maybe that the second command never
> completes? Maybe host_failed being non zero is blocking something in =
the
> port multiplier code?
>=20
>> Hmm.
>> I am really not sure about this.
>=20
> I wasn't sure either, that is one reason why I posted the patch.
>=20
>> 'host_busy' indicates the number of outstanding commands, and
>> 'host_failed' is the number of commands which have failed (on the gr=
ound
>> that failed commands are considered outstanding, too).
>>
>> So the first hunk would change the behaviour from 'start SCSI EH onc=
e all
>> commands are completed or failed' to 'start SCSI EH for _any_ comman=
d if
>> scsi_eh_wakeup is called'
>> (note that shost_failed might be '0'...).
>> Which doesn't sound right.
>=20
> So could the patch create any problems by starting the EH any time
> scsi_eh_wakeup is called? Or is it is just inefficient?
>=20
SCSI EH _relies_ on the fact that no other commands are outstanding
on that SCSI host, hence the contents of eh_entry list won't change.
Your patch breaks this assumption, causing some I/O to be lost.

>> I guess this needs further debugging to get to the bottom of it.
>=20
> Any suggestions on things I could try?
>=20
> The fact that the problem goes away when I only enable one CPU core m=
akes
> me think there is a race happening somewhere.
>=20
Not sure here. You're effectively creating an endless loop with your
patch, assuming that each ioctl will be
However, you are effectively creating an endless loop with you
testcase, assuming that 'ioctl' finishes all I/O before returning.
Which _actually_ is not a requirement; the I/O itself needs to be
finished by the time the ioctl returns (obviously), but the
_structures_ associated with the ioctl might linger on a bit longer
(delayed freeing and whatnot).
Yet this is a bit far-fetched, and definitely needs some more analysis.

=46or debugging I would suggest looking at the lifetime of each scsi
command, figuring out if by the time the ioctl returns the scsi
command is indeed freed up.
Also you might want to play around with the 'usleep' a bit; my
assumption is that at one point for a large enough wait the problem
goes away.
(And, incidentally, we might actually getting more than one pending
commands if the sleep is small enough; but this is just conjecture :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
