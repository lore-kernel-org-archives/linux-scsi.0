From: =?UTF-8?B?6IOh5rSq5YW1?= <huhb@lemote.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Mon, 25 May 2009 15:35:48 +0800
Message-ID: <4A1A4A54.6090401@lemote.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com>	 <200905222032.55869.bzolnier@gmail.com>	 <1243062702.8509.7.camel@localhost.localdomain>	 <200905231347.34717.bzolnier@gmail.com> <1243230339.9819.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1243230339.9819.18.camel@localhost.localdomain>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
To: yanh@lemote.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, wuzhangjin@gmail.com, linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>
List-Id: linux-scsi@vger.kernel.org

yanh =E5=86=99=E9=81=93:
> =E5=9C=A8 2009-05-23=E5=85=AD=E7=9A=84 13:47 +0200=EF=BC=8CBartlomiej=
 Zolnierkiewicz=E5=86=99=E9=81=93=EF=BC=9A
>  =20
>> On Saturday 23 May 2009 09:11:42 yanh wrote:
>>    =20
>>> =E5=9C=A8 2009-05-22=E4=BA=94=E7=9A=84 20:32 +0200=EF=BC=8CBartlomi=
ej Zolnierkiewicz=E5=86=99=E9=81=93=EF=BC=9A
>>>      =20
>>>> On Thursday 21 May 2009 00:12:46 wuzhangjin@gmail.com wrote:
>>>>        =20
>>>>> From: Wu Zhangjin <wuzhangjin@gmail.com>
>>>>>
>>>>> This is originally from the to-mips branch from
>>>>> http://dev.lemote.com/code/linux_loongson
>>>>>          =20
>>>> Sadly, the patch description lacks all the important information.
>>>>
>>>> What is the original problem that this fixup tries to address?
>>>>
>>>> Is it limited to amd74xx controllers?
>>>>        =20
>>> In loongson2f yeeloong machines, the ide controller is AMD cs5536, =
or
>>> say  amd74xx, and the hard drives is Fujistu.=20
>>>      =20
>> Then it should use the new & shiny :) native cs5536 IDE host driver
>> instead of legacy support in amd74xx...
>>
>>    =20
>>> While debuging the hard disk suspned and resume, the ide irq can no=
t be
>>> cleared. I guess this is a fake interrupt, hence the clear irq acti=
on
>>> can not be finished.=20
>>>      =20
>> AFAICS the only change that the fixup would cause for suspend/resume=
 paths
>> is the one in ide_config_drive_speed() which is called during resume=
 to set
>> transfer mode on the drive:
>>
>>        tp_ops->write_devctl(hwif, ATA_NIEN | ATA_DEVCTL_OBS);
>>
>>         memset(&tf, 0, sizeof(tf));
>>         tf.feature =3D SETFEATURES_XFER;
>>         tf.nsect   =3D speed;
>>
>>         tp_ops->tf_load(drive, &tf, IDE_VALID_FEATURE | IDE_VALID_NS=
ECT);
>>
>>         tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
>> --->
>>         if (drive->quirk_list =3D=3D 2)
>>                 tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
>>    =20
>
>  =20
>> --->
>>         error =3D __ide_wait_stat(drive, drive->ready_stat,
>>                                 ATA_BUSY | ATA_DRQ | ATA_ERR,
>>                                 WAIT_CMD, &stat);
>>
>> Please tell me I if understand the issue correctly: if the above qui=
rk is
>> not executed we end up with spurious IRQs, right?
>>    =20
> right.
>  =20
>>> This patch is to fix this issue. Maybe other controller and drives =
also
>>> have this issue, but I am not sure.
>>>      =20
>> Probably moving it to a generic quirk_drives list later will be usef=
ul...
>>
>> Anyway this fixup needs to be ported to / verified with cs5536 first=
=2E
>>    =20
> the cs5536 pata driver have some geode platform dependent codes. We c=
an
> just ignore it, but the performance is poor(using hdparm to test it),
> which only get 22+ MB/s. we find it only use udma2. However if using
> amd74xx driver, it can set udma5, and the speed can reach to 50+ MB/s=
=2E=20
>
> we will test whether this driver is working well without this patch.
>
> Anyway, thanks your advice.
>  =20
Use the driver drivers/ata/pata_cs5536.c, unfortunately it also have th=
e=20
same issue.
>> Thanks.
>> Bart
>>
>>    =20
>
>
>
>  =20


--=20
---------------------------------------------------------
Hongbing,Hu (Software Department)
Tel:    0512-52308631
E-mail:	huhb@lemote.com
MSN:	[huhb04@gmail.com]
JiangSu Lemote Corp. Ltd.
MengLan, Yushan, Changshu, JiangSu Province, China
---------------------------------------------------------
