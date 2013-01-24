From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 00/13] Corrections and customization of the SG_IO command whitelist (CVE-2012-4542)
Date: Thu, 24 Jan 2013 16:00:36 +0100
Message-ID: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi@kernel.org
List-Id: linux-scsi@vger.kernel.org

This series regards the whitelist that is used for the SG_IO ioctl.  This
whitelist has three problems:

* the bitmap of allowed commands is designed for MMC devices (roughly,
  "play/burn CDs without requiring root") but some opcodes overlap across SCSI
  device classes and have different meanings for different classes.

* also because the bitmap of allowed commands is designed for MMC devices
  only, some commands are missing even though they are generally useful and
  not insecure.  At least not more insecure than anything else you can
  do if you have access to /dev/sdX or /dev/stX nodes.

* the whitelist can be disabled per-process but not per-disk.  In addition,
  the required capability (CAP_SYS_RAWIO) gives access to a range of other 
  resources, enough to make it insecure.

The series corrects these problems.  Patches 1-4 solve the first problem,
which also has an assigned CVE, by using different bitmaps for the various
device classes.  Patches 5-11 solve the second by adding more commands
to the bitmaps.  Patches 12 and 13 solve the third, and were already
posted but ignored by the maintainers despite multiple pings.

Note: checkpatch hates the formatting of the command table.  I know about this,
and ensured that there are no errors in the rest of the code.

Ok for the next merge window?

Paolo Bonzini (13):
  sg_io: pass request_queue to blk_verify_command
  sg_io: reorganize list of allowed commands
  sg_io: use different default filters for each device class
  sg_io: resolve conflicts between commands assigned to multiple
    classes (CVE-2012-4542)
  sg_io: whitelist a few more commands for rare & obsolete device types
  sg_io: whitelist a few more commands for multimedia devices
  sg_io: whitelist a few more commands for media changers
  sg_io: whitelist a few more commands for tapes
  sg_io: whitelist a few more commands for disks
  sg_io: whitelist a few obsolete commands
  sg_io: add list of commands that were in the consulted list but are
    disabled
  sg_io: remove remnants of sysfs SG_IO filters
  sg_io: introduce unpriv_sgio queue flag

 Documentation/block/queue-sysfs.txt |    8 +
 block/blk-sysfs.c                   |   33 +++
 block/bsg.c                         |    2 +-
 block/scsi_ioctl.c                  |  440 ++++++++++++++++++++++++++++-------
 drivers/scsi/scsi_scan.c            |    2 +
 drivers/scsi/sg.c                   |    3 +-
 include/linux/blkdev.h              |    8 +-
 include/linux/genhd.h               |    9 -
 include/scsi/scsi.h                 |    1 +
 9 files changed, 403 insertions(+), 103 deletions(-)
