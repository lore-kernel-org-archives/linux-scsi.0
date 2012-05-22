From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH v3 0/4]: block layer runtime pm
Date: Tue, 22 May 2012 15:21:28 +0800
Message-ID: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:16258 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2EVHVo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 03:21:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

In August 2010, Jens and Alan discussed about "Runtime PM and the block
layer". http://marc.info/?t=128259108400001&r=1&w=2

Here are the RFC v3 patches that try to implement the ideas discussed.
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

 block/blk-core.c           |   71 ++++++++++++++++++++++++++++++++++++++++++++
 block/elevator.c           |    9 +++++
 drivers/scsi/scsi_lib.c    |   25 +++++++++++++--
 drivers/scsi/scsi_pm.c     |   27 ++++++++++++----
 drivers/scsi/scsi_sysfs.c  |    2 +
 drivers/scsi/sd.c          |   19 ++++--------
 include/linux/blk_types.h  |    2 +
 include/linux/blkdev.h     |   13 ++++++++
 include/scsi/scsi_device.h |    4 ++
 9 files changed, 149 insertions(+), 23 deletions(-)


