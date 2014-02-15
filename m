From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.14-rc3
Date: Sat, 15 Feb 2014 15:29:59 -0800
Message-ID: <1392506999.24417.14.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target-pending fixes for v3.14-rc3 code.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

Mostly minor fixes this time to v3.14-rc1 related changes.  Also
included is one fix for a free after use regression in persistent
reservations UNREGISTER logic that is CC'ed to >= v3.11.y stable.

Thank you,

--nab

Jingoo Han (1):
  IB/srpt: replace strict_strtoul() with kstrtoul()

Nicholas Bellinger (4):
  target: Fix free-after-use regression in PR unregister
  target: Fix 32-bit + CONFIG_LBDAF=n link error w/ sector_div
  iscsi-target: Fix SNACK Type 1 + BegRun=0 handling
  iser-target: Fix leak on failure in isert_conn_create_fastreg_pool

Roland Dreier (3):
  qla2xxx: Remove last vestiges of qla_tgt_cmd.cmd_list
  target: Fix missing length check in spc_emulate_evpd_83()
  target: Simplify command completion by removing CMD_T_FAILED flag

Sagi Grimberg (1):
  Target/sbc: Fix protection copy routine

 drivers/infiniband/ulp/isert/ib_isert.c  |    1 +
 drivers/infiniband/ulp/srpt/ib_srpt.c    |   14 +++++++-------
 drivers/scsi/qla2xxx/qla_target.c        |    2 --
 drivers/scsi/qla2xxx/qla_target.h        |    1 -
 drivers/target/iscsi/iscsi_target_erl1.c |    4 +++-
 drivers/target/target_core_alua.c        |    2 +-
 drivers/target/target_core_pr.c          |   11 +++++++----
 drivers/target/target_core_sbc.c         |    8 ++++++++
 drivers/target/target_core_spc.c         |    4 ++--
 drivers/target/target_core_transport.c   |    5 +----
 include/target/target_core_base.h        |    1 -
 11 files changed, 30 insertions(+), 23 deletions(-)
