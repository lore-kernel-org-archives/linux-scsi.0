From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.4-rc3
Date: Sat, 28 Nov 2015 22:02:53 -0800
Message-ID: <1448776973.579.26.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are outstanding target-pending fixes queued for v4.4-rc3 code.

Please go ahead and pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes:

  - Fix tcm-user backend driver expired cmd time processing (agrover)
  - Elimination of kref_put_spinlock_irqsave() for I/O completion (bart)
  - Fix iscsi login kthread failure case hung task regression (nab)
  - Fix COMPARE_AND_WRITE completion use-after-free race (nab)
  - Fix COMPARE_AND_WRITE with SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC
    non zero SGL offset data corruption.  (Jan + Doug)
  - Fix >= v4.4-rc1 regression for tcm_qla2xxx enable configfs attribute
    (Himanshu + HCH)

Thank you,

--nab

Andy Grover (2):
  target/user: Fix time calc in expired cmd processing
  target/user: Do not set unused fields in tcmu_ops

Bart Van Assche (2):
  target: Invoke release_cmd() callback without holding a spinlock
  kref: Remove kref_put_spinlock_irqsave()

David Disseldorp (1):
  target/stat: print full t10_wwn.model buffer

Himanshu Madhani (1):
  qla2xxx: Fix regression introduced by target configFS changes

Jan Engelhardt (1):
  target: fix COMPARE_AND_WRITE non zero SGL offset data corruption

Luis de Bethencourt (1):
  iscsi-target: return -ENOMEM instead of -1 in case of failed kmalloc()

Nicholas Bellinger (2):
  iscsi-target: Fix rx_login_comp hang after login failure
  target: Fix race for SCF_COMPARE_AND_WRITE_POST checking

 drivers/scsi/qla2xxx/tcm_qla2xxx.c             |  2 +-
 drivers/target/iscsi/iscsi_target.c            | 13 +++++++++-
 drivers/target/iscsi/iscsi_target_nego.c       |  1 +
 drivers/target/iscsi/iscsi_target_parameters.c | 10 ++++----
 drivers/target/target_core_sbc.c               | 17 ++++++++-----
 drivers/target/target_core_stat.c              |  2 +-
 drivers/target/target_core_tmr.c               |  7 +++++-
 drivers/target/target_core_transport.c         | 26 ++++++++++----------
 drivers/target/target_core_user.c              |  4 +---
 include/linux/kref.h                           | 33 --------------------------
 include/target/target_core_base.h              |  2 +-
 11 files changed, 53 insertions(+), 64 deletions(-)
