From: Anton Blanchard <anton@samba.org>
Subject: Re: sym2 oops in 2.6.9-rc2-BK
Date: Fri, 1 Oct 2004 00:05:31 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040930140531.GC3167@krispykreme.ozlabs.ibm.com>
References: <20040928135826.GA3373@krispykreme.ozlabs.ibm.com> <1096385921.2008.21.camel@mulgrave> <20040930130518.GB3167@krispykreme.ozlabs.ibm.com> <1096552371.2062.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:51668 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S269280AbUI3OKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 10:10:32 -0400
Content-Disposition: inline
In-Reply-To: <1096552371.2062.11.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

 
> Erm, because I didn't notice it and forgot to remove it when I revamped
> the negotiation routines...

OK, I backed that last patch out and hit what looks to be my bug 2 again.

Anton

sym0: <1010-66> rev 0x1 at pci 0004:03:01.0 irq 87
sym.0004:03:01.0: No NVRAM, ID 7, Fast-80, LVD, parity checking
xics_enable_irq 47 buid 4 gqirm 255
sym.0004:03:01.0: SCSI BUS has been reset.
scsi0 : sym-2.1.18j
Using anticipatory io scheduler
sym.0004:03:01.0:10: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S25M
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym.0004:03:01.0:10:0: tagged command queuing enabled, command queue depth 16.
scsi(0:0:10:0): Beginning Domain Validation
sym.0004:03:01.0:10: asynchronous.
sym.0004:03:01.0:10: wide asynchronous.
sym.0004:03:01.0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(0:0:10:0): Ending Domain Validation
sym.0004:03:01.0:11:0:phase change 2-7 6@01050368 resid=5.
sym.0004:03:01.0:11:0:phase change 2-3 6@01050368 resid=5.
sym.0004:03:01.0:11: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
sym.0004:03:01.0:11:control msgout: c.
sym.0004:03:01.0: TARGET 11 has been reset.
sym.0004:03:01.0:11:0: ABORT operation started.
sym.0004:03:01.0:11:0: ABORT operation complete.
sym.0004:03:01.0:11:0: DEVICE RESET operation started.
sym.0004:03:01.0:11:0: DEVICE RESET operation complete.
sym.0004:03:01.0:11:control msgout: c.
sym.0004:03:01.0: TARGET 11 has been reset.
sym.0004:03:01.0:11:0: ABORT operation started.
sym.0004:03:01.0:11:0: ABORT operation complete.
sym.0004:03:01.0:11:0: BUS RESET operation started.
sym.0004:03:01.0:11:0: BUS RESET operation complete.
sym.0004:03:01.0: SCSI BUS reset detected.
sym.0004:03:01.0: SCSI BUS has been reset.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 11 lun 0

NIP: C000000000294C48 XER: 0000000020000000 LR: C000000000294E30
REGS: c000001dfd0e7a40 TRAP: 0300   Not tainted  (2.6.9-rc2-bml)
MSR: 9000000000001032 EE: 0 PR: 0 FP: 0 ME: 1 IR/DR: 11
DAR: 0000000000100510, DSISR: 0000000040000000
TASK: c000000ffe73b240[1463] 'scsi_eh_0' THREAD: c000001dfd0e4000 CPU: 3
GPR00: FFFFFFFFFFFFFFFA C000001DFD0E7CC0 C0000000007297B8 00000000001000F0
GPR04: C0000032FC834000 0000000000000001 0000000000000000 0000000000000000
GPR08: 0000000000000000 0000000000100100 C000000FFFFD7228 9000000000009032
GPR12: 0000000024FFFF22 C000000000542700 0000000000000000 0000000000000000
GPR16: 0000000000000000 C00000000040D190 C000000000587058 C000001DFD0E7ED0
GPR20: 00000000000000FC C00000000040D190 C000000000587058 C000001DFD0E7F00
GPR24: C000001DFD0E7EF0 0000040100000000 C000001DFD077D30 C0000032FC834000
GPR28: 9000000000009032 C000000FFFFC3800 00000000001002D8 00000000001000F0
NIP [c000000000294c48] .scsi_device_get+0x20/0xe4
LR [c000000000294e30] .__scsi_iterate_devices+0x60/0xfc
Call Trace:
[c000001dfd0e7cc0] [c000000000294da8] .scsi_device_put+0x9c/0xc4 (unreliable)
[c000001dfd0e7d40] [c000000000294e30] .__scsi_iterate_devices+0x60/0xfc
[c000001dfd0e7de0] [c000000000299bf8] .scsi_run_host_queues+0x34/0x58
[c000001dfd0e7e60] [c0000000002989f8] .scsi_error_handler+0x268/0xaa0
[c000001dfd0e7f90] [c000000000017aac] .kernel_thread+0x4c/0x68
