From: "Nicholas A. Bellinger" <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [PATCH 0/6] iser-target: Fix active I/O shutdown related issues
Date: Tue,  4 Mar 2014 00:00:59 +0000
Message-ID: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

Hi Or & Sagi,

This series addresses a number of active I/O shutdown related issues
in iser-target code that have come up recently during stress testing.

Note there is still a seperate iser-target network portal shutdown
bug being tracked down, but this series addresses all existing issues
related to active I/O session shutdown.

The patch breakdown looks like:

Patch #1 fixes a long-standing bug where TPGs in shutdown incorrectly
could be referenced by new login attempts.

Patch #2 converts list_del -> list_del_init for iscsi_cmd->i_conn_node
so that list_empty works correctly.

Patch #3 addresses isert_conn->state related bugs resulting in hung
shutdown, and splits isert_free_conn() into seperate code that is
called earlier during shutdown to ensure that all outstanding I/O
has completed.

Patch #4 fixes incorrect accounting of ->post_send_buf_count during
active I/O shutdown with outstanding RDMA WRITE + RDMA READ work
requests.

Patch #5 addresses a bug related to active I/O shutdown with
outstanding FRMR work requests.  Note this patch is specific to
v3.12+ code.

Patch #6 addresses bugs related to active I/O shutdown with
outstanding completion interrupt coalescing batches. Note this patch
is specific to v3.13+ code.

Please review.

--nab

Nicholas Bellinger (6):
  iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
  iscsi/iser-target: Use list_del_init for ->i_conn_node
  iscsi/iser-target: Fix isert_conn->state hung shutdown issues
  iser-target: Fix post_send_buf_count for RDMA READ/WRITE
  iser-target: Ignore completions for FRWRs in isert_cq_tx_work
  iser-target: Fix command leak for tx_desc->comp_llnode_batch

 drivers/infiniband/ulp/isert/ib_isert.c  |  180 ++++++++++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.h  |    7 +-
 drivers/target/iscsi/iscsi_target.c      |   10 +-
 drivers/target/iscsi/iscsi_target_erl2.c |   16 +--
 drivers/target/iscsi/iscsi_target_tpg.c  |    2 +-
 include/target/iscsi/iscsi_transport.h   |    1 +
 6 files changed, 129 insertions(+), 87 deletions(-)

-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
