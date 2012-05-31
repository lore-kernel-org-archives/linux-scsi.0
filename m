From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for the 3.4+ merge window
Date: Thu, 31 May 2012 13:17:55 +0100
Message-ID: <1338466675.3073.21.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is primarily another round of driver updates (bnx2fc, qla2xxx,
qla4xxx) including the target mode driver for qla2xxx.  We've also got a
couple of regression fixes (async scanning, broken this merge window and
a fix to a long standing break in the scsi_wait_scan module).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git scsi-misc

The short changelog is

Aaron Lu (1):
      scsi_pm: resume device if suspend failed

Andrew Vasquez (1):
      qla2xxx: Fix typo in bus-reset handler.

Bhanu Prakash Gollapudi (4):
      bnx2fc: Bumped version to 1.0.11
      bnx2fc: cleanup task management IO when it times out.
      bnx2fc: Decrememnt io ref count when abort times out
      bnx2fc: Allow FLOGI to be retried when receiving bad responses.

Chad Dupuis (5):
      Revert "qla2xxx: During loopdown perform Diagnostic loopback."
      qla2xxx: Log link up and link down messages to track link flops.
      qla2xxx: Handle interrupt registration failures more gracefully.
      qla2xxx: Change "Done" to "Entering" in the debug print statement in qla2x00_port_logout.
      qla2xxx: Remove unneeded DPC wakeups from qla82xx_watchdog.

Chetan Loke (1):
      qla2xxx: Micro optimization in queuecommand handler

Dan Carpenter (2):
      qla2xxx: don't free pool that wasn't allocated
      mptfusion: unlock on error in mpt_config()

Dan Williams (1):
      fix async probe regression

Giridhar Malavali (4):
      qla2xxx: Display proper firmware version when new minidump template is gathered for ISP82xx.
      qla2xxx: Don't capture minidump for ISP82xx on flash update from application.
      qla2xxx: Display proper supported speeds for 16G FC adapters.
      qla2xxx: Detect PEG errors.

James Bottomley (1):
      fix scsi_wait_scan

Joe Carnuccio (3):
      qla2xxx: Avoid losing any fc ports when loop id's are exhausted.
      qla2xxx: Optimize existing port name server query matching.
      qla2xxx: Remove mirrored field vp_idx from struct fc_port.

Jun'ichi Nomura (1):
      Fix dm-multipath starvation when scsi host is busy

Krishna Gudipati (1):
      bfa: Fix to set vport FC host sysfs entries

Lalit Chandivade (1):
      qla4xxx: Correct early completion of pending mbox.

Manish Rangankar (2):
      qla4xxx: Fix clear ddb mbx command failure issue.
      qla4xxx: Fix kernel panic during discovery logout.

Masanari Iida (1):
      qla2xxx: Fix typo in qla_mbx.c

Mike Christie (1):
      be2iscsi: fix dma free size mismatch regression

Namjae Jeon (1):
      ufs: fix potential NULL pointer dereferencing error in ufshcd_prove.

Nicholas Bellinger (2):
      tcm_qla2xxx: Add >= 24xx series fabric module for target-core
      qla2xxx: Add LLD target-mode infrastructure for >= 24xx series

Nigel Kirkland (1):
      qla2xxx: Fixups for ISP83xx.

Raul Porcel (1):
      qla2xxx: Fix typo in qla_init.c

Robert Love (4):
      fcoe, bnx2fc, libfcoe: SW FCoE and bnx2fc use FCoE Syfs
      libfcoe: Add fcoe_sysfs
      bnx2fc: Allocate fcoe_ctlr with bnx2fc_interface, not as a member
      fcoe: Allocate fcoe_ctlr with fcoe_interface, not as a member

Saurav Kashyap (3):
      qla2xxx: Corrections to log messages.
      qla2xxx: Stats should be different from physical and virtual ports
      qla2xxx: Add ql_dbg_verbose logging level.

Tej Parkash (2):
      qla4xxx: Capture minidump for ISP82XX on firmware failure
      qla4xxx: Add change_queue_depth API support

Vikas Chaudhary (1):
      qla4xxx: Update driver version to 5.02.00-k17

