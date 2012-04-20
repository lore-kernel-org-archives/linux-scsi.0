From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/17] hpsa: remove unused parameter from finish_cmd
Date: Fri, 20 Apr 2012 10:06:56 -0500
Message-ID: <20120420150656.10596.49932.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7355891..e45bfda 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3055,7 +3055,7 @@ static inline int bad_tag(struct ctlr_info *h, u32 tag_index,
 	return 0;
 }
 
-static inline void finish_cmd(struct CommandList *c, u32 raw_tag)
+static inline void finish_cmd(struct CommandList *c)
 {
 	removeQ(c);
 	if (likely(c->cmd_type == CMD_SCSI))
@@ -3095,7 +3095,7 @@ static inline u32 process_indexed_cmd(struct ctlr_info *h,
 	if (bad_tag(h, tag_index, raw_tag))
 		return next_command(h);
 	c = h->cmd_pool + tag_index;
-	finish_cmd(c, raw_tag);
+	finish_cmd(c);
 	return next_command(h);
 }
 
@@ -3109,7 +3109,7 @@ static inline u32 process_nonindexed_cmd(struct ctlr_info *h,
 	tag = hpsa_tag_discard_error_bits(h, raw_tag);
 	list_for_each_entry(c, &h->cmpQ, list) {
 		if ((c->busaddr & 0xFFFFFFE0) == (tag & 0xFFFFFFE0)) {
-			finish_cmd(c, raw_tag);
+			finish_cmd(c);
 			return next_command(h);
 		}
 	}
@@ -4165,7 +4165,7 @@ static void fail_all_cmds_on_list(struct ctlr_info *h, struct list_head *list)
 	while (!list_empty(list)) {
 		c = list_entry(list->next, struct CommandList, list);
 		c->err_info->CommandStatus = CMD_HARDWARE_ERR;
-		finish_cmd(c, c->Header.Tag.lower);
+		finish_cmd(c);
 	}
 }
 
