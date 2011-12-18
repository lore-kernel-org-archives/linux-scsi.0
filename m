From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v4 0/3] qla2xxx: v3.4 target mode LLD changes + tcm_qla2xxx fabric module
Date: Sun, 18 Dec 2011 02:02:23 +0000
Message-ID: <1324173746-14361-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Parallels.com>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Andrew, James, Roland, Christoph & Co,

The following is the forth RFC series for adding qla2xxx LLD target mode support
into mainline 8.03.07.07-k @ 3.2-rc5 along with accompanying tcm_qla2xxx.ko
fabric module cut against target v4.1 infrastructure.  As before, this series
has been broken up into reviewable sections and should considered a 'for-3.4'
item as remaining TODO items are resolved.

The code is available directly against the most recent target-pending/for-next
changes using new v3.3 target_submit_cmd logic here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git qla_tgt-rfc-v4

There have been many improvements, bugfixes and cleanups since RFC-v3 during
the course of 2011.  Thanks to everyone who has contributed in order to get
this code worked into shape, as well as thanks to Vlad and the SCST community
for original qla2x00t implementation.

Here is a brief rundown of the changes since RFC-v3 earlier this year:

*) Convert to use scatterlist for all CDBS types for mainline target (andy + hch)
*) Fix for NULL s_id in qla_tgt_exec_sess_work() abort handling
   (roland via r3244 scst svn)
*) Disable EXPLICIT_CONFORM for FCP READ CHECK_CONDITION to address issue where
   SRR was being triggered during CHECK_CONDITION handling (nab + roland)
*) Address issues in qla_target.c request queue full handling (roland)
*) Add support for active I/O shutdown using generic target logic.  This includes
   numerous bugfixes related to shutdown. (roland + pure team + nab)
*) Kick target ATIO queue after qla2x00_fw_ready() completion. (roland + andrew)
*) Convert qla_target.c to use mainline v3.1 qla_dbg macros (nab)
*) Move to use command hardware structure definitions between > 24xx and older
   hardware. (madhu)
*) Make qla_target.c follow qla2xxx consistent code+naming conventions (madhu)
*) Add tcm_qla2xxx_free_wq for process context release instead of using
   TRANSPORT_FREE_CMD_INTR (hch + nab)
*) Refactor qla_tgt_send_term_exchange() in order to remove qla_tgt_cmd->locked_rsp
   exception path usage. (nab)
*) Conversion to use an internal workqueue in qla_target.c code for I/O dispatch
   into tcm_qla2xxx instead of legacy ->new_cmd_map(). (hch + nab)
*) Removal of unnecessary qla_hw_data->hardware_lock access in tcm_qla2xxx response
   path in tcm_qla2xxx_check_stop_free() and tcm_qla2xxx_release_cmd() (nab + joern)
*) Conversion to use target_submit_cmd() with for-next v3.3 code (nab + hch)
*) Merge into single tcm_qla2xxx.[c,h] files, and move into drivers/scsi/qla2xxx/

So to get the ball rolling on remaining items, one question is still how to
resolve mixed target/initiator mode operation on a HW per port context basis..?

This is currently done with a qla2xxx module parameter, but to do mixed mode
properly we will need something smarter between scsi-core and target-core ports.
Note we currently set qlini_mode = QLA2XXX_INI_MODE_STR_DISABLED, so by default
patch #1 will effectively disable initiator mode by skipping scsi_scan_host()
from being called in to avoid scsi-core timeouts when performing immediate
transition from initiator mode -> target mode via ISP reset.

What we would like to eventually do is run qla2xxx LLD to allow both initiator
and target mode access based on the physical HW port.  We tried some simple
qla_target.c changes this make this work, but to really do it properly
and address current qlini_mode = QLA2XXX_INI_MODE_STR_DISABLED usage it will
need to involve scsi-core so that individual HW port can be configured and
dynamically changed across different access modes.

(hch + james comments here..?)

So along with resolving this issue with mixed T/I mode, other TODO items
include:

*) Seperate out per qla_tgt session management from qla_hw_data->hardware_lock
   to use seperate lock. (nab)
*) Move write-pending abort checks into process-context (nab)
*) Finish up NPIV support for /sys/kernel/config/target/qla2xxx_npiv/ and determine
   remaining NPIV I/O path items. (nab + madhu)
*) FC jammer testing to verify bugfix for SRRs with non zero relative offsets before
   re-enabling them. (andrew + qlogic team)
*) Add proper support for ABORT_TASK in target-core (nab)
*) Multi-queue support with qla_hw_data->mqenable=1 (mq target fw support..?) 
*) Global event handling for active sessions in qla_tgt_reset()

Please have a look and let us know if you have any comments,

Thank you,

Nicholas Bellinger (3):
  qla2xxx: Add LLD internal target-mode support
  qla2xxx: Enable 2xxx series LLD target mode support
  qla2xxx: Add tcm_qla2xxx fabric module for mainline target

 drivers/scsi/qla2xxx/Kconfig       |    8 +
 drivers/scsi/qla2xxx/Makefile      |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c    |    5 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |   13 +-
 drivers/scsi/qla2xxx/qla_dbg.h     |    5 +
 drivers/scsi/qla2xxx/qla_def.h     |   70 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |    7 +
 drivers/scsi/qla2xxx/qla_gs.c      |    4 +-
 drivers/scsi/qla2xxx/qla_init.c    |  101 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |  105 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   86 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  122 +-
 drivers/scsi/qla2xxx/qla_mid.c     |   21 +-
 drivers/scsi/qla2xxx/qla_os.c      |  126 +-
 drivers/scsi/qla2xxx/qla_target.c  | 5482 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.h  | 1147 ++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2059 ++++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  148 +
 18 files changed, 9454 insertions(+), 58 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_target.c
 create mode 100644 drivers/scsi/qla2xxx/qla_target.h
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.c
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.h

-- 
1.7.2.3
