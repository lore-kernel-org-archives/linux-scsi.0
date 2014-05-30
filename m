From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] drivers/scsi/libsas/sas_scsi_host.c: use PTR_ERR_OR_ZERO
Date: Fri, 30 May 2014 18:52:16 +0200
Message-ID: <1401468736-9789-1-git-send-email-fabf@skynet.be>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:40845 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbaE3QwN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2014 12:52:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Lukasz Dorau <lukasz.dorau@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

replace IS_ERR/PTR_ERR

Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
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
1.8.4.5

