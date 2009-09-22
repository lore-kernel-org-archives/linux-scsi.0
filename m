From: Xiaotian Feng <xtfeng@gmail.com>
Subject: Re: [2.6.31] Memory leak in SCSI initialization?
Date: Tue, 22 Sep 2009 13:03:42 +0800
Message-ID: <7b6bb4a50909212203m19ed8276l5aab1fb4ea58c574@mail.gmail.com>
References: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:50508 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbZIVFDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2009 01:03:39 -0400
In-Reply-To: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Can this patch fix your leak?

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c447838..b0d3984 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -318,6 +318,7 @@ out_device_destroy:
        scsi_device_set_state(sdev, SDEV_DEL);
        transport_destroy_device(&sdev->sdev_gendev);
        put_device(&sdev->sdev_gendev);
+       put_device(&sdev->sdev_dev);
 out:
        if (display_failure_msg)
                printk(ALLOC_FAILURE_MSG, __func__);
@@ -958,6 +959,7 @@ static inline void scsi_destroy_sdev(struct
scsi_device *sdev)
                sdev->host->hostt->slave_destroy(sdev);
        transport_destroy_device(&sdev->sdev_gendev);
        put_device(&sdev->sdev_gendev);
+       put_device(&sdev->sdev_dev);
 }

 #ifdef CONFIG_SCSI_LOGGING



On Tue, Sep 22, 2009 at 12:18 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Hello.
>
> I can see below message appears for 15 times in
> /sys/kernel/debug/kmemleak after processing /init inside initramfs.
>
> unreferenced object 0xdeadb5c8 (size 32):
> =C2=A0comm "insmod", pid 543, jiffies 4294674766
> =C2=A0backtrace:
> =C2=A0 =C2=A0[<c048a22c>] create_object+0x135/0x202
> =C2=A0 =C2=A0[<c048a31e>] kmemleak_alloc+0x25/0x49
> =C2=A0 =C2=A0[<c04865d9>] kmemleak_alloc_recursive+0x1c/0x22
> =C2=A0 =C2=A0[<c0486d33>] __kmalloc+0x6c/0xb9
> =C2=A0 =C2=A0[<c04f5675>] kvasprintf+0x2d/0x4a
> =C2=A0 =C2=A0[<c04ef5af>] kobject_set_name_vargs+0x21/0x50
> =C2=A0 =C2=A0[<c054bbd7>] dev_set_name+0x1a/0x1c
> =C2=A0 =C2=A0[<e08dc1b7>] scsi_sysfs_device_initialize+0x8b/0xe4 [scs=
i_mod]
> =C2=A0 =C2=A0[<e08d9bbf>] scsi_alloc_sdev+0x134/0x18f [scsi_mod]
> =C2=A0 =C2=A0[<e08d9e7a>] scsi_probe_and_add_lun+0x107/0xa98 [scsi_mo=
d]
> =C2=A0 =C2=A0[<e08da946>] __scsi_scan_target+0x70/0x4b1 [scsi_mod]
> =C2=A0 =C2=A0[<e08dadbe>] scsi_scan_channel+0x37/0x60 [scsi_mod]
> =C2=A0 =C2=A0[<e08dae9f>] scsi_scan_host_selected+0xb8/0xf1 [scsi_mod=
]
> =C2=A0 =C2=A0[<e08daf2c>] do_scsi_scan_host+0x54/0x5d [scsi_mod]
> =C2=A0 =C2=A0[<e08db2ef>] scsi_scan_host+0x14d/0x165 [scsi_mod]
> =C2=A0 =C2=A0[<e0959771>] mptspi_probe+0x2cd/0x2f8 [mptspi]
>
> Environment is CentOS 5.3 on i686 .
> The content of /init is shown below.
>
> --
> #!/bin/nash
>
> mount -t proc /proc /proc
> setquiet
> echo Mounting proc filesystem
> echo Mounting sysfs filesystem
> mount -t sysfs /sys /sys
> echo Creating /dev
> mount -o mode=3D0755 -t tmpfs /dev /dev
> mkdir /dev/pts
> mount -t devpts -o gid=3D5,mode=3D620 /dev/pts /dev/pts
> mkdir /dev/shm
> mkdir /dev/mapper
> echo Creating initial device nodes
> mknod /dev/null c 1 3
> mknod /dev/zero c 1 5
> mknod /dev/systty c 4 0
> mknod /dev/tty c 5 0
> mknod /dev/console c 5 1
> mknod /dev/ptmx c 5 2
> mknod /dev/rtc c 10 135
> mknod /dev/tty0 c 4 0
> mknod /dev/tty1 c 4 1
> mknod /dev/tty2 c 4 2
> mknod /dev/tty3 c 4 3
> mknod /dev/tty4 c 4 4
> mknod /dev/tty5 c 4 5
> mknod /dev/tty6 c 4 6
> mknod /dev/tty7 c 4 7
> mknod /dev/tty8 c 4 8
> mknod /dev/tty9 c 4 9
> mknod /dev/tty10 c 4 10
> mknod /dev/tty11 c 4 11
> mknod /dev/tty12 c 4 12
> mknod /dev/ttyS0 c 4 64
> mknod /dev/ttyS1 c 4 65
> mknod /dev/ttyS2 c 4 66
> mknod /dev/ttyS3 c 4 67
> echo Setting up hotplug.
> hotplug
> echo Creating block device nodes.
> mkblkdevs
> echo "Loading jbd.ko module"
> insmod /lib/jbd.ko
> echo "Loading ext3.ko module"
> insmod /lib/ext3.ko
> echo "Loading scsi_mod.ko module"
> insmod /lib/scsi_mod.ko
> echo "Loading sd_mod.ko module"
> insmod /lib/sd_mod.ko
> echo "Loading scsi_transport_spi.ko module"
> insmod /lib/scsi_transport_spi.ko
> echo "Loading mptbase.ko module"
> insmod /lib/mptbase.ko
> echo "Loading mptscsih.ko module"
> insmod /lib/mptscsih.ko
> echo "Loading mptspi.ko module"
> insmod /lib/mptspi.ko
> echo Waiting for driver initialization.
> stabilized --hash --interval 1000 /proc/scsi/scsi
> mkblkdevs
> echo Scanning and configuring dmraid supported devices
> echo Creating root device.
> mkrootdev -t ext3 -o noatime,nodiratime,ro sda1
> echo Mounting root filesystem.
> mount /sysroot
> echo Setting up other filesystems.
> setuproot
> echo Switching to new root and running init.
> switchroot
> --
>
> This is a different one from the one solved by applying
> http://lkml.org/lkml/2009/9/21/384 .
>
> Regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
