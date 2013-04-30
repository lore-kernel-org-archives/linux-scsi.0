From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.9+ merge window
Date: Tue, 30 Apr 2013 11:03:59 -0700
Message-ID: <1367345039.4618.15.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the first round, consisting mostly of drivers and patches
submitted 3 weeks ago.  Since I've been travelling quite a bit, there
will be a second round just before the merge window closes for all the
patches three weeks or newer, or which got flagged for my attention
after 10 April.

The patch set is mostly driver updates (qla4, qla2 [ISF support
updates], lpfc, aacraid [dual firmware image support]) and a few bug
fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is

Adheer Chandravanshi (8):
      qla4xxx: Use correct value for max flash node entries
      qla4xxx: Restrict logout from boot target session using session id
      qla4xxx: Use correct flash ddb offset for ISP40XX
      qla4xxx: Replace dev type macros with generic portal type macros
      scsi_transport_iscsi: Declare portal type string macros for generic use
      qla4xxx: Add flash node mgmt support
      libiscsi: export function iscsi_switch_str_param
      scsi_transport_iscsi: Add flash node mgmt support

Giridhar Malavali (1):
      qla2xxx: Enhancements to support ISPFx00.

Jack Wang (1):
      pm8001: updated MAINTAINERS list

James Smart (11):
      lpfc 8.3.38: Update lpfc version for 8.3.38 driver release
      lpfc 8.3.38: Fixed potential mis-interpretation of READ_TOPOLOGY reserved fields
      lpfc 8.3.38: Fix default value for lpfc_enable_rrq.
      lpfc 8.3.38: Fixed circular locking dependency and inconsistent lock state issues
      lpfc 8.3.38: Fixed PT2PT bring up problem for FC SLI4.
      lpfc 8.3.38: Fixed OXID reuse issue.
      lpfc 8.3.38: Fixed async FCF modified event to in-use FCF failure to trigger recovery
      lpfc 8.3.38: Fixed deadlock condition in FCF round robin handling
      scsilpfc 8.3.38: Fixed bsg timeout handling issues that would result in crashes
      lpfc 8.3.38: Fixed degraded performance after cable pulls
      lpfc 8.3.38: Fixed NMI watch dog panic's when resetting the hba.

Jingoo Han (1):
      isci: add CONFIG_PM_SLEEP to suspend/resume functions

Joe Carnuccio (2):
      qla2xxx: Obtain loopback iteration count from bsg request.
      qla2xxx: Add clarifying printk to thermal access fail cases.

Mahesh Rajashekhara (1):
      aacraid: Dual firmware image support

Manish Dusane (1):
      qla4xxx: Take E-port out of reset before disabling pause frames

Masatake YAMATO (1):
      libiscsi: avoid unnecessary multiple NULL assignments

Mike Christie (2):
      iscsi_tcp: support PF_MEMALLOC/__GFP_MEMALLOC
      scsi_dh_alua: fix stpg sense handling

Nilesh Javali (1):
      qla4xxx: Skip retry of initialize_adapter for ISP80XX

Saurav Kashyap (1):
      qla2xxx: Update the driver version to 8.05.00.03-k.

Stewart, Sean (1):
      scsi_dh_alua: Add module parameter to allow failover to non preferred path without STPG

Tej Parkash (1):
      qla4xxx: Fixed request queue count manipulation on response path

Vikas Chaudhary (12):
      qla4xxx: Update driver version to 5.03.00-k8
      qla4xxx: Added print statements to display AENs
      qla4xxx: Update driver version to 5.03.00-k7
      qla4xxx: Update driver version to 5.03.00-k6
      qla4xxx: Assign correct CHAP table address to FLT
      qla4xxx: Added missing check for ISP83XX in CHAP related functions
      qla4xxx: Update driver version to 5.03.00-k5
      qla4xxx: Fix debug level to avoid floods of same message
      qla4xxx: Pass correct LUN address to firmware in case of lun_reset
      qla4xxx: Fix double reset in case of firmware hung for ISP83XX
      qla4xxx: Set graceful reset bit for ISP83XX
      qla4xxx: Boot from SAN fix for ISP83XX

