From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: crash in iscsi/scsi initiator with linux-4.15.0-rc1
Date: Fri, 01 Dec 2017 13:32:55 -0500
Message-ID: <1512153175.30220.76.camel@localhost.localdomain>
References: <000201d36ac5$dc96d390$95c47ab0$@opengridcomputing.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47335 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751208AbdLASc4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Dec 2017 13:32:56 -0500
In-Reply-To: <000201d36ac5$dc96d390$95c47ab0$@opengridcomputing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2017-12-01 at 11:00 -0600, Steve Wise wrote:
> Hey,
> 
> I'm  seeing this null pointer dereference with linux-4.15.0-rc1.  To reproduce
> it, I connect two ram disks via iscsi/TCP, and start an fio:
> 
> iscsiadm -m discovery --op update --type sendtargets -p 172.16.1.10:3260
> iscsiadm -m node -p 172.16.1.10:3260 -l
> ISCSI_DISKS=/dev/sdd:/dev/sde; fio --rw=randrw --name=random --norandommap
> --ioengine=libaio --size=400m --group_reporting --exitall --fsync_on_close=1
> --invalidate=1 --direct=1 --filename=$ISCSI_DISKS --time_based --runtime=300
> --iodepth=128 --numjobs=8 --unit_base=1 --bs=64k --kb_base=1000
> 
> Then on the initiator node, while the fio test is running, I detach the devices:
> 
> iscsiadm -m node -p 172.16.1.10:3260 -I iser -u
> 
> Then I hit this crash.  Has anyone else encountered this issue?  Wondering if
> there is a fix handy. :)
> 

This is the same problem that is being discussed under the thread:
"[PATCH] scsi: fix race condition when removing target".

We had good test results with both Jason Yan's patch and Bart's patch
applied, however the ultimate solution is still in progress, see James'
comments.

You could also try reverting fbce4d97fd "scsi: fixup kernel warning
during rmmod()" if you just need to get past this.

-Ewan

