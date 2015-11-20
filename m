From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux kernel security issuse scsi_report_lun_scan report
Date: Fri, 20 Nov 2015 10:14:13 -0800
Message-ID: <CA+55aFyn44rDnv3E9sSg_YGfeqhExvGz8yeAANU-BVghDHRFdA@mail.gmail.com>
References: <8159e011-35a9-4952-a0ef-be4dfb13983f.chengmiao.cj@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35022 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759590AbbKTSOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2015 13:14:14 -0500
Received: by ioc74 with SMTP id 74so131540302ioc.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2015 10:14:14 -0800 (PST)
In-Reply-To: <8159e011-35a9-4952-a0ef-be4dfb13983f.chengmiao.cj@alibaba-inc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ I don't know if the original reporter ended up actually sending this
to the scsi list like Greg asked, so I'll forward it myself just in
case ]

There seems to be a very old use-after-free in the scsi code (git
blame says the lines around this area are from 2005 and 2008) that
kasan reports.

I've tried to clean up the formatting in the email a bit, but the
executive summary seems to be that this:

drivers/scsi/scsi_scan.c, around line 1459:

        scsi_device_put(sdev);
        if (scsi_device_created(sdev))

is just wrong, because the "scsi_device_put()" may be freeing the
sdev, so then doing "scsi_device_created(sdev)" after it is bogus.

                     Linus

On Wed, Nov 18, 2015 at 5:15 AM, =E7=A8=8B=E5=90=9B(=E6=88=90=E6=B7=BC)=
 <chengmiao.cj@alibaba-inc.com> wrote:
>
> Dear all:
>              we find one security issuse in kernel 4.3.0=EF=BC=8Caslo=
 check the
