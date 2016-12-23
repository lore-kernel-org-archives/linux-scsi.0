From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v3 00/12] scsi: ufs: add trace/debug support, sysfs controls and few fixes
Date: Thu, 22 Dec 2016 18:39:33 -0800
Message-ID: <1482460773-5931-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45018 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932927AbcLWCjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2016 21:39:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>

This patch series adds following things:
 - ftrace support to trace important events in UFS driver.
 - debug dumps following failures to ease the debugging
 - sysfs node to control clock gating, clock scaling and PM
 - few fixes

---
Changes from v2 -> v3:

1. Patch #2: Used TRACE_DEFINE_ENUM to print out enums

2. Patch #11: Removed conditional compilation based on CONFIG_TRACEPOINTS
   and used trace_*_enabled() to skip unnecessary code path execution.

3. Patch #7: Simplified patch to just set the default power management
   level. Device tree capability to specify broken hardware will be taken
   up as separate patch in different patch series than current one.
	
1 & 2 should address Steven Rostedt's comments.

3 should address Rob Herring's comments.

Changes from v1 -> v2:
 - Added explicit new line character at the end of the printk messages
   for patch #1 & #12
 - Fixed couple of checkpatch warnings for patch #1
---

Dolev Raviv (3):
  scsi: ufs: dump debug info during failures
  scsi: ufs: fix multiple ufs spec violation
  scsi: ufs: Improve fatal error logs

Lee Susman (1):
  scsi: ufs: add trace event for ufs commands

Sahitya Tummala (2):
  scsi: ufs: Add sysfs node to dynamically control clock gating
  scsi: ufs: Add sysfs node to dynamically control clock scaling

Subhash Jadavani (6):
  scsi: ufs: add tracing support
  scsi: ufs: provide sysfs attribute to select the PM level
  scsi: ufs: set default UFS power management level
  scsi: ufs: add capability to keep auto bkops always enabled
  scsi: ufs: fix setting init power mode
  scsi: ufs: add time profiling support

 drivers/scsi/ufs/ufshcd.c  | 785 +++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h  |  70 +++-
 drivers/scsi/ufs/ufshci.h  |   3 +
 include/trace/events/ufs.h | 263 +++++++++++++++
 4 files changed, 1066 insertions(+), 55 deletions(-)
 create mode 100644 include/trace/events/ufs.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

