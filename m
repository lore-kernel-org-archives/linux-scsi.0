From: Ken Helias <kenhelias@web.de>
Subject: [PATCH 11/13] iscsi-target: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:30 +0200
Message-ID: <1402076072-4044-11-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
---
 drivers/target/iscsi/iscsi_target_erl1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index cda4d80..1926d0b 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -835,8 +835,8 @@ static int iscsit_attach_ooo_cmdsn(
 					continue;
 
 				/* Insert before this entry */
-				list_add(&ooo_cmdsn->ooo_list,
-					ooo_tmp->ooo_list.prev);
+				list_add_before(&ooo_cmdsn->ooo_list,
+						&ooo_tmp->ooo_list);
 				break;
 			}
 		}
-- 
2.0.0
