From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11713] bugcheck with modprobe -r sym53c8xx
Date: Tue, 16 Dec 2008 12:37:52 -0800 (PST)
Message-ID: <20081216203752.4797910800E@picon.linux-foundation.org>
References: <bug-11713-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265AbYLPUiM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 15:38:12 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBGKbq2P022979
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2008 12:37:53 -0800
In-Reply-To: <bug-11713-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11713





------- Comment #1 from tonyb@cybernetics.com  2008-12-16 12:37 -------
http://marc.info/?l=linux-scsi&m=120102742932161&w=2

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


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
