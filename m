From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Tue, 24 Aug 2004 14:39:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408242139.i7OLd1jE003353@bach.leonora.org>
References: <20040824205039.GC16196@parcelfarce.linux.theplanet.co.uk>
Reply-To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-052-249.sfo1.dsl.speakeasy.net ([64.81.52.249]:54509
	"EHLO bach.leonora.org") by vger.kernel.org with ESMTP
	id S268332AbUHXVjX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 17:39:23 -0400
In-Reply-To: Your message of "Tue, 24 Aug 2004 21:50:39 BST."
             <20040824205039.GC16196@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Mike Anderson <andmike@us.ibm.com>, Olaf Hering <olh@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

Sorry. The words "mismatch" and "reset" suggest (to me) that a problem
exists, and I'm extra sensitive to SCSI problems because of unresolved
problems like this (at boot):

   smartd[1831]: Opened configuration file /etc/smartd.conf 
   smartd[1831]: Configuration file /etc/smartd.conf parsed. 
   smartd[1831]: Device: /dev/hdc, opened 
   smartd[1831]: Device: /dev/hdc, not found in smartd database. 
   smartd[1831]: Device: /dev/hdc, is SMART capable. Adding to "monitor" list. 
   smartd[1831]: Device: /dev/hdg, opened 
   smartd[1831]: Device: /dev/hdg, not found in smartd database. 
   smartd[1831]: Device: /dev/hdg, is SMART capable. Adding to "monitor" list. 
   smartd[1831]: Device: /dev/sda, opened 
   smartd[1831]: Device: /dev/sda, is SMART capable. Adding to "monitor" list. 
   kernel: sym0:6:0:ODD transfer in DATA IN phase.
   kernel: sym0:6:0:COMMAND FAILED (87 0 10).
   kernel: sym0:6:0:ODD transfer in DATA IN phase.
   kernel: sym0:6:0:COMMAND FAILED (87 0 10).
   kernel: sym0:6:0:ODD transfer in DATA IN phase.
   kernel: sym0:6:0:COMMAND FAILED (87 0 10).
   kernel: sym0:6:0:ODD transfer in DATA IN phase.
   kernel: sym0:6:0:COMMAND FAILED (87 0 10).
   kernel: sym0:6:0:ODD transfer in DATA IN phase.
   kernel: sym0:6:0:COMMAND FAILED (87 0 10).
   smartd[1831]: Monitoring 2 ATA and 1 SCSI devices 
   smartd[1831]: Device: /dev/sda, initial Temperature is 33 degrees 
   smartd[1833]: smartd has fork()ed into background mode. New PID=1833. 
   smartd: smartd startup succeeded

or this (at seemingly random times after booting):

   kernel: sym0:6:0:ordered tag forced.
   last message repeated 4 times
   kernel: sym0:6:0:ordered tag forced.
   last message repeated 3 times
   last message repeated 29 times
   last message repeated 5 times

or this (which causes my system to hang):

   kernel: sym0:6: ERROR (81:0) (8-0-0) (3e/18/80) @ (scripta 38:f31c0004).
   kernel: sym0: script cmd = e21c0004
   kernel: sym0: regdump: da 00 00 18 47 3e 06 0f 04 08 86 00 80 00 0f 0a 72 cf 0c 00 02 00 00 00.
   kernel: sym0: SCSI BUS reset detected.
   kernel: sym0: enabling clock multiplier
   kernel: sym0: Downloading SCSI SCRIPTS.
   kernel: sym0: SCSI BUS has been reset.
   kernel: sym0: command processing suspended for 3 seconds
   kernel: sym0: command processing resumed

(Script cmd = e21c0004 triggers the same error also.)

-- 
Vladimir G. Ivanovic                        http://leonora.org/~vladimir
Palo Alto, CA 94306                                      +1 650 678 8014
>>>>> "mw" == Matthew Wilcox <willy@debian.org> writes:

    mw> 
    mw> On Tue, Aug 24, 2004 at 01:48:55PM -0700, Vladimir G. Ivanovic wrote:
    >> I don't know what an ACARD is, but I have similar issues when I boot my
    >> SMP system (ASUS CUV4X-DLS).
    >> 
    >> kernel: VFS: Mounted root (ext2 filesystem).
    >> kernel: SCSI subsystem initialized
    >> kernel: ACPI: PCI interrupt 0000:00:08.0[A] -> GSI 19 (level, low) -> IRQ 177
    >> kernel: sym0: <1010-33> rev 0x1 at pci 0000:00:08.0 irq 177
    >> kernel: sym0: using 64 bit DMA addressing
    >> kernel: sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
    >> kernel: sym0: open drain IRQ line driver, using on-chip SRAM
    >> kernel: sym0: using LOAD/STORE-based firmware.
    >> kernel: sym0: handling phase mismatch from SCRIPTS.
    >> kernel: sym0: SCSI BUS has been reset.
    >> kernel: scsi0 : sym-2.1.18j
    >> kernel:   Vendor: QUANTUM   Model: ATLAS10K3_18_WLS  Rev: 020K
    >> kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
    >> kernel: sym0:6:0: tagged command queuing enabled, command queue depth 16.
    >> kernel: scsi(0:0:6:0): Beginning Domain Validation
    >> kernel: sym0:6: wide asynchronous.
    >> kernel: sym0:6: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
    >> kernel: scsi(0:0:6:0): Ending Domain Validation
    >> kernel: SCSI device sda: 35916548 512-byte hdwr sectors (18389 MB)
    >> kernel: SCSI device sda: drive cache: write back
    >> kernel:  sda: sda1 sda2 sda3 sda4
    >> kernel: Attached scsi disk sda at scsi0, channel 0, id 6, lun 0
    >> kernel: ACPI: PCI interrupt 0000:00:08.1[B] -> GSI 16 (level, low) -> IRQ 185
    mw> 
    mw> Erm, I see no sign of any problem in this log.  You negotiated to 160MB/s.
    mw> 
    mw> -- 
    mw> "Next the statesmen will invent cheap lies, putting the blame upon 
    mw> the nation that is attacked, and every man will be glad of those
    mw> conscience-soothing falsities, and will diligently study them, and refuse
    mw> to examine any refutations of them; and thus he will by and by convince 
    mw> himself that the war is just, and will thank God for the better sleep 
    mw> he enjoys after this process of grotesque self-deception." -- Mark Twain
    mw> -
    mw> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
    mw> the body of a message to majordomo@vger.kernel.org
    mw> More majordomo info at  http://vger.kernel.org/majordomo-info.html
