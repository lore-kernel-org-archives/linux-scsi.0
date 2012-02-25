From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/7] target: Drop se_tmr_req inline + target_submit_tmr() fixes + conversion
Date: Sat, 25 Feb 2012 21:05:52 +0000
Message-ID: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45521 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2BYVOL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Feb 2012 16:14:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, Kiran Patil <kiran.patil@intel.com>, Arun Easi <arun.easi@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This series addresses some TMR related issues in lio-core that have come up
during recent fabric testing and target-pending/for-next merging.

Patch #1 converts Andy's se_tmr_req inlining changes back to core_tmr_alloc_req()
in lio-core due to extra memory overhead concerns per se_cmd allocation usage in
the fast path.  This patch keeps the SCF_SCSI_TMR_CDB usage + se_tmr_req_cache
removal in lio-core from his original patch (these pieces has also been kept in
for-next) ahead of converting this to proper unions at some point in the future.

Patch #2 -> #4 contain the target_submit_tmr() related fixes for core + tcm_fc(fcoe)
exception handling, and patch #5 -> pushes the TMR response callbacks for exceptions
into system_wq context.  Patch #6 -> #7 allows target_submit_tmr() to run from
interrupt context, and converts tcm_qla2xxx to use target_submit_tmr() with
se_cmd->cmd_kref usage fixes in tcm_qla2xxx_release_cmd()

So far the target_submit_tmr() failure paths have been tested with tcm_fc(fcoe)
and qla2xxx ports with LUN_RESET and appear to be working as expected.  These
patches can use more testing, so please have a look and let us know if you
have any concerns.

Thanks,

--nab

Nicholas Bellinger (7):
  target: Drop inlining of se_tmr_req from se_cmd
  target: Fix target_submit_tmr LUN lookup failures
  target: Fix target_submit_tmr se_tmr_req allocation failures
  tcm_fc: Handle target_submit_tmr allocation failure
  target: Push target_submit_tmr LUN lookup failure to system_wq
    context
  target: Allow target_submit_tmr to be called from interrupt context
  qla_target: Drop qla_tgt_mgmt_cmd->se_tmr_req usage

 drivers/infiniband/ulp/srpt/ib_srpt.c    |   14 +++++---
 drivers/scsi/qla2xxx/qla_target.c        |    2 +-
 drivers/scsi/qla2xxx/qla_target.h        |    1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       |   50 +++++-------------------------
 drivers/target/iscsi/iscsi_target.c      |    4 +-
 drivers/target/iscsi/iscsi_target_tmr.c  |    6 ++--
 drivers/target/iscsi/iscsi_target_util.c |    7 +++-
 drivers/target/loopback/tcm_loop.c       |   13 +++----
 drivers/target/target_core_device.c      |    2 +-
 drivers/target/target_core_tmr.c         |   21 ++++++++++--
 drivers/target/target_core_transport.c   |   43 +++++++++++++++++++------
 drivers/target/tcm_fc/tfc_cmd.c          |   11 ++++--
 include/target/target_core_base.h        |    2 +-
 include/target/target_core_fabric.h      |    7 ++--
 14 files changed, 97 insertions(+), 86 deletions(-)

-- 
1.7.2.5

