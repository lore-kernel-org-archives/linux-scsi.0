From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid on Poweredge 2650 ()
Date: Wed, 19 Apr 2006 14:25:03 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F0260926A@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw2.adaptec.com ([216.52.22.42]:55003 "EHLO
	aimspam2.adaptec.com") by vger.kernel.org with ESMTP
	id S1751097AbWDSSZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2006 14:25:04 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian von Bidder <avbidder@fortytwo.ch>, linux-scsi@vger.kernel.org

There is an extensive CHANGELOG, but it is Adaptec centric and not
kernel.org version centric.

The main fix that aided stability for the percraid adapters was waiting
up to 60 seconds for the adapter to catch up and complete commands when
they became reticent (overloaded). This wait was added in the scsi error
recover path (hba reset). By waiting, the adapter could (not always)
recover, before the adapter would be taken offline and hell would break
loose in the Linux Filesystem drivers.

Other issues surfaced as we experimented to improve the performance of
the driver by touching various limits of the adapters (percraid had 34SG
elements, 65KB maximum stripe sizes etc); the later block and scsi
systems aided our ability to enforce these limits long before they hit
the driver. These experiments were primarily performed in our labs, but
we did have some minor fixes that were rushed out post delivery in the
2.6.13 timeframe (2.6.8 was prior to these experiments).

The firmware updates, hardware and drives are primarily responsible for
the stability of the storage system.

There are no changes I know of since 2.6.14 in 1.1-4 that affect
percraid adapters. The new interfaces, performance and feature
enhancements all require modern Adaptec Firmware & Hardware.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Adrian 
> von Bidder
> Sent: Wednesday, April 19, 2006 10:55 AM
> To: linux-scsi@vger.kernel.org
> Subject: aacraid on Poweredge 2650 ()
> 
> 
> Yo!
> 
> Running a Dell Poweredge 2650, I run into a stability problem 
> triggered by 
> lots of disk activity (sometimes just tarring the whole 
> filesystem for 
> backup or creating a new chroot would suffice, sometimes 
> hundreds of GB of 
> filetransfers were necessary)
> 
> This was with Debian stable (2.6.8 kernel), and with what 
> appeared to be a 
> half-buggy disk and a (ecc-correctable) faulty memory.   Now, 
> with replaced 
> hardware and with the 2.6.15 kernel (aac 1.1-4), things seem 
> to be better.  
> (replacing the hardware alone didn't help, so it seemed to be 
> a driver 
> problem.) 
> 
> A quick test, moving a few 100G and a few 1000 files, 
> couldn't reproduce the 
> issue, but still: are there known stability problems with that driver 
> version?  Is there a changelog of the aacraid driver somewhere?
> 
> thanks in advance
> -- vbi
> 
> relevant kernel messages afaict:
> ===
> Adaptec aacraid driver (1.1-4 Mar  7 2006 02:24:50)
> AAC0: kernel 2.7-1[3170]
> AAC0: monitor 2.7-1[3170]
> AAC0: bios 2.7-1[3170]
> AAC0: serial d15810d3
> scsi0 : percraid
>   Vendor: DELL      Model: 3 discs and HS    Rev: V1.0
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> SCSI device sda: 142183296 512-byte hdwr sectors (72798 MB)
> sda: Write Protect is off
> sda: Mode Sense: 03 00 00 00
> sda: got wrong page
> sda: assuming drive cache: write through
> SCSI device sda: 142183296 512-byte hdwr sectors (72798 MB)
> sda: Write Protect is off
> sda: Mode Sense: 03 00 00 00
> sda: got wrong page
> sda: assuming drive cache: write through
>  sda: sda1 sda2 sda3 < sda5 sda6 >
> sd 0:0:0:0: Attached scsi removable disk sda
> ===
> 
> lspci output
> ===
> 0000:04:08.1 RAID bus controller: Dell PowerEdge Expandable 
> RAID Controller 
> 3/Di (rev 01)
>         Subsystem: Dell: Unknown device 0121
>         Flags: bus master, 66MHz, slow devsel, latency 32, IRQ 185
>         Memory at f0000000 (32-bit, prefetchable) [size=128M]
>         Expansion ROM at fcb00000 [disabled] [size=64K]
>         Capabilities: [80] Power Management version 2
> 
> 0000:05:06.0 SCSI storage controller: Adaptec RAID subsystem 
> HBA (rev 01)
>         Subsystem: Dell PowerEdge 2400,2500,2550,4400
>         Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 7
>         BIST result: 00
>         I/O ports at cc00 [size=256]
>         Memory at fccff000 (64-bit, non-prefetchable) [size=4K]
>         Expansion ROM at fcd00000 [disabled] [size=128K]
>         Capabilities: [dc] Power Management version 2
> 
> 0000:05:06.1 SCSI storage controller: Adaptec RAID subsystem 
> HBA (rev 01)
>         Subsystem: Dell PowerEdge 2400,2500,2550,4400
>         Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 11
>         BIST result: 00
>         I/O ports at c800 [size=256]
>         Memory at fccfe000 (64-bit, non-prefetchable) [size=4K]
>         Expansion ROM at f8100000 [disabled] [size=128K]
>         Capabilities: [dc] Power Management version 2
> ===
> 
> -- 
> Life is fraught with opportunities to keep your mouth shut.
> 
