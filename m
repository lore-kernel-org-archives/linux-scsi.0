From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] target: Return an error for WRITE SAME with ANCHOR==1
Date: Mon, 14 Oct 2013 15:49:23 -0700
Message-ID: <1381790963-14657-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Per SBC-3, since we report ANC_SUP==0 in VPD page B2h, we need to return
an error (ILLEGAL REQUEST/INVALID FIELD IN CDB) for all WRITE SAME
requests with ANCHOR==1.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_sbc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 4714c6f8da4b..d9b92b2c524d 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -263,6 +263,11 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 			sectors, cmd->se_dev->dev_attrib.max_write_same_len);
 		return TCM_INVALID_CDB_FIELD;
 	}
+	/* We always have ANC_SUP == 0 so setting ANCHOR is always an error */
+	if (flags[0] & 0x10) {
+		pr_warn("WRITE SAME with ANCHOR not supported\n");
+		return TCM_INVALID_CDB_FIELD;
+	}
 	/*
 	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
 	 * translated into block discard requests within backend code.
-- 
1.8.3.2
