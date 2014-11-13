From: Barto <mister.freeman@laposte.net>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Thu, 13 Nov 2014 10:38:24 +0100
Message-ID: <54647C10.4070506@laposte.net>
References: <54629CAE.2000207@laposte.net> <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com> <5462CB90.1080303@roeck-us.net> <54642541.9080302@laposte.net> <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

> Were you running with scsi_mod.use_blk_mq=3DY or =3DN?

I don't find this value in my .config file related to kernel modules
options,

perhaps you talk about a kernel boot option for grub ?
I don't use this kernel option boot in grub ( scsi_mod.use_blk_mq ),

I use archlinux and his default kernel config file for 64 bits CPU, you
can find this file here :

https://projects.archlinux.org/svntogit/packages.git/tree/trunk?h=3Dpac=
kages/linux

I don't have SCSI devices, I have only 3 SATA harddisks, and 2 IDE
harddisks,

before kernel 3.17 I don't have this random hang bug on boot, so we nee=
d
to know what's going on, it's probably a change made last months ago in
SCSI source code ( or something else ) who has introduced a bug who
prevents a correct behaviour on some parts in scsi_lib.c ( for example
the if statement related to atomic_read(&sdev->device_busy) and
blk_delay_queue(q, SCSI_QUEUE_DELAY)  )

Guenter Roeck was the first to have been hit by this bug ( his qemu tes=
t
files hang on boot ), he thought the solution was to revert the polarit=
y
of the if statement, it solves his problem but unfortunately a new bug
is now triggered on some PC configurations,

it would be interesting to find a definitive solution who can solve bot=
h
the "qemu bug" and the "random bug on boot" on some PC configurations,

I'm not an expert about the scsi code, perhaps with some unit tests you
can spot the defect element in the scsi source code, check if some part=
s
in the source code acts really like it should be ?


Le 13/11/2014 06:33, Elliott, Robert (Server Storage) a =C3=A9crit :
>=20
>=20
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Barto
>> Sent: Wednesday, November 12, 2014 9:28 PM
>> To: Guenter Roeck; Bjorn Helgaas
>> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Joe
>> Perches
>> Subject: Re: BUG in scsi_lib.c due to a bad commit
>>
>> reverting your commit 045065d8a300a37218c is a solution, but it's ju=
st a
>> temporary solution,
>>
>> it's better to search why your commit can create a random hang on bo=
ot
>> on some PC configurations,
>>
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct request_que=
ue
>> *q)
>> blk_requeue_request(q, req);
>> atomic_dec(&sdev->device_busy);
>> out_delay:
>> - if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
>> + if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev)=
)
>> blk_delay_queue(q, SCSI_QUEUE_DELAY);
>> }
>>
>> perhaps the atomic_read() function doesn't make the expected job on =
some
>> rare circonstances, I have the same doubts about the blk_delay_queue=
()
>> function
>=20
> Were you running with scsi_mod.use_blk_mq=3DY or =3DN?
>=20
> device_busy is the active queue depth for the device (e.g.
> 5 means there are 5 commands submitted but not yet completed).
>=20
> The function reaches this code if it has run out of tags, the host
> has reached its limit of outstanding commands, or the target has
> reached its limit.  It requeus the request:
> * with delay if device_busy is zero
> * without delay if device_busy is non_zero
>=20
> I think this is the reasoning:
> If device_busy is zero, trying to process the request again will
> probably run into the same problem; a delay gives time for the
> situation to change.  If device_busy is non-zero, then the=20
> requeued command goes behind others and might get a different
> result.
>=20
> With the polarity backwards, the lack of delay hung PA-RISC=20
> and SPARC64 systems), not just QEMU.  So, I don't think reverting
> the fix is good.
>=20
> Changing it to an unconditional delay might be safe - delay
> regardless of device_busy (until the root cause is understood).
>=20
> Also, SCSI_QUEUE_DELAY seems like an arbitrary magic number;=20
> maybe that value isn't working correctly anymore?
>=20
>=20
