From: =?iso-8859-1?Q?Michael_B=F6ttger?= <mb@globalcore.net>
Subject: cpqfc problems kernel 2.6.x
Date: Wed, 27 Oct 2004 18:21:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A78C801DDC69524C95EF94AD71E0BB0215E22B@sx1intn001.globalcore.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.globalcore.net ([80.78.224.10]:58330 "EHLO
	mx2.globalcore.net") by vger.kernel.org with ESMTP id S262501AbUJ0QVO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 12:21:14 -0400
Received: from sx1intn001.globalcore.local ([80.78.224.141])
	by mx2.globalcore.net (8.12.11/8.12.11) with ESMTP id i9RGL7ML008147
	for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2004 18:21:11 +0200
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 
Hello,
 
I am having some compile problems with the cpqfc driver in the 2.6.x kernel tree. I simply removed the two lines "#error This is too much stack" in the file cpqfcTScontrol.c -> it compiles but goes mad on module loading:
 
thnx for your time
&
keep on the great job you are doing for the linux development
 
kind regs.
Michael

PS: standard Fedora Core 2 installation with all updates

 
please find the output to /var/log/messages here:
 
#################################################### SNIP #############################################

Oct 27 13:39:49 cln2clul001 sshd(pam_unix)[1965]: session opened for user root by (uid=0)
Oct 27 13:39:56 cln2clul001 kernel: ACPI: PCI interrupt 0000:03:06.0[A] -> GSI 31 (level, low) -> IRQ 31
Oct 27 13:39:56 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:39:56 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:39:56 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:39:56 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:39:56 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:39:56 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:39:56 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:39:56 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:39:56 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:39:56 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:39:56 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:39:56 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:39:57 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:39:57 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:39:57 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:39:57 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:39:57 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:39:57 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:39:57 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:39:57 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:39:57 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:39:57 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:39:57 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:39:57 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:39:57 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:39:57 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:39:57 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:39:57 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:39:58 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:39:58 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:39:58 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:39:58 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:39:58 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:39:58 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:39:58 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:39:58 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:39:58 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:39:58 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:39:58 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:39:58 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:39:58 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:39:58 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:39:58 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:39:58 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:39:58 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:39:58 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:39:58 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:39:58 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:39:59 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:39:59 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:39:59 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:39:59 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:39:59 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:39:59 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:39:59 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:39:59 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:39:59 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:39:59 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:39:59 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:39:59 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:39:59 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:39:59 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:39:59 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:39:59 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:39:59 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:39:59 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:39:59 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:39:59 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:39:59 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:00 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:00 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:00 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:00 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:00 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:00 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:00 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:00 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:00 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:00 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:00 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:00 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:00 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:00 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:00 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:00 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:00 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:00 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:00 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:01 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:01 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:01 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:01 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:01 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:01 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:01 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:01 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:01 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:02 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:02 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:02 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:02 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:02 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:02 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/_task_prio+0xa8/0x1a0
Oct 27 13:40:02 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:02 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:02 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:02 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:02 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:02 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:02 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:02 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:02 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:02 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:02 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:02 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:02 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:02 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:02 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:02 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:02 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:02 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:02 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:02 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:02 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:03 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:03 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:03 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:03 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:03 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:03 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:03 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:03 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:03 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:03 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:03 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:03 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:03 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:03 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:03 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:03 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:03 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:03 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:03 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:03 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:04 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:04 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:04 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:04 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:04 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:04 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:04 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:04 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:04 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:04 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:04 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:04 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:04 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:04 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:04 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:04 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:04 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:04 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:04 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:04 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:04 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:04 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:04 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:05 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:05 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:05 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:05 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:05 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:05 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:05 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:05 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:05 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:05 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:05 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:05 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:05 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:05 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:05 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:05 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:05 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:05 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:05 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:05 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:05 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:05 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:05 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:06 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:06 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:06 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:06 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:06 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:06 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:06 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:06 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:06 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:06 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:06 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:06 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:06 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:06 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:06 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:06 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:06 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:06 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:06 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:06 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:06 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:06 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:07 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:07 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:07 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:07 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:07 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:07 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:07 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:07 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:07 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:07 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:07 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:07 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:07 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:07 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:07 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:07 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:07 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:07 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:07 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:07 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:07 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:07 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:08 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:08 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:08 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:08 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:08 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:08 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:08 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:08 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:08 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:08 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:08 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:08 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:08 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:08 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:08 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:08 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:08 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:08 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:08 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:08 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:08 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:08 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:09 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:09 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:09 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:09 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:09 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:09 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:09 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:09 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:09 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:09 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:09 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:09 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:09 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:09 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:09 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:09 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:09 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:09 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:09 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:09 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:09 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:09 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:09 cln2clul001 kernel:  [<f89c5cd0>] SendLogins+0x200/0x450 [cpqfc]
Oct 27 13:40:09 cln2clul001 kernel:  [<f89c4386>] cpqfcTS_WorkTask+0xb6/0x530 [cpqfc]
Oct 27 13:40:09 cln2clul001 kernel:  [<c0118cf8>] recalc_task_prio+0xa8/0x1a0
Oct 27 13:40:09 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:09 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:09 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:09 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:09 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:09 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:09 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:09 cln2clul001 kernel: cpqfcTS: New FC port 000002h WWN: 500508B1000E45B0 SCSI Chan/Trgt 0/0
Oct 27 13:40:09 cln2clul001 kernel: cpqfcTS: New FC port 000001h WWN: 100000E0020047B3 SCSI Chan/Trgt 0/1
Oct 27 13:40:09 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:09 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:09 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:09 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:09 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:10 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:10 cln2clul001 kernel:  [<f89c4415>] cpqfcTS_WorkTask+0x145/0x530 [cpqfc]
Oct 27 13:40:10 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:10 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:10 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:10 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:10 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:10 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:10 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:10 cln2clul001 kernel: bad: scheduling while atomic!
Oct 27 13:40:10 cln2clul001 kernel:  [<c03101ec>] schedule+0x4ec/0x500
Oct 27 13:40:10 cln2clul001 kernel:  [<c030fc37>] __down_interruptible+0xa7/0x140
Oct 27 13:40:10 cln2clul001 kernel:  [<c0119850>] default_wake_function+0x0/0x20
Oct 27 13:40:10 cln2clul001 kernel:  [<c030fce3>] __down_failed_interruptible+0x7/0xc
Oct 27 13:40:10 cln2clul001 kernel:  [<f89c9550>] .text.lock.cpqfcTSworker+0x37/0x77 [cpqfc]
Oct 27 13:40:10 cln2clul001 kernel:  [<f89c4415>] cpqfcTS_WorkTask+0x145/0x530 [cpqfc]
Oct 27 13:40:10 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:10 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:10 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:10 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:10 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:10 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:10 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:10 cln2clul001 kernel: ------------[ cut here ]------------
Oct 27 13:40:10 cln2clul001 kernel: kernel BUG at drivers/scsi/scsi_scan.c:1344!
Oct 27 13:40:10 cln2clul001 kernel: invalid operand: 0000 [#1]
Oct 27 13:40:10 cln2clul001 kernel: PREEMPT 
Oct 27 13:40:10 cln2clul001 kernel: Modules linked in: cpqfc qla2300 qla2xxx scsi_transport_fc md5 ipv6 autofs4 iptable_filter ip_tables e100 floppy sg microcode dm_mod button battery ac ext3 jbd cpqarray sd_mod
Oct 27 13:40:10 cln2clul001 kernel: CPU:    0
Oct 27 13:40:10 cln2clul001 kernel: EIP:    0060:[<c025f19a>]    Not tainted VLI
Oct 27 13:40:10 cln2clul001 kernel: EFLAGS: 00010213   (2.6.9-ac3) 
Oct 27 13:40:10 cln2clul001 kernel: EIP is at scsi_free_host_dev+0x5a/0x64
Oct 27 13:40:10 cln2clul001 kernel: eax: ffffffff   ebx: f719d000   ecx: f719d000   edx: f662f000
Oct 27 13:40:10 cln2clul001 kernel: esi: f653dca0   edi: f89c5f20   ebp: f662f1c0   esp: f6675e80
Oct 27 13:40:10 cln2clul001 kernel: ds: 007b   es: 007b   ss: 0068
Oct 27 13:40:10 cln2clul001 kernel: Process cpqfcTS_wt_0 (pid: 2001, threadinfo=f6674000 task=f717b020)
Oct 27 13:40:10 cln2clul001 kernel: Stack: f89c5f20 00003000 f89c633c f719d000 00000000 f66a0568 f653dca0 f6675ea4 
Oct 27 13:40:10 cln2clul001 kernel:        f719d000 00000000 f662f1c0 f66a055c f6675fd0 f662f1c4 f89c47d6 f662f1c0 
Oct 27 13:40:10 cln2clul001 kernel:        f66a0568 f66a031c 00000000 f6675ee0 f66a0000 00000007 f6680000 00000000 
Oct 27 13:40:11 cln2clul001 kernel: Call Trace:
Oct 27 13:40:11 cln2clul001 kernel:  [<f89c5f20>] ScsiReportLunsDone+0x0/0x220 [cpqfc]
Oct 27 13:40:11 cln2clul001 kernel:  [<f89c633c>] IssueReportLunsCommand+0x14c/0x1a0 [cpqfc]
Oct 27 13:40:11 cln2clul001 kernel:  [<f89c47d6>] cpqfcTS_WorkTask+0x506/0x530 [cpqfc]
Oct 27 13:40:11 cln2clul001 kernel:  [<c030ffbe>] schedule+0x2be/0x500
Oct 27 13:40:11 cln2clul001 kernel:  [<c0118f56>] try_to_wake_up+0xa6/0xc0
Oct 27 13:40:11 cln2clul001 kernel:  [<c0119977>] __wake_up_locked+0x27/0x30
Oct 27 13:40:11 cln2clul001 kernel:  [<c0114f5e>] __mask_IO_APIC_irq+0x1e/0x30
Oct 27 13:40:11 cln2clul001 kernel:  [<f89c41e1>] cpqfcTSWorkerThread+0x171/0x1e0 [cpqfc]
Oct 27 13:40:11 cln2clul001 kernel:  [<f89c4070>] cpqfcTSWorkerThread+0x0/0x1e0 [cpqfc]
Oct 27 13:40:11 cln2clul001 kernel:  [<c010404d>] kernel_thread_helper+0x5/0x18
Oct 27 13:40:11 cln2clul001 kernel: Code: 01 00 00 8b 5c 24 04 89 44 24 0c 83 c4 08 e9 5e 60 fb ff 89 1c 24 ff 50 0c eb e2 8d b6 00 00 00 00 89 1c 24 ff 50 44 8b 13 eb c8 <0f> 0b 40 05 3a 4a 33 c0 eb b4 e8 27 0b 0b 00 e9 4f fa ff ff e8 
Oct 27 13:40:11 cln2clul001 kernel:  <6>note: cpqfcTS_wt_0[2001] exited with preempt_count 1

###################################################### SNIP #########################################################
 
