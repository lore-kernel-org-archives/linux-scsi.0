From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH stable 0/3] possible privilege escalation via SG_IO ioctl (CVE-2011-4127)
Date: Mon, 16 Jan 2012 17:12:57 +0100
Message-ID: <1326730380-7674-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org, Petr Matousek <pmatouse@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Partition block devices or LVM volumes can be sent SCSI commands via
SG_IO, which are then passed down to the underlying device; it's
been this way forever, it was mentioned in 2004 in LKML at
https://lkml.org/lkml/2004/8/12/218 and it is even documented in the
sg_dd man page:

    blk_sgio=1
              when set to 0, block devices (e.g. /dev/sda) are treated
              like normal files (i.e. read(2) and write(2) are used for
              IO). When set to 1, block devices are assumed to accept the
              SG_IO ioctl and  SCSI commands are issued for IO. [...]
              If the input or output device is a block device partition
              (e.g. /dev/sda3) then setting this option causes the
              partition information to be ignored (since access is
              directly to the underlying device).

This is problematic because "safe" SCSI commands, including READ or WRITE,
can be sent to the disk without any particular capability.  All that is
required is having a file descriptor for the block device, and permission
to send a ioctl.  However, when a user lets a program access /dev/sda2,
it still should not be able to read/write /dev/sda outside the boundaries
of that partition.

Encryption on the host is a mitigating factor, but it does not provide
a full solution.  In particular it doesn't protect against DoS (write
random data), replay attacks (reinstate old ciphertext sectors), or
writes to unencrypted areas including the MBR, the partition table, or
/boot.

The patches implement a simple global whitelist for both partitions
and partial disk mappings.  Patch 1 refactors the code to prepare for
introduction of the whitelist, while patch 2 actually implements it for
the SCSI ioctls.  Logical volumes are also affected if they have only one
target, and this target can pass ioctls to the underlying block device.
Patch 3 thus adds the whitelist to logical volumes as well.

For stable, I removed the dependency on commit 07d106d (vfs: fix up
ENOIOCTLCMD error handling, 2012-01-05).  Patches 1 and 3 are untouched.

Paolo


Paolo Bonzini (3):
  block: add and use scsi_blk_cmd_ioctl
  block: fail SCSI passthrough ioctls on partition devices
  dm: do not forward ioctls from logical volumes to the underlying
    device

 block/scsi_ioctl.c             |   52 ++++++++++++++++++++++++++++++++++++++++
 drivers/block/cciss.c          |    6 ++--
 drivers/block/ub.c             |    3 +-
 drivers/block/virtio_blk.c     |    4 +-
 drivers/cdrom/cdrom.c          |    3 +-
 drivers/ide/ide-floppy_ioctl.c |    3 +-
 drivers/md/dm-flakey.c         |   11 +++++++-
 drivers/md/dm-linear.c         |   12 ++++++++-
 drivers/md/dm-mpath.c          |    6 ++++
 drivers/scsi/sd.c              |   13 +++++++--
 include/linux/blkdev.h         |    3 ++
 11 files changed, 100 insertions(+), 16 deletions(-)

-- 
1.7.7.1
