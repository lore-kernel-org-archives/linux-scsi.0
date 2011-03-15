From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: [PATCH 05/13] scsi: use list_move() instead of
	list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:17 +0200
Message-ID: <1300229605-14499-5-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1300229605-14499-1-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "James E.J. Bottomley" <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: "James E.J. Bottomley" <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Cc: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
---
 drivers/scsi/esp_scsi.c     |    6 ++----
 drivers/scsi/fcoe/libfcoe.c |    6 ++----
 drivers/scsi/scsi_tgt_lib.c |    6 ++----
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
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 625c6be..a1f7025 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1004,10 +1004,8 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
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
-- 
1.7.4.1
