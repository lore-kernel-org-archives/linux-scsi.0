From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 27/34] scsi proc_ops: remove tcm_loop proc code
Date: Wed, 22 Feb 2012 22:46:18 +0300
Message-ID: <1329939985-26793-27-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39744 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab2BVTrW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:22 -0500
Received: by bkcjm19 with SMTP id jm19so434475bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:21 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

proc file shows absolutely useless info, remove it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/target/loopback/tcm_loop.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index c47ff7f..e2a4ec4 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -205,13 +205,6 @@ static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
 	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 }
 
-static int tcm_loop_proc_info(struct Scsi_Host *host, char *buffer,
-				char **start, off_t offset,
-				int length, int inout)
-{
-	return sprintf(buffer, "tcm_loop_proc_info()\n");
-}
-
 static int tcm_loop_driver_probe(struct device *);
 static int tcm_loop_driver_remove(struct device *);
 
@@ -410,8 +403,6 @@ static int tcm_loop_slave_configure(struct scsi_device *sd)
 }
 
 static struct scsi_host_template tcm_loop_driver_template = {
-	.proc_info		= tcm_loop_proc_info,
-	.proc_name		= "tcm_loopback",
 	.name			= "TCM_Loopback",
 	.queuecommand		= tcm_loop_queuecommand,
 	.change_queue_depth	= tcm_loop_change_queue_depth,
-- 
1.7.3.4

