From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 00/16] aacraid: Fixes and enhancements for arc family
Date: Tue, 14 Feb 2017 12:44:30 -0800
Message-ID: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0059.outbound.protection.outlook.com ([104.47.36.59]:5696
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751417AbdBODWb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

This patch set contains issue fixes, enhancements and other misc changes.

The majority of the fixes are a direct outcome of testing and work done on the
adapter reset mechanism. Initially it just had IOP reset and then was augmented
with IWBR soft hardware resets in the previous patch set. The reset mechanism
is triggered in 2 paths, one is from the eh handler from the kernel and the
other is from the driver's internal periodic health checkup.

Raghava Aditya Renukunta (16):
 [SCSI] aacraid: Fix camel case
 [SCSI] aacraid: Use correct channel number for raw srb
 [SCSI] aacraid: Fix for excessive prints on EEH
 [SCSI] aacraid: Prevent E3 lockup when deleting units
 [SCSI] aacraid: Fix memory leak in fib init path
 [SCSI] aacraid: Added sysfs for driver version
 [SCSI] aacraid: Fix sync fibs time out on controller reset
 [SCSI] aacraid: Skip wellness sync on controller failure
 [SCSI] aacraid: Reload offlined drives after controller reset
 [SCSI] aacraid: Terminate kthread on controller fw assert
 [SCSI] aacraid: Decrease adapter health check  interval
 [SCSI] aacraid: Skip IOP reset on controller panic(SMART Family)
 [SCSI] aacraid: Reorder Adapter status check
 [SCSI] aacraid: Save adapter fib log before an IOP reset
 [SCSI] aacraid: Fix a potential spinlock double unlock bug
 [SCSI] aacraid: Update driver version

 drivers/scsi/aacraid/aachba.c   |  59 ++++++++++++----------
 drivers/scsi/aacraid/aacraid.h  | 107 +++++++++++++++++++++-------------------
 drivers/scsi/aacraid/commctrl.c |   2 +-
 drivers/scsi/aacraid/comminit.c |   2 +-
 drivers/scsi/aacraid/commsup.c  |  97 +++++++++++++++++++++++++++++-------
 drivers/scsi/aacraid/linit.c    |  47 ++++++++++++------
 drivers/scsi/aacraid/rx.c       |   2 +-
 drivers/scsi/aacraid/src.c      |  48 +++++++++++++++---
 8 files changed, 248 insertions(+), 116 deletions(-)

-- 
2.7.4
