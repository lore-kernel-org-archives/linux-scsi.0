From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: kernel BUG in drivers/scsi/53c700.c:1129
Date: Thu, 09 Jun 2016 15:23:22 -0700
Message-ID: <1465511002.2259.19.camel@HansenPartnership.com>
References: <5759C524.2030009@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <5759C524.2030009@gmx.de>
Sender: linux-parisc-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-06-09 at 21:36 +0200, Helge Deller wrote:
> Hi James,
> 
> I just tried Debian kernel 4.6.1-1 on my historic 715/64 machine, and it
> ran into this  BUG() in the LASI scsi driver:
> 
>  scsi 0:0:6:0: no saved request for untagged cmd
> 
> Any idea?
> 
> Helge
>  
> [    0.000000] Linux version 4.6.0-1-parisc (debian-kernel@lists.debian.org) (gcc version 5.4.0 20160603 (Debian 5.4.0-3) ) #1 Debian 4.6.1-1 (2016-06-06)
> ...
> [    0.000000] Determining PDC firmware type: Snake.
> [    0.000000] model 000060a0 00000481 00000000 00000000 773c7d2c 00000000 00000004 00000072 00000072
> [    0.000000] vers  0000000c
> [    0.000000] model 9000/715
> [    0.000000] Total Memory: 160 MB
> ...
> [   43.180000] SCSI subsystem initialized
> [   45.076000] 53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
> [   45.156000] scsi0: 53c710 rev 2 
> [   46.204000] scsi host0: LASI SCSI 53c700
> [   58.268000] scsi 0:0:6:0: no saved request for untagged cmd
> [   58.336000] ------------[ cut here ]------------
> [   58.392000] kernel BUG at /build/linux-XAODSw/linux-4.6.1/drivers/scsi/53c700.c:1129!
> [   58.484000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.6.0-1-parisc #1 Debian 4.6.1-1
> [   58.580000] task: 1083cdd8 ti: 107b1000 task.ti: 107b1000
> [   58.644000] 
> [   58.660000]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
> [   58.716000] PSW: 00000000000001001111111100001110 Not tainted
> [   58.788000] r00-03  0004ff0e 0084e388 00a8ea8c 107ba400
> [   58.848000] r04-07  00000000 00000000 15b88cc0 00000006
> [   58.912000] r08-11  198ca400 000000ff 00000020 00000000
> [   58.976000] r12-15  000000ff 00001003 10801020 00000001
> [   59.036000] r16-19  107b1240 00000002 000000ff 00000001
> [   59.100000] r20-23  00000001 0000000e 0084f388 00000000
> [   59.164000] r24-27  107ba500 0083b540 1021a7a4 107b5020
> [   59.224000] r28-31  00000000 00000040 107ba480 104d52bc
> [   59.288000] sr00-03  00000000 00000000 00000000 0000000d
> [   59.352000] sr04-07  00000000 00000000 00000000 00000000
> [   59.416000] 
> [   59.432000] IASQ: 00000000 00000000 IAOQ: 00a8ea8c 00a8ea90
> [   59.500000]  IIR: 03ffe01f    ISR: 0000000d  IOR: 00a8ea90
> [   59.564000]  CPU:        0   CR30: 107b1000 CR31: f00effff
> [   59.632000]  ORIG_R28: 10855e80
> [   59.668000]  IAOQ[0]: process_script_interrupt+0x13ec/0x16a4 [53c700]
> [   59.748000]  IAOQ[1]: process_script_interrupt+0x13f0/0x16a4 [53c700]
> [   59.824000]  RP(r2): process_script_interrupt+0x13ec/0x16a4 [53c700]
> [   59.900000] Backtrace:
> [   59.928000]  [<00a8ea8c>] process_script_interrupt+0x13ec/0x16a4 [53c700]
> [   60.012000] 
> [   60.028000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.6.0-1-parisc #1 Debian 4.6.1-1
> [   60.120000] Backtrace:
> [   60.148000]  [<1015bffc>] show_stack+0x3c/0x50
> [   60.204000]  [<10425d40>] dump_stack+0x28/0x38
> [   60.256000]  [<1015c180>] die_if_kernel+0x134/0x20c
> [   60.316000]  [<1015cd34>] handle_interruption+0x804/0x828
> [   60.380000] 
> [   60.400000] Kernel panic - not syncing: Fatal exception in interrupt
> [   60.400000] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

It looks like either an unsolicited reselection or possibly a spurious
interrupt left over from something.  Can you define NCR_700_DEBUG in
drivers/scsi/53c700.h and see what it says?

Thanks,

James


