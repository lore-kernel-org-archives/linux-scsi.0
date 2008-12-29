From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
Date: Mon, 29 Dec 2008 15:55:28 -0500
Message-ID: <49593940.9060102@cybernetics.com>
References: <495932A0.5040306@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1384 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYL2Uza (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Dec 2008 15:55:30 -0500
In-Reply-To: <495932A0.5040306@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaro.Koskinen@nokia.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

Just found another problem with this patch: sym_alloc_lcb() allocates
memory with GFP_KERNEL, and you are calling it while holding a spinlock
(np->s.host->host_lock).  Either do the allocation without holding the
spinlock, or else use GFP_ATOMIC.

BUG: sleeping function called from invalid context at mm/slab.c:3043
in_atomic():0, irqs_disabled():1
2 locks held by insmod/1216:
 #0:  (&shost->scan_mutex){--..}, at: [<c026386b>]
scsi_scan_host_selected+0x4b/0x140
 #1:  (shost->host_lock){++..}, at: [<d092eb5c>]
sym53c8xx_slave_alloc+0x4c/0x190 [sym53c8xx]
irq event stamp: 7322
hardirqs last  enabled at (7321): [<c0145d5b>] trace_hardirqs_on+0xb/0x10
hardirqs last disabled at (7322): [<c014120b>] trace_hardirqs_off+0xb/0x10
softirqs last  enabled at (7204): [<c0127c32>] __do_softirq+0x102/0x120
softirqs last disabled at (7185): [<c0127ca7>] do_softirq+0x57/0x60
Pid: 1216, comm: insmod Not tainted 2.6.27.10 #2
 [<c0127ca7>] ? do_softirq+0x57/0x60
 [<c011b2e6>] __might_sleep+0xc6/0xf0
 [<c016bcfd>] __kmalloc+0x11d/0x150
 [<d09304b1>] ? sym_alloc_lcb+0xe1/0x180 [sym53c8xx]
 [<d09304b1>] sym_alloc_lcb+0xe1/0x180 [sym53c8xx]
 [<d092ec02>] sym53c8xx_slave_alloc+0xf2/0x190 [sym53c8xx]
 [<c026236f>] scsi_alloc_sdev+0x18f/0x200
 [<c025aac0>] ? scsi_device_lookup_by_target+0x60/0x80
 [<c026254d>] scsi_probe_and_add_lun+0xcd/0xb40
 [<c02632da>] __scsi_scan_target+0x20a/0x6c0
 [<c0145d5b>] ? trace_hardirqs_on+0xb/0x10
 [<c0145d5b>] ? trace_hardirqs_on+0xb/0x10
 [<c0145ccd>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<c0327302>] ? __mutex_lock_common+0x1f2/0x2f0
 [<c026386b>] ? scsi_scan_host_selected+0x4b/0x140
 [<c0263802>] scsi_scan_channel+0x72/0x90
 [<c02638ed>] scsi_scan_host_selected+0xcd/0x140
 [<c0265eaa>] ? scsi_proc_host_add+0x4a/0xa0
 [<c02639d6>] do_scsi_scan_host+0x76/0x80
 [<c0263c8a>] scsi_scan_host+0x15a/0x190
 [<c0328ab9>] ? _spin_unlock_irqrestore+0x49/0x60
 [<d0937c8a>] sym2_probe+0x89a/0x92e [sym53c8xx]
 [<c01f4e2e>] pci_device_probe+0x5e/0x80
 [<c024717e>] driver_probe_device+0x7e/0x170
 [<c02472e5>] __driver_attach+0x75/0x80
 [<c0246a59>] bus_for_each_dev+0x49/0x70
 [<c0246ff9>] driver_attach+0x19/0x20
 [<c0247270>] ? __driver_attach+0x0/0x80
 [<c024635c>] bus_add_driver+0xac/0x220
 [<c01f4a40>] ? pci_device_remove+0x0/0x40
 [<c024747f>] driver_register+0x4f/0x120
 [<c01eb9b2>] ? __spin_lock_init+0x32/0x60
 [<d0864000>] ? sym2_init+0x0/0xf6 [sym53c8xx]
 [<c01f4cae>] __pci_register_driver+0x5e/0xa0
 [<d0864000>] ? sym2_init+0x0/0xf6 [sym53c8xx]
 [<d0864087>] sym2_init+0x87/0xf6 [sym53c8xx]
 [<c0145ccd>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<d0864000>] ? sym2_init+0x0/0xf6 [sym53c8xx]
 [<c010102a>] _stext+0x2a/0x140
 [<c0145d5b>] ? trace_hardirqs_on+0xb/0x10
 [<c0145ccd>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<c014d725>] sys_init_module+0x85/0x1b0
 [<c0145ccd>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<c01ddb94>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0103031>] sysenter_do_call+0x12/0x35
 [<c01211f8>] ? __mmdrop+0x28/0x30
 =======================

Tony Battersby
Cybernetics
 
