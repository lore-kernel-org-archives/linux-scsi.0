From: Stephen Cameron <stephenmcameron@gmail.com>
Subject: Re: [PATCH] hpsa: fix physical device lun and target numbering problem
Date: Tue, 9 Aug 2011 08:33:09 -0500
Message-ID: <CADzpL0SnZ+t6RT5iU2Ne+HEdBO1n2K51WwqaVDHXPs1CDHGk2A@mail.gmail.com>
References: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 9, 2011 at 8:18 AM, Stephen M. Cameron
<scameron@beardog.cce.hp.com> wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> If a physical device exposed to the OS by hpsa
> is replaced (e.g. one hot plug tape drive is replaced
> by another, or a tape drive is placed into "OBDR" mode
> in which it acts like a CD-ROM device) and a rescan is
> initiated, the replaced device will be added to the
> SCSI midlayer with target and lun numbers set to -1.
> After that, a panic is likely to ensue. =A0When a physical
> device is replaced, the lun and target number should be
> preserved.
>
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
> =A0drivers/scsi/hpsa.c | =A0 10 ++++++++++
> =A01 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 1f32f06..b200b73 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -676,6 +676,16 @@ static void hpsa_scsi_replace_entry(struct ctlr_=
info *h, int hostno,
> =A0 =A0 =A0 =A0BUG_ON(entry < 0 || entry >=3D HPSA_MAX_SCSI_DEVS_PER_=
HBA);
> =A0 =A0 =A0 =A0removed[*nremoved] =3D h->dev[entry];
> =A0 =A0 =A0 =A0(*nremoved)++;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* New physical devices won't have target/lun assigne=
d yet
> + =A0 =A0 =A0 =A0* so we need to preserve the values in the slot we a=
re replacing.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (new_entry->target =3D=3D -1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_entry->target =3D h->dev[entry]->ta=
rget;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_entry->lun =3D h->dev[entry]->lun;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0h->dev[entry] =3D new_entry;
> =A0 =A0 =A0 =A0added[*nadded] =3D new_entry;
> =A0 =A0 =A0 =A0(*nadded)++;
>
>

Despite the above patch, which I do think is correct, I can still get
a panic (on RHEL 6.1 with 2.6.31-rc1 kernel) by using a program to
send a particular MODE SELECT to change a tape drive's personality
back and forth between OBDR mode (makes the device type switch back
and forth between sequential access and CD-ROM) and doing "echo 1  >
/sys/.../scsi_host/host1/rescan" to make the hpsa driver rescan for
devices and update the SCSI midlayer.

The panic appears to be some interaction between the block layer,
SG_IO, nautilus (which loves to poke at CD-ROM devices) the cdrom
driver, and the hpsa driver's way of updating the SCSI midlayer's
notion of what devices are present.

Panic looks like this:

------------[ cut here ]------------
kernel BUG at block/cfq-iosched.c:1195!
invalid opcode: 0000 [#1] SMP
CPU 0
Modules linked in: sr_mod cdrom nfs lockd fscache auth_rpcgss nfs_acl f=
use ip6t]

Pid: 3388, comm: cdrom_id Not tainted 3.1.0-rc1+ #1 HP ProLiant DL380 G=
7
RIP: 0010:[<ffffffff812344e2>]  [<ffffffff812344e2>] cfq_put_cfqg+0xc2/=
0xd0
RSP: 0018:ffff8805f5a75af8  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8805f3342848 RCX: 0000000000000077
RDX: 0000000000000000 RSI: ffff8805f81dd498 RDI: ffff8805f3342848
RBP: ffff8805f5a75b08 R08: 00c0000000000000 R09: 0600000000000000
R10: 000000b911dc0248 R11: 0000000000000000 R12: ffff8805f7c657b8
R13: 0000000002224800 R14: ffff8805f81dd498 R15: ffff8805f474b440
=46S:  00007f58a528e700(0000) GS:ffff88061f200000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003f708abd60 CR3: 00000005f721f000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cdrom_id (pid: 3388, threadinfo ffff8805f5a74000, task ffff8805=
f4e3f540)
Stack:
 ffff8805f5a75af8 ffff8805f81dd498 ffff8805f5a75b28 ffffffff81238198
 ffff8805f47bc038 ffff8805f81dd498 ffff8805f5a75b38 ffffffff8121cc2e
 ffff8805f5a75b68 ffffffff81223713 0000000000000000 ffff8805f47bc038
Call Trace:
 [<ffffffff81238198>] cfq_put_request+0x68/0x90
 [<ffffffff8121cc2e>] elv_put_request+0x1e/0x20
 [<ffffffff81223713>] __blk_put_request+0xb3/0xe0
 [<ffffffff81223daa>] blk_put_request+0x3a/0x60
 [<ffffffff8122d980>] sg_io+0x1b0/0x400
 [<ffffffffa05498a1>] ? sr_do_ioctl+0x191/0x310 [sr_mod]
 [<ffffffff8122e230>] scsi_cmd_ioctl+0x2a0/0x4c0
 [<ffffffffa054964d>] ? sr_drive_status+0x6d/0x100 [sr_mod]
 [<ffffffff811822fd>] ? mntput+0x1d/0x30
 [<ffffffff8116f162>] ? path_put+0x22/0x30
 [<ffffffffa053d2a1>] cdrom_ioctl+0x51/0xa60 [cdrom]
 [<ffffffff81172ef9>] ? path_openat+0x109/0x3e0
 [<ffffffffa05488c6>] sr_block_ioctl+0x76/0xf0 [sr_mod]
 [<ffffffff8122a778>] __blkdev_driver_ioctl+0x28/0x30
 [<ffffffff8122ac4e>] blkdev_ioctl+0x1fe/0x6e0
 [<ffffffff811989fc>] block_ioctl+0x3c/0x40
 [<ffffffff8117640c>] do_vfs_ioctl+0x8c/0x340
 [<ffffffff811703a5>] ? putname+0x35/0x50
 [<ffffffff81176761>] sys_ioctl+0xa1/0xb0
 [<ffffffff814ed842>] system_call_fastpath+0x16/0x1b
Code: 00 00 00 48 83 c7 03 83 f9 03 75 9f 48 8b bb 20 03 00 00 e8 81 1d=
 ef ff 4
RIP  [<ffffffff812344e2>] cfq_put_cfqg+0xc2/0xd0
 RSP <ffff8805f5a75af8>

I'm guessing the queue is getting torn down while SG_IO is trying to
put requests (from Nautilus) on it, but I'm not quite sure precisely
where things begin to go off the rails.

-- steve
