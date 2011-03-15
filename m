From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] scsi: use list_move() instead of list_del()/list_add()
	combination
Date: Tue, 15 Mar 2011 16:57:10 -0700
Message-ID: <20110315235710.16992.33761.stgit@localhost6.localdomain6>
References: <1300229605-14499-5-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300229605-14499-5-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
To: kirill@shutemov.name
Cc: James.Bottomley@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devel@open-fcoe.org
List-Id: linux-scsi@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org
Cc: devel@open-fcoe.org
Acked-by: Robert Love <robert.w.love@intel.com>
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
index c399be9..4c444b8 100644
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
