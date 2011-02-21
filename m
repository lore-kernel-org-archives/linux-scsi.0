From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29442] target: Race between target driver unregistration and
 LUN removal
Date: Mon, 21 Feb 2011 11:16:59 GMT
Message-ID: <201102211116.p1LBGxeB027730@demeter2.kernel.org>
References: <bug-29442-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:51801 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1BULQ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Feb 2011 06:16:59 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1LBGxAP027731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2011 11:16:59 GMT
In-Reply-To: <bug-29442-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=29442


nab <nab@linux-iscsi.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nab@linux-iscsi.org




--- Comment #1 from nab <nab@linux-iscsi.org>  2011-02-21 11:16:57 ---
(In reply to comment #0)
> With the ib_srpt driver from branch srpt of https://github.com/bvanassche/srpt,
> the call trace included below sometimes appears in the kernel log while
> removing ib_srpt-related nodes from configfs and unloading ib_srpt. IMHO this
> call trace reveals a race condition in the target core between target driver
> template unregistration and LUN removal.
> 
> Session 0x00000000000000000002c9030005f34f: kernel thread ib_srpt_compl (PID
> 7298) stopped

Ok, the SRP Nexus for 2c9030005f34f is stopped at this point..

> srpt_TPG[1] - Deleted ACL with TCQ Depth: 1 for srpt Initiator Node:
> 0x00000000000000000002c9030005f34f
> srpt_TPG[2] - Deleted ACL with TCQ Depth: 1 for srpt Initiator Node:
> 0x00000000000000000002c9030003cca3
> srpt_TPG[2] - Deleted ACL with TCQ Depth: 1 for srpt Initiator Node:
> 0x00000000000000000002c9030003cca7
> srpt_TPG[2] - Deleted ACL with TCQ Depth: 1 for srpt Initiator Node:
> 0x00000000000000000002c9030005f34b
> srpt_TPG[2] - Deleted ACL with TCQ Depth: 1 for srpt Initiator Node:
> 0x00000000000000000002c9030005f34f

Hmmm, so this is with five explict NodeACLs including 2c9030005f34f across
TPG=1 and TPG=2 to the same $SRP_TARGET_WWN endpoint, but *not* with explict
MappedLUN into
/sys/kernel/config/target/srpt/$SRP_TARGET_WWN/acls/$SRP_INITIATOR_WWN/lun_$ID,
correct..?

> srpt_TPG[1]_LUN[0] - Deactivated srpt Logical Unit from device object
> srpt_TPG[1]_LUN[1] - Deactivated srpt Logical Unit from device object
> srpt_TPG[1]_LUN[2] - Deactivated srpt Logical Unit from device object
> srpt_TPG[2]_LUN[0] - Deactivated srpt Logical Unit from device object
> srpt_TPG[2]_LUN[1] - Deactivated srpt Logical Unit from device object
> srpt_TPG[2]_LUN[2] - Deactivated srpt Logical Unit from device object
> ib_srpt drop_tpg(mlx4_0, mlx4_0)
> ib_srpt drop_tpg(mlx4_1, mlx4_1)
> ib_srpt drop_tport(mlx4_0)
> ib_srpt drop_tport(mlx4_1)
> Target_Core_ConfigFS: DEREGISTER -> Looking up srpt in tf list
> Target_Core_ConfigFS: DEREGISTER -> located fabric: srpt
> Target_Core_ConfigFS: DEREGISTER -> Releasing tf->tf_fabric for srpt
> Target_Core_ConfigFS: DEREGISTER -> Releasing ci srpt
> Target_Core_ConfigFS: Calling se_free_virtual_device() for se_dev_ptr:
> ffff880063f02120
> Target_Core_ConfigFS: Deallocating se_subsystem_dev_t: ffff88006a914120
> Target_Core_ConfigFS: Calling se_free_virtual_device() for se_dev_ptr:
> ffff880063f00848
> Target_Core_ConfigFS: Deallocating se_subsystem_dev_t: ffff88006a070000
> Target_Core_ConfigFS: Calling se_free_virtual_device() for se_dev_ptr:
> ffff880063f018d8
> CORE_RD[0] - Released device space for Ramdisk Device ID: 0, pages 2 in 1
> tables total bytes 8192
> Target_Core_ConfigFS: Deallocating se_subsystem_dev_t: ffff88006a075168
> CORE_HBA[1] - Detached FILEIO HBA: 0 from Generic Target Core
> CORE_HBA[1] - Detached HBA from Generic Target Core
> CORE_HBA[3] - Detached FILEIO HBA: 1 from Generic Target Core
> CORE_HBA[3] - Detached HBA from Generic Target Core
> CORE_HBA[2] - Detached Ramdisk HBA: 0 from Generic Target Core
> CORE_HBA[2] - Detached HBA from Generic Target Core
> TARGET_CORE[Normal]: Deallocating srpt struct se_portal_group for endpoint:
> 0x2c9030005f34a Portal Tag 1
> general protection fault: 0000 [#1] PREEMPT SMP 
> last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
> CPU 0 
> Modules linked in: target_core_pscsi target_core_iblock target_core_file
> ib_srpt(-) target_core_mod netconsole configfs af_packet rdma_ucm rdma_cm iw_cm
> ib_addr ib_ipoib ib_cm ib_sa ib_uverbs ib_umad cpufreq_conservative
> cpufreq_userspace cpufreq_powersave acpi_cpufreq mlx4_ib ib_mad ib_core mperf
> loop dm_mod mlx4_core sr_mod i2c_i801 pcspkr sg cdrom intel_agp intel_gtt
> serio_raw i2c_core button uhci_hcd ehci_hcd usbcore rtc_cmos sd_mod crc_t10dif
> rtc_core rtc_lib edd ext3 mbcache jbd fan ata_generic ata_piix pata_marvell
> ahci libahci libata scsi_mod thermal processor thermal_sys hwmon [last
> unloaded: target_core_mod]
> 
> Pid: 7324, comm: tcm_cl_0 Not tainted 2.6.38-rc5-dbg+ #2 System manufacturer
> P5Q DELUXE/P5Q DELUXE
> RIP: 0010:[<ffffffff811f4bf0>]  [<ffffffff811f4bf0>] list_del+0x30/0x110
> RSP: 0018:ffff8800446b3e20  EFLAGS: 00010883
> RAX: dead000000200200 RBX: ffff880044760130 RCX: 6b6b6b6b6b6b6b6b
> RDX: ffff880044760130 RSI: ffff88006a1266e8 RDI: ffff880044760130
> RBP: ffff8800446b3e30 R08: 0000000000000000 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000000 R12: dead000000100100
> R13: ffff88006a1266d0 R14: ffff88006a1267c0 R15: ffff88006a1266d0
> FS:  0000000000000000(0000) GS:ffff88007ce00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007faf05a335e0 CR3: 000000003bdc8000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process tcm_cl_0 (pid: 7324, threadinfo ffff8800446b2000, task
> ffff88007180dfa0)
> Stack:
>  ffff8800447600c0 ffff88006a126670 ffff8800446b3e80 ffffffffa034a5a1
>  00000000001d2180 0000000000000286 ffff8800767d9320 ffff88006a126670
>  ffff8800446b3ec0 ffff88006a126670 ffffffffa034a820 0000000000000000
> Call Trace:
>  [<ffffffffa034a5a1>] __transport_clear_lun_from_sessions+0x61/0x2e0
> [target_core_mod]
>  [<ffffffffa034a820>] ? transport_clear_lun_thread+0x0/0x30 [target_core_mod]
>  [<ffffffffa034a836>] transport_clear_lun_thread+0x16/0x30 [target_core_mod]
>  [<ffffffffa034a820>] ? transport_clear_lun_thread+0x0/0x30 [target_core_mod]
>  [<ffffffff81070256>] kthread+0xa6/0xb0
>  [<ffffffff81003d54>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8103e170>] ? finish_task_switch+0x80/0xe0
>  [<ffffffff813cb97b>] ? _raw_spin_unlock_irq+0x3b/0x60
>  [<ffffffff813cbfc4>] ? restore_args+0x0/0x30
>  [<ffffffff810701b0>] ? kthread+0x0/0xb0
>  [<ffffffff81003d50>] ? kernel_thread_helper+0x0/0x10
> Code: 54 49 bc 00 01 10 00 00 00 ad de 53 48 89 fb 4c 39 27 0f 84 9a 00 00 00
> 48 8b 4b 08 48 b8 00 02 20 00 00 00 ad de 48 39 c1 74 48 <4c> 8b 01 4c 39 c3 75
> 60 48 8b 03 4c 8b 40 08 4c 39 c3 0f 85 96 
> RIP  [<ffffffff811f4bf0>] list_del+0x30/0x110
>  RSP <ffff8800446b3e20>
> ---[ end trace a00acd2001b8e456 ]---
> note: tcm_cl_0[7324] exited with preempt_count 1

Ok, this is currently happening with for normal idle shutdown after pushing
sustained I/O, yes..?

Also, this issue within __transport_clear_lun_from_sessions() may be related to
the incorrect usage of TFO->check_stop_free() usage in the mentioned previous
email, or related to demo-mode MappedLUN access.  Please verify your running
/sys/kernel/config/target/srpt layout and will look at reproducing..

Thanks,

--nab

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
