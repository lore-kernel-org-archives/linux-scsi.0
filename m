From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v3 0/4] Improve requeuing behavior
Date: Wed, 30 Aug 2017 16:58:38 -0700
Message-ID: <20170830235842.29725-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2692 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbdH3X72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 19:59:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

The conclusion of a recent discussion is that .jiffies_at_alloc and .retries
should be set once at the start of a lifetime of a SCSI request instead of
every time a request is requeued. This patch series realizes that and also
ensures that a request is unprepared and reprepared when requeued. Please
consider these patches for kernel v4.14.

Thanks,

Bart.

Changes between v2 and v3:
- Removed a WARN_ON_ONCE() statement from the first patch ("Call
  scsi_initialize_rq() also for filesystem requests".)
- Fixed handling of jiffies_at_alloc in patch 2/3.
- Converted jiffies_at_alloc to seconds in patch 3/3 before printing.
- Added a fourth patch, namely "scsi-mq: Always unprepare before requeuing a
  request".

Changes between v1 and v2:
- Added two more patches next to "Improve requeuing behavior".

Bart Van Assche (4):
  Call scsi_initialize_rq() also for filesystem requests
  Improve requeuing behavior
  Show .retries and .jiffies_at_alloc in debugfs
  scsi-mq: Always unprepare before requeuing a request

 drivers/scsi/scsi_debugfs.c |  4 +++-
 drivers/scsi/scsi_lib.c     | 51 ++++++++++++++++++++++++++++++++++++++-------
 include/scsi/scsi_cmnd.h    |  3 +++
 3 files changed, 49 insertions(+), 9 deletions(-)

-- 
2.14.1
