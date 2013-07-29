From: David Miller <davem@davemloft.net>
Subject: Re: sparc ESP SCSI error handling BUG+hang
Date: Mon, 29 Jul 2013 16:15:32 -0700 (PDT)
Message-ID: <20130729.161532.1928549790091477295.davem@davemloft.net>
References: <alpine.SOC.1.00.1304211357540.2145@math.ut.ee>
	<20130729.153223.2291945302397524459.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20130729.153223.2291945302397524459.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: mroos@linux.ee
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 29 Jul 2013 15:32:23 -0700 (PDT)

> Therefore I think the fix is going to involve adding a member to
> "struct esp_cmd_entry" called "->orig_tag[]" so that we can see what
> the original tag[] values were at esp_alloc_lun_tag() time.

Please try this patch:

====================
esp_scsi: Fix tag state corruption when autosensing.

Meelis Roos reports a crash in esp_free_lun_tag() in the presense
of a disk which has died.

The issue is that when we issue an autosense command, we do so by
hijacking the original command that caused the check-condition.

When we do so we clear out the ent->tag[] array when we issue it via
find_and_prep_issuable_command().  This is so that the autosense
command is forced to be issued non-tagged.

That is problematic, because it is the value of ent->tag[] which
determines whether we issued the original scsi command as tagged
vs. non-tagged (see esp_alloc_lun_tag()).

And that, in turn, is what trips up the sanity checks in
esp_free_lun_tag().  That function needs the original ->tag[] values
in order to free up the tag slot properly.

Fix this by remembering the original command's tag values, and
having esp_alloc_lun_tag() and esp_free_lun_tag() use them.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 34552bf..55548dc 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -530,7 +530,7 @@ static int esp_need_to_nego_sync(struct esp_target_data *tp)
 static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
 			     struct esp_lun_data *lp)
 {
-	if (!ent->tag[0]) {
+	if (!ent->orig_tag[0]) {
 		/* Non-tagged, slot already taken?  */
 		if (lp->non_tagged_cmd)
 			return -EBUSY;
@@ -564,9 +564,9 @@ static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
 			return -EBUSY;
 	}
 
-	BUG_ON(lp->tagged_cmds[ent->tag[1]]);
+	BUG_ON(lp->tagged_cmds[ent->orig_tag[1]]);
 
-	lp->tagged_cmds[ent->tag[1]] = ent;
+	lp->tagged_cmds[ent->orig_tag[1]] = ent;
 	lp->num_tagged++;
 
 	return 0;
@@ -575,9 +575,9 @@ static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
 static void esp_free_lun_tag(struct esp_cmd_entry *ent,
 			     struct esp_lun_data *lp)
 {
-	if (ent->tag[0]) {
-		BUG_ON(lp->tagged_cmds[ent->tag[1]] != ent);
-		lp->tagged_cmds[ent->tag[1]] = NULL;
+	if (ent->orig_tag[0]) {
+		BUG_ON(lp->tagged_cmds[ent->orig_tag[1]] != ent);
+		lp->tagged_cmds[ent->orig_tag[1]] = NULL;
 		lp->num_tagged--;
 	} else {
 		BUG_ON(lp->non_tagged_cmd != ent);
@@ -667,6 +667,8 @@ static struct esp_cmd_entry *find_and_prep_issuable_command(struct esp *esp)
 			ent->tag[0] = 0;
 			ent->tag[1] = 0;
 		}
+		ent->orig_tag[0] = ent->tag[0];
+		ent->orig_tag[1] = ent->tag[1];
 
 		if (esp_alloc_lun_tag(ent, lp) < 0)
 			continue;
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 28e22ac..cd68805 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -271,6 +271,7 @@ struct esp_cmd_entry {
 #define ESP_CMD_FLAG_AUTOSENSE	0x04 /* Doing automatic REQUEST_SENSE */
 
 	u8			tag[2];
+	u8			orig_tag[2];
 
 	u8			status;
 	u8			message;
