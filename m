From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v7 0/4] block layer runtime pm
Date: Wed, 16 Jan 2013 17:02:17 +0800
Message-ID: <1358326941-3725-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

In August 2010, Jens and Alan discussed about "Runtime PM and the block
layer". http://marc.info/?t=128259108400001&r=1&w=2
And then Alan has given a detailed implementation guide:
http://marc.info/?l=linux-scsi&m=133727953625963&w=2

To test:
# ls -l /sys/block/sda
/sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda

# echo 10000 > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/autosuspend_delay_ms
# echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/control
Then you'll see sda is suspended after 10secs idle.

[ 1767.680192] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[ 1767.680317] sd 2:0:0:0: [sda] Stopping disk

And if you do some IO, it will resume immediately.
[ 1791.052438] sd 2:0:0:0: [sda] Starting disk

For test, I often set the autosuspend time to 1 second. If you are using
a GUI, the 10 seconds delay may be too long that the disk can not enter
runtime suspended state.

Note that sd's runtime suspend callback will dump some kernel messages
and the syslog daemon will write kernel message to /var/log/messages,
making the disk instantly resume after suspended. So for test, the
syslog daemon should better be temporarily stopped.

A git repo for it:
https://github.com/aaronlu/linux.git blockpm_v7

v7:
- Add kernel doc for block layer runtime PM API as suggested by
  Alan Stern;

- Add back check for q->dev, as that serves as a flag if driver
  is using block layer runtime PM;

- Do not auto suspend when last request is finished, as that's a hot
  path and auto suspend is not a trivial function. Instead, mark last
  busy in pre_suspend so that runtim PM core will retry suspend some
  time later to solve the 1st problem demostrated in v6, suggested by
  Alan Stern.

- Move block layer runtime PM strtegy functions to where they are
  needed instead of in include/linux/blkdev.h as suggested by Alan
  Stern since clients of block layer do not need to know those
  functions.

v6:
Take over from Lin Ming.

- Instead of put the device into autosuspend state in
  blk_post_runtime_suspend, do it when the last request is finished.
  This can also solve the problem illustrated below:

      thread A				      thread B
|suspend timer expired			|
|  ... ...				|a new request comes in,
|  ... ...				|blk_pm_add_request
|  ... ...				|skip request_resume due to
|  ... ...				|q->status is still RPM_ACTIVE
|  rpm_suspend				|  ... ...
|    scsi_runtime_suspend		|  ... ...
|      blk_pre_runtime_suspend		|  ... ...
|      return -EBUSY due to nr_pending	|  ... ...
|  rpm_suspend done			|  ... ...
|					|    blk_pm_put_request, mark last busy

But no more trigger point, and the device will stay at RPM_ACTIVE state.
Run pm_runtime_autosuspend after the last request is finished solved
this problem.

- Requests which have the REQ_PM flag should not involve nr_pending
  counting, or we may lose the condition to resume the device:
  Suppose queue is active and nr_pending is 0. Then a REQ_PM request
  comes and nr_pending will be increased to 1, but since the request has
  REQ_PM flag, it will not cause resume. Before it is finished, a normal
  request comes in, and since nr_pending is 1 now, it will not trigger
  the resume of the device either. Bug.

- Do not quiesce the device in scsi bus level runtime suspend callback.
  Since the only reason the device is to be runtime suspended is due to
  no more requests pending for it, quiesce it is pointless.

- Remove scsi_autopm_* from sd_check_events as we are request driven.

- Call blk_pm_runtime_init in scsi_sysfs_initialize_dev, so that we do
  not need to check queue's device in blk_pm_add/put_request.

- Do not mark last busy and initiate an autosuspend for the device in
  blk_pm_runtime_init function.

- Do not mark last busy and initiate an autosuspend for the device in
  block_post_runtime_resume, as when the request that triggered the
  resume finished, the blk_pm_put_request will mark last busy and
  initiate an autosuspend.

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
  sd: change to auto suspend mode

 block/blk-core.c           | 175 +++++++++++++++++++++++++++++++++++++++++++++
 block/elevator.c           |  26 +++++++
 drivers/scsi/scsi_lib.c    |   9 ++-
 drivers/scsi/scsi_pm.c     |  35 +++++----
 drivers/scsi/scsi_sysfs.c  |   2 +
 drivers/scsi/sd.c          |  21 ++----
 include/linux/blk_types.h  |   2 +
 include/linux/blkdev.h     |  27 +++++++
 include/scsi/scsi_device.h |  17 +++--
 9 files changed, 277 insertions(+), 37 deletions(-)

-- 
1.8.0.2

