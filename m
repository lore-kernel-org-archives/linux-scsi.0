From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 0/4] Avoid that __scsi_remove_device() hangs
Date: Fri, 21 Apr 2017 14:26:32 -0700
Message-ID: <20170421212636.14376-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60209 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162284AbdDUV0p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 17:26:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>

__scsi_remove_device() hangs if it is waiting for the SYNCHRONIZE CACHE
command submitted by the sd driver to finish if the block layer queue is
stopped and does not get restarted. This patch series avoids that that
hang occurs.

Changes compared to v3:
- Removed the logging statements from sd_sync_cache_done() that triggered
  a crash due to a use-after-free.

Changes compared to v2:
- Moved the "stop_disk" assignment after the sdkp check in the sd driver.
- Added a completion function for asynchronous SYNCHRONIZE CACHE commands.
- Added "disk" and "done" arguments to scsi_execute_async().

Changes compared to v1:
- Reworked the approach of this patch series.

Bart Van Assche (4):
  Introduce scsi_start_queue()
  Introduce scsi_execute_async()
  sd: Make synchronize cache upon shutdown asynchronous
  Avoid that __scsi_remove_device() hangs

 drivers/scsi/scsi_lib.c    | 114 ++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/scsi_priv.h   |   1 +
 drivers/scsi/scsi_sysfs.c  |   9 ++++
 drivers/scsi/sd.c          |  39 ++++++++++++++--
 include/scsi/scsi_device.h |   5 ++
 5 files changed, 136 insertions(+), 32 deletions(-)

-- 
2.12.2
