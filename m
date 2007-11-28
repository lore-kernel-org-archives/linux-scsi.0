From: Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
Date: Wed, 28 Nov 2007 22:38:38 +0100
Message-ID: <474DDFDE.7010204@free.fr>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	 <4744A6F2.4030302@free.fr>	 <20071121144116.c932727b.akpm@linux-foundation.org>	 <4746814F.80502@free.fr> <4746866B.5070207@suse.de>	 <4746BB9D.2030508@suse.de>  <4747135C.60205@free.fr>	 <1195886569.3195.2.camel@localhost.localdomain> <47481FA6.9050506@free.fr>	 <1195910809.3195.5.camel@localhost.localdomain> <4748ACC7.4010509@free.fr> <1195976275.3427.6.camel@localhost.localdomain> <4749DD87.5020206@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4749DD87.5020206@free.fr>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Le 25.11.2007 21:39, Laurent Riffard a =C3=A9crit :
> Le 25.11.2007 08:37, James Bottomley a =C3=A9crit :
>> On Sat, 2007-11-24 at 23:59 +0100, Laurent Riffard wrote:
>>> Le 24.11.2007 14:26, James Bottomley a =C3=A9crit :
>>>> OK, could you post dmesgs again, please.  I actually tested this
>>> with an
>>>> aic79xx card, and for me it does cause Domain Validation to succee=
d
>>>> again.
>>> James,=20
>>>
>>> Here is a dmesg produced by 2.6.24-rc3-mm1 + your patch "separates
>>> the=20
>>> BLOCK and QUIESCE states
>>> correctly" (http://lkml.org/lkml/2007/11/24/8).
>>>
[...]
>>> [   25.521256] scsi0 : pata_via
>>> [   25.521711] scsi1 : pata_via
>>> [   25.524089] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x=
b800 irq 14
>>> [   25.524176] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x=
b808 irq 15
>>> [   25.683141] ata1.00: ATA-5: ST340016A, 3.75, max UDMA/100
>>> [   25.683208] ata1.00: 78165360 sectors, multi 16: LBA=20
>>> [   25.683475] ata1.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/1=
33
>>> [   25.684116] ata1.01: 160086528 sectors, multi 16: LBA=20
>>> [   25.691127] ata1.00: configured for UDMA/100
>>> [   25.699142] ata1.01: configured for UDMA/100
>>> [   26.170860] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-4165B, DL05, max=
 UDMA/33
>>> [   26.171562] ata2.01: ATAPI: CD-950E/AKU, A4Q, max MWDMA2, CDB in=
tr
>>> [   26.330839] ata2.00: configured for UDMA/33
>>> [   26.490828] ata2.01: configured for MWDMA2
>>> [   26.503014] scsi 0:0:0:0: Direct-Access     ATA      ST340016A 3=
=2E75 PQ: 0 ANSI: 5
>>> [   26.504670] scsi 0:0:1:0: Direct-Access     ATA      Maxtor 6Y08=
0L0 YAR4 PQ: 0 ANSI: 5
>>> [   26.509842] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-=
4165B DL05 PQ: 0 ANSI: 5
>>> [   26.511673] scsi 1:0:1:0: CD-ROM            E-IDE    CD-950E/AKU=
 A4Q  PQ: 0 ANSI: 5
>> [...]
>>> [   60.216113] sd 0:0:0:0: [sda] Result: hostbyte=3DDID_NO_CONNECT =
driverbyte=3DDRIVER_OK,SUGGEST_OK
>>> [   60.216124] end_request: I/O error, dev sda, sector 16460
>> I think this one's quite easy:  PATA devices in libata are queue dep=
th 1
>> (since they don't do NCQ).  Thus, they're peculiarly sensitive to th=
e
>> bug where we fail over queue depth requests.
>>
>> On the other hand, I don't see how a filesystem request is getting
>> REQ_FAILFAST ... unless there's a bio or readahead issue involved.
>> Anyway, could you try this patch:
>>
>> http://marc.info/?l=3Dlinux-scsi&m=3D119592627425498
>>
>> Which should fix the queue depth issue, and see if the errors go awa=
y?
>=20
> No, this one doesn't help...
=20
still happens with 2.6.24-rc3-mm2...
--=20
laurent
