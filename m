From: Tony Battersby <tonyb@cybernetics.com>
Subject: Warning: sym53c8xx calls dma_free_coherent() with irqs disabled
Date: Tue, 22 Jan 2008 13:19:09 -0500
Message-ID: <4796339D.2010506@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cybernetics.com ([70.169.137.4]:1796 "EHLO mail.cybernetics.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbYAVSnd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 13:43:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

When unloading, sym53c8xx calls dma_free_coherent() while holding a
spinlock (sym53c8xx_lock) with irqs disabled, which produces the
following warning with 2.6.24:

modprobe sym53c8xx
modprobe -r sym53c8xx
sym0: detaching ...
sym0: resetting chip
WARNING: at arch/x86/kernel/pci-dma_32.c:66 dma_free_coherent()
Pid: 682, comm: rmmod Not tainted 2.6.24-rc8-git5 #1
 [<c0107a05>] dma_free_coherent+0x95/0xa0
 [<d0942066>] ___free_dma_mem_cluster+0x46/0x70 [sym53c8xx]
 [<d0941f0d>] __sym_mfree+0x6d/0xc0 [sym53c8xx]
 [<c010ec6c>] smp_call_function+0x1c/0x20
 [<c01209c8>] on_each_cpu+0x28/0x40
 [<d094232e>] __sym_mfree_dma+0x5e/0xb0 [sym53c8xx]
 [<d093d510>] sym_hcb_free+0x70/0x170 [sym53c8xx]
 [<d09389dc>] sym_free_resources+0x3c/0x70 [sym53c8xx]
 [<d093a06c>] sym_detach+0x8c/0xb0 [sym53c8xx]
 [<d093a0b9>] sym2_remove+0x29/0x50 [sym53c8xx]
 [<c01d5316>] pci_device_remove+0x16/0x40
 [<c0223498>] __device_release_driver+0x68/0xb0
 [<c02239a4>] driver_detach+0xa4/0xb0
 [<c0222f83>] bus_remove_driver+0x73/0xa0
 [<c01d549e>] pci_unregister_driver+0xe/0x70
 [<d0942dd0>] sym2_exit+0x0/0x7d [sym53c8xx]
 [<d0942dda>] sym2_exit+0xa/0x7d [sym53c8xx]
 [<c013e51b>] sys_delete_module+0x11b/0x1b0
 [<c0112dd9>] do_page_fault+0xe9/0x640
 [<c0154207>] do_munmap+0x197/0x1f0
 [<c0102a7e>] sysenter_past_esp+0x5f/0x85
 [<c02f0000>] __lro_proc_segment+0x130/0x300
 =======================

However, everything does work OK at least on i386; the warning is for
portability to other archs (ARM and MIPS).  This warning was added in
2.6.24-rc1, so the message does not appear in 2.6.23, although it is not
really a regression.  This appears non-trivial to fix, since the
spinlock protects access to higher-level data structures.

Tony Battersby
Cybernetics

