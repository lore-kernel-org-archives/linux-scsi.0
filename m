From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/2] Rework handling of scsi_device.vpd_pg8[03]
Date: Fri, 25 Aug 2017 13:35:59 -0700
Message-ID: <20170825203601.23612-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:53001 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755346AbdHYUgr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:36:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

The conclusion of a recent discussion about the handling of SCSI device VPD
data is that the code should be reworked such that that data is freed through
kfree_rcu() instead of kfree(). The two patches in this series realize this
and also simplify the VPD code somewhat. Please consider these patches for
kernel v4.14.

Thanks,

Bart.

Bart Van Assche (2):
  Introduce scsi_get_vpd_buf()
  Rework handling of scsi_device.vpd_pg8[03]

 drivers/scsi/scsi.c        | 116 +++++++++++++++++++++------------------------
 drivers/scsi/scsi_lib.c    |  16 +++----
 drivers/scsi/scsi_sysfs.c  |  26 +++++++---
 include/scsi/scsi_device.h |  18 +++++--
 4 files changed, 95 insertions(+), 81 deletions(-)

-- 
2.14.1
