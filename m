From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v3 0/2] Ensure that the SCSI error handler gets woken up
Date: Mon,  4 Dec 2017 10:06:22 -0800
Message-ID: <20171204180624.18722-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:29886 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdLDSGc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 13:06:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

As reported by Pavel Tikhomirov it can happen that the SCSI error handler does
not get woken up. This is very annoying because it results in a queue
stall. The two patches in this series address this issue without acquiring the
SCSI host lock in the hot path. Please consider these patches for kernel
v4.16.

Thanks,

Bart.

Changes between v2 and v3:
- Made it again safe to call scsi_eh_scmd_add() from interrupt context.

Changes between v1 and v2:
- Ensure that host_lock is held while checking host_failed.
- Moved the lockdep_assert_held() change into a separate patch.

Bart Van Assche (2):
  Ensure that the SCSI error handler gets woken up
  Convert a source code comment into a runtime check

 drivers/scsi/hosts.c      |  6 ++++++
 drivers/scsi/scsi_error.c | 21 ++++++++++++++++++---
 drivers/scsi/scsi_lib.c   | 39 ++++++++++++++++++++++++++++-----------
 include/scsi/scsi_host.h  |  2 ++
 4 files changed, 54 insertions(+), 14 deletions(-)

-- 
2.15.0
