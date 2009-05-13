From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense:
	Logical block address out of range, sector 0
Date: Tue, 12 May 2009 19:08:54 -0600
Message-ID: <51f3faa70905121808x29c12a35n6905104f45883f17@mail.gmail.com>
References: <20090421015234.GA7014@hexapodia.org>
	 <20090422144904.407df635.akpm@linux-foundation.org>
	 <49F00EBB.7040504@gmail.com> <20090423070713.GF19113@hexapodia.org>
	 <20090512215256.GA22095@hexapodia.org> <4A0A050D.4000804@gmail.com>
	 <20090513010056.GT21505@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090513010056.GT21505@hexapodia.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andy Isaacson <adi@hexapodia.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 12, 2009 at 7:00 PM, Andy Isaacson <adi@hexapodia.org> wrot=
e:
> On Tue, May 12, 2009 at 05:23:57PM -0600, Robert Hancock wrote:
>> >Looking at hald/linux/addons/addon-storage.c it does appear to
>> >open(O_EXCL) as well, so perhaps the O_EXCL multiple-open logic bro=
ke
>> >recently?
>> >
>> >Complete dmesg, kconfig, and so on at
>> >
>> >http://web.hexapodia.org/~adi/sysinfo/1242164411_cvpe4300_2.6.30-rc=
5-dmar-00096-ga4d7749/
>>
>> I'm not sure how this is supposed to work. The only place I can see =
any
>> O_EXCL handling is in the sg driver. But if you access the sr device
>> directly, it doesn't seem like that would have any effect.
>>
>> CCing linux-scsi. Could be there's a bad user-space assumption here,=
 or
>> something.
>
> Perhaps, I haven't tracked down exactly what the difference in behavi=
or
> between working 2.6.29 and broken 2.6.30-rc2 is. =A0It seems like the=
 disk
> spins up more often (in response to hal background probes presumably)
> with 30-rc2 than it did before, and running "udevadm monitor" I do se=
e
> the following repeated "change" events happening, even on an idle
> system:
>
> KERNEL[1242175547.793029] change =A0 /devices/pci0000:00/0000:00:1f.2=
/host1/target1:0:0/1:0:0:0 (scsi)
> KERNEL[1242175547.794669] change =A0 /devices/pci0000:00/0000:00:1f.2=
/host1/target1:0:0/1:0:0:0/block/sr0 (block)
> UDEV =A0[1242175547.794912] change =A0 /devices/pci0000:00/0000:00:1f=
=2E2/host1/target1:0:0/1:0:0:0 (scsi)
> UDEV =A0[1242175547.888539] change =A0 /devices/pci0000:00/0000:00:1f=
=2E2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
> KERNEL[1242175673.309129] change =A0 /devices/pci0000:00/0000:00:1f.2=
/host1/target1:0:0/1:0:0:0 (scsi)
> KERNEL[1242175673.310775] change =A0 /devices/pci0000:00/0000:00:1f.2=
/host1/target1:0:0/1:0:0:0/block/sr0 (block)
> UDEV =A0[1242175673.311013] change =A0 /devices/pci0000:00/0000:00:1f=
=2E2/host1/target1:0:0/1:0:0:0 (scsi)
> UDEV =A0[1242175674.658718] change =A0 /devices/pci0000:00/0000:00:1f=
=2E2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
> KERNEL[1242175690.227604] change =A0 /devices/pci0000:00/0000:00:1f.2=
/host1/target1:0:0/1:0:0:0 (scsi)
> KERNEL[1242175690.229730] change =A0 /devices/pci0000:00/0000:00:1f.2=
/host1/target1:0:0/1:0:0:0/block/sr0 (block)
> UDEV =A0[1242175690.229960] change =A0 /devices/pci0000:00/0000:00:1f=
=2E2/host1/target1:0:0/1:0:0:0 (scsi)
> UDEV =A0[1242175714.060440] change =A0 /devices/pci0000:00/0000:00:1f=
=2E2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
> KERNEL[1242175727.909819] change =A0 /devices/pci0000:00/0000:00:1f.2=
/host1/target1:0:0/1:0:0:0 (scsi)
> KERNEL[1242175727.911356] change =A0 /devices/pci0000:00/0000:00:1f.2=
/host1/target1:0:0/1:0:0:0/block/sr0 (block)
> UDEV =A0[1242175727.911690] change =A0 /devices/pci0000:00/0000:00:1f=
=2E2/host1/target1:0:0/1:0:0:0 (scsi)
> UDEV =A0[1242175727.987747] change =A0 /devices/pci0000:00/0000:00:1f=
=2E2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
> KERNEL[1242175731.591853] change =A0 /devices/pci0000:00/0000:00:1f.2=
/host1/target1:0:0/1:0:0:0 (scsi)
> KERNEL[1242175731.593541] change =A0 /devices/pci0000:00/0000:00:1f.2=
/host1/target1:0:0/1:0:0:0/block/sr0 (block)
>
> I've verified that O_EXCL works at least with a trivial test program,=
 so
> it's not simply that EXCL broke.
>
> Also I've verified with strace that hald-addon-storage and wodim are
> both using O_EXCL, and that hald-addon-storage gets EBUSY while wodim=
 is
> writing the disk. =A0(The straced run didn't fail, unfortunately.)

Those events seem rather suspicious. Hmm:

[    2.770959] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-U633A, D200, max
UDMA/100, ATAPI AN

Did libata report it was using ATAPI AN in 2.6.29?

You could try bisecting to see if you can find which patch started
triggering those spurious events..
