From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc4-mm1
Date: Fri, 14 Sep 2007 13:15:24 -0700
Message-ID: <20070914131524.874c8db7.akpm@linux-foundation.org>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<20070910174926.GC30335@shadowen.org>
	<20070910111926.9c942358.akpm@linux-foundation.org>
	<20070910044323T.tomof@acm.org>
	<20070914081018.GA20042@shadowen.org>
	<64bb37e0709140601te21f5d0l9871ea03dbf4b135@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <64bb37e0709140601te21f5d0l9871ea03dbf4b135@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Andy Whitcroft <apw@shadowen.org>, FUJITA Tomonori <tomof@acm.org>, linux-kernel@vger.kernel.org, mel@csn.ul.ie, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 14 Sep 2007 15:01:03 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> On 9/14/07, Andy Whitcroft <apw@shadowen.org> wrote:
> > On Tue, Sep 11, 2007 at 04:31:12AM +0900, FUJITA Tomonori wrote:
> > [...]
> > >
> > > Even if we revert the qla1280 patch, scsi-ml still sends chaining sg
> > > list. So it doesn't work.
> > >
> > > The following patch disables chaining sg list for qla1280. If the fix
> > > that I've just sent doesn't work, please try this.
> >
> > Ok, the other patch _did_ work, but this got tested anyhow and it did
> > _not_ fix things.
> >
> 
> Sorry to confirm this. My RAID5 got destroyed a second time.
> To summarize what worked / not worked / and seems to work for me:
> 
> First 2 tries with unpatched rc4-mm1: Both times one sata_sil24-drive got kicked
> Then I switched back to rc3-mm1, 18 boots with that kernel worked.
> Then I tried the patched rc4-mm1 and it worked too.
> The next boot also worked, but the third time kicked a drive out again.
> But as nobody reads logs, I did not notice that and keep using the
> patched rc4-mm1.
> The next 5 times the system worked normally with the two remaining drives.
> The sixth boot kicked the second sata_sil24 drive. That I did notice...
> After reassembling the RAID, I'm now back to the patch rc4-mm1 that
> did boot correctly this time.
> So the patch just makes it unlikelier to hit the bug. Instead of
> failing 2 out of 2 times, it only failed 2 out of 8 times.
> I compared the rc4-mm1 boot from a working case and the case where it
> kicked the first drive. Nothing seems to stand out...
> 
> < == good rc4-mm1 boot
> > == bad rc4-mm1 boot that kicked the drive
> 
> 145c145
> < CPU 0: aperture @ 4000000 size 32 MB
> ---
> > CPU 0: aperture @ b7f0000000 size 32 MB
> 154c154
> < Calibrating delay using timer specific routine.. 5203.23 BogoMIPS
> (lpj=26016160)
> ---
> > Calibrating delay using timer specific routine.. 5203.22 BogoMIPS (lpj=26016138)
> 169c169
> < APIC timer calibration result 12499998
> ---
> > APIC timer calibration result 12499994
> 173c173
> < Calibrating delay using timer specific routine.. 5222.40 BogoMIPS
> (lpj=26112010)
> ---
> > Calibrating delay using timer specific routine.. 5200.01 BogoMIPS (lpj=26000052)
> 182c182
> < Calibrating delay using timer specific routine.. 5222.73 BogoMIPS
> (lpj=26113694)
> ---
> > Calibrating delay using timer specific routine.. 5200.01 BogoMIPS (lpj=26000081)
> 191c191
> < Calibrating delay using timer specific routine.. 5223.07 BogoMIPS
> (lpj=26115369)
> ---
> > Calibrating delay using timer specific routine.. 5200.03 BogoMIPS (lpj=26000164)
> 269d268
> < Switched to high resolution mode on CPU 3
> 270a270
> > Switched to high resolution mode on CPU 3
> 502,509c502,509
> < raid6: int64x1   2634 MB/s
> < raid6: int64x2   3244 MB/s
> < raid6: int64x4   3405 MB/s
> < raid6: int64x8   2614 MB/s
> < raid6: sse2x1    3607 MB/s
> < raid6: sse2x2    4834 MB/s
> < raid6: sse2x4    4946 MB/s
> < raid6: using algorithm sse2x4 (4946 MB/s)
> ---
> > raid6: int64x1   2680 MB/s
> > raid6: int64x2   3232 MB/s
> > raid6: int64x4   3411 MB/s
> > raid6: int64x8   2620 MB/s
> > raid6: sse2x1    3606 MB/s
> > raid6: sse2x2    4810 MB/s
> > raid6: sse2x4    4910 MB/s
> > raid6: using algorithm sse2x4 (4910 MB/s)
> 567c567
> < md1: bitmap initialized from disk: read 10/10 pages, set 96 bits
> ---
> > md1: bitmap initialized from disk: read 10/10 pages, set 104 bits
> 568a569,655
> > ata1.00: exception Emask 0x20 SAct 0x1 SErr 0x0 action 0x2
> > ata1.00: irq_stat 0x00020002, PCI master abort while fetching SGT
> > ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
> >          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x20 (host bus error)
> > ata1.00: status: {DRDY }
> > ata1: soft resetting link
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: configured for UDMA/100
> > ata1: EH complete
> > sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > ata1.00: exception Emask 0x20 SAct 0x1 SErr 0x0 action 0x2
> > ata1.00: irq_stat 0x00020002, PCI master abort while fetching SGT
> > ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
> >          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x20 (host bus error)
> > ata1.00: status: {DRDY }
> > ata1: soft resetting link
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: configured for UDMA/100
> > ata1: EH complete
> > sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > ata1.00: exception Emask 0x20 SAct 0x1 SErr 0x0 action 0x2
> > ata1.00: irq_stat 0x00020002, PCI master abort while fetching SGT
> > ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
> >          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x20 (host bus error)
> > ata1.00: status: {DRDY }
> > ata1: soft resetting link
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: configured for UDMA/100
> > ata1: EH complete
> > sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > ata1.00: exception Emask 0x20 SAct 0x1 SErr 0x0 action 0x2
> > ata1.00: irq_stat 0x00020002, PCI master abort while fetching SGT
> > ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
> >          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x20 (host bus error)
> > ata1.00: status: {DRDY }
> > ata1: soft resetting link
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: configured for UDMA/100
> > ata1: EH complete
> > sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > ata1.00: exception Emask 0x20 SAct 0x1 SErr 0x0 action 0x2
> > ata1.00: irq_stat 0x00020002, PCI master abort while fetching SGT
> > ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
> >          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x20 (host bus error)
> > ata1.00: status: {DRDY }
> > ata1: soft resetting link
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: configured for UDMA/100
> > ata1: EH complete
> > sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > ata1.00: exception Emask 0x20 SAct 0x1 SErr 0x0 action 0x2
> > ata1.00: irq_stat 0x00020002, PCI master abort while fetching SGT
> > ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
> >          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x20 (host bus error)
> > ata1.00: status: {DRDY }
> > ata1: soft resetting link
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: configured for UDMA/100
> > sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> > sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
> > Descriptor sense data with sense descriptors (in hex):
> >         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
> >         00 00 00 af
> > sd 0:0:0:0: [sda] Add. Sense: No additional sense information
> > end_request: I/O error, dev sda, sector 625137161

