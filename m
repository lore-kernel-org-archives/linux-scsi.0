From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] target: update error handling for sbc_setup_write_same()
Date: Tue, 27 Nov 2012 17:27:01 +0300
Message-ID: <20121127142701.GA1059@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We recently changed this to return positive subsystem error codes so the
error handling needs to be updated.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 943c689..4fd22cd 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -439,7 +439,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 
 			ret = sbc_setup_write_same(cmd, &cdb[10], ops);
-			if (ret < 0)
+			if (ret)
 				return ret;
 			break;
 		default:
@@ -512,7 +512,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
 
 		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
-		if (ret < 0)
+		if (ret)
 			return ret;
 		break;
 	case WRITE_SAME:
@@ -530,7 +530,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		 * of byte 1 bit 3 UNMAP instead of original reserved field
 		 */
 		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
-		if (ret < 0)
+		if (ret)
 			return ret;
 		break;
 	case VERIFY:
