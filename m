From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 00/20] qla2xxx: Patches for scsi "misc" branch.
Date: Fri, 13 Dec 2013 15:03:40 -0500
Message-ID: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:29137 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295Ab3LMUhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 15:37:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree at your earliest
convenience for inclusion in the next mainline merge window.

Note: This patch set contains a change to the FC transport (10/20)
as one of the patches in this patch set is dependent on that change.

Thanks,
~Saurav 

Armen Baloyan (4):
  qla2xxx: Add handling for boot indication progress AENs for ISPFX00.
  qla2xxx: Replace constant value for IOCTL IOCB abort execution status
    with a macro for ISPFX00.
  qla2xxx: Remove Marker type IOCB logic for ISPFX00.
  qla2xxx: Add changes in the IOCB structures to adjust driver source
    codes to ISPFX00 firmware spec.

Atul Deshmukh (2):
  qla2xxx: Use proper message for Non owner reset ACK Timeout.
  qla2xxx: Remove ISP_ABORT_NEEDED and ISP_ABORT_RETRY checks from
    watchdog function for ISP8044.

Chad Dupuis (6):
  qla2xxx: Add mutex around optrom calls to serialize accesses.
  qla2xxx: Set host can_queue value based on available resources.
  scsi_transport_fc: Add 32Gbps speed definition.
  qla2xxx: Add support for ISP2701.
  qla2xxx: Read capture firmware dump on mailbox timeout for ISP8044
    and ISP82XX.
  qla2xxx: Fix multiqueue MSI-X registration.

Joe Carnuccio (1):
  qla2xxx: Enable the Flash Access Control (FAC) mailbox command.

Saurav Kashyap (7):
  qla2xxx: Remove init control block related dead code for ISPFX00.
  qla2xxx: Select correct request queue for error type IOCB for
    ISPFX00.
  qla2xxx: Properly handle 32 bit mailbox register for ISPFX00.
  qla2xxx: Avoid poisoining in the response queue for ISPFX00.
  qla2xxx: Simplyfy the ISPFX00 interrupt handler code for ISPFX00.
  qla2xxx: Correctly set the read_optrom pointer for ISP8044.
  qla2xxx: Update the driver version to 8.07.00.02-k.

 drivers/scsi/qla2xxx/Makefile      |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c    |  193 +++++++-
 drivers/scsi/qla2xxx/qla_bsg.c     |   12 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |  133 +++++-
 drivers/scsi/qla2xxx/qla_dbg.h     |    7 +
 drivers/scsi/qla2xxx/qla_def.h     |   65 ++--
 drivers/scsi/qla2xxx/qla_dfs.c     |    3 +-
 drivers/scsi/qla2xxx/qla_fw.h      |    4 +
 drivers/scsi/qla2xxx/qla_gbl.h     |   10 +
 drivers/scsi/qla2xxx/qla_gs.c      |   11 +
 drivers/scsi/qla2xxx/qla_init.c    |  261 ++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |   15 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   72 ++--
 drivers/scsi/qla2xxx/qla_mbx.c     |   47 ++-
 drivers/scsi/qla2xxx/qla_mid.c     |    4 +-
 drivers/scsi/qla2xxx/qla_mr.c      |   98 ++---
 drivers/scsi/qla2xxx/qla_mr.h      |   57 +--
 drivers/scsi/qla2xxx/qla_nx.c      |   21 +-
 drivers/scsi/qla2xxx/qla_nx2.c     |   22 +-
 drivers/scsi/qla2xxx/qla_os.c      |  152 +++++--
 drivers/scsi/qla2xxx/qla_sup.c     |   65 ++-
 drivers/scsi/qla2xxx/qla_tmpl.c    |  909 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_tmpl.h    |  205 ++++++++
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 drivers/scsi/scsi_transport_fc.c   |    1 +
 include/scsi/scsi_transport_fc.h   |    1 +
 26 files changed, 2040 insertions(+), 334 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_tmpl.c
 create mode 100644 drivers/scsi/qla2xxx/qla_tmpl.h

-- 
1.7.7

