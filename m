From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 0/4] Avoid that __scsi_remove_device() hangs
Date: Mon, 17 Apr 2017 10:34:32 -0700
Message-ID: <20170417173436.15555-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:8742 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754627AbdDQRey (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2017 13:34:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>

__scsi_remove_device() hangs if it is waiting for the SYNCHRONIZE CACHE
command submitted by the sd driver to finish if the block layer queue is
stopped and does not get restarted. This patch series avoids that that
hang occurs.

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
 drivers/scsi/sd.c          |  45 ++++++++++++++++--
 include/scsi/scsi_device.h |   5 ++
 5 files changed, 142 insertions(+), 32 deletions(-)

-- 
2.12.2