And the diffstat:

 Documentation/ABI/testing/sysfs-bus-fcoe |   77 +
 drivers/message/fusion/mptbase.c         |    1 +
 drivers/scsi/be2iscsi/be_mgmt.c          |    5 +-
 drivers/scsi/bfa/bfad_attr.c             |   17 +
 drivers/scsi/bfa/bfad_im.c               |    2 +-
 drivers/scsi/bfa/bfad_im.h               |    1 +
 drivers/scsi/bnx2fc/bnx2fc.h             |    9 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c         |   18 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c        |  173 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c         |   39 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c          |  122 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c         |   21 +-
 drivers/scsi/fcoe/Makefile               |    2 +-
 drivers/scsi/fcoe/fcoe.c                 |  200 +-
 drivers/scsi/fcoe/fcoe.h                 |    8 +-
 drivers/scsi/fcoe/fcoe_ctlr.c            |  159 +-
 drivers/scsi/fcoe/fcoe_sysfs.c           |  832 +++++
 drivers/scsi/fcoe/fcoe_transport.c       |   13 +-
 drivers/scsi/qla2xxx/Kconfig             |    9 +
 drivers/scsi/qla2xxx/Makefile            |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c          |   22 +-
 drivers/scsi/qla2xxx/qla_bsg.c           |   12 +-
 drivers/scsi/qla2xxx/qla_dbg.c           |   81 +-
 drivers/scsi/qla2xxx/qla_dbg.h           |    9 +
 drivers/scsi/qla2xxx/qla_def.h           |   78 +-
 drivers/scsi/qla2xxx/qla_gbl.h           |    9 +
 drivers/scsi/qla2xxx/qla_gs.c            |    4 +-
 drivers/scsi/qla2xxx/qla_init.c          |  199 +-
 drivers/scsi/qla2xxx/qla_iocb.c          |   90 +-
 drivers/scsi/qla2xxx/qla_isr.c           |   94 +-
 drivers/scsi/qla2xxx/qla_mbx.c           |  615 ++--
 drivers/scsi/qla2xxx/qla_mid.c           |   18 +-
 drivers/scsi/qla2xxx/qla_nx.c            |   66 +-
 drivers/scsi/qla2xxx/qla_nx.h            |   14 +-
 drivers/scsi/qla2xxx/qla_os.c            |  173 +-
 drivers/scsi/qla2xxx/qla_target.c        | 4973 ++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.h        | 1005 ++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       | 1955 ++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.h       |   82 +
 drivers/scsi/qla4xxx/ql4_attr.c          |  134 +
 drivers/scsi/qla4xxx/ql4_def.h           |   22 +
 drivers/scsi/qla4xxx/ql4_fw.h            |   28 +
 drivers/scsi/qla4xxx/ql4_glbl.h          |    8 +
 drivers/scsi/qla4xxx/ql4_init.c          |   95 +-
 drivers/scsi/qla4xxx/ql4_mbx.c           |  111 +-
 drivers/scsi/qla4xxx/ql4_nx.c            |  738 ++++-
 drivers/scsi/qla4xxx/ql4_nx.h            |  192 ++
 drivers/scsi/qla4xxx/ql4_os.c            |   78 +-
 drivers/scsi/qla4xxx/ql4_version.h       |    2 +-
 drivers/scsi/scsi_lib.c                  |   11 +-
 drivers/scsi/scsi_pm.c                   |    5 +-
 drivers/scsi/scsi_scan.c                 |    7 +-
 drivers/scsi/scsi_wait_scan.c            |    2 +-
 drivers/scsi/ufs/ufshcd.c                |    5 +-
 include/scsi/fcoe_sysfs.h                |  124 +
 include/scsi/libfcoe.h                   |   27 +
 56 files changed, 12125 insertions(+), 674 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-fcoe
 create mode 100644 drivers/scsi/fcoe/fcoe_sysfs.c
 create mode 100644 drivers/scsi/qla2xxx/qla_target.c
 create mode 100644 drivers/scsi/qla2xxx/qla_target.h
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.c
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.h
 create mode 100644 include/scsi/fcoe_sysfs.h

James
