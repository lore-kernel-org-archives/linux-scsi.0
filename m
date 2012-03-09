From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v5 0/3] qla22xxx: target mode LLD changes + tcm_qla2xxx fabric module
Date: Fri,  9 Mar 2012 00:46:56 +0000
Message-ID: <1331254019-31877-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, James Bottomley <JBottomley@Parallels.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

The following is the fifth RFC series for adding qla2xxx LLD target mode support
into mainline with 8.03.07.13-k @ v3.3-rc6 code.  This along with accompanying
tcm_qla2xxx.ko fabric module using target-core v4.1 infrastructure allows Qlogic
>= 24xx series PCI-Express adapters to function in hardware Fibre Channel
target mode operation.

Along with a number of bugfixes from different folks, the biggest changes during
RFC-v5 is the removal of pre 24xx series (PCI-X) HW support from qla_target +
qla2xxx LLD changes (1K less LOC than RFC-v4), and enabling of ABORT_TASK usabe
in tcm_qla2xxx with the current set of v3.4 target-pending/for-next patches in
the queue for v3.4-rc1.  This series is available directly here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git qla_tgt-rfc-v5

As before, this series has been broken up into reviewable sections and should
considered a 'for-3.4' -> 'for-3.5' item following the TODO items below.

The changes since RFC-v4 in mid December include:

*) Fix cmd_kref leak on target shutdown in qla_tgt_do_work() (roland)
*) Drop pre 24xx series support for target-mode (hch + nab)
*) Fix tcm_qla2xxx_do_rsp check condition cmd_kref leak (nab)
*) Hookup ABORT_TASK into qla_target/tcm_qla2xxx code (nab)
*) Convert to target_submit_tmr() usage in tcm_qla2xxx (andy + nab)
*) Fix sign of FCP_RESID field for status with RESID_OVER (roland)
*) Fix NULL pointer dereference for qla_tgt_do_work() w/ new session (joern)
*) Set disable_target_scan=1 when initiator-mode is disabled (nab)
*) Set correct nport_handle in __qla_tgt_send_term_exchange() (roland)
*) Seperate out per qla_tgt session management from qla_hw_data->hardware_lock
   to use se_session->sess_kref (nab)
*) Convert qla_target.c to use qla2x00_start_iocbs() (nab)

Unfortuately little much progress has been made since RFC-v4 to address
the TODO item wrt to mixed target/initiator mode operation on a HW per port
(struct qla_hw_data) context basis between target-core and scsi-core subsystems.

Note to testers that patch #1 by default sets the following qla2xxx module
parameter at the head of qla_target.c to enforce qla2xxx LLD module wide
target-mode and disable initiator mode:

static char *qlini_mode = QLA2XXX_INI_MODE_STR_DISABLED;
module_param(qlini_mode, charp, S_IRUGO);
MODULE_PARM_DESC(qlini_mode,
        "Determines when initiator mode will be enabled. Possible values: "
        "\"exclusive\" - initiator mode will be enabled on load, "
        "disabled on enabling target mode and then on disabling target mode "
        "enabled back; "
        "\"disabled\" (default) - initiator mode will never be enabled; "
        "\"enabled\" - initiator mode will always stay enabled.");


For an initial mainline merge, we still expect to use initiator-mode by default
(QLA2XXX_INI_MODE_STR_EXCLUSIVE) and disable target mode by default.  The qla2xxx
module parameter should be used to enable target mode for qla2xxx until scsi-core +
target-core interaction can be addressed.

(PING for feedback from hch, jejb, andrew, other folks on scsi-core + target-core
 interaction here..?)

So along with resolving this issue wrt mixed T/I mode between subsystems, other
remaining items include:

*) Fix HW session level and ConfigFS ACL level shutdown race in target core (nab)
*) Move write-pending abort checks into process-context in target core (nab)
*) Finish up NPIV support for /sys/kernel/config/target/qla2xxx_npiv/ and determine
   remaining NPIV I/O path items. (nab + madhu)
*) FC jammer testing to verify bugfix for SRRs with non zero relative offsets before
   re-enabling them. (qlogic linux team)
*) Multi-queue support with qla_hw_data->mqenable=1 (arun + qlogic team) 
*) Global event handling for active sessions in qla_tgt_reset() (nab)
*) Support for target mode on 16 Gb/sec hw (qlogic team)

Thanks again to everyone who has been testing lio-core code in their respective
setups, and to the Qlogic + Pure teams for their feedback and patches.

--nab

Nicholas Bellinger (3):
  qla2xxx: Add LLD target-mode infrastructure for >= 24xx series
  qla2xxx: Enable >= 24xx target-mode support in SCSI LLD
  tcm_qla2xxx: Add >= 24xx series fabric module for target-core

 drivers/scsi/qla2xxx/Kconfig       |    8 +
 drivers/scsi/qla2xxx/Makefile      |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c    |    5 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |    5 +
 drivers/scsi/qla2xxx/qla_dbg.h     |    5 +
 drivers/scsi/qla2xxx/qla_def.h     |   69 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |    7 +
 drivers/scsi/qla2xxx/qla_gs.c      |    4 +-
 drivers/scsi/qla2xxx/qla_init.c    |   92 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |  102 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   87 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  116 +-
 drivers/scsi/qla2xxx/qla_mid.c     |   17 +-
 drivers/scsi/qla2xxx/qla_os.c      |  133 +-
 drivers/scsi/qla2xxx/qla_target.c  | 4730 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.h  |  984 ++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 1961 +++++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  149 ++
 18 files changed, 8431 insertions(+), 46 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_target.c
 create mode 100644 drivers/scsi/qla2xxx/qla_target.h
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.c
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.h

-- 
1.7.2.5
