From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 4/8] snic: target cleanup in driver unload path
Date: Thu, 17 Mar 2016 00:51:13 -0700
Message-ID: <1458201077-10211-4-git-send-email-nmusini@cisco.com>
References: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-8.cisco.com ([173.37.142.95]:11617 "EHLO
	alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663AbcCQH5i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2016 03:57:38 -0400
In-Reply-To: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

Fix deletes the snic targets synchronously prior to deletion of host.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/snic_disc.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index 5f63217..c46960c 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -480,10 +480,21 @@ int
 snic_disc_start(struct snic *snic)
 {
 	struct snic_disc *disc = &snic->disc;
+	unsigned long flags;
 	int ret = 0;
 
 	SNIC_SCSI_DBG(snic->shost, "Discovery Start.\n");
 
+	spin_lock_irqsave(&snic->snic_lock, flags);
+	if (snic->in_remove) {
+		spin_unlock_irqrestore(&snic->snic_lock, flags);
+		SNIC_ERR("snic driver removal in progress ...\n");
+		ret = 0;
+
+		return ret;
+	}
+	spin_unlock_irqrestore(&snic->snic_lock, flags);
+
 	mutex_lock(&disc->mutex);
 	if (disc->state == SNIC_DISC_PENDING) {
 		disc->req_cnt++;
@@ -533,6 +544,8 @@ snic_tgt_del_all(struct snic *snic)
 	struct list_head *cur, *nxt;
 	unsigned long flags;
 
+	scsi_flush_work(snic->shost);
+
 	mutex_lock(&snic->disc.mutex);
 	spin_lock_irqsave(snic->shost->host_lock, flags);
 
@@ -545,7 +558,7 @@ snic_tgt_del_all(struct snic *snic)
 		tgt = NULL;
 	}
 	spin_unlock_irqrestore(snic->shost->host_lock, flags);
-
-	scsi_flush_work(snic->shost);
 	mutex_unlock(&snic->disc.mutex);
+
+	flush_workqueue(snic_glob->event_q);
 } /* end of snic_tgt_del_all */
-- 
1.8.5.4

