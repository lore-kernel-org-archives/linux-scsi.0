From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.5-rc4
Date: Sat, 13 Feb 2016 13:47:36 -0800
Message-ID: <1455400056.32243.19.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target-pending bug-fixes for v4.5-rc4.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes the long awaited series to address a set of bugs around
active I/O remote-port LUN_RESET, as well as properly handling this same
case with concurrent fabric driver session disconnect -> reconnect.

Note this set of LUN_RESET bug-fixes has been surviving extended testing
on both v4.5-rc1 and v3.14.y code over the last weeks, and is CC'ed for
stable as it's something folks using multiple ESX connected hosts with
slow backends can certainly trigger.

The highlights also include:

  - Fix WRITE_SAME/DISCARD emulation 4k sector conversion in target/iblock
    (Mike Christie)
  - Fix TMR abort interaction and AIO type TMR response in qla2xxx target
    (Quinn Tran + Swapnil Nagle)
  - Fix >= v3.17 stale descriptor pointer regression in qla2xxx target
    (Quinn Tran)
  - Fix >= v4.5-rc1 return regression with unmap_zeros_data_store
    new configfs store handler (nab)
  - Add CPU affinity flag + convert qla2xxx to use bit
    (Quinn + HCH + Bart)

Thank you,

--nab

Arnd Bergmann (1):
  target/user: Fix cast from pointer to phys_addr_t

Himanshu Madhani (1):
  qla2xxx: Fix warning reported by static checker

Mike Christie (1):
  target: Fix WRITE_SAME/DISCARD conversion to linux 512b sectors

Nicholas Bellinger (7):
  target: Fix LUN_RESET active I/O handling for ACK_KREF
  target: Fix LUN_RESET active TMR descriptor handling
  target: Fix TAS handling for multi-session se_node_acls
  target: Fix remote-port TMR ABORT + se_cmd fabric stop
  target: Fix race with SCF_SEND_DELAYED_TAS handling
  target: Drop legacy se_cmd->task_stop_comp + REQUEST_STOP usage
  target: Fix incorrect unmap_zeroes_data_store return

Quinn Tran (4):
  qla2xxx: Fix TMR ABORT interaction issue between qla2xxx and TCM
  qla2xxx: Fix stale pointer access.
  target/transport: add flag to indicate CPU Affinity is observed
  qla2xxx: use TARGET_SCF_USE_CPUID flag to indiate CPU Affinity

Swapnil Nagle (1):
  qla2xxx: Use ATIO type to send correct tmr response

 drivers/scsi/qla2xxx/qla_init.c        |  10 +-
 drivers/scsi/qla2xxx/qla_isr.c         |   4 +-
 drivers/scsi/qla2xxx/qla_mid.c         |   4 +-
 drivers/scsi/qla2xxx/qla_os.c          |   6 +
 drivers/scsi/qla2xxx/qla_target.c      |  68 ++++---
 drivers/scsi/qla2xxx/qla_target.h      |  59 +++---
 drivers/scsi/qla2xxx/qla_tmpl.c        |  16 ++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  76 +++++++-
 drivers/target/target_core_configfs.c  |   2 +-
 drivers/target/target_core_device.c    |  44 +++++
 drivers/target/target_core_file.c      |  29 +--
 drivers/target/target_core_iblock.c    |  58 ++----
 drivers/target/target_core_internal.h  |   1 -
 drivers/target/target_core_tmr.c       | 139 ++++++++++----
 drivers/target/target_core_transport.c | 327 ++++++++++++++++++++-------------
 drivers/target/target_core_user.c      |   2 +-
 include/target/target_core_backend.h   |   3 +
 include/target/target_core_base.h      |   9 +-
 18 files changed, 567 insertions(+), 290 deletions(-)
