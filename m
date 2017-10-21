From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH v10 00/10] block, scsi, md: Improve suspend and resume
Date: Sat, 21 Oct 2017 19:21:59 +0200
Message-ID: <3006499.SSja2RFHbQ@natalenko.name>
References: <20171017232630.4264-1-bart.vanassche@wdc.com> <11010777.WJQNYl18e6@natalenko.name> <1508340432.2540.4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1508340432.2540.4.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Well,

I've cherry-picked this series for current upstream/master branch, and got=
=20
this while performing another suspend try:

=3D=3D=3D
[   62.415890] Freezing of tasks failed after 20.007 seconds (1 tasks refus=
ing=20
to freeze, wq_busy=3D0):
[   62.421150] xfsaild/dm-7    D    0   289      2 0x80000000
[   62.425800] Call Trace:
[   62.428902]  __schedule+0x239/0x870
[   62.431834]  schedule+0x33/0x90
[   62.434156]  _xfs_log_force+0x143/0x280 [xfs]
[   62.438767]  ? schedule_timeout+0x188/0x390
[   62.443592]  ? wake_up_q+0x80/0x80
[   62.446545]  ? xfsaild+0x18d/0x780 [xfs]
[   62.449702]  xfs_log_force+0x2c/0x90 [xfs]
[   62.453217]  xfsaild+0x18d/0x780 [xfs]
[   62.456717]  kthread+0x124/0x140
[   62.459237]  ? kthread+0x124/0x140
[   62.461818]  ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[   62.465146]  ? kthread_create_on_node+0x70/0x70
[   62.467331]  ret_from_fork+0x25/0x30
[   62.474386] Restarting kernel threads ... done.
=3D=3D=3D

After this it looks like the system tried to freeze anyway:

=3D=3D=3D
[   62.478290] OOM killer enabled.
[   62.481711] Restarting tasks ... done.
[   62.488931] PM: suspend exit
[   62.491497] PM: suspend entry (s2idle)
[   62.493445] PM: Syncing filesystems ... done.
[   63.774220] Freezing user space processes ... (elapsed 0.001 seconds) do=
ne.
[   63.782707] OOM killer disabled.
[   63.785226] Freezing remaining freezable tasks ... (elapsed 0.001 second=
s)=20
done.
[   63.861548] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[   63.868153] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   63.868463] sd 1:0:0:0: [sdb] Stopping disk
[   63.873216] sd 0:0:0:0: [sda] Stopping disk
=3D=3D=3D

but got hung completely. After some time hung task was detected:

=3D=3D=3D
[  247.531069] INFO: task systemd-sleep:663 blocked for more than 120 secon=
ds.
[  247.535307]       Not tainted 4.14.0-pf0 #1
[  247.537820] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[  247.541015] systemd-sleep   D    0   663      1 0x00000000
[  247.542706] Call Trace:
[  247.543386]  __schedule+0x239/0x870
[  247.544351]  schedule+0x33/0x90
[  247.545197]  suspend_devices_and_enter+0x61b/0x890
[  247.546539]  ? wait_woken+0x80/0x80
[  247.547517]  pm_suspend+0x340/0x3b0
[  247.548550]  state_store+0x5a/0x90
[  247.549646]  kobj_attr_store+0xf/0x20
[  247.550649]  sysfs_kf_write+0x37/0x40
[  247.551640]  kernfs_fop_write+0x11c/0x1a0
[  247.552708]  __vfs_write+0x37/0x150
[  247.553641]  ? SYSC_newfstat+0x44/0x70
[  247.554628]  vfs_write+0xb1/0x1a0
[  247.555509]  SyS_write+0x55/0xc0
[  247.556366]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[  247.557667] RIP: 0033:0x7f56b74ec8d4
[  247.558616] RSP: 002b:00007fff141c7738 EFLAGS: 00000246 ORIG_RAX:=20
0000000000000001
[  247.560667] RAX: ffffffffffffffda RBX: 000055dd61863290 RCX:=20
00007f56b74ec8d4
[  247.562639] RDX: 0000000000000007 RSI: 000055dd61864eb0 RDI:=20
0000000000000004
[  247.564874] RBP: 00007f56b77b3240 R08: 000055dd61863370 R09:=20
00007f56b79c88c0
[  247.566875] R10: 000000000000000a R11: 0000000000000246 R12:=20
0000000000000000
[  247.569213] R13: 000055dd61863290 R14: 000055dd61863d08 R15:=20
00000000ffffffea
=3D=3D=3D

P.S. Current Ming's series is enough for 4.13 to not experience any issues=
=20
like this.

On st=C5=99eda 18. =C5=99=C3=ADjna 2017 17:27:14 CEST Bart Van Assche wrote:
> I think this version (v10) has significant advantages over the most recent
> patch series posted by Ming Lei to address suspend, resume and SPI domain
> validation. So it would be appreciated if you could switch to this series
> for testing suspend and resume.