> lastest code=EF=BC=8Cplease check , thanks.
>
>             1.user-after-free in scsi_report_lun_scan
>
> CPU: 0 PID: 1 Comm: swapper/0 Tainted: G  B      4.3.0+ #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/20=
14
> Call Trace:
>  scsi_device_created include/scsi/scsi_device.h:460
>  scsi_report_lun_scan+0x28b/0x434 drivers/scsi/scsi_scan.c:1459
>  device_release+0x44/0xde drivers/base/core.c:247
>  scsi_device_created include/scsi/scsi_device.h:460
>  scsi_report_lun_scan+0x28b/0x434 drivers/scsi/scsi_scan.c:1459
>  scsi_probe_and_add_lun+0xe4f/0xe4f drivers/scsi/scsi_scan.c:1053
>  scsi_free_host_dev+0x4d/0x4d drivers/scsi/scsi_scan.c:1921
>  __raw_callee_save___pv_queued_spin_unlock+0x11/0x1e ??:?
>  __scsi_scan_target+0x16f/0x293 drivers/scsi/scsi_scan.c:1563
>  scsi_add_device+0x20/0x20 drivers/scsi/scsi_scan.c:1513
>  __pm_runtime_idle+0x5c/0x5c drivers/base/power/runtime.c:904
>  __raw_callee_save___pv_queued_spin_unlock+0x11/0x1e ??:?
>  scsi_scan_channel+0x81/0x8f drivers/scsi/scsi_scan.c:1641
>  scsi_scan_host_selected+0x144/0x161 drivers/scsi/scsi_scan.c:1669
>  scsi_scan_host+0xa5/0x21d drivers/scsi/scsi_scan.c:1837
>  virtscsi_probe+0x4c8/0x50b drivers/scsi/virtio_scsi.c:1032
>  virtscsi_init+0x392/0x392 drivers/scsi/virtio_scsi.c:908
>  kernfs_type include/linux/kernfs.h:239
>  kernfs_leftmost_descendant+0x12/0x36 fs/kernfs/dir.c:970
>  kernfs_activate+0x30/0xea fs/kernfs/dir.c:1036
>  mutex_clear_owner kernel/locking/mutex.h:27
>  mutex_unlock+0x12/0x2a kernel/locking/mutex.c:435
>  kernfs_add_one+0x20d/0x21f fs/kernfs/dir.c:647
>  __virtio_clear_bit include/linux/virtio_config.h:135
>  vring_transport_features+0x3f/0x55 drivers/virtio/virtio_ring.c:786
>  vp_finalize_features+0x49/0x4e drivers/virtio/virtio_pci_legacy.c:44
>  virtio_dev_probe+0x163/0x2d0 drivers/virtio/virtio.c:235
>  really_probe drivers/base/dd.c:316
>  driver_probe_device+0x25d/0x378 drivers/base/dd.c:429
>  really_probe drivers/base/dd.c:368
>  driver_probe_device+0x378/0x378 drivers/base/dd.c:429
>  __driver_attach+0x6d/0xae drivers/base/dd.c:642
>  bus_for_each_dev+0x106/0x10a drivers/base/bus.c:314
>  next_device+0x24/0x24 drivers/base/bus.c:280
>  __raw_callee_save___pv_queued_spin_unlock+0x11/0x1e ??:?
>  bus_add_driver+0x269/0x2bc drivers/base/bus.c:708
>  initcall_blacklist+0xbe/0xbe init/main.c:726
>  driver_register+0x103/0x144 drivers/base/driver.c:168
>  scsi_init_sysctl+0x1d/0x1d drivers/scsi/scsi_sysctl.c:46
>  init+0xaf/0xb9 net/ipv4/netfilter/nf_nat_h323.c:590
>  scsi_init_sysctl+0x1d/0x1d drivers/scsi/scsi_sysctl.c:46
>  do_one_initcall+0x9d/0x1f4 init/main.c:794
>  try_to_run_init_process+0x2f/0x2f init/main.c:928
>  parse_args+0x4b/0x3ab kernel/params.c:234
> Memory state around the buggy address:
> ffff88006984d000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88006984d080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>ffff88006984d100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                          ^
> ffff88006984d180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88006984d200: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>
> INFO: Allocated in scsi_alloc_sdev+0x7c/0x56e age=3D4 cpu=3D0 pid=3D1
>   set_track+0x6d/0x108 mm/slub.c:528
>   alloc_debug_processing+0xaf/0x142 mm/slub.c:1049
>   __slab_alloc+0x3e0/0x4b8 mm/slub.c:2402
>   kmalloc include/linux/slab.h:445
>   kzalloc include/linux/slab.h:593
>   scsi_alloc_sdev+0x7c/0x56e drivers/scsi/scsi_scan.c:218
>   init_object+0x2d/0x5e mm/slub.c:681
>   __raw_callee_save___pv_queued_spin_unlock+0x11/0x1e ??:?
>   scsi_probe_and_add_lun+0xe3d/0xe4f drivers/scsi/scsi_scan.c:1178
>   slab_alloc_node mm/slub.c:2470
>   slab_alloc mm/slub.c:2512
>   __kmalloc+0x84/0x169 mm/slub.c:3417
>   slab_alloc_node mm/slub.c:2470
>   slab_alloc mm/slub.c:2512
>   __kmalloc+0x84/0x169 mm/slub.c:3417
>   kmalloc include/linux/slab.h:445
>   kzalloc include/linux/slab.h:593
>   scsi_alloc_sdev+0x7c/0x56e drivers/scsi/scsi_scan.c:218
>   scsi_report_lun_scan+0x17f/0x434 drivers/scsi/scsi_scan.c:1328
>   scsi_report_lun_scan+0x0/0x434 drivers/scsi/scsi_scan.c:1053
>   scsi_probe_and_add_lun+0x0/0xe4f drivers/scsi/scsi_scan.c:1921
>   rpm_resume+0x0/0x6e6 drivers/base/power/runtime.c:904
>   virtscsi_target_alloc+0xa0/0xca drivers/scsi/virtio_scsi.c:749
>   kobject_get+0x12/0x74 lib/kobject.c:580
>
> INFO: Freed in scsi_device_dev_release_usercontext+0x23d/0x2d7 age=3D=
4 cpu=3D0 pid=3D1
>   free_debug_processing+0x188/0x207 mm/slub.c:1108
>   scsi_device_dev_release_usercontext+0x23d/0x2d7 drivers/scsi/scsi_s=
ysfs.c:429
>   __slab_free+0x4a/0x27a mm/slub.c:2587
>   mempool_free_slab+0x0/0x13 mm/mempool.c:453
>   ida_remove+0xc6/0x159 lib/idr.c:1042
>   __raw_callee_save___pv_queued_spin_unlock+0x11/0x1e ??:?
>   __read_once_size include/linux/compiler.h:218
>   atomic_read ./arch/x86/include/asm/atomic.h:27
>   __rcu_is_watching+0x18/0x1f kernel/rcu/tree.c:987
>   scsi_device_dev_release_usercontext+0x23d/0x2d7 drivers/scsi/scsi_s=
ysfs.c:429
>   scsi_device_dev_release_usercontext+0x23d/0x2d7 drivers/scsi/scsi_s=
ysfs.c:429
>   scsi_device_dev_release_usercontext+0x0/0x2d7 drivers/scsi/scsi_sys=
fs.c:438
>   execute_in_process_context+0x24/0x82 kernel/workqueue.c:2969
>   device_release+0x44/0xde drivers/base/core.c:247
>   kobject_cleanup lib/kobject.c:631
>   kobject_release lib/kobject.c:660
>   kref_sub include/linux/kref.h:74
>   kref_put include/linux/kref.h:99
>   kobject_put+0xbc/0xcf lib/kobject.c:677
>   scsi_report_lun_scan+0x27f/0x434 drivers/scsi/scsi_scan.c:1458
>   scsi_report_lun_scan+0x0/0x434 drivers/scsi/scsi_scan.c:1053
>   scsi_probe_and_add_lun+0x0/0xe4f drivers/scsi/scsi_scan.c:1921
>
>              in drivers/scsi/scsi_sysfs.c:429 release sdev object=EF=BC=
=8Cso kasan
> tips us use after free  read in scsi_device_created functions
>
>        Best regards
>        Berry Cheng @ Alibaba mobile security Team
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
