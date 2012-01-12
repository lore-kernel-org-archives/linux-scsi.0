From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 0/3] possible privilege escalation via SG_IO ioctl (CVE-2011-4127)
Date: Thu, 12 Jan 2012 16:01:26 +0100
Message-ID: <1326380489-9044-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64343 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2ALPCA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2012 10:02:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Petr Matousek <pmatouse@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>

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

This should be entirely independent of capabilities.  Continuing the
previous example, if the same user gives CAP_SYS_RAWIO to the program and
write access to /dev/sdb, the program should be able to send arbitrary
SCSI commands to /dev/sdb, but still should not be able to access /dev/sda
outside the boundaries of /dev/sda2.  However, for now when the program
has CAP_SYS_RAWIO the ioctls are let through (while still being logged
to dmesg).

drivers/ide/ has several ioctls that should only be restricted to the full
block device (for example HDIO_SET_*, HDIO_DRIVE_CMD, HDIO_DRIVE_TASK,
HDIO_DRIVE_RESET).  However, all of them require either CAP_SYS_ADMIN
or CAP_SYS_RAWIO, so they do not need any change given the above interim
measure.

Tested on top of 3.2 + Linus's patch to sanitize ioctl return values.

Thanks to Daniel Berrange, Milan Broz, Mike Christie, Alasdair Kergon,
Petr Matousek, Jeff Moyer, Mike Snitzer and others for help discussing
this issue.

Paolo

v1->v2:
	Added logging and temporary wildcard for CAP_SYS_RAWIO;
	added CDROM ioctls to the whitelist; return -ENOIOCTLCMD.
	No changes in patches 1 and 3.

Paolo Bonzini (3):
  block: add and use scsi_blk_cmd_ioctl
  block: fail SCSI passthrough ioctls on partition devices
  dm: do not forward ioctls from logical volumes to the underlying
    device

 block/scsi_ioctl.c             |   50 ++++++++++++++++++++++++++++++++++++++++
 drivers/block/cciss.c          |    6 ++--
 drivers/block/ub.c             |    3 +-
 drivers/block/virtio_blk.c     |    4 +-
 drivers/cdrom/cdrom.c          |    3 +-
 drivers/ide/ide-floppy_ioctl.c |    3 +-
 drivers/md/dm-flakey.c         |   11 ++++++++-
 drivers/md/dm-linear.c         |   12 ++++++++-
 drivers/md/dm-mpath.c          |    6 ++++
 drivers/scsi/sd.c              |   13 ++++++++--
 include/linux/blkdev.h         |    3 ++
 11 files changed, 98 insertions(+), 16 deletions(-)

-- 
1.7.7.1

