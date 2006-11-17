From: Sven Rudolph <Sven_Rudolph@drewag.de>
Subject: Re: Atto UL5D: negotiates only up to FAST-40 SCSI
Date: Fri, 17 Nov 2006 17:17:56 +0100
Message-ID: <xfk8xia82tn.fsf@uxrs53.drewag.de>
References: <xfku00y8gjn.fsf@uxrs53.drewag.de>
	<1163777478.8594.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from miranda.drewag.de ([212.111.238.29]:41958 "EHLO
	miranda.drewag.de") by vger.kernel.org with ESMTP id S933694AbWKQQRj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 11:17:39 -0500
In-Reply-To: <1163777478.8594.18.camel@mulgrave.il.steeleye.com> (James
 Bottomley's message of "Fri, 17 Nov 2006 09:31:18 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> writes:

> On Fri, 2006-11-17 at 12:21 +0100, Sven Rudolph wrote:
>>   scsi 1:0:3:0: Direct-Access     SEAGATE  ST3300007LC      7806 PQ: 0
>> ANSI: 3
>>    target1:0:3: Beginning Domain Validation
>>    target1:0:3: Domain Validation skipping write tests
>>    target1:0:3: Ending Domain Validation
>>    target1:0:3: FAST-40 SCSI 40.0 MB/s ST (25 ns, offset 63)
>
> This is characteristic of the bus being in single ended mode, can you
> execute
>
> cat /sys/class/spi_host/host1/signalling
>
> and see what it says.  If it returns SE, that's your problem.

# cat /sys/class/spi_host/host1/signalling 
unknown

Irritating. But this result appears for other hosts/busses too. See
below.


>>   scsi 1:0:8:0: Processor         QLogic   GEM359           1.10 PQ: 0
>> ANSI: 2
>
> This is a very old (circa 2000) processor.  Are you sure your storage
> cage supports LVD?

I think so. It is a Fujitsu-Siemens Primergy SX30, which is the
Ultra320 version of the older S30 (up to Ultra160 only). The manual of
the S30 lists December 2000.

I connected this to a real LSI controller (LSI20320-R):

  0e:06.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)

  0e:06.0 0100: 1000:0030 (rev 08)

dmesg says:

  ACPI: PCI Interrupt 0000:0e:06.0[A] -> GSI 74 (level, low) -> IRQ 20
  mptbase: Initiating ioc2 bringup
  ioc2: 53C1030: Capabilities={Initiator}
  scsi3 : ioc2: LSI53C1030, FwRev=01030f00h, Ports=1, MaxQ=222, IRQ=20
  scsi 3:0:3:0: Direct-Access     SEAGATE  ST3300007LC      7806 PQ: 0 ANSI: 3
   target3:0:3: Beginning Domain Validation
   target3:0:3: Ending Domain Validation
   target3:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
  SCSI device sdl: 585937500 512-byte hdwr sectors (300000 MB)
  sdl: Write Protect is off
  sdl: Mode Sense: ab 00 10 08
  SCSI device sdl: drive cache: write through w/ FUA
  SCSI device sdl: 585937500 512-byte hdwr sectors (300000 MB)
  sdl: Write Protect is off
  sdl: Mode Sense: ab 00 10 08
  SCSI device sdl: drive cache: write through w/ FUA
   sdl: unknown partition table
  sd 3:0:3:0: Attached scsi disk sdl
  scsi 3:0:8:0: Processor         QLogic   GEM359           1.10 PQ: 0 ANSI: 2
   target3:0:8: Beginning Domain Validation
   target3:0:8: Ending Domain Validation
   target3:0:8: asynchronous

FAST-160 is detected when the same cable, storage cage and disk drive
are connected to the LSI controller, but on the Atto only FAST-40
appears. Does it make sense to try another SCSI cable?


# cat /var/log/dmesg| grep "scsi[0123] "
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
scsi1 : ioc0: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=16
scsi2 : ioc1: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=17
scsi3 : ioc2: LSI53C1030, FwRev=01030f00h, Ports=1, MaxQ=222, IRQ=20
# cat /sys/class/spi_host/host*/signalling
LVD
unknown
unknown
unknown
#

(scsi1/scsi2 are the Atto channels, scsi3 is the LSI20320-R.)

Looks like this sysfs entry is only set by aic7xxx, but not by
mptfusion. Or am I missing some kernel config option?

Comparing the dmesg output the difference is that it says on the Atto:

  target1:0:3: Domain Validation skipping write tests

Might this be caused by either different PCI vendor IDs or some
differences in the controller firmware? Perhaps I should try the Atto
Linux driver just to make sure that it can do Ultra320?

	Sven

