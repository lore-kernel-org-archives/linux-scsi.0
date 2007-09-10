From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc4-mm1
Date: Mon, 10 Sep 2007 12:20:38 -0700
Message-ID: <20070910122038.1f1bb006.akpm@linux-foundation.org>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<20070910174926.GC30335@shadowen.org>
	<20070910111926.9c942358.akpm@linux-foundation.org>
	<64bb37e0709101159v47f586aby7f078ef1db5cbc39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933359AbXIJTWa@vger.kernel.org>
In-Reply-To: <64bb37e0709101159v47f586aby7f078ef1db5cbc39@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org, mel@csn.ul.ie, Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 10 Sep 2007 20:59:49 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> On 9/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 10 Sep 2007 18:49:26 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> >
> > > I have a couple of old NUMA-Q systems which are unable to read their
> > > boot disks with 2.6.23-rc4-mm1.  The disks appear to be recognised and
> > > even the partition tables read correctly, and then they go pop:
> 
> I reported a similar problem on Sep 1, but until now got no response.

You still haven't had a response ;)  Let's add a cc.

Oh, you reported it against 2.6.23-rc4-mm1
(http://lkml.org/lkml/2007/9/1/92) and I did cc linux-ide in my response.

I'll continue to point out where this sort of thing occurs because last
week I was told that a reson why so many bug reports are ignored is because
"linux-kernel has too much traffic".

> The system boots, reads the partition tables, starts the RAID and then
> kicks one drive out because of errors.

Andy is using qla1280.  You're using sata.  So it's probably a different
bug, with the same symptoms.

> > >   qla1280: QLA1040 found on PCI bus 0, dev 10
> > >   Clocksource tsc unstable (delta = 99922590 ns)
> > >   Time: jiffies clocksource has been installed.
> > >   scsi(0:0): Resetting SCSI BUS
> > >   scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
> > >          Firmware version:  7.65.06, Driver version 3.26
> > >   scsi 0:0:0:0: Direct-Access     IBM      DGHS18X          0360 PQ: 0 ANSI: 3
> > >   scsi(0:0:0:0): Sync: period 10, offset 12, Wide
> > >   scsi 0:0:1:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
> > >   scsi(0:0:1:0): Sync: period 10, offset 12, Wide
> > >   scsi 0:0:2:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
> > >   scsi(0:0:2:0): Sync: period 10, offset 12, Wide
> > >   scsi 0:0:3:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
> > >   scsi(0:0:3:0): Sync: period 10, offset 12, Wide
> > >   scsi 0:0:4:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
> > >   scsi(0:0:4:0): Sync: period 10, offset 12, Wide
> > >   st: Version 20070203, fixed bufsize 32768, s/g segs 256
> > >   sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
> > >   sd 0:0:0:0: [sda] Write Protect is off
> > >   sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
> > >   sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
> > >   sd 0:0:0:0: [sda] Write Protect is off
> > >   sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
> > >    sda: sda1
> [snip]
> > >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> > >   end_request: I/O error, dev sda, sector 63
> > >   Buffer I/O error on device sda1, logical block 0
> > >   Buffer I/O error on device sda1, logical block 1
> > >   Buffer I/O error on device sda1, logical block 2
> > >   Buffer I/O error on device sda1, logical block 3
> > >   mount: fs type devfs not supported by kernel
> > >   ext3: No journal on filesystem on sda1
> > >   umount: devfs: not mounted
> > >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> > >   end_request: I/O error, dev sda, sector 28010831
> > >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> > >   end_request: I/O error, dev sda, sector 31080815
> 
> >From my log:
> [    3.890000] scsi0 : sata_sil24
> [    3.900000] scsi1 : sata_sil24
> [    3.900000] ata1: SATA max UDMA/100 host m128@0xefeffc00 port
> 0xefef8000 irq 16
> [    3.920000] ata2: SATA max UDMA/100 host m128@0xefeffc00 port
> 0xefefa000 irq 16
> [    4.300000] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    4.360000] ata1.00: ATA-7: MAXTOR STM3320820AS, 3.AAE, max UDMA/133
> [    4.370000] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    4.430000] ata1.00: configured for UDMA/100
> [    4.500000] ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0010dc00005cc354]
> [    4.500000] ieee1394: Host added: ID:BUS[0-01:1023]  GUID[0011d80000c4c261]
> [    4.790000] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    4.850000] ata2.00: ATA-7: MAXTOR STM3320820AS, 3.AAE, max UDMA/133
> [    4.860000] ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    4.920000] ata2.00: configured for UDMA/100
> [    4.930000] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR
> STM332082 3.AA PQ: 0 ANSI: 5
> [    4.960000] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> [    4.980000] sd 0:0:0:0: [sda] Write Protect is off
> [    4.990000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    4.990000] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    5.020000] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> [    5.040000] sd 0:0:0:0: [sda] Write Protect is off
> [    5.050000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    5.050000] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    5.080000]  sda: sda1 sda2
> [    5.110000] sd 0:0:0:0: [sda] Attached SCSI disk
> [    5.120000] scsi 1:0:0:0: Direct-Access     ATA      MAXTOR
> STM332082 3.AA PQ: 0 ANSI: 5
> [    5.140000] sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
> [    5.170000] sd 1:0:0:0: [sdb] Write Protect is off
> [    5.180000] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    5.180000] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    5.210000] sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
> [    5.230000] sd 1:0:0:0: [sdb] Write Protect is off
> [    5.240000] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    5.240000] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    5.270000]  sdb: sdb1 sdb2
> [    5.300000] sd 1:0:0:0: [sdb] Attached SCSI disk
> [more normal boot messaged, 3-disk RAID5 starts]
> [   63.420000] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
> [   63.420000] ata2.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0
> cdb 0x0 data 4096 out
> [   63.420000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [   63.420000] ata2.00: status: {DRDY }
> [   63.420000] ata2: hard resetting link
> [   65.720000] ata2: softreset failed (port not ready)
> [   65.720000] ata2: reset failed (errno=-5), retrying in 8 secs
> [   73.420000] ata2: hard resetting link
> [   75.720000] ata2: softreset failed (port not ready)
> [   75.720000] ata2: reset failed (errno=-5), retrying in 8 secs
> [   83.420000] ata2: hard resetting link
> [   85.720000] ata2: softreset failed (port not ready)
> [   85.720000] ata2: reset failed (errno=-5), retrying in 33 secs
> [snip, disk gets kicked]
> [  120.780000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK,SUGGEST_OK
> [  120.780000] end_request: I/O error, dev sdb, sector 19550927
> [  120.780000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK,SUGGEST_OK
> [  120.780000] end_request: I/O error, dev sdb, sector 19550935
> [  120.780000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK,SUGGEST_OK
> [  120.780000] end_request: I/O error, dev sdb, sector 19550943
> [  120.780000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK,SUGGEST_OK
> 
> More similar error messages in the old my LKML-mail.
> 
> After sdb was removed from the array the system worked normal with
> only two drives.
> But on the next boot it kicked the second sata_sil24 disk from the
> array killing it.

Can you please confirm that this bug is present in -mm and not present in
mainline (yet)?

Thanks.
