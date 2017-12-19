From: "Ewan D. Milne" <emilne@redhat.com>
Subject: RE: crash in iscsi/scsi initiator with linux-4.15.0-rc1
Date: Tue, 19 Dec 2017 15:20:13 -0500
Message-ID: <1513714813.10760.153.camel@localhost.localdomain>
References: <000201d36ac5$dc96d390$95c47ab0$@opengridcomputing.com>
         <1512153175.30220.76.camel@localhost.localdomain>
         <014a01d378ff$f42c3d90$dc84b8b0$@opengridcomputing.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750825AbdLSUUO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Dec 2017 15:20:14 -0500
In-Reply-To: <014a01d378ff$f42c3d90$dc84b8b0$@opengridcomputing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-scsi@vger.kernel.org, yanaijie@huawei.com, Bart.VanAssche@wdc.com

On Tue, 2017-12-19 at 13:31 -0600, Steve Wise wrote:
> > > Hey,
> > >
> > > I'm  seeing this null pointer dereference with linux-4.15.0-rc1.  To reproduce
> > > it, I connect two ram disks via iscsi/TCP, and start an fio:
> > >
> > > iscsiadm -m discovery --op update --type sendtargets -p 172.16.1.10:3260
> > > iscsiadm -m node -p 172.16.1.10:3260 -l
> > > ISCSI_DISKS=/dev/sdd:/dev/sde; fio --rw=randrw --name=random --
> > norandommap
> > > --ioengine=libaio --size=400m --group_reporting --exitall --fsync_on_close=1
> > > --invalidate=1 --direct=1 --filename=$ISCSI_DISKS --time_based --runtime=300
> > > --iodepth=128 --numjobs=8 --unit_base=1 --bs=64k --kb_base=1000
> > >
> > > Then on the initiator node, while the fio test is running, I detach the devices:
> > >
> > > iscsiadm -m node -p 172.16.1.10:3260 -I iser -u
> > >
> > > Then I hit this crash.  Has anyone else encountered this issue?  Wondering if
> > > there is a fix handy. :)
> > >
> > 
> > This is the same problem that is being discussed under the thread:
> > "[PATCH] scsi: fix race condition when removing target".
> > 
> > We had good test results with both Jason Yan's patch and Bart's patch
> > applied, however the ultimate solution is still in progress, see James'
> > comments.
> > 
> > You could also try reverting fbce4d97fd "scsi: fixup kernel warning
> > during rmmod()" if you just need to get past this.
> > 
> > -Ewan
> > 
> 
> Hey Ewan, Yan, Bart, 
> 
> I'm still seeing this issue with 4.15-rc4.  Is the issue still outstanding?  
> 
> Steve.
> 

Please apply the following commit from the 4.15/scsi-fixes branch of

git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git

and advise if it does not fix your issue.  It should.

----

commit 81b6c999897919d5a16fedc018fe375dbab091c5
Author: Hannes Reinecke <hare@suse.de>
Date:   Wed Dec 13 14:21:37 2017 +0100

    scsi: core: check for device state in __scsi_remove_target()
    
    As it turned out device_get() doesn't use kref_get_unless_zero(), so we
    will be always getting a device pointer.  Consequently, we need to check
    for the device state in __scsi_remove_target() to avoid tripping over
    deleted objects.
    
    Fixes: fbce4d97fd43 ("scsi: fixup kernel warning during rmmod()")
    Reported-by: Jason Yan <yanaijie@huawei.com>
    Signed-off-by: Hannes Reinecke <hare@suse.com>
    Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
    Reviewed-by: Ewan D. Milne <emilne@redhat.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

