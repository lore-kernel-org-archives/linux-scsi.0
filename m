From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.14-rc6
Date: Sat, 08 Mar 2014 13:51:45 -0800
Message-ID: <1394315505.11448.30.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target-pending fixes for v3.14-rc6.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This series addresses a number of outstanding issues wrt to active I/O
shutdown using iser-target.  This includes:

- Fix a long standing tpg_state bug where a tpg could be referenced
  during explicit shutdown (v3.1+ stable)
- Use list_del_init for iscsi_cmd->i_conn_node so list_empty checks
  work as expected (v3.10+ stable)
- Fix a isert_conn->state related hung task bug + ensure outstanding
  I/O completes during session shutdown. (v3.10+ stable)
- Fix isert_conn->post_send_buf_count accounting for RDMA READ/WRITEs
  (v3.10+ stable)
- Ignore FRWR completions during active I/O shutdown (v3.12+ stable)
- Fix command leakage for interrupt coalescing during active I/O 
  shutdown (v3.13+ stable)

Also included is another DIF emulation fix from Sagi specific to
v3.14-rc code.

Thank you,

--nab

Nicholas Bellinger (6):
  iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
  iscsi/iser-target: Use list_del_init for ->i_conn_node
  iscsi/iser-target: Fix isert_conn->state hung shutdown issues
  iser-target: Fix post_send_buf_count for RDMA READ/WRITE
  iser-target: Ignore completions for FRWRs in isert_cq_tx_work
  iser-target: Fix command leak for tx_desc->comp_llnode_batch

Sagi Grimberg (1):
  Target/sbc: Fix sbc_copy_prot for offset scatters

 drivers/infiniband/ulp/isert/ib_isert.c  |  180 ++++++++++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.h  |    7 +-
 drivers/target/iscsi/iscsi_target.c      |   10 +-
 drivers/target/iscsi/iscsi_target_erl2.c |   16 +--
 drivers/target/iscsi/iscsi_target_tpg.c  |    2 +-
 drivers/target/target_core_sbc.c         |   38 ++++---
 include/target/iscsi/iscsi_transport.h   |    1 +
 7 files changed, 151 insertions(+), 103 deletions(-)
