From: "Kai OM" <epimetreus@fastmail.fm>
Subject: Re: SYM53C8XX_2 driver issue - system unbootable
Date: Mon, 28 Jun 2004 16:14:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088453655.3348.199340485@webmail.messagingengine.com>
References: <1088386215.7782.199277656@webmail.messagingengine.com>
   <40E02C86.1010204@jound.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52116 "EHLO
	out2.smtp.messagingengine.com") by vger.kernel.org with ESMTP
	id S265163AbUF1UOQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 16:14:16 -0400
Content-Disposition: inline
In-Reply-To: <40E02C86.1010204@jound.net>
List-Id: linux-scsi@vger.kernel.org
To: Lance Dryden <lance@jound.net>
Cc: linux-scsi@vger.kernel.org

First, it is starting to look like this issue affects 53c1010
controllers in general.

Second, I mistyped part of the log.

Here is the corrected version:

sym0: <1010-33> rev 0x1 at PCI 0000:01:0a.0
sym0: Symbios NVRAM ID7, Fast 80 LVD, Parity Checking
sym0: Open drain IRQ line driver, using on chip SRAM
sym0: Handling phase mismatch from SCRIPTS
sym0: SCAN AT BOOT disabled for targets 0 1 2 3 4 5 6 7 8 9 10 11 12 13
14 15
sym0: SCAN FOR LUNS disabled for targets 0 1 2 3 4 5 6 7 8 9 10 11 12 13
14 15
sym0: SCSI bus has been reset
scsi0: sym-2.1.18j
Vendor: Quantum       Model: ATLAS10K2-TY734J      Rev: DDD6
Type: Direct-access        ANSI SCSI revision: 03
sym0:0:0: Tagged command queue enabled, command queue depth 16
scsi(0:0:0:0): Beginning Domain Validation
sym0:0: Wide asynchronous
sym0:0:0: ABORT operation started
sym0:0:0: ABORT operation timed out
sym0:0:0: DEVICE RESET operation started
sym0:0:0: DEVICE RESET operation timed out
sym0:0:0: BUS RESET operation started
sym0: SCSI BUS reset detected
sym0: SCSI BUS has been reset
sym0:0:0: BUS RESET operation complete
sum0:0:0: ABORT operation started
sum0:0:0: ABORT operation timed out
sym0:0:0: HOST RESET operation started
sym0: SCSI BUS has been reset
[Hangs]



----- Original message -----
From: "Lance Dryden" <lance@jound.net>
To: "Kai OM" <epimetreus@fastmail.fm>
Date: Mon, 28 Jun 2004 10:34:46 -0400
Subject: Re: SYM53C8XX_2 driver issue - system unbootable

Good morning,

I have seen something similar to this.  Any chance there is a line 
missing from your log, something that says "scsi0: Begin Domain 
Validation" or the like?  My "fix" was to stub out domain validation 
code in:

drivers/scsi/scsi_transport_spi.c:~ line 572
	"spi_dv_device_internal(sreq, buffer);"

and keep going.

But, so far only my 53c1010 (Tekram DC390U3W) is affected; I had 
occasion to replace the card with a 53c895 (Tekram DC390U2W) and a stock 
2.6.7 kernel works fine on it.

   Yours, &c,
   Lance Dryden

P.S. If you feel this may be useful to the list (I personally don't, 
but...) feel free to quote parts of it as needed.

Kai OM wrote:

> I sent a mail to the list earlier, but someone helpfully pointed out
> that some of the log info indicated I'd set some bad options in my
> config; that has been corrected, and the issue recreated without those
> options enabled.
> 
> Issue: System hangs during boot.
> Affected kernel versions: 2.6.6, 2.6.7; all earlier kernel versions I
> have tested work fine.
> Workaround in use currently: Replace contents of
> drivers/scsi/sym53c8xx_2 in 2.6.7 with contents of same dir from 2.6.5
> 
> Here's a log(copied by hand, since log never was written to HDD and no
> serial to output data) of what happens when I boot an affected kernel:
> 
> sym0: <1010-33> rev 0x1 at PCI 0000:01:0a.0
> sym0: Symbios NVRAM ID7, Fast 80 LVD, Parity Checking
> sym0: Open drain IRQ line driver, using on chip SRAM
> sym0: Handling phase mismatch from SCRIPTS
> sym0: SCAN AT BOOT disabled for targets 0 1 2 3 4 5 6 7 8 9 10 11 12 13
> 14 15
> sym0: SCAN FOR LUNS disabled for targets 0 1 2 3 4 5 6 7 8 9 10 11 12 13
> 14 15
> sym0: SCSI bus has been reset
> scsi0: sym-2.1.18j
> Vendor: Quantum       Model: ATLAS10K2-TY734J      Rev: DDD6
> Type: Direct-access        ANSI SCSI revision: 03
> sym0:0:0: Tagged command queue enabled, command queue depth 16
> scsi(0:0:0:0): Wide asynchronous
> sym0:0:0: ABORT operation started
> sym0:0:0: ABORT operation timed out
> sym0:0:0: DEVICE RESET operation started
> sym0:0:0: DEVICE RESET operation timed out
> sym0:0:0: BUS RESET operation started
> sym0: SCSI BUS reset detected
> sym0: SCSI BUS has been reset
> sym0:0:0: BUS RESET operation complete
> sum0:0:0: ABORT operation started
> sum0:0:0: ABORT operation timed out
> sym0:0:0: HOST RESET operation started
> sym0: SCSI BUS has been reset
> [Hangs]
> 
> And attached are a normal dmesg from booting with the kernel I compiled,
> after replacing the contents of drivers/scsi/sym53c8xx_2 with the same
> from 2.6.5; also attached is the .config file I used for BOTH of these
> kernels.
> 
> Hopefully somebody here can make more sense of this than I can.
> 
> Thanks in advance.
> 
> 
> ------------------------------------------------------------------------

[snip]
