From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [dm-devel] split scsi passthrough fields out of struct request
 V2
Date: Fri, 27 Jan 2017 17:02:05 +0000
Message-ID: <1485536503.4267.3.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485455329.2540.7.camel@sandisk.com>
         <e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
         <1485456745.2540.9.camel@sandisk.com>
         <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
         <20170126185924.GA25289@lst.de>
         <ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
         <71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
         <4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
         <1485464486.2540.12.camel@sandisk.com>
         <6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
         <1485467235.2540.14.camel@sandisk.com>
         <e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
         <1485472465.2540.19.camel@sandisk.com>
         <e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
         <1485474426.2540.25.camel@sandisk.com>
         <b98195e7-6e04-5a59-8b83-ce2e1c5c4e1a@fb.com>
         <1485477510.2540.27.camel@sandisk.com>
         <2d971693-b79d-c1b9-fb2a-f5dd04128c68@fb.com>
         <1485479738.2540.30.camel@sandisk.com>
         <ecca734c-7a9c-f060-9335-c2de089849c2@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ecca734c-7a9c-f060-9335-c2de089849c2@fb.com>
Content-Language: en-US
Content-ID: <6FF42AE3E397534B8126789522636C92@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-01-26 at 18:22 -0700, Jens Axboe wrote:
> What's your boot device? I've been booting this on a variety of setups,
> no problems observed. It's booting my laptop, and on SCSI and SATA as
> well. What is your root drive? What is the queue depth of it?
> Controller?

The boot device in my test setup is a SATA hard disk:

# cat /proc/cmdline =A0
BOOT_IMAGE=3D/boot/vmlinuz-4.10.0-rc5-dbg+ root=3DUUID=3D60a4b064-b3ef-4d28=
-96d3-3c13ecbec43e resume=3D/dev/sda2 showopts
# ls -l /dev/disk/by-uuid/60a4b064-b3ef-4d28-96d3-3c13ecbec43e
lrwxrwxrwx 1 root root 10 Jan 27 08:43 /dev/disk/by-uuid/60a4b064-b3ef-4d28=
-96d3-3c13ecbec43e -> ../../sda1
# cat /sys/block/sda/queue/nr_requests =A0
31
# lsscsi | grep sda
[0:0:0:0] =A0=A0=A0disk =A0=A0=A0ATA =A0=A0=A0=A0=A0ST1000NM0033-9ZM GA67 =
=A0/dev/sda
# hdparm -i /dev/sda

/dev/sda:
=A0Model=3DST1000NM0033-9ZM173, FwRev=3DGA67, SerialNo=3DZ1W2HM75
=A0Config=3D{ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
=A0RawCHS=3D16383/16/63, TrkSize=3D0, SectSize=3D0, ECCbytes=3D0
=A0BuffType=3Dunknown, BuffSize=3Dunknown, MaxMultSect=3D16, MultSect=3Doff
=A0CurCHS=3D16383/16/63, CurSects=3D16514064, LBA=3Dyes, LBAsects=3D1953525=
168
=A0IORDY=3Don/off, tPIO=3D{min:120,w/IORDY:120}, tDMA=3D{min:120,rec:120}
=A0PIO modes: =A0pio0 pio1 pio2 pio3 pio4 =A0
=A0DMA modes: =A0mdma0 mdma1 mdma2 =A0
=A0UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6 =A0
=A0AdvancedPM=3Dno WriteCache=3Ddisabled
=A0Drive conforms to: Unspecified: =A0ATA/ATAPI-4,5,6,7

=A0* signifies the current active mode

Bart.=
