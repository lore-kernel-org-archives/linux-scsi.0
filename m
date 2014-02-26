From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 00/23] qla2xxx: Patches for 3.15 scsi "misc" branch.
Date: Wed, 26 Feb 2014 04:14:55 -0500
Message-ID: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:21726 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbaBZJvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Feb 2014 04:51:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Hi James,

Please apply the following patches to the scsi tree, misc branch  at your
earliest convenience. This patch set is a resubmission of a patch set we
had previously submitted plus three new patches and that this supersedes
what was posted in December.

Thanks,
~Saurav


Armen Baloyan (6):
  qla2xxx: Add handling for boot indication progress AENs for ISPFX00.
  qla2xxx: Replace constant value for IOCTL IOCB abort execution status
    with a macro for ISPFX00.
  qla2xxx: Remove Marker type IOCB logic for ISPFX00.
  qla2xxx: Add changes in the IOCB structures to adjust driver source
    codes to ISPFX00 firmware spec.
  qla2xxx: Fix Task Management command asynchronous handling
  qla2xxx: Add IOCB Abort command asynchronous handling.

Atul Deshmukh (2):
  qla2xxx: Use proper message for Non owner reset ACK Timeout.
  qla2xxx: Remove ISP_ABORT_NEEDED and ISP_ABORT_RETRY checks from
    watchdog function for ISP8044.

Chad Dupuis (6):
  qla2xxx: Add mutex around optrom calls to serialize accesses.
  qla2xxx: Set host can_queue value based on available resources.
  scsi_transport_fc: Add 32Gbps speed definition.
  qla2xxx: Add support for ISP2071.
  qla2xxx: Read capture firmware dump on mailbox timeout for ISP8044
    and ISP82XX.
  qla2xxx: Fix multiqueue MSI-X registration.

Joe Carnuccio (1):
  qla2xxx: Enable the Flash Access Control (FAC) mailbox command.

Saurav Kashyap (8):
  qla2xxx: Remove init control block related dead code for ISPFX00.
  qla2xxx: Select correct request queue for error type IOCB for
    ISPFX00.
  qla2xxx: Properly handle 32 bit mailbox register for ISPFX00.
  qla2xxx: Avoid poisoning in the response queue for ISPFX00.
  qla2xxx: Simplify the ISPFX00 interrupt handler code for ISPFX00.
  qla2xxx: Correctly set the read_optrom pointer for ISP8044.
  qla2xxx: Update the driver version to 8.07.00.02-k.
  qla2xxx: Correct the port no assignment for ISP82XX.

 drivers/scsi/qla2xxx/Makefile      |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c    |  193 +++++++-
 drivers/scsi/qla2xxx/qla_bsg.c     |   12 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |  134 +++++-
 drivers/scsi/qla2xxx/qla_dbg.h     |    7 +
 drivers/scsi/qla2xxx/qla_def.h     |   65 ++--
 drivers/scsi/qla2xxx/qla_dfs.c     |    3 +-
 drivers/scsi/qla2xxx/qla_fw.h      |    4 +
 drivers/scsi/qla2xxx/qla_gbl.h     |   12 +-
 drivers/scsi/qla2xxx/qla_gs.c      |   11 +
 drivers/scsi/qla2xxx/qla_init.c    |  426 +++++++++++++++---
 drivers/scsi/qla2xxx/qla_iocb.c    |   42 ++-
 drivers/scsi/qla2xxx/qla_isr.c     |  139 ++++--
 drivers/scsi/qla2xxx/qla_mbx.c     |   50 ++-
 drivers/scsi/qla2xxx/qla_mid.c     |    4 +-
 drivers/scsi/qla2xxx/qla_mr.c      |  252 ++---------
 drivers/scsi/qla2xxx/qla_mr.h      |   57 +--
 drivers/scsi/qla2xxx/qla_nx.c      |   21 +-
 drivers/scsi/qla2xxx/qla_nx2.c     |   22 +-
 drivers/scsi/qla2xxx/qla_os.c      |  155 +++++--
 drivers/scsi/qla2xxx/qla_sup.c     |   65 ++-
 drivers/scsi/qla2xxx/qla_tmpl.c    |  909 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_tmpl.h    |  205 ++++++++
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 drivers/scsi/scsi_transport_fc.c   |    1 +
 include/scsi/scsi_transport_fc.h   |    1 +
 26 files changed, 2248 insertions(+), 548 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_tmpl.c
 create mode 100644 drivers/scsi/qla2xxx/qla_tmpl.h

-- 
1.7.7

