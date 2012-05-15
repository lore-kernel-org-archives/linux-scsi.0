From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 00/22] qla2xxx: Updates for scsi "misc" branch.
Date: Tue, 15 May 2012 14:34:07 -0400
Message-ID: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:22989 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966144Ab2EOS5Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree at your earliest
convenience for inclusion in the 3.5 mainline merge window.  One
important thing to point out is that we've included the hooks for the
new target infrastructure into the qla2xx driver with this patch set.
We've been testing extensively the initiator mode functionalities and
target mode components with the consolidated tree for last several
months and we believe that it is ready for merging.

Thanks,
Chad

Andrew Vasquez (1):
  qla2xxx: Fix typo in bus-reset handler.

Chad Dupuis (5):
  qla2xxx: Remove unneeded DPC wakeups from qla82xx_watchdog.
  qla2xxx: Change "Done" to "Entering" in the debug print statement in
    qla2x00_port_logout.
  qla2xxx: Handle interrupt registration failures more gracefully.
  qla2xxx: Log link up and link down messages to track link flops.
  Revert "qla2xxx: During loopdown perform Diagnostic loopback."

Chetan Loke (1):
  qla2xxx: Micro optimization in queuecommand handler

Giridhar Malavali (4):
  qla2xxx: Detect PEG errors.
  qla2xxx: Display proper supported speeds for 16G FC adapters.
  qla2xxx: Don't capture minidump for ISP82xx on flash update from
    application.
  qla2xxx: Display proper firmware version when new minidump template
    is gathered for ISP82xx.

Joe Carnuccio (3):
  qla2xxx: Remove mirrored field vp_idx from struct fc_port.
  qla2xxx: Optimize existing port name server query matching.
  qla2xxx: Avoid losing any fc ports when loop id's are exhausted.

Masanari Iida (1):
  qla2xxx: Fix typo in qla_mbx.c

Nicholas Bellinger (2):
  qla2xxx: Add LLD target-mode infrastructure for >= 24xx series
  tcm_qla2xxx: Add >= 24xx series fabric module for target-core

Nigel Kirkland (1):
  qla2xxx: Fixups for ISP83xx.

Raul Porcel (1):
  qla2xxx: Fix typo in qla_init.c

Saurav Kashyap (3):
  qla2xxx: Add ql_dbg_verbose logging level.
  qla2xxx: Stats should be different from physical and virtual ports
  qla2xxx: Corrections to log messages.

 drivers/scsi/qla2xxx/Kconfig       |    9 +
 drivers/scsi/qla2xxx/Makefile      |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c    |   22 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |   12 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |   81 +-
 drivers/scsi/qla2xxx/qla_dbg.h     |    9 +
 drivers/scsi/qla2xxx/qla_def.h     |   78 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |    9 +
 drivers/scsi/qla2xxx/qla_gs.c      |    4 +-
 drivers/scsi/qla2xxx/qla_init.c    |  197 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   88 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   94 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  615 ++++--
 drivers/scsi/qla2xxx/qla_mid.c     |   18 +-
 drivers/scsi/qla2xxx/qla_nx.c      |   66 +-
 drivers/scsi/qla2xxx/qla_nx.h      |   14 +-
 drivers/scsi/qla2xxx/qla_os.c      |  173 +-
 drivers/scsi/qla2xxx/qla_target.c  | 4973 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.h  | 1005 ++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 1955 ++++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |   82 +
 21 files changed, 9085 insertions(+), 422 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_target.c
 create mode 100644 drivers/scsi/qla2xxx/qla_target.h
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.c
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.h

-- 
1.7.7

