From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 00/22] qla2xxx: Target code enhancemets and feature update
Date: Tue, 6 Dec 2016 12:30:29 -0800
Message-ID: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0053.outbound.protection.outlook.com ([104.47.36.53]:43808
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751488AbcLFUbB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 15:31:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Hi Nic, 

Please consider this series for target-pending. This series is based on
scsi-misc series that was submitted earlier today.

Here's link for that series
 http://marc.info/?l=linux-scsi&m=148105128210090&w=2 

This series contains following changes

o Clean up Target code and tcm_qla2xxx for cleaner interaction.
o Enhanced and strengthen support for T10-DIF/PI.
o Renamed qlini_mode to qlop_mode for better readbility.
o Improve driver capability to manage dual personality 
  (i.e. Initiator and Target) simultaneously.
o Added capability to send non-critical MBX via IOCB path. 
o Some of the pending bug-fixes for target code.

Thanks, 
Himanshu

Himanshu Madhani (3):
  qla2xxx: Include ATIO queue in firmware dump when in target mode
  qla2xxx: Set tcm_qla2xxx version to automatically track qla2xxx
    version.
  qla2xxx: Clear BIT 15 in NVRAM during initialization.

Joe Carnuccio (1):
  qla2xxx: Rerfactor use of sp context

Quinn Tran (18):
  qla2xxx: Fix wrong IOCB type assumption.
  qla2xxx: Add DebugFS node of irq vector cpuid
  qla2xxx: Collect addtional debug data for FW
  qla2xxx: Fix crash due to null pointer access.
  qla2xxx: Refactore target code to remove symbol dependency
  qla2xxx: Refactor T10-DIF PI support
  qla2xxx: Add framework for Async fabric discovery.
  qla2xxx: Refactor session management code.
  qla2xxx: Add Dual mode support in the driver
  qla2xxx: Fix invalid handle erroneous message.
  qla2xxx: Add interrupt polling mechanism
  qla2xxx: Rename qlini_mode parameter
  qla2xxx: Improve RSCN handling in driver
  qla2xxx: Fix slow mem alloc behind lock
  qla2xxx: Reduce exess wait during chip reset
  qla2xxx: Allow relogin to go through if remote login did not finish
  qla2xxx: Improve submission of non critical MB interface.
  qla2xxx: Add check for corrupt ATIO.

 drivers/scsi/qla2xxx/qla_attr.c    |  366 ++++-
 drivers/scsi/qla2xxx/qla_bsg.c     |   21 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.h     |    1 +
 drivers/scsi/qla2xxx/qla_def.h     |  287 +++-
 drivers/scsi/qla2xxx/qla_dfs.c     |  237 ++-
 drivers/scsi/qla2xxx/qla_fw.h      |  107 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   86 +-
 drivers/scsi/qla2xxx/qla_gs.c      |  733 ++++++++-
 drivers/scsi/qla2xxx/qla_init.c    | 1604 +++++++++++++++-----
 drivers/scsi/qla2xxx/qla_inline.h  |   34 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |  172 ++-
 drivers/scsi/qla2xxx/qla_isr.c     |  414 ++++--
 drivers/scsi/qla2xxx/qla_mbx.c     |  553 +++++--
 drivers/scsi/qla2xxx/qla_mid.c     |   15 +-
 drivers/scsi/qla2xxx/qla_mr.c      |   52 +-
 drivers/scsi/qla2xxx/qla_os.c      |  454 ++++--
 drivers/scsi/qla2xxx/qla_target.c  | 2890 +++++++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_target.h  |  257 ++--
 drivers/scsi/qla2xxx/qla_tmpl.c    |   24 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  753 ++++++++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |   16 +-
 22 files changed, 6658 insertions(+), 2420 deletions(-)

-- 
1.8.3.1

