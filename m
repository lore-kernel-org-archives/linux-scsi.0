From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [qla2xxx] INFO: possible irq lock inversion dependency detected
Date: Thu, 04 Oct 2012 17:57:46 +0530
Message-ID: <506D80C2.5040405@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

With the mainline kernel (in the merge window) I am seeing the following lockdep
splat every time during boot.

Regards,
Srivatsa S. Bhat

------------------------------------>

[    3.940316] SCSI subsystem initialized
[    3.949021] Fusion MPT base driver 3.04.20
[    3.953141] Copyright (c) 1999-2008 LSI Corporation
[    3.955471] Fusion MPT SAS Host driver 3.04.20
[    3.955850] mptbase: ioc0: Initiating bringup
[    4.656179] ioc0: LSISAS1064E B3: Capabilities={Initiator}
[   16.216323] scsi0 : ioc0: LSISAS1064E B3, FwRev=011e0000h, Ports=1, MaxQ=277, IRQ=28
[   16.248414] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 1, phy 0, sas_addr 0x5000c5001d7e18c9
[   16.259708] scsi 0:0:0:0: Direct-Access     IBM-ESXS ST9146803SS      B536 PQ: 0 ANSI: 5
[   16.271986] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 3, phy 1, sas_addr 0x677c605e9f919a95
[   16.284288] scsi 0:0:1:0: Direct-Access     ATA      GBRLB031XVECCM   4.26 PQ: 0 ANSI: 5
[   16.348106] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.04.00.03-k.
[   16.356369] qla2xxx [0000:24:00.0]-001d: : Found an ISP2532 irq 32 iobase 0xffffc9001e0ba000.
[   16.365364] qla2xxx 0000:24:00.0: irq 66 for MSI/MSI-X
[   16.370527] qla2xxx 0000:24:00.0: irq 67 for MSI/MSI-X
[   16.436226] scsi1 : qla2xxx
[   17.280685] qla2xxx [0000:24:00.0]-505f:1: Link is operational (2 Gbps).
[   17.780955] 
[   17.782450] =========================================================
[   17.784924] [ INFO: possible irq lock inversion dependency detected ]
[   17.784924] 3.6.0-0.0.0.28.36b5ec9-default #1 Not tainted
[   17.784924] ---------------------------------------------------------
[   17.784924] qla2xxx_1_dpc/368 just changed the state of lock:
[   17.784924]  (&(&ha->vport_slock)->rlock){+.....}, at: [<ffffffffa009b377>] qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
[   17.784924] but this lock was taken by another, HARDIRQ-safe lock in the past:
[   17.784924]  (&(&ha->hardware_lock)->rlock){-.....}

and interrupts could create inverse lock ordering between them.