So do we think it's a sata regression?

> > ata1: EH complete
> > sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > md: super_written gets error=-5, uptodate=0
> > raid5: Disk failure on sda2, disabling device. Operation continuing on 2 devices
> 571a659,663
> > RAID5 conf printout:
> >  --- rd:3 wd:2
> >  disk 0, o:0, dev:sda2
> >  disk 1, o:1, dev:sdb2
> >  disk 2, o:1, dev:sdc2
> 576a669,672
> > RAID5 conf printout:
> >  --- rd:3 wd:2
> >  disk 1, o:1, dev:sdb2
> >  disk 2, o:1, dev:sdc2
> 
> Another good boot also showed the aperture at a similar high address:
> CPU 0: aperture @ b7f2000000 size 32 MB
> And that good boot also showed the "correct" BogoMIPS:
> Calibrating delay using timer specific routine.. 5205.43 BogoMIPS (lpj=26027183)
> Calibrating delay using timer specific routine.. 5200.01 BogoMIPS (lpj=26000052)
> Calibrating delay using timer specific routine.. 5200.01 BogoMIPS (lpj=26000082)
> Calibrating delay using timer specific routine.. 5200.03 BogoMIPS (lpj=26000166)
> 
> Anything more I can provide to help debugging this?
> 

Let's keep linux-ide cc'ed, please.
