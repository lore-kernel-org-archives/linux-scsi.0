From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 0/4] Avoid that __scsi_remove_device() hangs
Date: Mon, 10 Apr 2017 10:53:58 -0700
Message-ID: <20170410175402.9003-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:17690 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753377AbdDJRyM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 13:54:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>

Several weeks ago Israel Rukshin reported that __scsi_remove_device()
hangs if it is waiting for the SYNCHRONIZE CACHE command submitted by
the sd driver to finish if the block layer queue is stopped and does
not get restarted. This patch series avoids that that hang occurs.

Bart Van Assche (4):
  Introduce scsi_start_queue()
  Introduce scsi_execute_async()
  sd: Make synchronize cache upon shutdown asynchronous
  Avoid that __scsi_remove_device() hangs

 drivers/scsi/scsi_lib.c    | 114 ++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/scsi_priv.h   |   1 +
 drivers/scsi/scsi_sysfs.c  |   9 ++++
 drivers/scsi/sd.c          |  25 +++++++++-
 include/scsi/scsi_device.h |   4 ++
 5 files changed, 124 insertions(+), 29 deletions(-)

-- 
2.12.0