> ---
> 
> [ 1002.205103] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [ 1002.213022] IP: _raw_spin_lock_irqsave+0x1e/0x40
> [ 1002.217740] PGD 0 P4D 0
> [ 1002.220382] Oops: 0002 [#1] SMP
> [ 1002.223637] Modules linked in: iw_cxgb4 cxgb4 nvme_rdma nvme_fabrics rdma_ktest(O) rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core libcxgb vfat intel_rapl fat iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd glue_helper cryptd iTCO_wdt iTCO_vendor_support mxm_wmi mei_me ipmi_si lpc_ich mei pcspkr i2c_i801 mfd_core ipmi_devintf shpchp sg ipmi_msghandler wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 mbcache jbd2 mlx4_en mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm sd_mod igb drm ahci libahci dc
 a mlx4_core
> [ 1002.295663]  ptp libata pps_core crc32c_intel nvme i2c_algo_bit i2c_core nvme_core [last unloaded: cxgb4]
> [ 1002.305563] CPU: 4 PID: 5156 Comm: fio Tainted: G           O     4.15.0-rc4 #3
> [ 1002.313223] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.2a 07/09/2015
> [ 1002.320555] RIP: 0010:_raw_spin_lock_irqsave+0x1e/0x40
> [ 1002.326077] RSP: 0018:ffffc900070cbd10 EFLAGS: 00010046
> [ 1002.331692] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000000000000
> [ 1002.339225] RDX: 0000000000000001 RSI: ffff88085fd0e038 RDI: 0000000000000000
> [ 1002.346763] RBP: ffff880855a65f18 R08: 0000000000000000 R09: 0000000000000744
> [ 1002.354315] R10: 00000000000003ff R11: 0000000000000001 R12: ffff88084992e180
> [ 1002.361873] R13: ffff880855a67000 R14: ffff880855a65800 R15: ffff880856d7d5a8
> [ 1002.369447] FS:  0000000000000000(0000) GS:ffff88085fd00000(0000) knlGS:0000000000000000
> [ 1002.377995] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1002.384209] CR2: 0000000000000000 CR3: 0000000001c09005 CR4: 00000000000606e0
> [ 1002.391826] Call Trace:
> [ 1002.394774]  scsi_device_dev_release_usercontext+0x40/0x230
> [ 1002.400858]  execute_in_process_context+0x58/0x60
> [ 1002.406085]  device_release+0x2d/0x80
> [ 1002.410277]  kobject_cleanup+0x5e/0x180
> [ 1002.414659]  scsi_disk_put+0x2b/0x40 [sd_mod]
> [ 1002.419559]  __blkdev_put+0x1b5/0x1d0
> [ 1002.423777]  ? disk_flush_events+0x24/0x60
> [ 1002.428430]  blkdev_close+0x21/0x30
> [ 1002.432484]  __fput+0xd5/0x210
> [ 1002.436111]  task_work_run+0x82/0xa0
> [ 1002.440262]  do_exit+0x2be/0xb20
> [ 1002.444074]  ? syscall_trace_enter+0x1af/0x290
> [ 1002.449110]  do_group_exit+0x39/0xa0
> [ 1002.453287]  SyS_exit_group+0x10/0x10
> [ 1002.457557]  do_syscall_64+0x61/0x1a0
> [ 1002.461829]  entry_SYSCALL64_slow_path+0x25/0x25
> [ 1002.467064] RIP: 0033:0x7f9abb1c8529
> [ 1002.471266] RSP: 002b:00007ffe53be40d8 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
> [ 1002.479482] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007f9abb1c8529
> [ 1002.487279] RDX: 0000000000000005 RSI: 000000000000000a RDI: 0000000000000005
> [ 1002.495079] RBP: 00007f9a9c9de818 R08: 000000000000003c R09: 00000000000000e7
> [ 1002.502882] R10: ffffffffffffff60 R11: 0000000000000206 R12: 0000000000000006
> [ 1002.510690] R13: 0000000000000006 R14: 0000000000000000 R15: 000000000172a440
> [ 1002.518497] Code: f4 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 53 9c 58 66 66 90 66 90 48 89 c3 fa 66 66 90 66 66 90 31 c0 ba 01 00 00 00 <f0> 0f b1 17 85 c0 75 05 48 89 d8 5b c3 89 c6 e8 77 06 9e ff eb
> [ 1002.538742] RIP: _raw_spin_lock_irqsave+0x1e/0x40 RSP: ffffc900070cbd10
> [ 1002.546055] CR2: 0000000000000000
> 
> 
> ---
> This email has been checked for viruses by AVG.
> http://www.avg.com
> 
