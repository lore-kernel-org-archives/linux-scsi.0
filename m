From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.2-rc5
Date: Tue, 28 Jul 2015 17:53:42 -0700
Message-ID: <1438131222.3750.23.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Alexei Potashnik <alexei@purestorage.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Roland Dreier <roland@purestorage.com>, Arun Easi <arun.easi@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the outstanding target-pending fixes for v4.2-rc5 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This series is larger than what I'd normally be conformable with sending
for a -rc5 PULL request..

However, the bulk of the series is localized to qla2xxx target specific
fixes that address a number of real-world correctness issues, that have
been outstanding on the list for ~6 weeks now.  They where submitted +
verified + acked by the HW LLD vendor, contributed by a major production
customer of the code, and are marked for v3.18.y stable code.

That said, I don't see a good reason to wait another month to get these
fixes into mainline.

Beyond the qla2xx specific fixes, this series also includes:

  - Bugfix for a long standing use-after-free in iscsi-target during
    TPG shutdown + demo-mode sessions.
  - Bugfix for a >= v4.0 regression OOPs in iscsi-target during a
    iscsi_start_kthreads() failure.
  - Bugfix for a >= v4.0 regression hang in iscsi-target for iser
    explicit session/connection logout.
  - Bugfix for a iser-target bug where a early CMA REJECTED status
    during login triggers a NULL pointer dereference OOPs.
  - Bugfixes for a handful of v4.2-rc1 specific regressions related
    to the larger set of recent backend configfs attribute changes.

A big thanks to QLogic + Pure Storage for the qla2xxx target bugfixes.

Thank you,

--nab

Alexei Potashnik (6):
  qla2xxx: delay plogi/prli ack until existing sessions are deleted
  qla2xxx: Abort stale cmds on qla_tgt_wq when plogi arrives
  qla2xxx: added sess generations to detect RSCN update races
  qla2xxx: disable scsi_transport_fc registration in target mode
  qla2xxx: drop cmds/tmrs arrived while session is being deleted
  qla2xxx: terminate exchange when command is aborted by LIO

Andy Grover (2):
  target: Indicate success if writing 0 to pi_prot_type
  target: Do not return 0 from aptpl and alua configfs store functions

David Disseldorp (1):
  target/configfs: handle match_int() errors

Himanshu Madhani (2):
  qla2xxx: Enable target mode for ISP27XX
  qla2xxx: Remove msleep in qlt_send_term_exchange

Kanoj Sarcar (1):
  qla2xxx: fix command initialization in target mode.

Nicholas Bellinger (5):
  target: Add extra TYPE_DISK + protection checks for INQUIRY SPT
  iscsi-target: Fix use-after-free during TPG session shutdown
  iscsi-target: Fix iscsit_start_kthreads failure OOPs
  iscsi-target: Fix iser explicit logout TX kthread leak
  iser-target: Fix REJECT CM event use-after-free OOPs

Nicholas Mc Guire (1):
  tcm_qla2xxx: pass timeout as HZ independent value

Quinn Tran (3):
  qla2xxx: Add flush after updating ATIOQ consumer index.
  qla2xxx: release request queue reservation.
  qla2xxx: adjust debug flags

Roland Dreier (1):
  qla2xxx: kill sessions/log out initiator on RSCN and port down events

Sagi Grimberg (3):
  target/pr: Fix possible uninitialized variable usage
  target/spc: Set SPT correctly in Extended INQUIRY Data VPD page
  target/rd: Set ramdisk as non rotational device

Saurav Kashyap (1):
  qla2xxx: Fix hardware lock/unlock issue causing kernel panic.

Sebastian Herbszt (1):
  Documentation/target: Fix tcm_mod_builder.py build breakage

Swapnil Nagle (1):
  qla2xxx: cleanup cmd in qla workqueue before processing TMR

 Documentation/target/tcm_mod_builder.py   |  21 +-
 drivers/infiniband/ulp/isert/ib_isert.c   |  16 +-
 drivers/scsi/qla2xxx/qla_attr.c           |   2 +-
 drivers/scsi/qla2xxx/qla_dbg.c            |   6 +-
 drivers/scsi/qla2xxx/qla_def.h            |  20 +-
 drivers/scsi/qla2xxx/qla_init.c           | 190 ++++++--
 drivers/scsi/qla2xxx/qla_iocb.c           |   3 +
 drivers/scsi/qla2xxx/qla_mbx.c            |   7 +-
 drivers/scsi/qla2xxx/qla_os.c             |  12 +-
 drivers/scsi/qla2xxx/qla_sup.c            |   2 +-
 drivers/scsi/qla2xxx/qla_target.c         | 763 +++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_target.h         |  72 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c        |  28 +-
 drivers/target/iscsi/iscsi_target.c       |  48 +-
 drivers/target/iscsi/iscsi_target_login.c |  45 +-
 drivers/target/iscsi/iscsi_target_login.h |   3 +-
 drivers/target/iscsi/iscsi_target_nego.c  |  34 +-
 drivers/target/target_core_configfs.c     |  40 +-
 drivers/target/target_core_pr.c           |   2 +-
 drivers/target/target_core_rd.c           |   1 +
 drivers/target/target_core_spc.c          |   9 +-
 include/target/iscsi/iscsi_target_core.h  |   1 +
 22 files changed, 1105 insertions(+), 220 deletions(-)
