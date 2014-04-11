From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] [SCSI] libsas: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Fri, 11 Apr 2014 16:38:30 +0800
Message-ID: <1397205510-24502-1-git-send-email-duanj.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19321 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756071AbaDKIk1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Apr 2014 04:40:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Duan Jiong <duanj.fnst@cn.fujitsu.com>

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 25d0f12..400a2aa 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1093,9 +1093,7 @@ int sas_init_queue(struct sas_ha_struct *sas_ha)
 
 	core->queue_thread = kthread_run(sas_queue_thread, sas_ha,
 					 "sas_queue_%d", core->shost->host_no);
-	if (IS_ERR(core->queue_thread))
-		return PTR_ERR(core->queue_thread);
-	return 0;
+	return PTR_ERR_OR_ZERO(core->queue_thread);
 }
 
 void sas_shutdown_queue(struct sas_ha_struct *sas_ha)
-- 
1.8.3.1

