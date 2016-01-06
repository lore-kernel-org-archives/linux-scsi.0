From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Wed, 6 Jan 2016 10:48:44 -0500
Message-ID: <568D375C.1020800@interlog.com>
References: <20151218170644.24167419@harpe.intellique.com>
 <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr>
 <20160104124626.3112e8c0@harpe.intellique.com>
 <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com>
 <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com>
 <20160106161049.34f29973@harpe.intellique.com>
 <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com>
 <197363090.3557312.1452093937340.JavaMail.zimbra@redhat.com>
 <434451353.3559713.1452094368819.JavaMail.zimbra@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39993 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbcAFPs4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jan 2016 10:48:56 -0500
In-Reply-To: <434451353.3559713.1452094368819.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>
Cc: Laurence Oberman <oberman.l@gmail.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

On 16-01-06 10:32 AM, Laurence Oberman wrote:
> Firmware update fails as follows:
>
> Still researching. This is the only LTO5 I have access to so unless S=
hane has one I may not be able to make progress.
> (Its way long out of warranty and support)
>
> We mostly use this for generic st driver and changer testing for RHEL=
 and it has not been updated for at least two years.
>
> Performing FUP operation...
>
> Checking image file (/root/V3210A011-E00.IMG)
>
> Checking device readiness
>
> Sending image file to the device
>
> Redetecting device
> Fup drive command failed: Unknown error! (status =3D -100)
>
> Host adapter status =3D 0x00
> Driver status =3D 0x08
> Error buffer =3D 'MSG: FupDrive() - Error committing image file to dr=
ive (/root/V3210A011-E00.IMG) 1584236 of 1584236 bytes written.
> SCSI: WriteBuffer()::DevIo() - ErrorCode (0x70h) ,Sense Key (0x05h) I=
LLEGAL REQUEST, INVALID FIELD IN PARAMETER LIST. ASC(0x26h), ASCQ(0x00h=
) - )
> '
>
> Unable to perform FUP operation.

The 1584236 byte firmware image might be too big for a single
WRITE BUFFER command. You might try getting a recent version of
sg3_utils and doing something like:
    sg_write_buffer -b 4k -I V3210A011-E00.IMG -m 7 /dev/sg3

where /dev/sg3 corresponds to your tape drive. 'lsscsi -g' will
show you the mapping.

The above technique works fine for recent Seagate SAS disks (with
".LOD" firmware images).

Doug Gilbert

> ----- Original Message -----
> From: "Laurence Oberman" <loberman@redhat.com>
> To: "Emmanuel Florac" <eflorac@intellique.com>
> Cc: "Laurence Oberman" <oberman.l@gmail.com>, "Kai Makisara" <Kai.Mak=
isara@kolumbus.fi>, linux-scsi@vger.kernel.org
> Sent: Wednesday, January 6, 2016 10:25:37 AM
> Subject: Re: st driver doesn't seem to grok LTO partitioning
>
> I left the log of the failure to partition out
>
> Here it is
>
> # mt -f /dev/nst0  mkpartition 1
> /dev/nst0: Input/output error
>
> [ 5499.341648] st 0:0:0:0: [st0] Block limits 1 - 16777215 bytes.
> [ 5499.342903] st 0:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS=
 10, BLL 8
> [ 5499.343523] st 0:0:0:0: [st0] Density 58, tape length: 0, drv buff=
er: 1
> [ 5499.344114] st 0:0:0:0: [st0] Block size: 512, buffer size: 4096 (=
8 blocks).
> [ 5499.344702] st 0:0:0:0: [st0] Loading tape.
> [ 5499.359733] st 0:0:0:0: [st0] Block limits 1 - 16777215 bytes.
> [ 5499.360970] st 0:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS=
 10, BLL 8
> [ 5499.361584] st 0:0:0:0: [st0] Density 58, tape length: 0, drv buff=
er: 1
> [ 5499.362165] st 0:0:0:0: [st0] Block size: 512, buffer size: 4096 (=
8 blocks).
> [ 5499.363851] st 0:0:0:0: [st0] Partition page length is 10 bytes.
> [ 5499.364468] st 0:0:0:0: [st0] PP: max 0, add 0, xdp 0, psum 03, po=
fmetc 0,rec 03, units 09, sizes: 1541 65535
> [ 5499.365074] st 0:0:0:0: [st0] MP: 11 08 00 00 18 03 09 00 06 05 ff=
 ff
> [ 5499.365658] st 0:0:0:0: [st0] psd_cnt 2, max.parts 0, nbr_parts 0
> [ 5499.366246] st 0:0:0:0: [st0] Formatting tape with two partitions =
(FDP).
> [ 5499.366826] st 0:0:0:0: [st0] Sent partition page length is 12 byt=
es.  needs_format: 0
> [ 5499.367424] st 0:0:0:0: [st0] PP: max 0, add 1, xdp 4, psum 03, po=
fmetc 0 rec 03, units 00, sizes: 65535 65535
> [ 5499.368024] st 0:0:0:0: [st0] MP: 11 0a 00 01 98 03 00 00 ff ff ff=
 ff
