From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Thu, 26 Jul 2018 14:50:20 +0200
Message-ID: <CAD+HZHW5ee385yfnrPJob5mVXHn=f9hKfdqbmbGdv-8JfZ5Dtg@mail.gmail.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180725173828.2227-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, ebiederm@xmission.com, tj@kernel.org, hare@suse.com, Johannes Thumshirn <jthumshirn@suse.de>, mingo@kernel.org, oleg@redhat.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche <bart.vanassche@wdc.com> =E4=BA=8E2018=E5=B9=B47=E6=9C=8825=
=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=887:39=E5=86=99=E9=81=93=EF=BC=
=9A
>
> This patch avoids that self-removal triggers the following deadlock:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> 4.18.0-rc2-dbg+ #5 Not tainted
> ------------------------------------------------------
> modprobe/6539 is trying to acquire lock:
> 000000008323c4cd (kn->count#202){++++}, at: kernfs_remove_by_name_ns+0x45=
/0x90
>
> but task is already holding lock:
> 00000000a6ec2c69 (&shost->scan_mutex){+.+.}, at: scsi_remove_host+0x21/0x=
150 [scsi_mod]
>
> which lock already depends on the new lock.
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&shost->scan_mutex){+.+.}:
>        __mutex_lock+0xfe/0xc70
>        mutex_lock_nested+0x1b/0x20
>        scsi_remove_device+0x26/0x40 [scsi_mod]
>        sdev_store_delete+0x27/0x30 [scsi_mod]
>        dev_attr_store+0x3e/0x50
>        sysfs_kf_write+0x87/0xa0
>        kernfs_fop_write+0x190/0x230
>        __vfs_write+0xd2/0x3b0
>        vfs_write+0x101/0x270
>        ksys_write+0xab/0x120
>        __x64_sys_write+0x43/0x50
>        do_syscall_64+0x77/0x230
>        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> -> #0 (kn->count#202){++++}:
>        lock_acquire+0xd2/0x260
>        __kernfs_remove+0x424/0x4a0
>        kernfs_remove_by_name_ns+0x45/0x90
>        remove_files.isra.1+0x3a/0x90
>        sysfs_remove_group+0x5c/0xc0
>        sysfs_remove_groups+0x39/0x60
>        device_remove_attrs+0x82/0xb0
>        device_del+0x251/0x580
>        __scsi_remove_device+0x19f/0x1d0 [scsi_mod]
>        scsi_forget_host+0x37/0xb0 [scsi_mod]
>        scsi_remove_host+0x9b/0x150 [scsi_mod]
>        sdebug_driver_remove+0x4b/0x150 [scsi_debug]
>        device_release_driver_internal+0x241/0x360
>        device_release_driver+0x12/0x20
>        bus_remove_device+0x1bc/0x290
>        device_del+0x259/0x580
>        device_unregister+0x1a/0x70
>        sdebug_remove_adapter+0x8b/0xf0 [scsi_debug]
>        scsi_debug_exit+0x76/0xe8 [scsi_debug]
>        __x64_sys_delete_module+0x1c1/0x280
>        do_syscall_64+0x77/0x230
>        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&shost->scan_mutex);
>                                lock(kn->count#202);
>                                lock(&shost->scan_mutex);
>   lock(kn->count#202);
>
>  *** DEADLOCK ***
>
> 2 locks held by modprobe/6539:
>  #0: 00000000efaf9298 (&dev->mutex){....}, at: device_release_driver_inte=
rnal+0x68/0x360
>  #1: 00000000a6ec2c69 (&shost->scan_mutex){+.+.}, at: scsi_remove_host+0x=
21/0x150 [scsi_mod]
>
> stack backtrace:
> CPU: 10 PID: 6539 Comm: modprobe Not tainted 4.18.0-rc2-dbg+ #5
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.0.0-prebuilt.q=
emu-project.org 04/01/2014
> Call Trace:
>  dump_stack+0xa4/0xf5
>  print_circular_bug.isra.34+0x213/0x221
>  __lock_acquire+0x1a7e/0x1b50
>  lock_acquire+0xd2/0x260
>  __kernfs_remove+0x424/0x4a0
>  kernfs_remove_by_name_ns+0x45/0x90
>  remove_files.isra.1+0x3a/0x90
>  sysfs_remove_group+0x5c/0xc0
>  sysfs_remove_groups+0x39/0x60
>  device_remove_attrs+0x82/0xb0
>  device_del+0x251/0x580
>  __scsi_remove_device+0x19f/0x1d0 [scsi_mod]
>  scsi_forget_host+0x37/0xb0 [scsi_mod]
>  scsi_remove_host+0x9b/0x150 [scsi_mod]
>  sdebug_driver_remove+0x4b/0x150 [scsi_debug]
>  device_release_driver_internal+0x241/0x360
>  device_release_driver+0x12/0x20
>  bus_remove_device+0x1bc/0x290
>  device_del+0x259/0x580
>  device_unregister+0x1a/0x70
>  sdebug_remove_adapter+0x8b/0xf0 [scsi_debug]
>  scsi_debug_exit+0x76/0xe8 [scsi_debug]
>  __x64_sys_delete_module+0x1c1/0x280
>  do_syscall_64+0x77/0x230
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> See also https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg54525=
.html.
>
> Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
> Fixes: ac0ece9174ac ("scsi: use device_remove_file_self() instead of devi=
ce_schedule_callback()")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: <stable@vger.kernel.org>
Looks good to me!
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
