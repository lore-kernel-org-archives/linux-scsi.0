From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/11] scsi: use list_move() instead of list_del()/list_add()
	combination
Date: Fri, 01 Apr 2011 16:06:09 -0700
Message-ID: <20110401230609.15001.77090.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55782 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab1DAXGU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:06:20 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>

From: Kirill A. Shutemov <kirill@shutemov.name>

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/esp_scsi.c       |    6 ++----
 drivers/scsi/fcoe/fcoe_ctlr.c |    6 ++----
 drivers/scsi/scsi_tgt_lib.c   |    6 ++----
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 5755852..9a1af1d 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -708,8 +708,7 @@ static void esp_maybe_execute_command(struct esp *esp)
 	tp = &esp->target[tgt];
 	lp = dev->hostdata;
 
-	list_del(&ent->list);
-	list_add(&ent->list, &esp->active_cmds);
+	list_move(&ent->list, &esp->active_cmds);
 
 	esp->active_cmd = ent;
 
@@ -1244,8 +1243,7 @@ static int esp_finish_select(struct esp *esp)
 		/* Now that the state is unwound properly, put back onto
 		 * the issue queue.  This command is no longer active.
 		 */
-		list_del(&ent->list);
-		list_add(&ent->list, &esp->queued_cmds);
+		list_move(&ent->list, &esp->queued_cmds);
 		esp->active_cmd = NULL;
 
 		/* Return value ignored by caller, it directly invokes
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index c93f007..fb3a506 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -978,10 +978,8 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	 * the FCF that answers multicast solicitations, not the others that
 	 * are sending periodic multicast advertisements.
 	 */
-	if (mtu_valid) {
-		list_del(&fcf->list);
-		list_add(&fcf->list, &fip->fcfs);
-	}
+	if (mtu_valid)
+		list_move(&fcf->list, &fip->fcfs);
 
 	/*
 	 * If this is the first validated FCF, note the time and
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index f672820..edb8bff 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -275,10 +275,8 @@ void scsi_tgt_free_queue(struct Scsi_Host *shost)
 
 	for (i = 0; i < ARRAY_SIZE(qdata->cmd_hash); i++) {
 		list_for_each_entry_safe(tcmd, n, &qdata->cmd_hash[i],
-					 hash_list) {
-			list_del(&tcmd->hash_list);
-			list_add(&tcmd->hash_list, &cmds);
-		}
+					 hash_list)
+			list_move(&tcmd->hash_list, &cmds);
 	}
 
 	spin_unlock_irqrestore(&qdata->cmd_hash_lock, flags);