> Thanks,
> 
> Steve.
> 
> ----
> 
> [  127.175953] scsi 8:0:0:0: alua: Detached
> [  127.175955] scsi 8:0:0:0: alua: Detached
> [  127.175981] ------------[ cut here ]------------
> [  127.175984] list_del corruption. prev->next should be ffff8803382f1240, but
> was ffff88039ab0f780
> [  127.176010] WARNING: CPU: 5 PID: 373 at lib/list_debug.c:53
> __list_del_entry_valid+0x7c/0xa0
> [  127.176011] Modules linked in: iscsi_tcp libiscsi_tcp rpcrdma ib_isert
> iscsi_target_mod libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp
> scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm
> iw_cm libcxgb mlx5_ib ext4 ib_core dm_mirror dm_region_hash dm_log dm_mod
> mbcache jbd2 coretemp kvm iTCO_wdt ppdev irqbypass iTCO_vendor_support gpio_ich
> i2c_i801 pcspkr lpc_ich parport_pc i5400_edac sg parport i5k_amb shpchp nfsd
> auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod nouveau
> cdrom sd_mod ata_generic pata_acpi video mxm_wmi wmi drm_kms_helper syscopyarea
> sysfillrect sysimgblt fb_sys_fops ttm mlx5_core drm igb cxgb4 ahci firewire_ohci
> ata_piix libahci firewire_core dca i2c_algo_bit devlink libata ptp serio_raw
> i2c_core crc_itu_t pps_core [last unloaded: ib_iser]
> [  127.176055] CPU: 5 PID: 373 Comm: kworker/u16:4 Not tainted 4.15.0-rc1+ #6
> [  127.176056] Hardware name: Supermicro X7DWA/X7DWA, BIOS 6.00 12/21/2007
> [  127.176074] Workqueue: scsi_wq_9 __iscsi_unbind_session
> [scsi_transport_iscsi]
> [  127.176075] task: ffff88039a498000 task.stack: ffffc90002880000
> [  127.176076] RIP: 0010:__list_del_entry_valid+0x7c/0xa0
> [  127.176076] RSP: 0018:ffffc90002883d38 EFLAGS: 00010082
> [  127.176077] RAX: 0000000000000000 RBX: ffff8803382f1240 RCX: 0000000000000000
> [  127.176078] RDX: 0000000000000001 RSI: 0000000000000002 RDI: 0000000000000092
> [  127.176079] RBP: ffff8803982129c0 R08: 0000000000000054 R09: ffffffff823d60e0
> [  127.176079] R10: 0000000000000473 R11: 0000000000000000 R12: ffff880398212800
> [  127.176080] R13: ffff880396701800 R14: ffff880396701800 R15: ffff8801afc31000
> [  127.176081] FS:  0000000000000000(0000) GS:ffff8803bfd40000(0000)
> knlGS:0000000000000000
> [  127.176082] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  127.176083] CR2: 00007f6a80028038 CR3: 000000039a957000 CR4: 00000000000006e0
> [  127.176084] Call Trace:
> [  127.176091]  alua_bus_detach+0x5c/0xc0
> [  127.176095]  scsi_dh_release_device+0x18/0x50
> [  127.176098]  scsi_device_dev_release_usercontext+0x25/0x230
> [  127.176107]  execute_in_process_context+0x58/0x60
> [  127.176110]  device_release+0x2d/0x80
> [  127.176113]  kobject_cleanup+0x5e/0x180
> [  127.176115]  scsi_remove_target+0x16b/0x1b0
> [  127.176119]  __iscsi_unbind_session+0xb3/0x160 [scsi_transport_iscsi]
> [  127.176121]  process_one_work+0x141/0x340
> [  127.176123]  worker_thread+0x47/0x3e0
> [  127.176124]  kthread+0xf5/0x130
> [  127.176126]  ? rescuer_thread+0x380/0x380
> [  127.176127]  ? kthread_associate_blkcg+0x90/0x90
> [  127.176129]  ret_from_fork+0x1f/0x30
> [  127.176130] Code: ff 31 c0 c3 48 89 fe 31 c0 48 c7 c7 60 19 a9 81 e8 3a 33 d0
> ff 0f ff 31 c0 c3 48 89 fe 31 c0 48 c7 c7 20 19 a9 81 e8 24 33 d0 ff <0f> ff 31
> c0 c3 48 89 fe 31 c0 48 c7 c7 e8 18 a9 81 e8 0e 33 d0
> [  127.176145] ---[ end trace e7e378e0f32966e0 ]---
> [  127.176148] scsi 9:0:0:0: alua: Detached
> [  127.466362] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [  127.474355] IP: _raw_spin_lock_irqsave+0x1e/0x40
> [  127.479136] PGD 399e70067 P4D 399e70067 PUD 3966cd067 PMD 0
> [  127.484961] Oops: 0002 [#1] SMP
> [  127.488269] Modules linked in: iscsi_tcp libiscsi_tcp rpcrdma ib_isert
> iscsi_target_mod libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp
> scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm
> iw_cm libcxgb mlx5_ib ext4 ib_core dm_mirror dm_region_hash dm_log dm_mod
> mbcache jbd2 coretemp kvm iTCO_wdt ppdev irqbypass iTCO_vendor_support gpio_ich
> i2c_i801 pcspkr lpc_ich parport_pc i5400_edac sg parport i5k_amb shpchp nfsd
> auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod nouveau
> cdrom sd_mod ata_generic pata_acpi video mxm_wmi wmi drm_kms_helper syscopyarea
> sysfillrect sysimgblt fb_sys_fops ttm mlx5_core drm igb cxgb4 ahci firewire_ohci
> ata_piix libahci firewire_core dca i2c_algo_bit devlink libata ptp serio_raw
> i2c_core crc_itu_t pps_core [last unloaded: ib_iser]
> [  127.565494] CPU: 0 PID: 374 Comm: kworker/u16:5 Tainted: G        W
> 4.15.0-rc1+ #6
> [  127.573846] Hardware name: Supermicro X7DWA/X7DWA, BIOS 6.00 12/21/2007
> [  127.580649] Workqueue: scsi_wq_8 __iscsi_unbind_session
> [scsi_transport_iscsi]
> [  127.588054] task: ffff88039a4995c0 task.stack: ffffc90002888000
> [  127.594138] RIP: 0010:_raw_spin_lock_irqsave+0x1e/0x40
> [  127.599433] RSP: 0018:ffffc9000288bd68 EFLAGS: 00010046
> [  127.604819] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000000000000
> [  127.612129] RDX: 0000000000000001 RSI: ffff8803bfc0e038 RDI: 0000000000000000
> [  127.619427] RBP: ffff880396700f28 R08: 0000000000000000 R09: 0000000000000496
> [  127.626768] R10: 0000000000000000 R11: 0000000000000010 R12: ffff88033ab43900
> [  127.634067] R13: ffff88033997f000 R14: ffff880396700800 R15: ffff88033997f000
> [  127.641390] FS:  0000000000000000(0000) GS:ffff8803bfc00000(0000)
> knlGS:0000000000000000
> [  127.649667] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  127.655579] CR2: 0000000000000000 CR3: 0000000396042000 CR4: 00000000000006f0
> [  127.662890] Call Trace:
> [  127.665521]  scsi_device_dev_release_usercontext+0x40/0x230
> [  127.671273]  execute_in_process_context+0x58/0x60
> [  127.676144]  device_release+0x2d/0x80
> [  127.679987]  kobject_cleanup+0x5e/0x180
> [  127.684005]  scsi_remove_target+0x16b/0x1b0
> [  127.688356]  __iscsi_unbind_session+0xb3/0x160 [scsi_transport_iscsi]
> [  127.694972]  process_one_work+0x141/0x340
> [  127.699179]  worker_thread+0x47/0x3e0
> [  127.703018]  kthread+0xf5/0x130
> [  127.706330]  ? rescuer_thread+0x380/0x380
> [  127.710504]  ? kthread_associate_blkcg+0x90/0x90
> [  127.715321]  ret_from_fork+0x1f/0x30
> [  127.719083] Code: f4 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 53 9c
> 58 66 66 90 66 90 48 89 c3 fa 66 66 90 66 66 90 31 c0 ba 01 00 00 00 <f0> 0f b1
> 17 85 c0 75 05 48 89 d8 5b c3 89 c6 e8 77 63 98 ff eb
> [  127.738870] RIP: _raw_spin_lock_irqsave+0x1e/0x40 RSP: ffffc9000288bd68
> [  127.745673] CR2: 0000000000000000
> 
