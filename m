From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 8469] Bad EIP value on pentium3 SMP kernel-2.6.21.1
Date: Sat, 12 May 2007 23:54:07 -0700
Message-ID: <20070512235407.6bfaf277.akpm@linux-foundation.org>
References: <200705130240.l4D2eEGH018066@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757231AbXEMGyN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2007 02:54:13 -0400
In-Reply-To: <200705130240.l4D2eEGH018066@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rainer Malitzke-Goes <malitzke@metronets.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Sat, 12 May 2007 19:40:14 -0700 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8469

OK, thanks.

Mark, we have a post-2.6.21 oops in aacraid:

> scsi 2:0:5:0: CD-ROM            NEC      CD-ROM DRIVE:466 1.06 PQ: 0 ANSI: 2
>  target2:0:5: Beginning Domain Validation
>  target2:0:5: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
>  target2:0:5: Domain Validation skipping write tests
>  target2:0:5: Ending Domain Validation
> Adaptec aacraid driver (1.1-5[2423]-mh3)
> ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 19 (level, low) -> IRQ 19
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> 00000000
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT SMP 
> Modules linked in:
> CPU:    1
> EIP:    0060:[<00000000>]    Not tainted VLI
> EFLAGS: 00010002   (2.6.21.1c #3)
> EIP is at _stext+0x3fefff50/0x14
> eax: f7fd0000   ebx: 00000202   ecx: 00000001   edx: f7f9db2c
> esi: f7fd0000   edi: f7fd0024   ebp: f7f9db2c   esp: c295fe58
> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Process swapper (pid: 1, ti=c295e000 task=c2949a30 task.ti=c295e000)
> Stack: c0268c79 00000000 00000286 00000058 000002bf 01000202 f7f9db2c c0040020 
>        c0040078 00000016 c02658e7 00000001 ffffffff 00000001 00000000 00000000 
>        00000080 024675a0 c4d9400e 0000005d f7fd0000 f7f9db2c f7f8a530 f7f9d800 
> Call Trace:
>  [<c0268c79>] aac_fib_send+0x120/0x255
>  [<c02658e7>] aac_get_adapter_info+0x74/0x502
>  [<c02643e2>] aac_probe_one+0x220/0x41e
>  [<c02695ac>] aac_command_thread+0x0/0x468
>  [<c01f50ca>] pci_match_device+0x84/0xa4
>  [<c01f5136>] pci_device_probe+0x36/0x57
>  [<c023e2e7>] really_probe+0xbd/0x146
>  [<c023e3b4>] driver_probe_device+0x44/0xa5
>  [<c023e498>] __driver_attach+0x0/0x7f
>  [<c023e4e1>] __driver_attach+0x49/0x7f
>  [<c023d9a0>] bus_for_each_dev+0x33/0x55
>  [<c023e163>] driver_attach+0x16/0x18
>  [<c023e498>] __driver_attach+0x0/0x7f
>  [<c023dc1d>] bus_add_driver+0x5e/0x15f
>  [<c01f52a1>] __pci_register_driver+0x74/0xa0
>  [<c03b0657>] aac_init+0x30/0x66
>  [<c039b7e0>] init+0x143/0x223
>  [<c010254a>] ret_from_fork+0x6/0x1c
>  [<c039b69d>] init+0x0/0x223
>  [<c039b69d>] init+0x0/0x223
>  [<c010323b>] kernel_thread_helper+0x7/0x10
>  =======================
> Code:  Bad EIP value.
> EIP: [<00000000>] _stext+0x3fefff50/0x14 SS:ESP 0068:c295fe58
> Kernel panic - not syncing: Attempted to kill init!
> BUG: at arch/i386/kernel/smp.c:547 smp_call_function()
>  [<c010bac5>] smp_call_function+0x5f/0x107
>  [<c0231179>] do_unblank_screen+0xd/0x102
>  [<c010bb88>] smp_send_stop+0x1b/0x24
>  [<c0117bd5>] panic+0x57/0xea
>  [<c011a38f>] do_exit+0x72/0x6a6
>  [<c0231179>] do_unblank_screen+0xd/0x102
>  [<c0103b19>] die+0x1f4/0x219
>  [<c01111d4>] do_page_fault+0x40c/0x4e8
>  [<c0110dc8>] do_page_fault+0x0/0x4e8
>  [<c02e06dc>] error_code+0x7c/0x84
>  [<c0268c79>] aac_fib_send+0x120/0x255
>  [<c02658e7>] aac_get_adapter_info+0x74/0x502
>  [<c02643e2>] aac_probe_one+0x220/0x41e
>  [<c02695ac>] aac_command_thread+0x0/0x468
>  [<c01f50ca>] pci_match_device+0x84/0xa4
>  [<c01f5136>] pci_device_probe+0x36/0x57
>  [<c023e2e7>] really_probe+0xbd/0x146
>  [<c023e3b4>] driver_probe_device+0x44/0xa5
>  [<c023e498>] __driver_attach+0x0/0x7f
>  [<c023e4e1>] __driver_attach+0x49/0x7f
>  [<c023d9a0>] bus_for_each_dev+0x33/0x55
>  [<c023e163>] driver_attach+0x16/0x18
>  [<c023e498>] __driver_attach+0x0/0x7f
>  [<c023dc1d>] bus_add_driver+0x5e/0x15f
>  [<c01f52a1>] __pci_register_driver+0x74/0xa0
>  [<c03b0657>] aac_init+0x30/0x66
>  [<c039b7e0>] init+0x143/0x223
>  [<c010254a>] ret_from_fork+0x6/0x1c
>  [<c039b69d>] init+0x0/0x223
>  [<c039b69d>] init+0x0/0x223
>  [<c010323b>] kernel_thread_helper+0x7/0x10
>  =======================
