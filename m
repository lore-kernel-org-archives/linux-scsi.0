From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 0/4]: block layer runtime pm
Date: Thu,  5 Jul 2012 15:26:35 +0800
Message-ID: <1341473199-3837-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In August 2010, Jens and Alan discussed about "Runtime PM and the block
layer". http://marc.info/?t=128259108400001&r=1&w=2

Here are the v4 patches to implement the ideas discussed.
Welcome to give it a try.

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git block_pm

The test steps, for example

# ls -l /sys/block/sda
/sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda

# echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata1/power/control
# echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/control
# echo 10000 > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/autosuspend_delay_ms

Then you'll see sda is suspended after 10secs idle.

# cat /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/runtime_status
suspended

And if you do some IO, it will resume immediately.

v4:
- add CONFIG_PM_RUNTIME check
- update queue runtime pm status after system resume
- use pm_runtime_autosuspend instead of pm_request_autosuspend in scsi_runtime_idle
- always count PM request

v3:
- remove block layer suspend/resume callbacks
- add block layer runtime pm helper functions

v2:
- remove queue idle timer, use runtime pm core's auto suspend

Lin Ming (4):
      block: add a flag to identify PM request
      block: add runtime pm helpers
      block: implement runtime pm strategy
      [SCSI] sd: change to auto suspend mode

 block/blk-core.c           |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 block/elevator.c           |   13 +++++++++++++
 drivers/scsi/scsi_lib.c    |   25 ++++++++++++++++++++++---
 drivers/scsi/scsi_pm.c     |   32 +++++++++++++++++++++++++-------
 drivers/scsi/scsi_sysfs.c  |    2 ++
 drivers/scsi/sd.c          |   16 +++++-----------
 include/linux/blk_types.h  |    2 ++
 include/linux/blkdev.h     |   27 +++++++++++++++++++++++++++
 include/scsi/scsi_device.h |    4 ++++
 9 files changed, 179 insertions(+), 21 deletions(-)
