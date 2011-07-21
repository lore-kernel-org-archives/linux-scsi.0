From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 069/103] target: remove the unused SCF_CMD_PASSTHROUGH_NOALLOC flag
Date: Thu, 21 Jul 2011 00:11:52 -0700
Message-ID: <1311232346-6674-70-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm22-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.126]:34954 "HELO
	nm22-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752276Ab1GUHHL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:11 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

From: Christoph Hellwig <hch@infradead.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    6 ------
 include/target/target_core_base.h      |    1 -
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bd97c6a..6ca367d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3758,12 +3758,6 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		return;
 	}
 
-	/*
-	 * Caller will handle releasing of struct se_mem.
-	 */
-	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH_NOALLOC)
-		return;
-
 	list_for_each_entry_safe(se_mem, se_mem_tmp,
 			&cmd->t_mem_list, se_list) {
 		/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bfcf4c2..820ff2e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -112,7 +112,6 @@ enum se_cmd_flags_table {
 	SCF_SCSI_NON_DATA_CDB		= 0x00000040,
 	SCF_SCSI_CDB_EXCEPTION		= 0x00000080,
 	SCF_SCSI_RESERVATION_CONFLICT	= 0x00000100,
-	SCF_CMD_PASSTHROUGH_NOALLOC	= 0x00000200,
 	SCF_SE_CMD_FAILED		= 0x00000400,
 	SCF_SE_LUN_CMD			= 0x00000800,
 	SCF_SE_ALLOW_EOO		= 0x00001000,
-- 
1.7.6

