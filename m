From: Matthew Wilcox <matthew@wil.cx>
Subject: lockdep warning in qla2xxx
Date: Tue, 6 May 2008 12:23:41 -0600
Message-ID: <20080506182341.GN19219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46959 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYEFSXx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 14:23:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I'm in the middle of chasing something else right now, so I don't want
to spend any time on this:

=================================
[ INFO: inconsistent lock state ]
2.6.26-rc1-00115-g0340eda-dirty #60
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
swapper/1 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&ha->hardware_lock){+-..}, at: [<c035495d>] qla2300_intr_handler+0x35/0x1f5
{hardirq-on-W} state was registered at:
  [<c0139a16>] __lock_acquire+0x459/0xb1d
  [<c013a091>] __lock_acquire+0xad4/0xb1d
  [<c013a142>] lock_acquire+0x68/0x82
  [<c035495d>] qla2300_intr_handler+0x35/0x1f5
  [<c0506da5>] _spin_lock+0x24/0x4d
  [<c035495d>] qla2300_intr_handler+0x35/0x1f5
  [<c035495d>] qla2300_intr_handler+0x35/0x1f5
  [<c01391e4>] trace_hardirqs_on+0xe7/0x10e
  [<c034f0a6>] qla2x00_mailbox_command+0x1c6/0x433
  [<c0351d24>] qla2x00_mbx_reg_test+0x62/0xf2
  [<c050735e>] _spin_unlock_irqrestore+0x34/0x57
  [<c01391e4>] trace_hardirqs_on+0xe7/0x10e
  [<c0507300>] _read_unlock+0x10/0x3a
  [<c034c419>] qla2x00_chip_diag+0x240/0x2c3
  [<c034cca7>] qla2x00_initialize_adapter+0x1cb/0x2e1
  [<c04f99d9>] qla2x00_probe_one+0xc05/0xf22
  [<c02a5c6c>] pci_match_device+0x7b/0x9b
  [<c02a5c6c>] pci_match_device+0x7b/0x9b
  [<c02f9f4f>] __driver_attach+0x0/0x5b
  [<c02a5d2d>] pci_device_probe+0x36/0x57
  [<c02f9ed8>] driver_probe_device+0xb5/0x12c
  [<c02f9f89>] __driver_attach+0x3a/0x5b
  [<c02f975a>] bus_for_each_dev+0x3a/0x5c
  [<c02f9d65>] driver_attach+0x11/0x13
  [<c02f9f4f>] __driver_attach+0x0/0x5b
  [<c02f9ac3>] bus_add_driver+0x90/0x1b1
  [<c028d3a5>] kset_find_obj+0x4f/0x56
  [<c02fa0e4>] driver_register+0x6d/0xc1
  [<c029d168>] __spin_lock_init+0x21/0x41
  [<c02a5ef0>] __pci_register_driver+0x3d/0x69
  [<c0749551>] qla2x00_module_init+0xc8/0xf1
  [<c0730424>] kernel_init+0x122/0x22c
  [<c01391e4>] trace_hardirqs_on+0xe7/0x10e
  [<c0102c9f>] restore_nocheck+0x12/0x15
  [<c0730302>] kernel_init+0x0/0x22c
  [<c0730302>] kernel_init+0x0/0x22c
  [<c01038b7>] kernel_thread_helper+0x7/0x10
  [<ffffffff>] 0xffffffff
irq event stamp: 479336
hardirqs last  enabled at (479335): [<c05073a1>] _spin_unlock_irq+0x20/0x40
hardirqs last disabled at (479336): [<c0103628>] common_interrupt+0x24/0x34
softirqs last  enabled at (479332): [<c012462e>] do_softirq+0x36/0x51
softirqs last disabled at (479325): [<c012462e>] do_softirq+0x36/0x51

other info that might help us debug this:
no locks held by swapper/1.

stack backtrace:
Pid: 1, comm: swapper Not tainted 2.6.26-rc1-00115-g0340eda-dirty #60
 [<c0138121>] print_usage_bug+0x100/0x10a
 [<c0138d37>] mark_lock+0xaa/0x395
 [<c01399af>] __lock_acquire+0x3f2/0xb1d
 [<c013a091>] __lock_acquire+0xad4/0xb1d
 [<c013a142>] lock_acquire+0x68/0x82
 [<c035495d>] qla2300_intr_handler+0x35/0x1f5
 [<c0506da5>] _spin_lock+0x24/0x4d
 [<c035495d>] qla2300_intr_handler+0x35/0x1f5
 [<c035495d>] qla2300_intr_handler+0x35/0x1f5
 [<c014a37b>] handle_IRQ_event+0x13/0x3d
 [<c014b366>] handle_fasteoi_irq+0x76/0xab
 [<c01053ab>] do_IRQ+0x4f/0x68
 [<c0103632>] common_interrupt+0x2e/0x34
 [<c050007b>] init_intel_cacheinfo+0x3cb/0x42b
 [<c05073a7>] _spin_unlock_irq+0x26/0x40
 [<c011ae67>] finish_task_switch+0x3f/0x8c
 [<c011ae28>] finish_task_switch+0x0/0x8c
 [<c0505257>] schedule+0x5c7/0x622
 [<c050533b>] preempt_schedule+0x36/0x53
 [<c0291025>] __delay+0x6/0x7
 [<c0361e7f>] lpfc_sli_brdrestart+0x12a/0x13f
 [<c0361f0a>] lpfc_do_config_port+0x76/0x351
 [<c01a1a26>] sysfs_find_dirent+0x13/0x23
 [<c0362bac>] lpfc_sli_hba_setup+0x99/0x44b
 [<c01a15e8>] sysfs_add_file+0xb/0xe
 [<c04fa3b2>] lpfc_pci_probe_one+0x6bc/0x8ce
 [<c02f9f4f>] __driver_attach+0x0/0x5b
 [<c02a5d2d>] pci_device_probe+0x36/0x57
 [<c02f9ed8>] driver_probe_device+0xb5/0x12c
 [<c02f9f89>] __driver_attach+0x3a/0x5b
 [<c02f975a>] bus_for_each_dev+0x3a/0x5c
 [<c02f9d65>] driver_attach+0x11/0x13
 [<c02f9f4f>] __driver_attach+0x0/0x5b
 [<c02f9ac3>] bus_add_driver+0x90/0x1b1
 [<c028d3a5>] kset_find_obj+0x4f/0x56
 [<c02fa0e4>] driver_register+0x6d/0xc1
 [<c029d168>] __spin_lock_init+0x21/0x41
 [<c02a5ef0>] __pci_register_driver+0x3d/0x69
 [<c07495fa>] lpfc_init+0x80/0x9e
 [<c0730424>] kernel_init+0x122/0x22c
 [<c01391e4>] trace_hardirqs_on+0xe7/0x10e
 [<c0102c9f>] restore_nocheck+0x12/0x15
 [<c0730302>] kernel_init+0x0/0x22c
 [<c0730302>] kernel_init+0x0/0x22c
 [<c01038b7>] kernel_thread_helper+0x7/0x10
 =======================


-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
