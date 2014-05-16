From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.15-rc6
Date: Fri, 16 May 2014 14:32:10 -0700
Message-ID: <1400275930.7353.17.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49250 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaEPVcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 May 2014 17:32:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>

Hello Linus,

Here are the target-pending fixes for v3.15-rc6.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This series include:

  - Close race between iser-target network portal shutdown + accepting 
    new connection logins (sagi)
  - Fix free-after-use regression in tcm_fc post conversion to 
    percpu-ida pre-allocation (nab)
  - Explicitly disable Immediate + Unsolicited Data for iser-target 
    connections when T10-PI is enabled (sagi + nab)
  - Allow pi_prot_type + emulate_write_cache attributes to be set to
    zero regardless of backend support (andy)

Thank you,

--nab

Andy Grover (2):
  target: Allow non-supporting backends to set pi_prot_type to 0
  target: Don't allow setting WC emulation if device doesn't support

Nicholas Bellinger (3):
  iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
  tcm_fc: Fix free-after-use regression in ft_free_cmd
  iscsi-target: Disable Immediate + Unsolicited Data with ISER
    Protection

Sagi Grimberg (3):
  Target/iser: Fix wrong connection requests list addition
  Target/iser: Fix iscsit_accept_np and rdma_cm racy flow
  Target/iscsi,iser: Avoid accepting transport connections during stop
    stage

 drivers/infiniband/ulp/isert/ib_isert.c   |   38 +++++++++++++----------------
 drivers/infiniband/ulp/isert/ib_isert.h   |    2 +-
 drivers/target/iscsi/iscsi_target.c       |    4 ++-
 drivers/target/iscsi/iscsi_target_core.h  |    1 +
 drivers/target/iscsi/iscsi_target_login.c |   28 ++++++++++++++++++++-
 drivers/target/iscsi/iscsi_target_tpg.c   |    1 +
 drivers/target/target_core_device.c       |   12 ++++++---
 drivers/target/tcm_fc/tfc_cmd.c           |    8 +++---
 8 files changed, 62 insertions(+), 32 deletions(-)

-- 
1.7.10.4

