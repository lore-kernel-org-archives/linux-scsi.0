From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Fri, 21 Apr 2017 21:17:32 +0000
Message-ID: <1492809452.2499.2.camel@sandisk.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:50941 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1039992AbdDUVRg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 17:17:36 -0400
In-Reply-To: <20170421211302.2667649-1-songliubraving@fb.com>
Content-Language: en-US
Content-ID: <783D041D2765B1418EF759D427B150FC@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "songliubraving@fb.com" <songliubraving@fb.com>
Cc: "hch@infradead.org" <hch@infradead.org>

On Fri, 2017-04-21 at 14:13 -0700, Song Liu wrote:
> When a device is deleted through sysfs handle "delete", [ ... ]

If I try to use that sysfs attribute then I encounter a deadlock (see
also the report below). How is it possible that you have not hit that
deadlock in your tests?

Bart.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ INFO: possible circular locking dependency detected ]
4.11.0-rc6-dbg+ #3 Tainted: G=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0I=A0=A0=A0=A0
-------------------------------------------------------
bash/7858 is trying to acquire lock:
=A0(&shost->scan_mutex){+.+.+.}, at: [<ffffffff814de090>] scsi_remove_devic=
e+0x20/0x40

but task is already holding lock:
=A0(s_active#326){++++.+}, at: [<ffffffff81293e20>] kernfs_remove_self+0xe0=
/0x140

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (s_active#326){++++.+}:
=A0=A0=A0=A0=A0=A0=A0lock_acquire+0xd5/0x1c0
=A0=A0=A0=A0=A0=A0=A0__kernfs_remove+0x248/0x310
=A0=A0=A0=A0=A0=A0=A0kernfs_remove_by_name_ns+0x45/0xa0
=A0=A0=A0=A0=A0=A0=A0remove_files.isra.1+0x35/0x70
=A0=A0=A0=A0=A0=A0=A0sysfs_remove_group+0x44/0x90
=A0=A0=A0=A0=A0=A0=A0sysfs_remove_groups+0x2e/0x50
=A0=A0=A0=A0=A0=A0=A0device_remove_attrs+0x5e/0x80
=A0=A0=A0=A0=A0=A0=A0device_del+0x1fd/0x320
=A0=A0=A0=A0=A0=A0=A0__scsi_remove_device+0xe9/0x120
=A0=A0=A0=A0=A0=A0=A0scsi_forget_host+0x60/0x70
=A0=A0=A0=A0=A0=A0=A0scsi_remove_host+0x71/0x110
=A0=A0=A0=A0=A0=A0=A00xffffffffa0703690
=A0=A0=A0=A0=A0=A0=A0process_one_work+0x20b/0x6a0
=A0=A0=A0=A0=A0=A0=A0worker_thread+0x4e/0x4a0
=A0=A0=A0=A0=A0=A0=A0kthread+0x113/0x150
=A0=A0=A0=A0=A0=A0=A0ret_from_fork+0x2e/0x40

-> #0 (&shost->scan_mutex){+.+.+.}:
=A0=A0=A0=A0=A0=A0=A0__lock_acquire+0x1109/0x1280
=A0=A0=A0=A0=A0=A0=A0lock_acquire+0xd5/0x1c0
=A0=A0=A0=A0=A0=A0=A0__mutex_lock+0x83/0x980
=A0=A0=A0=A0=A0=A0=A0mutex_lock_nested+0x1b/0x20
=A0=A0=A0=A0=A0=A0=A0scsi_remove_device+0x20/0x40
=A0=A0=A0=A0=A0=A0=A0sdev_store_delete+0x27/0x30
=A0=A0=A0=A0=A0=A0=A0dev_attr_store+0x18/0x30
=A0=A0=A0=A0=A0=A0=A0sysfs_kf_write+0x45/0x60
=A0=A0=A0=A0=A0=A0=A0kernfs_fop_write+0x13c/0x1c0
=A0=A0=A0=A0=A0=A0=A0__vfs_write+0x28/0x140
=A0=A0=A0=A0=A0=A0=A0vfs_write+0xc8/0x1e0
=A0=A0=A0=A0=A0=A0=A0SyS_write+0x49/0xa0
=A0=A0=A0=A0=A0=A0=A0entry_SYSCALL_64_fastpath+0x18/0xad

other info that might help us debug this:

=A0Possible unsafe locking scenario:

=A0=A0=A0=A0=A0=A0=A0CPU0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0CPU1
=A0=A0=A0=A0=A0=A0=A0----=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0----
=A0 lock(s_active#326);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0lock(&shost->scan_mutex);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0lock(s_active#326);
=A0 lock(&shost->scan_mutex);

=A0*** DEADLOCK ***

3 locks held by bash/7858:
=A0#0:=A0=A0(sb_writers#4){.+.+.+}, at: [<ffffffff81206b45>] vfs_write+0x19=
5/0x1e0
=A0#1:=A0=A0(&of->mutex){+.+.+.}, at: [<ffffffff81294af6>] kernfs_fop_write=
+0x106/0x1c0
=A0#2:=A0=A0(s_active#326){++++.+}, at: [<ffffffff81293e20>] kernfs_remove_=
self+0xe0/0x140

stack backtrace:
CPU: 3 PID: 7858 Comm: bash Tainted: G=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0I=A0=A0=
=A0=A0=A04.11.0-rc6-dbg+ #3
Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
Call Trace:
=A0dump_stack+0x68/0x93
=A0print_circular_bug+0x1be/0x210
=A0__lock_acquire+0x1109/0x1280
=A0lock_acquire+0xd5/0x1c0
=A0__mutex_lock+0x83/0x980
=A0mutex_lock_nested+0x1b/0x20
=A0scsi_remove_device+0x20/0x40
=A0sdev_store_delete+0x27/0x30
=A0dev_attr_store+0x18/0x30
=A0sysfs_kf_write+0x45/0x60
=A0kernfs_fop_write+0x13c/0x1c0
=A0__vfs_write+0x28/0x140
=A0vfs_write+0xc8/0x1e0
=A0SyS_write+0x49/0xa0
=A0entry_SYSCALL_64_fastpath+0x18/0xad
RIP: 0033:0x7fec0f748500
RSP: 002b:00007ffc1ddaec98 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fec0f748500
RDX: 0000000000000002 RSI: 0000000002012aa0 RDI: 0000000000000001
RBP: 00007ffc1ddaebf0 R08: 00007fec0fa0a740 R09: 00007fec10061100
R10: 0000000000000098 R11: 0000000000000246 R12: 00007fec10084bf0
R13: 0000000000000001 R14: 0000000000000000 R15: 00007ffc1ddaec18
