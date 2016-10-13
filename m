From: Adam Manzanares <adam.manzanares@hgst.com>
Subject: [PATCH v5 0/4] Enabling ATA Command Priorities
Date: Thu, 13 Oct 2016 16:00:27 -0700
Message-ID: <1476399631-5799-1-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, tj@kernel.org, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@hgst.com>
List-Id: linux-scsi@vger.kernel.org

This patch builds ATA commands with high priority if the iocontext of a process
is set to real time. The goal of the patch is to improve tail latencies of 
workloads that use higher queue depths. This requires setting the iocontext 
ioprio on the request when it is initialized.

This patch has been tested with an Ultrastar HE8 HDD and cuts the 
the p99.99 tail latency of foreground IO from 2s down to 72ms when
using the deadline scheduler. This patch works independently of the
scheduler so it can be used with all of the currently available 
request based schedulers. 

Foreground IO, for the previously described results, is an async fio job 
submitting 4K read requests at a QD of 1 to the HDD. The foreground IO is set 
with the iopriority class of real time. The background workload is another fio
job submitting read requests at a QD of 32 to the same HDD with default 
iopriority.

This feature is enabled for ATA devices by setting the ata enable_prio device 
attribute to 1. An ATA device is also checked to see if the device supports per
command priority.

v5:
 - Updated block patch commit message to explain the why 

v4:
 - Added blk_rq_set_prio function to associate request prio with ioc prio
 - In init_request_from_bio use bio_prio if it is valid
 - Removed queue flag used to enable prio
 - Added ata enable_prio dev attribute to sysfs to enable prioritized commands

v3:
 - Removed null dereference issue in blk-core
 - Renamed queue sysfs entries for clarity
 - Added documentation for sysfs queue entry

v2:
 - Add queue flag to set iopriority going to the request
 - If queue flag set, send iopriority class to ata_build_rw_tf
 - Remove redundant code in ata_ncq_prio_enabled function.


Adam Manzanares (4):
  block: Add iocontext priority to request
  fusion: remove iopriority handling
  ata: Enabling ATA Command Priorities
  ata: ATA Command Priority Disabled By Default

 block/blk-core.c                  |  4 ++-
 drivers/ata/libahci.c             |  1 +
 drivers/ata/libata-core.c         | 35 +++++++++++++++++-
 drivers/ata/libata-scsi.c         | 74 ++++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata.h              |  2 +-
 drivers/message/fusion/mptscsih.c |  5 ---
 include/linux/ata.h               |  6 ++++
 include/linux/blkdev.h            | 14 ++++++++
 include/linux/libata.h            | 26 ++++++++++++++
 9 files changed, 158 insertions(+), 9 deletions(-)

-- 
2.1.4

