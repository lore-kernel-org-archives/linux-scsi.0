From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: OCZ Z-drive p84 read performance
Date: Mon, 30 Nov 2009 20:07:58 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C7557A@inbmail01.lsi.com>
References: <b30d1c3b0911300137n2736664fxab0e9f3c55877e73@mail.gmail.com>
	 <0D1E8821739E724A86F4D16902CE275C1C93C7556B@inbmail01.lsi.com>
 <b30d1c3b0911300607w43f2b2a2mdd8957ffc5d3f74d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:56587 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbZK3OiC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Nov 2009 09:38:02 -0500
In-Reply-To: <b30d1c3b0911300607w43f2b2a2mdd8957ffc5d3f74d@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryousei Takano <ryousei@gmail.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "Support, Software" <support@lsi.com>, "takano-ryousei@aist.go.jp" <takano-ryousei@aist.go.jp>, "Yang, Bo" <Bo.Yang@lsi.com>

Ryousei,

See my comments inlined.

Thanks,
Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Ryousei Takano
> Sent: Monday, November 30, 2009 7:38 PM
> To: Desai, Kashyap
> Cc: Moore, Eric; linux-scsi@vger.kernel.org; DL-MPT Fusion Linux; Sup=
port,
> Software; takano-ryousei@aist.go.jp; Yang, Bo
> Subject: Re: OCZ Z-drive p84 read performance
>=20
> Hi Kashyap,
>=20
> Thanks for your reply, and I am sorry for lack of information.
>=20
> I am using mpt fusion driver version 3.04.10.
>=20
> What setup information do you need?
>=20
> My PC consists of two Intel Quad-core Xeon E5430 2.66~GHz, Intel 5100
> chipset,
> and 4 GB memory (DDR2-667). OCZ Z-Drive p84 is plugged into a
> PCI-Express x8 lane.
>=20
> Here is my test script:
>=20
> #!/bin/bash
>=20
> BS=3D$((1024))
> COUNT=3D$((1024*1024*10))
>=20
> for i in 1 4 16 64 256 512 1024 2048 4096 8192 16384 32768 65536; do
>         bs=3D$((BS * i))
>         count=3D$((COUNT / i))
>=20
>         echo bs=3D$bs count=3D$count
>         sudo mount /dev/sdb1 /media/test
>         dd if=3D/dev/zero of=3D/media/test/foo bs=3D$bs count=3D$coun=
t
>         sudo umount /media/test
>         sleep 1
>         sudo mount /dev/sdb1 /media/test
>         dd if=3D/media/test/foo of=3D/dev/null bs=3D$bs count=3D$coun=
t
Replace /media/test/foo with /dev/sdb1, you will see raw read
>         rm /media/test/foo
>         sudo umount /media/test
> done
>=20
This test is not purely RAW read/write test. In you test File system pe=
rformance is also included. While read operation, (sequential read) Fil=
e system buffering will give huge advantage to data transfer.


> This script assumes the Z-drive is /dev/sdb1 and it is mounted on
> /media/test.
>=20
> Best regards,
> Ryousei
>=20
> On Mon, Nov 30, 2009 at 10:25 PM, Desai, Kashyap <Kashyap.Desai@lsi.c=
om>
> wrote:
> > Ryousei,
> >
> > Replied inlined.
> >
> > Thanks,
> > Kashyap
> >
> >
> >> -----Original Message-----
> >> From: Ryousei Takano [mailto:ryousei@gmail.com]
> >> Sent: Monday, November 30, 2009 3:08 PM
> >> To: Moore, Eric
> >> Cc: linux-scsi@vger.kernel.org; DL-MPT Fusion Linux; Support, Soft=
ware;
> >> takano-ryousei@aist.go.jp
> >> Subject: OCZ Z-drive p84 read performance
> >>
> >> Dear Eric Moore and all,
> >>
> >> I am installing ubuntu 9.10 (kernel 2.6.31-14-server) on my PC, wh=
ich
> >> has OCZ Z-Drive p84.
> >> This drive consists of LSI logic's SAS1068E controller and 4 MLC S=
SDs.
> >> I am using mptsas driver instead of the official binary driver
> >> (megasar).
> > Is this megaraid driver or mpt fusion?
> > Driver version?
> >
> > =A0I ran simple read & write
> >> benchmark using dd(1). The result shows the throughput of sequenti=
al
> >> read achieves 260 MB/s,
> >> which is the half of sequential write performance (520 MB/s):
> > Setup information?
> >>
> >> block size =A0write (MB/s) =A0read (MB/s)
> >> 1024 =A0201 =A0 =A0 241
> >> 4096 =A0472 =A0 =A0 262
> >> 16384 486 =A0 =A0 267
> >> 65536 502 =A0 =A0 266
> >> 262144 =A0 =A0 =A0 =A0472 =A0 =A0 259
> >> 524288 =A0 =A0 =A0 =A0525 =A0 =A0 251
> >> 1048576 =A0 =A0 =A0 528 =A0 =A0 245
> >> 2097152 =A0 =A0 =A0 517 =A0 =A0 253
> >> 4194304 =A0 =A0 =A0 433 =A0 =A0 247
> >> 8388608 =A0 =A0 =A0 406 =A0 =A0 246
> >> 16777216 =A0 =A0 =A0405 =A0 =A0 243
> >> 33554432 =A0 =A0 =A0405 =A0 =A0 242
> >> 67108864 =A0 =A0 =A0405 =A0 =A0 242
> >>
> >> I wonder why read performance is worse than write performance.
> >> What is the bottleneck of read performance?
> >>
> >> For more information, please see my page:
> >> http://code.google.com/p/pspacer/wiki/ZdrivePerformance
> >>
> >> Any comments and suggestions will be welcome.
> >>
> >> Best regards,
> >> Ryousei
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
