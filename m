From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/9] target: Drop unnecessary t_state_lock access for SCF_SUPPORTED_SAM_OPCODE assignment
Date: Fri,  7 Jun 2013 21:34:20 +0000
Message-ID: <1370640864-15568-6-git-send-email-nab@linux-iscsi.org>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch drops the se_cmd->t_state_lock access around SCF_SUPPORTED_SAM_OPCODE
assignment within target_setup_cmd_from_cdb().

Original v4.0 target code required this as fabrics would be checking for
this values in different process contexts for setup and I/O submission.

Given that modern v4.1 target code performs setup and I/O submission
from the same process context, this t_state_lock access is no longer
required.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f9e69f5..77c0b29 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1088,7 +1088,6 @@ sense_reason_t
 target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
 	struct se_device *dev = cmd->se_dev;
-	unsigned long flags;
 	sense_reason_t ret;
 
 	/*
@@ -1148,9 +1147,7 @@ target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
 	if (ret)
 		return ret;
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	spin_lock(&cmd->se_lun->lun_sep_lock);
 	if (cmd->se_lun->lun_sep)
-- 
1.7.2.5