> [ 5499.369842] st 0:0:0:0: [st0] Error: 8000002, cmd: 15 10 0 0 18 0
> [ 5499.370495] st 0:0:0:0: [st0] Sense Key : Illegal Request [current=
]
> [ 5499.371109] st 0:0:0:0: [st0] Add. Sense: Invalid field in paramet=
er list
> [ 5499.371714] st 0:0:0:0: [st0] Partitioning of tape failed.
>
> Laurence Oberman
> Principal Software Maintenance Engineer
> Red Hat Global Support Services
>
> ----- Original Message -----
> From: "Laurence Oberman" <loberman@redhat.com>
> To: "Emmanuel Florac" <eflorac@intellique.com>
> Cc: "Laurence Oberman" <oberman.l@gmail.com>, "Kai Makisara" <Kai.Mak=
isara@kolumbus.fi>, linux-scsi@vger.kernel.org
> Sent: Wednesday, January 6, 2016 10:23:34 AM
> Subject: Re: st driver doesn't seem to grok LTO partitioning
>
> Hello Emanuel
>
> I am using this device, its an Ultrium 5 (LTO5)
> Its an older changer and I am unable to update the firmware, still wo=
rking on that.
>
> What version of mt are you using, as I am testing using a RHEL7.2 bas=
e and the upstream patched kernel.
>
> Linux example.redhat.com 4.3.3 #1 SMP Tue Jan 5 15:58:47 EST 2016 x86=
_64 x86_64 x86_64 GNU/Linux
>
> # tapeinfo -f /dev/st0
> Product Type: Tape Drive
> Vendor ID: 'QUANTUM '
> Product ID: 'ULTRIUM 5       '
> Revision: '3060'
> Attached Changer API: No
> SerialNumber: 'HU1023AKHE'
> MinBlock: 1
> MaxBlock: 16777215
> SCSI ID: 0
> SCSI LUN: 0
> Ready: yes
> BufferedMode: yes
> Medium Type: Not Loaded
> Density Code: 0x58
> BlockSize: 512
> DataCompEnabled: yes
> DataCompCapable: yes
> DataDeCompEnabled: yes
> CompType: 0x1
> DeCompType: 0x1
> BOP: yes
> Block Position: 0
> Partition 0 Remaining Kbytes: 1541692
> Partition 0 Size in Kbytes: 1541692
> ActivePartition: 0
> EarlyWarningSize: 0
> NumPartitions: 0
> MaxPartitions: 0
>
> Drive is working fine,
>
> # mt -f /dev/st0 status
> SCSI 2 tape drive:
> File number=3D0, block number=3D0, partition=3D0.
> Tape block size 512 bytes. Density code 0x58 (no translation).
> Soft error count since last status=3D0
> General status bits on (41010000):
>   BOT ONLINE IM_REP_EN
>
> This is what I get when I try and partition and I believe this may be=
 a firmware issue for me.
>
> mt -f /dev/st0  stsetoption can-partitions
>
> [ 5343.620005] st 0:0:0:0: [st0] Block limits 1 - 16777215 bytes.
> [ 5343.621424] st 0:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS=
 10, BLL 8
> [ 5343.622005] st 0:0:0:0: [st0] Density 58, tape length: 0, drv buff=
er: 1
> [ 5343.622606] st 0:0:0:0: [st0] Block size: 512, buffer size: 4096 (=
8 blocks).
> [ 5343.623208] st 0:0:0:0: [st0] Mode 0 options: buffer writes: 1, as=
ync writes: 1, read ahead: 1
> [ 5343.623810] st 0:0:0:0: [st0]     can bsr: 1, two FMs: 0, fast mte=
om: 0, auto lock: 0,
> [ 5343.624413] st 0:0:0:0: [st0]     defs for wr: 0, no block limits:=
 0, partitions: 1, s2 log: 0
> [ 5343.625011] st 0:0:0:0: [st0]     sysv: 0 nowait: 0 sili: 0 nowait=
_filemark: 0
> [ 5343.625623] st 0:0:0:0: [st0]     debugging: 1
> [ 5343.626222] st 0:0:0:0: [st0] Rewinding tape.
>
> # mt -f /dev/nst0  mkpartition 1
> /dev/nst0: Input/output error
>
>
>
>
>
> Laurence Oberman
> Principal Software Maintenance Engineer
> Red Hat Global Support Services
>
> ----- Original Message -----
> From: "Emmanuel Florac" <eflorac@intellique.com>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: "Laurence Oberman" <oberman.l@gmail.com>, "Kai Makisara" <Kai.Mak=
isara@kolumbus.fi>, linux-scsi@vger.kernel.org
> Sent: Wednesday, January 6, 2016 10:10:49 AM
> Subject: Re: st driver doesn't seem to grok LTO partitioning
>
> Le Tue, 5 Jan 2016 16:55:04 -0500 (EST)
> Laurence Oberman <loberman@redhat.com> =C3=A9crivait:
>
>> mt -f /dev/nst0  mkpartition 1
>>
>
> What is the type of drive exactly? I still couldn't test with the LTO=
-5
> drive as the machine it's connected to is being reinstalled.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
