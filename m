From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Fri, 31 Dec 2004 14:53:06 +0000
Message-ID: <20041231145306.GB18080@parcelfarce.linux.theplanet.co.uk>
References: <200412311343.42484.peter.missel@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:22197 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262085AbULaOxM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2004 09:53:12 -0500
Content-Disposition: inline
In-Reply-To: <200412311343.42484.peter.missel@onlinehome.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Missel <peter.missel@onlinehome.de>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Fri, Dec 31, 2004 at 01:43:42PM +0100, Peter Missel wrote:
> Hello Matthew!
> 
> I hope I'm turning to the right person with my report.

Yep, that's me.  Best to keep linux-scsi in the loop too.  That way
other people prod me when I've been inattentive ;-)

> After updating to SuSE 
> Linux 9.2, kernel 2.6.8, which brought rev. 2.1.18j of the LSI SCSI driver, I 
> see that the driver's speed/width negotiation no longer considers any 
> limitations configured in the adapter's BIOS. My previous installation, using 
> kernel 2.4.20 and its included LSI SCSI driver, did that perfectly fine.

Yes, that's right.  I'm not a big fan of dealing with distro kernels
because they make changes without informing me.  An earlier SuSE kernel
commented out the domain validation calls from the sym2 driver -- without
putting the previous code back in.  However, that problem doesn't seem to
be present in this kernel.

