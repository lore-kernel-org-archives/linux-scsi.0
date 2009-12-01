From: Ryousei Takano <ryousei@gmail.com>
Subject: Re: OCZ Z-drive p84 read performance
Date: Tue, 1 Dec 2009 12:25:01 +0900
Message-ID: <b30d1c3b0911301925o55adc2e2x42ec0aaedc2f833c@mail.gmail.com>
References: <b30d1c3b0911300137n2736664fxab0e9f3c55877e73@mail.gmail.com>
	 <0D1E8821739E724A86F4D16902CE275C1C93C7556B@inbmail01.lsi.com>
	 <b30d1c3b0911300607w43f2b2a2mdd8957ffc5d3f74d@mail.gmail.com>
	 <0D1E8821739E724A86F4D16902CE275C1C93C7557A@inbmail01.lsi.com>
	 <20091130161158.GR9482@parisc-linux.org>
	 <b30d1c3b0911301730i1a5b2c73w3a0fdea68ef0b3ec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:38279 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbZLADYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2009 22:24:55 -0500
Received: by pzk1 with SMTP id 1so3305655pzk.33
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2009 19:25:01 -0800 (PST)
In-Reply-To: <b30d1c3b0911301730i1a5b2c73w3a0fdea68ef0b3ec@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "Support, Software" <support@lsi.com>, "takano-ryousei@aist.go.jp" <takano-ryousei@aist.go.jp>, "Yang, Bo" <Bo.Yang@lsi.com>

Hi,

On Tue, Dec 1, 2009 at 10:30 AM, Ryousei Takano <ryousei@gmail.com> wro=
te:
> Hi Matthew and Kashyap,
>
> Thanks for your comments!
>
> On Tue, Dec 1, 2009 at 1:11 AM, Matthew Wilcox <matthew@wil.cx> wrote=
:
>> On Mon, Nov 30, 2009 at 08:07:58PM +0530, Desai, Kashyap wrote:
>>> > for i in 1 4 16 64 256 512 1024 2048 4096 8192 16384 32768 65536;=
 do
>>> > =A0 =A0 =A0 =A0 bs=3D$((BS * i))
>>> > =A0 =A0 =A0 =A0 count=3D$((COUNT / i))
>>> >
>>> > =A0 =A0 =A0 =A0 echo bs=3D$bs count=3D$count
>>> > =A0 =A0 =A0 =A0 sudo mount /dev/sdb1 /media/test
>>> > =A0 =A0 =A0 =A0 dd if=3D/dev/zero of=3D/media/test/foo bs=3D$bs c=
ount=3D$count
>>> > =A0 =A0 =A0 =A0 sudo umount /media/test
>>> > =A0 =A0 =A0 =A0 sleep 1
>>> > =A0 =A0 =A0 =A0 sudo mount /dev/sdb1 /media/test
>>> > =A0 =A0 =A0 =A0 dd if=3D/media/test/foo of=3D/dev/null bs=3D$bs c=
ount=3D$count
>>> Replace /media/test/foo with /dev/sdb1, you will see raw read
>>> > =A0 =A0 =A0 =A0 rm /media/test/foo
>>> > =A0 =A0 =A0 =A0 sudo umount /media/test
>>> > done
>>> >
>>> This test is not purely RAW read/write test. In you test File syste=
m performance is also included. While read operation, (sequential read)=
 File system buffering will give huge advantage to data transfer.
>>
>> Both filesystem and block access will use the page cache. =A0You sho=
uld
>> use iflag=3Ddirect (or oflag=3Ddirect as appropriate) in order to by=
pass
>> the page cache.
>>
>> --
>> Matthew Wilcox =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0In=
tel Open Source Technology Centre
>> "Bill, look, we understand that you're interested in selling us this
>> operating system, but compare it to ours. =A0We can't possibly take =
such
>> a retrograde step."
>>
>
> The bottleneck is in the file system.
> I retried dd with the direct I/O option. =A0The performance improves
> with large block sizes.
> The cross point is about 256 KB.
>
> bs =A0write (MB/s) =A0read (MB/s)
> 1024 =A0 =A09.5 =A0 =A0 9.7
> 4096 =A0 =A034.4 =A0 =A028.3
> 16384 =A0 95.8 =A0 =A047.0
> 65536 =A0 186 =A0 =A0 121
> 262144 =A0382 =A0 =A0 307
> 524288 =A0417 =A0 =A0 366
> 1048576 449 =A0 =A0 380
> 2097152 497 =A0 =A0 467
> 4194304 511 =A0 =A0 532
> 8388608 498 =A0 =A0 560
> 16777216 =A0 =A0 =A0 =A0523 =A0 =A0 545
> 33554432 =A0 =A0 =A0 =A0555 =A0 =A0 541
> 67108864 =A0 =A0 =A0 =A0554 =A0 =A0 543
>
> My page is also updated.
>
> Best regards,
> Ryousei
>

Here is the result on btrfs without direct I/O:

bs  write (MB/s) =A0read (MB/s)
1024	176	605=09
4096	435	614=09
16384	641	620=09
65536	664	624=09
262144	676	618=09
524288	677	620=09
1048576	674	625=09
2097152	666	615=09
4194304	652	600=09
8388608	625	599=09
16777216	633	598=09
33554432	629	601=09
67108864	624	603

I got good performance. However, the continued usage (read&write)
causes the write performance
decrease independently of the block size.
Anyway, my first question is resolved.

Thanks,
Ryousei
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
