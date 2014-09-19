From: Christoph Hellwig <hch@lst.de>
Subject: boot stall regression due to blk-mq: use percpu_ref for mq usage
	count
Date: Fri, 19 Sep 2014 13:38:15 +0200
Message-ID: <20140919113815.GA10791@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jens, hi Tejun,

I've seen multi-second boot stalls in one of my KVM setups during
the initial scsi scan:

[    0.949892] scsi host0: Virtio SCSI HBA
[    1.007864] scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    1.1. PQ: 0 ANSI: 5
[    1.021299] scsi 0:0:1:0: Direct-Access     QEMU     QEMU HARDDISK    1.1. PQ: 0 ANSI: 5
[    1.520356] tsc: Refined TSC clocksource calibration: 2491.910 MHz

<stall>

[   16.186549] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   16.190478] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   16.194099] osd: LOADED open-osd 0.2.1
[   16.203202] sd 0:0:0:0: [sda] 31457280 512-byte logical blocks: (16.1 GB/15.0 GiB)
[   16.208478] sd 0:0:0:0: [sda] Write Protect is off
[   16.211439] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.218771] sd 0:0:1:0: [sdb] 31457280 512-byte logical blocks: (16.1 GB/15.0 GiB)
[   16.223264] sd 0:0:1:0: [sdb] Write Protect is off
[   16.225682] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA



I've tracked this down to "blk-mq: use percpu_ref for mq usage count" in
a rather painful way as that one introduced enough other regressions
to mess up bisect.

If I revert the following commits:

dd840087086f3b93ac20f7472b4fca59aff7b79f
cddd5d17642cc6881352732693c2ae6930e9ce65
add703fda981b9719d37f371498b9f129acbd997

which are the above mentioned commit and two fixes to it the problem goes
away.

My qemu command line is below:

kvm \
	-m 2048 \
	-smp 1 \
	-kernel arch/x86/boot/bzImage \
	-append "root=/dev/vda console=tty0 console=ttyS0,115200n8 scsi_mod.use_blk_mq=Y" \
	-nographic \
	-drive if=virtio,file=/work/images/debian.qcow2,cache=none,serial="test1234" \
	-drive if=none,id=test,file=/work/images/test.img,cache=none,aio=native \
	-drive if=none,id=scratch,file=/work/images/scratch.img,cache=none,aio=native \
	-device virtio-scsi-pci,id=scsi \
	-device scsi-hd,drive=test \
	-device scsi-hd,drive=scratch \
	-drive file=/work/images/debian-7.3.0-amd64-netinst.iso,index=2,media=cdrom