> For example (and that's why I noticed), if in SCSI BIOS a certain SCSI channel 
> (or a single device) has been limited by the user to 10 MT/s, the Linux SCSI 
> driver nonetheless negotiates to 20 MT/s.
> 
> It is necessary to stick to the settings from BIOS (as read from EEPROM), 
> simply because there might be a good reason why the user did that. In my 
> particular case, I need to restrict the sym0 channel from doing Ultra (20 
> MT/s) altogether because the total cable length doesn't allow me to,

The Domain Validation code is supposed to catch problems like this, and
automatically fall back to a setting that works without requiring the
user to set magic bits in their NVRAM.  Are you actually experiencing
problems due to the faster speed, or is it just that you know the cable
is out of spec?

Hm, I see we skip the write tests, presumably because the drive doesn't
support a write buffer.  Drat.

> and I 
> have one device restricted further to 5 MT/s because I own a buggy Fujitsu MO 
> that claims 10 MT/s capability but (according to Fujitsu's support answer 
> back when I bought it) has a SCSI interface chip on that can't actually do 
> that.

Buggy drive firmware keeps on biting us ;-(  It does seem worth honouring
the NVRAM settings, but the thing is that we then have to support such
fixes in each driver.

> Below please see a snippet from /var/log/boot.msg; the external branch 
> (including the MO) is disconnected so I can use the system at all. You can 
> still see from dev 0.0.1.0 that 20 MT/s are being set up although the 
> adapter's EEPROM settings mandate a maximum of 10 MT/s for the entire sym0 
> channel. Also, in line 5 of the snippet, you see the sym0 host is being 
> logged as "Fast-40 SE" which should read lower. The "SCAN AT BOOT" parameter 
> from the same EEPROM is read correctly.
> 
> Being a system BIOS developper, I have the means to do an EEPROM dump of my 
> SCSI adapter. So in case this is helpful to you, I'll do that as soon as I'm 
> back to work on Jan 10.

I don't need you to do that -- I know the ability has been removed from the
driver.  I bet I can put it back without disturbing things too much.

> <5>SCSI subsystem initialized
> <6>ACPI: PCI interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 169
> <6>sym0: <896> rev 0x5 at pci 0000:00:0a.0 irq 169
> <6>sym0: using 64 bit DMA addressing
> <4>sym0: Symbios NVRAM, ID 7, Fast-40, SE, parity checking
> <4>sym0: SCAN AT BOOT disabled for targets 2 3 8 9 10 11 12 13 14 15.
> <5>sym0: SCSI BUS has been reset.
> <6>scsi0 : sym-2.1.18j
> <5>  Vendor: NAKAMICH  Model: MJ-5.16S          Rev: 1.02
> <5>  Type:   CD-ROM                             ANSI SCSI revision: 02
> <6>scsi(0:0:0:0): Beginning Domain Validation
> <6>sym0:0: FAST-10 SCSI 10.0 MB/s ST (100.0 ns, offset 15)
> <6>scsi(0:0:0:0): Domain Validation skipping write tests
> <6>scsi(0:0:0:0): Ending Domain Validation
> <5>  Vendor: NAKAMICH  Model: MJ-5.16S          Rev: 1.02
> <5>  Type:   CD-ROM                             ANSI SCSI revision: 02
> <6>scsi(0:0:0:1): Beginning Domain Validation
> <6>sym0:0: asynchronous.
> <6>sym0:0: FAST-10 SCSI 10.0 MB/s ST (100.0 ns, offset 15)
> <6>scsi(0:0:0:1): Domain Validation skipping write tests
> <6>scsi(0:0:0:1): Ending Domain Validation
> <5>  Vendor: NAKAMICH  Model: MJ-5.16S          Rev: 1.02
> <5>  Type:   CD-ROM                             ANSI SCSI revision: 02
> <6>scsi(0:0:0:2): Beginning Domain Validation
> <6>sym0:0: asynchronous.
> <6>sym0:0: FAST-10 SCSI 10.0 MB/s ST (100.0 ns, offset 15)
> <6>scsi(0:0:0:2): Domain Validation skipping write tests
> <6>scsi(0:0:0:2): Ending Domain Validation
> <5>  Vendor: NAKAMICH  Model: MJ-5.16S          Rev: 1.02
> <5>  Type:   CD-ROM                             ANSI SCSI revision: 02
> <6>scsi(0:0:0:3): Beginning Domain Validation
> <6>sym0:0: asynchronous.
> <6>sym0:0: FAST-10 SCSI 10.0 MB/s ST (100.0 ns, offset 15)
> <6>scsi(0:0:0:3): Domain Validation skipping write tests
> <6>scsi(0:0:0:3): Ending Domain Validation
> <5>  Vendor: NAKAMICH  Model: MJ-5.16S          Rev: 1.02
> <5>  Type:   CD-ROM                             ANSI SCSI revision: 02
> <6>scsi(0:0:0:4): Beginning Domain Validation
> <6>sym0:0: asynchronous.
> <6>sym0:0: FAST-10 SCSI 10.0 MB/s ST (100.0 ns, offset 15)
> <6>scsi(0:0:0:4): Domain Validation skipping write tests
> <6>scsi(0:0:0:4): Ending Domain Validation
> <5>  Vendor: YAMAHA    Model: CRW2100S          Rev: 1.0N
> <5>  Type:   CD-ROM                             ANSI SCSI revision: 02
> <6>scsi(0:0:1:0): Beginning Domain Validation
> <6>sym0:1: FAST-20 SCSI 20.0 MB/s ST (50.0 ns, offset 7)
> <6>scsi(0:0:1:0): Domain Validation skipping write tests
> <6>scsi(0:0:1:0): Ending Domain Validation
> <5>  Vendor: OnStream  Model: SC-30             Rev: 1.09
> <5>  Type:   Sequential-Access                  ANSI SCSI revision: 02
> <6>scsi(0:0:4:0): Beginning Domain Validation
> <6>sym0:4: FAST-10 SCSI 10.0 MB/s ST (100.0 ns, offset 7)
> <6>scsi(0:0:4:0): Domain Validation skipping write tests
> <6>scsi(0:0:4:0): Ending Domain Validation
> <6>ACPI: PCI interrupt 0000:00:0a.1[B] -> GSI 19 (level, low) -> IRQ 209
> <6>sym1: <896> rev 0x5 at pci 0000:00:0a.1 irq 209
> <6>sym1: using 64 bit DMA addressing
> <4>sym1: Symbios NVRAM, ID 7, Fast-40, LVD, parity checking
> <4>sym1: SCAN AT BOOT disabled for targets 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
> <5>sym1: SCSI BUS has been reset.
> <6>scsi1 : sym-2.1.18j
> <5>  Vendor: QUANTUM   Model: ATLAS IV 9 WLS    Rev: 0909
> <5>  Type:   Direct-Access                      ANSI SCSI revision: 03
> <6>sym1:0:0: tagged command queuing enabled, command queue depth 16.
> <6>scsi(1:0:0:0): Beginning Domain Validation
> <6>sym1:0: wide asynchronous.
> <6>sym1:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
> <6>scsi(1:0:0:0): Domain Validation skipping write tests
> <6>scsi(1:0:0:0): Ending Domain Validation
> <5>SCSI device sda: 17942584 512-byte hdwr sectors (9187 MB)
> <5>SCSI device sda: drive cache: write back
> <6> sda: sda1 sda2
> <5>Attached scsi disk sda at scsi1, channel 0, id 0, lun 0

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