[   17.784924] 
[   17.784924] other info that might help us debug this:
[   17.784924]  Possible interrupt unsafe locking scenario:
[   17.784924] 
[   17.784924]        CPU0                    CPU1
[   17.784924]        ----                    ----
[   17.784924]   lock(&(&ha->vport_slock)->rlock);
[   17.784924]                                local_irq_disable();
[   17.784924]                                lock(&(&ha->hardware_lock)->rlock);
[   17.784924]                                lock(&(&ha->vport_slock)->rlock);
[   17.784924]   <Interrupt>
[   17.784924]     lock(&(&ha->hardware_lock)->rlock);
[   17.784924] 
[   17.784924]  *** DEADLOCK ***
[   17.784924] 
[   17.784924] no locks held by qla2xxx_1_dpc/368.
[   17.784924] 
[   17.784924] the shortest dependencies between 2nd lock and 1st lock:
[   17.784924]  -> (&(&ha->hardware_lock)->rlock){-.....} ops: 49 {
[   17.784924]     IN-HARDIRQ-W at:
[   17.784924]                       [<ffffffff810ab36f>] mark_irqflags+0x17f/0x190
[   17.784924]                       [<ffffffff810aca0c>] __lock_acquire+0x35c/0x520
[   17.784924]                       [<ffffffff810acc6f>] lock_acquire+0x9f/0x190
[   17.784924]                       [<ffffffff814afdd4>] _raw_spin_lock_irqsave+0x54/0x70
[   17.784924]                       [<ffffffffa00b5a90>] qla24xx_msix_default+0x40/0x250 [qla2xxx]
[   17.784924]                       [<ffffffff810dd644>] handle_irq_event_percpu+0x84/0x3a0
[   17.784924]                       [<ffffffff810dd9a3>] handle_irq_event+0x43/0x70
[   17.784924]                       [<ffffffff810e0e6d>] handle_edge_irq+0x6d/0x130
[   17.784924]                       [<ffffffff810045ed>] handle_irq+0x1d/0x30
[   17.784924]                       [<ffffffff81003c98>] do_IRQ+0x58/0xe0
[   17.784924]                       [<ffffffff814b0a32>] ret_from_intr+0x0/0x1a
[   17.784924]                       [<ffffffff813a8c69>] cpuidle_enter+0x19/0x20
[   17.784924]                       [<ffffffff813a8c82>] cpuidle_enter_state+0x12/0x50
[   17.784924]                       [<ffffffff813a96c0>] cpuidle_idle_call+0xc0/0x260
[   17.784924]                       [<ffffffff8100af35>] cpu_idle+0x95/0xf0
[   17.784924]                       [<ffffffff8149459a>] rest_init+0xfa/0x170
[   17.784924]                       [<ffffffff81aeaeec>] start_kernel+0x3bf/0x3cc
[   17.784924]                       [<ffffffff81aea335>] x86_64_start_reservations+0x131/0x136
[   17.784924]                       [<ffffffff81aea43d>] x86_64_start_kernel+0x103/0x112
[   17.784924]     INITIAL USE at:
[   17.784924]                      [<ffffffff810ac88d>] __lock_acquire+0x1dd/0x520
[   17.784924]                      [<ffffffff810acc6f>] lock_acquire+0x9f/0x190
[   17.784924]                      [<ffffffff814afd68>] _raw_spin_lock_irq+0x48/0x60
[   17.784924]                      [<ffffffffa00b6b8c>] qla2x00_request_irqs+0x16c/0x2d0 [qla2xxx]
[   17.784924]                      [<ffffffffa00e1bb6>] qla2x00_probe_one+0xe15/0x225f [qla2xxx]
[   17.784924]                      [<ffffffff812a6b34>] local_pci_probe+0x74/0x100
[   17.784924]                      [<ffffffff812a6ca9>] __pci_device_probe+0xe9/0xf0
[   17.784924]                      [<ffffffff812a7f65>] pci_device_probe+0x35/0x60
[   17.784924]                      [<ffffffff8134e617>] really_probe+0x67/0x330
[   17.784924]                      [<ffffffff8134e922>] driver_probe_device+0x42/0xa0
[   17.784924]                      [<ffffffff8134ea23>] __driver_attach+0xa3/0xb0
[   17.784924]                      [<ffffffff8134c8a4>] bus_for_each_dev+0x64/0x90
[   17.784924]                      [<ffffffff8134e3d9>] driver_attach+0x19/0x20
[   17.784924]                      [<ffffffff8134de18>] bus_add_driver+0x208/0x290
[   17.784924]                      [<ffffffff8134f0af>] driver_register+0x6f/0x150
[   17.784924]                      [<ffffffff812a808c>] __pci_register_driver+0x5c/0x70
[   17.784924]                      [<ffffffffa01091cb>] qla2x00_module_init+0x1cb/0x21a [qla2xxx]
[   17.784924]                      [<ffffffff810001bd>] do_one_initcall+0x3d/0x170
[   17.784924]                      [<ffffffff810bafe6>] sys_init_module+0xc6/0x220
[   17.784924]                      [<ffffffff814b98b9>] system_call_fastpath+0x16/0x1b
[   17.784924]   }
[   17.784924]   ... key      at: [<ffffffffa00fb5a8>] __key.74145+0x0/0xfffffffffffe7a58 [qla2xxx]
[   17.784924]   ... acquired at:
[   17.784924]    [<ffffffff810ac5ac>] validate_chain+0x63c/0x740
[   17.784924]    [<ffffffff810ac9bd>] __lock_acquire+0x30d/0x520
[   17.784924]    [<ffffffff810acc6f>] lock_acquire+0x9f/0x190
[   17.784924]    [<ffffffff814afc8c>] _raw_spin_lock+0x3c/0x50
[   17.784924]    [<ffffffffa009b74d>] qla2x00_init_rings+0x11d/0x240 [qla2xxx]
[   17.784924]    [<ffffffffa009fad8>] qla2x00_initialize_adapter+0x3b8/0x3e0 [qla2xxx]
[   17.784924]    [<ffffffffa00e1dd2>] qla2x00_probe_one+0x1031/0x225f [qla2xxx]
[   17.784924]    [<ffffffff812a6b34>] local_pci_probe+0x74/0x100
[   17.784924]    [<ffffffff812a6ca9>] __pci_device_probe+0xe9/0xf0
[   17.784924]    [<ffffffff812a7f65>] pci_device_probe+0x35/0x60
[   17.784924]    [<ffffffff8134e617>] really_probe+0x67/0x330
[   17.784924]    [<ffffffff8134e922>] driver_probe_device+0x42/0xa0
[   17.784924]    [<ffffffff8134ea23>] __driver_attach+0xa3/0xb0
[   17.784924]    [<ffffffff8134c8a4>] bus_for_each_dev+0x64/0x90
[   17.784924]    [<ffffffff8134e3d9>] driver_attach+0x19/0x20
[   17.784924]    [<ffffffff8134de18>] bus_add_driver+0x208/0x290
[   17.784924]    [<ffffffff8134f0af>] driver_register+0x6f/0x150
[   17.784924]    [<ffffffff812a808c>] __pci_register_driver+0x5c/0x70
[   17.784924]    [<ffffffffa01091cb>] qla2x00_module_init+0x1cb/0x21a [qla2xxx]
[   17.784924]    [<ffffffff810001bd>] do_one_initcall+0x3d/0x170
[   17.784924]    [<ffffffff810bafe6>] sys_init_module+0xc6/0x220
[   17.784924]    [<ffffffff814b98b9>] system_call_fastpath+0x16/0x1b
[   17.784924] 
[   17.784924] -> (&(&ha->vport_slock)->rlock){+.....} ops: 2 {
[   17.784924]    HARDIRQ-ON-W at:
[   17.784924]                     [<ffffffff810ab320>] mark_irqflags+0x130/0x190
[   17.784924]                     [<ffffffff810aca0c>] __lock_acquire+0x35c/0x520
[   17.784924]                     [<ffffffff810acc6f>] lock_acquire+0x9f/0x190
[   17.784924]                     [<ffffffff814afc8c>] _raw_spin_lock+0x3c/0x50
[   17.784924]                     [<ffffffffa009b377>] qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
[   17.784924]                     [<ffffffffa00a2060>] qla2x00_configure_loop+0x30/0x2f0 [qla2xxx]
[   17.784924]                     [<ffffffffa00a27d6>] qla2x00_loop_resync+0x126/0x160 [qla2xxx]
[   17.784924]                     [<ffffffffa00994de>] qla2x00_do_dpc+0x5ee/0x660 [qla2xxx]
[   17.784924]                     [<ffffffff8106cc26>] kthread+0xd6/0xe0
[   17.784924]                     [<ffffffff814bab24>] kernel_thread_helper+0x4/0x10
[   17.784924]    INITIAL USE at:
[   17.784924]                    [<ffffffff810ac88d>] __lock_acquire+0x1dd/0x520
[   17.784924]                    [<ffffffff810acc6f>] lock_acquire+0x9f/0x190
[   17.784924]                    [<ffffffff814afc8c>] _raw_spin_lock+0x3c/0x50
[   17.784924]                    [<ffffffffa009b74d>] qla2x00_init_rings+0x11d/0x240 [qla2xxx]
[   17.784924]                    [<ffffffffa009fad8>] qla2x00_initialize_adapter+0x3b8/0x3e0 [qla2xxx]
[   17.784924]                    [<ffffffffa00e1dd2>] qla2x00_probe_one+0x1031/0x225f [qla2xxx]
[   17.784924]                    [<ffffffff812a6b34>] local_pci_probe+0x74/0x100
[   17.784924]                    [<ffffffff812a6ca9>] __pci_device_probe+0xe9/0xf0
[   17.784924]                    [<ffffffff812a7f65>] pci_device_probe+0x35/0x60
[   17.784924]                    [<ffffffff8134e617>] really_probe+0x67/0x330
[   17.784924]                    [<ffffffff8134e922>] driver_probe_device+0x42/0xa0
[   17.784924]                    [<ffffffff8134ea23>] __driver_attach+0xa3/0xb0
[   17.784924]                    [<ffffffff8134c8a4>] bus_for_each_dev+0x64/0x90
[   17.784924]                    [<ffffffff8134e3d9>] driver_attach+0x19/0x20
[   17.784924]                    [<ffffffff8134de18>] bus_add_driver+0x208/0x290
[   17.784924]                    [<ffffffff8134f0af>] driver_register+0x6f/0x150
[   17.784924]                    [<ffffffff812a808c>] __pci_register_driver+0x5c/0x70
[   17.784924]                    [<ffffffffa01091cb>] qla2x00_module_init+0x1cb/0x21a [qla2xxx]
[   17.784924]                    [<ffffffff810001bd>] do_one_initcall+0x3d/0x170
[   17.784924]                    [<ffffffff810bafe6>] sys_init_module+0xc6/0x220
[   17.784924]                    [<ffffffff814b98b9>] system_call_fastpath+0x16/0x1b
[   17.784924]  }
[   17.784924]  ... key      at: [<ffffffffa00fb5a0>] __key.74146+0x0/0xfffffffffffe7a60 [qla2xxx]
[   17.784924]  ... acquired at:
[   17.784924]    [<ffffffff810aa43a>] check_usage_backwards+0x8a/0xf0
[   17.784924]    [<ffffffff810aadf9>] mark_lock_irq+0x99/0x290
[   17.784924]    [<ffffffff810ab13e>] mark_lock+0x14e/0x200
[   17.784924]    [<ffffffff810ab320>] mark_irqflags+0x130/0x190
[   17.784924]    [<ffffffff810aca0c>] __lock_acquire+0x35c/0x520
[   17.784924]    [<ffffffff810acc6f>] lock_acquire+0x9f/0x190
[   17.784924]    [<ffffffff814afc8c>] _raw_spin_lock+0x3c/0x50
[   17.784924]    [<ffffffffa009b377>] qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
[   17.784924]    [<ffffffffa00a2060>] qla2x00_configure_loop+0x30/0x2f0 [qla2xxx]
[   17.784924]    [<ffffffffa00a27d6>] qla2x00_loop_resync+0x126/0x160 [qla2xxx]
[   17.784924]    [<ffffffffa00994de>] qla2x00_do_dpc+0x5ee/0x660 [qla2xxx]
[   17.784924]    [<ffffffff8106cc26>] kthread+0xd6/0xe0
[   17.784924]    [<ffffffff814bab24>] kernel_thread_helper+0x4/0x10
[   17.784924] 
[   17.784924] 
[   17.784924] stack backtrace:
[   17.784924] Pid: 368, comm: qla2xxx_1_dpc Not tainted 3.6.0-0.0.0.28.36b5ec9-default #1
[   17.784924] Call Trace:
[   17.784924]  [<ffffffff810a9ce6>] print_irq_inversion_bug+0x1c6/0x210
[   17.784924]  [<ffffffff810aa43a>] check_usage_backwards+0x8a/0xf0
[   17.784924]  [<ffffffff814b05cb>] ? _raw_spin_unlock_irqrestore+0x3b/0x80
[   17.784924]  [<ffffffff810aa3b0>] ? print_usage_bug+0x190/0x190
[   17.784924]  [<ffffffff810aadf9>] mark_lock_irq+0x99/0x290
[   17.784924]  [<ffffffff810ab13e>] mark_lock+0x14e/0x200
[   17.784924]  [<ffffffff810ab320>] mark_irqflags+0x130/0x190
[   17.784924]  [<ffffffff810aca0c>] __lock_acquire+0x35c/0x520
[   17.784924]  [<ffffffff810acc6f>] lock_acquire+0x9f/0x190
[   17.784924]  [<ffffffffa009b377>] ? qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
[   17.784924]  [<ffffffff814afc8c>] _raw_spin_lock+0x3c/0x50
[   17.784924]  [<ffffffffa009b377>] ? qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
[   17.784924]  [<ffffffffa009b377>] qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
[   17.784924]  [<ffffffff810ab700>] ? trace_hardirqs_on_caller+0xb0/0x1a0
[   17.784924]  [<ffffffffa00a2060>] qla2x00_configure_loop+0x30/0x2f0 [qla2xxx]
[   17.784924]  [<ffffffffa00a27d6>] qla2x00_loop_resync+0x126/0x160 [qla2xxx]
[   17.784924]  [<ffffffffa00994de>] qla2x00_do_dpc+0x5ee/0x660 [qla2xxx]
[   17.784924]  [<ffffffffa0098ef0>] ? qla2x00_relogin+0x220/0x220 [qla2xxx]
[   17.784924]  [<ffffffff8106cc26>] kthread+0xd6/0xe0
[   17.784924]  [<ffffffff814b056b>] ? _raw_spin_unlock_irq+0x2b/0x50
[   17.784924]  [<ffffffff814bab24>] kernel_thread_helper+0x4/0x10
[   17.784924]  [<ffffffff814b0af3>] ? retint_restore_args+0x13/0x13
[   17.784924]  [<ffffffff8106cb50>] ? __init_kthread_worker+0x70/0x70
[   17.784924]  [<ffffffff814bab20>] ? gs_change+0x13/0x13
[   18.928207] qla2xxx [0000:24:00.0]-00fb:1: QLogic QMI2572 - QLogic 4Gb Fibre Channel Expansion Card (CIOv) for IBM BladeCenter.
[   18.939685] qla2xxx [0000:24:00.0]-00fc:1: ISP2532: PCIe (5.0GT/s x8) @ 0000:24:00.0 hdma+ host#=1 fw=5.06.05 (90d5).
[   18.951022] qla2xxx [0000:24:00.1]-001d: : Found an ISP2532 irq 42 iobase 0xffffc9001e2a0000.
[   18.959964] qla2xxx 0000:24:00.1: irq 68 for MSI/MSI-X
[   18.965162] qla2xxx 0000:24:00.1: irq 69 for MSI/MSI-X
[   19.023894] scsi2 : qla2xxx
[   19.888618] scsi 1:0:0:0: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   19.901563] scsi 1:0:0:1: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   19.910274] scsi 1:0:0:2: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   19.918951] scsi 1:0:0:3: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   19.927742] scsi 1:0:0:4: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   19.936460] scsi 1:0:0:5: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   19.945269] scsi 1:0:0:6: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   19.953995] scsi 1:0:0:31: Direct-Access     IBM      Universal Xport  0542 PQ: 0 ANSI: 3
[   19.963750] scsi 1:0:1:0: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   19.976798] scsi 1:0:1:1: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   19.985520] scsi 1:0:1:2: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   19.994223] scsi 1:0:1:3: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   20.002872] scsi 1:0:1:4: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   20.011658] scsi 1:0:1:5: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   20.020233] scsi 1:0:1:6: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
[   20.028905] scsi 1:0:1:31: Direct-Access     IBM      Universal Xport  0542 PQ: 0 ANSI: 3
[   24.028195] qla2xxx [0000:24:00.1]-00fb:2: QLogic QMI2572 - QLogic 4Gb Fibre Channel Expansion Card (CIOv) for IBM BladeCenter.
[   24.039718] qla2xxx [0000:24:00.1]-00fc:2: ISP2532: PCIe (5.0GT/s x8) @ 0000:24:00.1 hdma+ host#=2 fw=5.06.05 (90d5).
[   24.084241] ACPI: bus type usb registered
