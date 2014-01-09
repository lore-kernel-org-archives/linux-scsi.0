From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 01/11] Target/core: Fixes for isert compilation
Date: Thu,  9 Jan 2014 18:40:48 +0200
Message-ID: <1389285658-7037-2-git-send-email-sagig@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, nab@linux-iscsi.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

replace prot_interleaved with prot_handover in se_cmd.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 include/target/target_core_base.h |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 13daea5..2ae304d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -439,14 +439,20 @@ struct se_tmr_req {
 	struct list_head	tmr_list;
 };
 
+#define TARGET_DIF_SIZE 8
 enum target_prot_op {
-	TARGET_PROT_NORMAL,
-	TARGET_PROT_READ_INSERT,
-	TARGET_PROT_WRITE_INSERT,
-	TARGET_PROT_READ_STRIP,
-	TARGET_PROT_WRITE_STRIP,
-	TARGET_PROT_READ_PASS,
-	TARGET_PROT_WRITE_PASS,
+	TARGET_PROT_NORMAL = 0,
+	TARGET_PROT_DIN_INSERT,
+	TARGET_PROT_DOUT_INSERT,
+	TARGET_PROT_DIN_STRIP,
+	TARGET_PROT_DOUT_STRIP,
+	TARGET_PROT_DIN_PASS,
+	TARGET_PROT_DOUT_PASS
+};
+
+enum target_prot_ho {
+	PROT_SEPERATED,
+	PROT_INTERLEAVED,
 };
 
 enum target_prot_type {
@@ -573,7 +579,7 @@ struct se_cmd {
 	u32			prot_length;
 	struct scatterlist	*t_prot_sg;
 	unsigned int		t_prot_nents;
-	bool			prot_interleaved;
+	enum target_prot_ho     prot_handover;
 	enum target_pi_error	pi_err;
 	u32			block_num;
 };
-- 
1.7.1
