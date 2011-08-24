From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/2] megaraid_sas: Initialize the cmd field to a known value
Date: Wed, 24 Aug 2011 17:35:30 +0200
Message-ID: <1314200130-28890-3-git-send-email-thenzl@redhat.com>
References: <1314200130-28890-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab1HXPf5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 11:35:57 -0400
In-Reply-To: <1314200130-28890-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: steve.masters@lsi.com, michael.benz@lsi.com, aradford@gmail.com, bo.yang@lsi.com, Tomas Henzl <thenzl@redhat.com>

When the command is returned to the pool initialize it with a known value,
this helps to recognize an errant (non-initialized) command and skip it later.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |    4 ++++
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 3cdb769..edc0117 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -138,6 +138,10 @@
 #define MFI_CMD_ABORT				0x06
 #define MFI_CMD_SMP				0x07
 #define MFI_CMD_STP				0x08
+#define MFI_CMD_GHOST				0x09
+/*
+ * Ghost command - used to catch unexpected messages from the hardware
+ */
 
 #define MR_DCMD_CTRL_GET_INFO			0x01010000
 #define MR_DCMD_LD_GET_LIST			0x03010000
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 14c33f6..4b8f457 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -212,6 +212,7 @@ megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 
 	cmd->scmd = NULL;
 	cmd->frame_count = 0;
+	cmd->frame->hdr.cmd = MFI_CMD_GHOST;
 	list_add_tail(&cmd->list, &instance->cmd_pool);
 
 	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
@@ -2288,6 +2289,10 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		megasas_complete_abort(instance, cmd);
 		break;
 
+	case MFI_CMD_GHOST:
+		printk("megasas: Ghost command arrived, this really shoudn't happen!\n");
+		break;
+
 	default:
 		printk("megasas: Unknown command completed! [0x%X]\n",
 		       hdr->cmd);
-- 
1.7.6

