From: Adam Manzanares <adam.manzanares@hgst.com>
Subject: [PATCH v6 0/3] Enabling ATA Command Priorities
Date: Mon, 17 Oct 2016 11:27:27 -0700
Message-ID: <1476728850-2309-1-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, tj@kernel.org, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@hgst.com>
List-Id: linux-scsi@vger.kernel.org

This patch builds ATA commands with high priority if the iocontext of a process
is set to real time. The goal of the patch is to improve tail latencies of 
workloads that use higher queue depths. This requires setting the iocontext 
ioprio on the request when it is initialized

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

This feature is enabled for ATA devices by setting the ata ncq_prio_on device 
attribute to 1. An ATA device is also checked to see if the device supports per
command priority.

v6:
 - Removed fusion mpt sas prio related code deletion
 - Renamed ata device attribute that enables priority cmds to the device

v5:
 - Updated block patch commit message to indicate the why and not the how
v4:
 - Added blk_rq_set_prio function to associate request prio with ioc prio
 - In init_request_from_bio use bio_prio if it is valid
 - Added ata enable_prio dev attribute to sysfs to enable prioritized commands

v3:
 - Removed null dereference issue in blk-core
 - Renamed queue sysfs entries for clarity
 - Added documentation for sysfs queue entry

v2:
 - Add queue flag to set iopriority going to the request
 - If queue flag set, send iopriority class to ata_build_rw_tf
 - Remove redundant code in ata_ncq_prio_enabled function.


Adam Manzanares (3):
  block: Add iocontext priority to request
  ata: Enabling ATA Command Priorities
  ata: ATA Command Priority Disabled By Default

 block/blk-core.c          |  4 ++-
 drivers/ata/libahci.c     |  1 +
 drivers/ata/libata-core.c | 35 +++++++++++++++++++++-
 drivers/ata/libata-scsi.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata.h      |  2 +-
 include/linux/ata.h       |  6 ++++
 include/linux/blkdev.h    | 14 +++++++++
 include/linux/libata.h    | 25 ++++++++++++++++
 8 files changed, 157 insertions(+), 4 deletions(-)

-- 
2.1.4
