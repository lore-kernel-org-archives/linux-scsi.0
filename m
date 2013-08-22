From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 08/12] target: Make __target_execute_cmd() available as extern
Date: Thu, 22 Aug 2013 04:54:06 +0000
Message-ID: <1377147250-10125-9-git-send-email-nab@daterainc.com>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

Required by COMPARE_AND_WRITE for write instance user-data
submission, in order to bypass target_execute_cmd() checks.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_transport.c |    2 +-
 include/target/target_core_fabric.h    |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5236a80..dc39f1f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1627,7 +1627,7 @@ queue_full:
 }
 EXPORT_SYMBOL(transport_generic_request_failure);
 
-static void __target_execute_cmd(struct se_cmd *cmd)
+void __target_execute_cmd(struct se_cmd *cmd)
 {
 	sense_reason_t ret;
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index d559c36..192eb52 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -134,6 +134,7 @@ int	core_tmr_alloc_req(struct se_cmd *, void *, u8, gfp_t);
 void	core_tmr_release_req(struct se_tmr_req *);
 int	transport_generic_handle_tmr(struct se_cmd *);
 void	transport_generic_request_failure(struct se_cmd *, sense_reason_t);
+void	__target_execute_cmd(struct se_cmd *);
 int	transport_lookup_tmr_lun(struct se_cmd *, u32);
 
 struct se_node_acl *core_tpg_check_initiator_node_acl(struct se_portal_group *,
-- 
1.7.2.5
