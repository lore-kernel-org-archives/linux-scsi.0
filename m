From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v5 0/4] block layer runtime pm
Date: Fri,  6 Jul 2012 12:04:28 +0800
Message-ID: <1341547472-6863-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In August 2010, Jens and Alan discussed about "Runtime PM and the block
layer". http://marc.info/?t=128259108400001&r=1&w=2

Here are the v5 patches to implement the ideas discussed.
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

v5:
- rename scsi_execute_req to scsi_execute_req_flags
  and wrap scsi_execute_req around it.
- add detail function descriptions in patch 2 log
- define static helper functions to do runtime pm work on block layer
  and put the definitions inside a #ifdef block

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

 block/blk-core.c           |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 block/elevator.c           |    4 ++++
 drivers/scsi/scsi_lib.c    |    9 ++++-----
 drivers/scsi/scsi_pm.c     |   38 ++++++++++++++++++++++++++++++--------
 drivers/scsi/scsi_sysfs.c  |    2 ++
 drivers/scsi/sd.c          |   16 +++++-----------
 include/linux/blk_types.h  |    2 ++
 include/linux/blkdev.h     |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |   17 +++++++++++++----
 9 files changed, 194 insertions(+), 28 deletions(-)
