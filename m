From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.17-rc6
Date: Fri, 19 Sep 2014 15:41:02 -0700
Message-ID: <1411166462.23258.36.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target pending fixes for v3.17-rc6.  Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

Included are Sagi's long overdue fixes related to iser-target shutdown,
along with a couple of fixes from Sebastian related to ALUA Referrals
changes that when in during the v3.14 time-frame.

Also included are a few iscsi-target fixes, most recently of which where
found during Joern's Coverity scanning of target code.

Thanks,

--nab

Joern Engel (1):
  iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure

Nicholas Bellinger (2):
  iscsi-target: Ignore ICF_GOT_LAST_DATAOUT during Data-Out ITT lookup
  iscsi-target: Fix memory corruption in
    iscsit_logout_post_handler_diffcid

Sagi Grimberg (4):
  Target/iser: Get isert_conn reference once got to connected_handler
  Target/iser: Don't put isert_conn inside disconnected handler
  Target/iser: Avoid calling rdma_disconnect twice
  Target/iser: Fix initiator_depth and responder_resources

Sebastian Herbszt (2):
  target: Fix user data segment multiplier in spc_emulate_evpd_b3()
  target: Fix inverted logic in SE_DEV_ALUA_SUPPORT_STATE_STORE

 drivers/infiniband/ulp/isert/ib_isert.c        |   20 +++++++++++---------
 drivers/target/iscsi/iscsi_target.c            |    4 +++-
 drivers/target/iscsi/iscsi_target_parameters.c |    2 +-
 drivers/target/iscsi/iscsi_target_util.c       |    2 ++
 drivers/target/target_core_configfs.c          |    2 +-
 drivers/target/target_core_spc.c               |    2 +-
 6 files changed, 19 insertions(+), 13 deletions(-)
