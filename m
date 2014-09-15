From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/4] target: Remove unneeded check in sbc_parse_cdb
Date: Mon, 15 Sep 2014 16:12:27 -0700
Message-ID: <1410822750-10717-2-git-send-email-agrover@redhat.com>
References: <1410822750-10717-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410822750-10717-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, shli@kernel.org, linux-kernel@vger.kernel.org, rjones@redhat.com
List-Id: linux-scsi@vger.kernel.org

The check of SCF_SCSI_DATA_CDB seems to be a remnant from before hch's
refactoring of this function. There are no places where that flag is set
that cmd->execute_cmd isn't also set.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_sbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index bd78d92..ebe62af 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -948,7 +948,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	}
 
 	/* reject any command that we don't have a handler for */
-	if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) && !cmd->execute_cmd)
+	if (!cmd->execute_cmd)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 	if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
-- 
1.9.3
