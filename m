From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v3 0/3] Rework handling of scsi_device.vpd_pg8[03]
Date: Mon, 28 Aug 2017 13:44:39 -0700
Message-ID: <20170828204446.29066-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:63462 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH1Upa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Aug 2017 16:45:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

The conclusion of a recent discussion about the handling of SCSI device VPD
data is that the code should be reworked such that that data is freed through
kfree_rcu() instead of kfree(). The three patches in this series realize this
and also simplify the VPD code. Please consider these patches for kernel
v4.14.

Thanks,

Bart.

Changes between v2 and v3:
- Added a third patch that introduces rcu_swap_protected().
- Introduced scsi_update_vpd_page().
- Skip VPD buffer updating if querying VPD data fails.
- Fix a race condition in the VPD sysfs show method.

Changes between v1 and v2:
- Split the VPD rework into two patches.
- Introduced struct scsi_vpd and scsi_get_vpd_buf().

Bart Van Assche (3):
  Rework the code for caching Vital Product Data (VPD)
  Rework handling of scsi_device.vpd_pg8[03]
  scsi_transport_sas: Fix error handling in sas_smp_request()

 drivers/scsi/scsi.c               | 140 ++++++++++++++++----------------------
 drivers/scsi/scsi_lib.c           |  16 ++---
 drivers/scsi/scsi_sysfs.c         |  29 +++++---
 drivers/scsi/scsi_transport_sas.c |   6 +-
 include/scsi/scsi_device.h        |  18 +++--
 5 files changed, 106 insertions(+), 103 deletions(-)

-- 
2.14.1
