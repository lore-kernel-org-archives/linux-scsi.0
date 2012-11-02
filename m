From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.7-rc4 (round 2)
Date: Fri, 02 Nov 2012 15:06:23 -0700
Message-ID: <1351893983.29493.239.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

This series is a second round of target fixes for v3.7-rc4 that have
come into target-devel over the last days, and are important enough to
be applied ASAP.  Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

All are being CC'ed to stable.  The most important two are:

- target: Re-add explict zeroing of INQUIRY bounce buffer memory to fix
a regression for handling zero-length payloads, a bug that went during
v3.7-rc1, and hit >= v3.6.3 stable. (nab + paolo)
- iscsi-target: Fix a long-standing missed R2T wakeup race in TX thread
processing when using a single queue slot. (Roland)

Thanks to Roland & PureStorage team for helping to track down this long
standing race with iscsi-target single queue slot operation.

Also, the tcm_fc(FCoE) regression bug that was observed recently with
-rc2 code has also been resolved with the cancel_delayed_work() return
bugfix (commit c0158ca) now in -rc3.  Thanks again to Yi Zou, MDR,
Robert Love @ Intel for helping to track this down.

Thank you,

--nab

Nicholas Bellinger (1):
  target: Re-add explict zeroing of INQUIRY bounce buffer memory

Roland Dreier (3):
  target: Don't return success from module_init() if setup fails
  target: Avoid integer overflow in se_dev_align_max_sectors()
  iscsi-target: Fix missed wakeup race in TX thread

Steve Hodgson (1):
  target: Fix incorrect usage of nested IRQ spinlocks in ABORT_TASK
    path

 drivers/target/iscsi/iscsi_target.c       |    4 +++-
 drivers/target/iscsi/iscsi_target_core.h  |    1 +
 drivers/target/iscsi/iscsi_target_login.c |    1 +
 drivers/target/iscsi/iscsi_target_util.c  |   22 ++++++++++++++++++++--
 drivers/target/iscsi/iscsi_target_util.h  |    1 +
 drivers/target/target_core_configfs.c     |    3 ++-
 drivers/target/target_core_device.c       |   18 +++++++++---------
 drivers/target/target_core_spc.c          |    2 ++
 drivers/target/target_core_tmr.c          |    6 +++---
 9 files changed, 42 insertions(+), 16 deletions(-)