Wei Yongjun (2):
      qla2xxx: Remove duplicated include form qla_isr.c
      csiostor: remove unused variable in csio_process_fwevtq_entry()

And the diffstat

 MAINTAINERS                                |    2 +-
 drivers/scsi/aacraid/aacraid.h             |    6 +-
 drivers/scsi/aacraid/comminit.c            |    2 +-
 drivers/scsi/aacraid/src.c                 |   26 +-
 drivers/scsi/csiostor/csio_hw.c            |    5 -
 drivers/scsi/device_handler/scsi_dh_alua.c |   17 +-
 drivers/scsi/isci/init.c                   |    6 +-
 drivers/scsi/iscsi_tcp.c                   |   18 +-
 drivers/scsi/libiscsi.c                    |    4 +-
 drivers/scsi/lpfc/lpfc_attr.c              |   12 +-
 drivers/scsi/lpfc/lpfc_bsg.c               | 1107 +++++----
 drivers/scsi/lpfc/lpfc_crtn.h              |    1 +
 drivers/scsi/lpfc/lpfc_els.c               |   21 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c           |   68 +-
 drivers/scsi/lpfc/lpfc_hw4.h               |    3 +
 drivers/scsi/lpfc/lpfc_init.c              |  106 +-
 drivers/scsi/lpfc/lpfc_mbox.c              |   24 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c         |    1 -
 drivers/scsi/lpfc/lpfc_scsi.c              |    8 +-
 drivers/scsi/lpfc/lpfc_sli.c               |  115 +-
 drivers/scsi/lpfc/lpfc_version.h           |    2 +-
 drivers/scsi/qla2xxx/Makefile              |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c            |   35 +-
 drivers/scsi/qla2xxx/qla_bsg.c             |  154 +-
 drivers/scsi/qla2xxx/qla_bsg.h             |    1 +
 drivers/scsi/qla2xxx/qla_dbg.c             |   27 +-
 drivers/scsi/qla2xxx/qla_def.h             |  236 +-
 drivers/scsi/qla2xxx/qla_gbl.h             |   47 +-
 drivers/scsi/qla2xxx/qla_gs.c              |   16 +-
 drivers/scsi/qla2xxx/qla_init.c            |   52 +-
 drivers/scsi/qla2xxx/qla_inline.h          |   41 +-
 drivers/scsi/qla2xxx/qla_iocb.c            |   67 +-
 drivers/scsi/qla2xxx/qla_isr.c             |   20 +-
 drivers/scsi/qla2xxx/qla_mbx.c             |   10 +-
 drivers/scsi/qla2xxx/qla_mr.c              | 3476 ++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mr.h              |  510 ++++
 drivers/scsi/qla2xxx/qla_os.c              |  212 +-
 drivers/scsi/qla2xxx/qla_version.h         |    4 +-
 drivers/scsi/qla4xxx/ql4_83xx.c            |   28 +
 drivers/scsi/qla4xxx/ql4_83xx.h            |   10 +
 drivers/scsi/qla4xxx/ql4_dbg.h             |    7 +
 drivers/scsi/qla4xxx/ql4_def.h             |   19 +
 drivers/scsi/qla4xxx/ql4_fw.h              |   38 +
 drivers/scsi/qla4xxx/ql4_glbl.h            |    9 +-
 drivers/scsi/qla4xxx/ql4_isr.c             |   47 +-
 drivers/scsi/qla4xxx/ql4_mbx.c             |  120 +-
 drivers/scsi/qla4xxx/ql4_nx.c              |   19 +-
 drivers/scsi/qla4xxx/ql4_os.c              | 1937 +++++++++++++++-
 drivers/scsi/qla4xxx/ql4_version.h         |    2 +-
 drivers/scsi/scsi_transport_iscsi.c        | 1002 +++++++-
 include/scsi/iscsi_if.h                    |  117 +
 include/scsi/libiscsi.h                    |    1 +
 include/scsi/scsi_transport_iscsi.h        |  151 ++
 53 files changed, 9067 insertions(+), 904 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_mr.c
 create mode 100644 drivers/scsi/qla2xxx/qla_mr.h

James
