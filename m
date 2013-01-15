From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.8-rc4
Date: Tue, 15 Jan 2013 13:17:48 -0800
Message-ID: <1358284668.25196.47.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, "Rustad, Mark D" <mark.d.rustad@intel.com>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

The following are the target pending fixes headed into v3.8-rc4.  Please
go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes an important >= v3.6 regression bugfix for active I/O
shutdown (Roland), some TMR related failure / corner cases fixes for
long outstanding I/O (Roland), two FCoE target mode fabric fabric role
fixes (MDR), a fix for an incorrect sense code during LUN communication
failure (Dr. Hannes), plus a handful of other minor fixes.

There are still some outstanding zero-length control CDB regression
fixes that need to be addressed for v3.8, that will be coming in a
follow-up PULL request.

Thank you,

--nab

Hannes Reinecke (3):
  target: use correct sense code for LUN communication failure
  target: Introduce TCM_NO_SENSE
  target: Use TCM_NO_SENSE for initialisation

Mark Rustad (2):
  tcm_fc: Do not indicate retry capability to initiators
  tcm_fc: Do not report target role when target is not defined

Roland Dreier (4):
  target: Fix missing CMD_T_ACTIVE bit regression for pending WRITEs
  target: Fix use-after-free in LUN RESET handling
  target: Release se_cmd when LUN lookup fails for TMR
  iscsi-target: Fix CmdSN comparison (use cmd->cmd_sn instead of
    cmd->stat_sn)

 drivers/target/iscsi/iscsi_target_erl2.c |    2 +-
 drivers/target/target_core_alua.c        |    2 +-
 drivers/target/target_core_pr.c          |    2 +-
 drivers/target/target_core_transport.c   |   20 ++++++++++++++++----
 drivers/target/tcm_fc/tfc_sess.c         |   12 +++++++++---
 include/target/target_core_base.h        |    1 +
 6 files changed, 29 insertions(+), 10 deletions(-)
