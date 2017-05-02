From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v6 0/5] Avoid that __scsi_remove_device() hangs
Date: Tue, 2 May 2017 11:00:38 -0700
Message-ID: <20170502180043.14734-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:57632 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdEBSAt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2017 14:00:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>

__scsi_remove_device() hangs if it is waiting for the SYNCHRONIZE CACHE
command submitted by the sd driver to finish if the block layer queue is
stopped and does not get restarted. This patch series avoids that that
hang occurs.

Changes compared to v5:
- Reworked the approach. Instead of submitting the SYNCHRONIZE CACHE command
  asynchronously, make __scsi_remove_device() go straight from BLOCKED to DEL.

Changes compared to v4:
- Fixed the deadlock reported by the 0-day bot by changing a blk_put_request()
  call into __blk_put_request().

Changes compared to v3:
- Removed the logging statements from sd_sync_cache_done() that triggered
  a crash due to a use-after-free.

Changes compared to v2:
- Moved the "stop_disk" assignment after the sdkp check in the sd driver.
- Added a completion function for asynchronous SYNCHRONIZE CACHE commands.
- Added "disk" and "done" arguments to scsi_execute_async().

Changes compared to v1:
- Reworked the approach of this patch series.

Bart Van Assche (5):
  Split scsi_internal_device_block()
  Create two versions of scsi_internal_device_unblock()
  Protect SCSI device state changes with a mutex
  Introduce scsi_start_queue()
  Make __scsi_remove_device go straight from BLOCKED to DEL

 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   8 +-
 drivers/scsi/scsi_error.c            |   8 +-
 drivers/scsi/scsi_lib.c              | 171 +++++++++++++++++++++++------------
 drivers/scsi/scsi_priv.h             |   1 +
 drivers/scsi/scsi_scan.c             |  16 ++--
 drivers/scsi/scsi_sysfs.c            |  37 +++++++-
 drivers/scsi/scsi_transport_srp.c    |   7 +-
 drivers/scsi/sd.c                    |   7 +-
 include/scsi/scsi_device.h           |   7 +-
 9 files changed, 181 insertions(+), 81 deletions(-)

-- 
2.12.2
