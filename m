From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 29/31] target: Fix SCF_SCSI_CONTROL_SG_IO_CDB breakage
Date: Wed,  9 Feb 2011 15:35:04 -0800
Message-ID: <1297294506-23579-30-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm21-vm0.bullet.mail.ne1.yahoo.com ([98.138.90.94]:38949 "HELO
	nm21-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756129Ab1BIXgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:36:05 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug introduced during the v4 control CDB emulation
refactoring that broke SCF_SCSI_CONTROL_SG_IO_CDB operation within
transport_map_control_cmd_to_task().  It moves the BUG_ON() into
transport_do_se_mem_map() after the TRANSPORT(dev)->do_se_mem_map()
RAMDISK_DR special case, and adds the proper struct se_mem assignment
when !list_empty() for normal non RAMDISK_DR backend device cases.

Reported-by: Kai-Thorsten Hambrecht <kai@hambrecht.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 73e45e9..c684956 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4856,6 +4856,8 @@ static int transport_do_se_mem_map(
 
 		return ret;
 	}
+
+	BUG_ON(list_empty(se_mem_list));
 	/*
 	 * This is the normal path for all normal non BIDI and BIDI-COMMAND
 	 * WRITE payloads..  If we need to do BIDI READ passthrough for
@@ -5037,7 +5039,9 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
 		struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
 		u32 se_mem_cnt = 0, task_offset = 0;
 
-		BUG_ON(list_empty(cmd->t_task->t_mem_list));
+		if (!list_empty(T_TASK(cmd)->t_mem_list))
+			se_mem = list_entry(T_TASK(cmd)->t_mem_list->next,
+					struct se_mem, se_list);
 
 		ret = transport_do_se_mem_map(dev, task,
 				cmd->t_task->t_mem_list, NULL, se_mem,
-- 
1.7.4

