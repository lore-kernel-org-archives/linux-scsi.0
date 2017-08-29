From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v4 0/3] Rework handling of scsi_device.vpd_pg8[03]
Date: Tue, 29 Aug 2017 08:50:10 -0700
Message-ID: <20170829155013.11124-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:9012 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdH2Pu7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 11:50:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

The conclusion of a recent discussion about the handling of SCSI device VPD
data is that the code should be reworked such that that data is freed through
kfree_rcu() instead of kfree(). The three patches in this series realize this
and also simplify the VPD code. Please consider these patches for kernel
v4.14.

Thanks,

Bart.

Changes between v3 and v4:
- Reworked patch 1/3 as requested by Paul E. McKenney.
- Added Acked-by / Reviewed-by tags.

Changes between v2 and v3:
- Added a third patch that introduces rcu_swap_protected().
- Introduced scsi_update_vpd_page().
- Skip VPD buffer updating if querying VPD data fails.
- Fix a race condition in the VPD sysfs show method.

Changes between v1 and v2:
- Split the VPD rework into two patches.
- Introduced struct scsi_vpd and scsi_get_vpd_buf().

Bart Van Assche (3):
  rcu: Introduce rcu_swap_protected()
  Rework the code for caching Vital Product Data (VPD)
  Rework handling of scsi_device.vpd_pg8[03]

 drivers/scsi/scsi.c        | 140 +++++++++++++++++++--------------------------
 drivers/scsi/scsi_lib.c    |  16 +++---
 drivers/scsi/scsi_sysfs.c  |  29 +++++++---
 include/linux/rcupdate.h   |  16 ++++++
 include/scsi/scsi_device.h |  18 ++++--
 5 files changed, 118 insertions(+), 101 deletions(-)

-- 
2.14.1
