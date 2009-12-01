From: Ryousei Takano <ryousei@gmail.com>
Subject: Re: OCZ Z-drive p84 read performance
Date: Tue, 1 Dec 2009 10:30:29 +0900
Message-ID: <b30d1c3b0911301730i1a5b2c73w3a0fdea68ef0b3ec@mail.gmail.com>
References: <b30d1c3b0911300137n2736664fxab0e9f3c55877e73@mail.gmail.com>
	 <0D1E8821739E724A86F4D16902CE275C1C93C7556B@inbmail01.lsi.com>
	 <b30d1c3b0911300607w43f2b2a2mdd8957ffc5d3f74d@mail.gmail.com>
	 <0D1E8821739E724A86F4D16902CE275C1C93C7557A@inbmail01.lsi.com>
	 <20091130161158.GR9482@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45473 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZLABaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2009 20:30:23 -0500
Received: by pwi3 with SMTP id 3so2209579pwi.21
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2009 17:30:30 -0800 (PST)
In-Reply-To: <20091130161158.GR9482@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "Support, Software" <support@lsi.com>, "takano-ryousei@aist.go.jp" <takano-ryousei@aist.go.jp>, "Yang, Bo" <Bo.Yang@lsi.com>

Hi Matthew and Kashyap,

Thanks for your comments!

On Tue, Dec 1, 2009 at 1:11 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Mon, Nov 30, 2009 at 08:07:58PM +0530, Desai, Kashyap wrote:
>> > for i in 1 4 16 64 256 512 1024 2048 4096 8192 16384 32768 65536; =
do
>> > =A0 =A0 =A0 =A0 bs=3D$((BS * i))
>> > =A0 =A0 =A0 =A0 count=3D$((COUNT / i))
>> >
>> > =A0 =A0 =A0 =A0 echo bs=3D$bs count=3D$count
>> > =A0 =A0 =A0 =A0 sudo mount /dev/sdb1 /media/test
>> > =A0 =A0 =A0 =A0 dd if=3D/dev/zero of=3D/media/test/foo bs=3D$bs co=
unt=3D$count
>> > =A0 =A0 =A0 =A0 sudo umount /media/test
>> > =A0 =A0 =A0 =A0 sleep 1
>> > =A0 =A0 =A0 =A0 sudo mount /dev/sdb1 /media/test
>> > =A0 =A0 =A0 =A0 dd if=3D/media/test/foo of=3D/dev/null bs=3D$bs co=
unt=3D$count
>> Replace /media/test/foo with /dev/sdb1, you will see raw read
>> > =A0 =A0 =A0 =A0 rm /media/test/foo
>> > =A0 =A0 =A0 =A0 sudo umount /media/test
>> > done
>> >
>> This test is not purely RAW read/write test. In you test File system=
 performance is also included. While read operation, (sequential read) =
=46ile system buffering will give huge advantage to data transfer.
>
> Both filesystem and block access will use the page cache. =A0You shou=
ld
> use iflag=3Ddirect (or oflag=3Ddirect as appropriate) in order to byp=
ass
> the page cache.
>
> --
> Matthew Wilcox =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Int=
el Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours. =A0We can't possibly take s=
uch
> a retrograde step."
>

The bottleneck is in the file system.
I retried dd with the direct I/O option.  The performance improves
with large block sizes.
The cross point is about 256 KB.

bs  write (MB/s)  read (MB/s)
1024	9.5	9.7=09
4096	34.4	28.3=09
16384	95.8	47.0=09
65536	186	121=09
262144	382	307=09
524288	417	366=09
1048576	449	380=09
2097152	497	467=09
4194304	511	532=09
8388608	498	560
16777216	523	545=09
33554432	555	541=09
67108864	554	543=09

My page is also updated.

Best regards,
Ryousei
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
