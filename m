From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH v2] hpsa: remove unneeded loop
Date: Wed, 11 Sep 2013 16:42:56 +0200
Message-ID: <52308170.3030500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab3IKOoK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Sep 2013 10:44:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, James Bottomley <jejb@kernel.org>

From: Tomas Henzl <thenzl@redhat.com>

Originally this was first patch in a series, but while the  other patches
were taken into 'for-next', this one was forgotten.
The code below is adapted for the 'for=next' branch.

The cmd_pool_bits is protected everywhere with a spinlock,
we don't need the test_and_set_bit, set_bit is enough and the loop
can be removed too.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 31489b5..6069c45 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2736,15 +2736,12 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	unsigned long flags;
 
 	spin_lock_irqsave(&h->lock, flags);
-	do {
-		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
-		if (i == h->nr_cmds) {
-			spin_unlock_irqrestore(&h->lock, flags);
-			return NULL;
-		}
-	} while (test_and_set_bit
-		 (i & (BITS_PER_LONG - 1),
-		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
+	i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
+	if (i == h->nr_cmds) {
+		spin_unlock_irqrestore(&h->lock, flags);
+		return NULL;
+	}
+	set_bit(i & (BITS_PER_LONG - 1), h->cmd_pool_bits + (i / BITS_PER_LONG));
 	spin_unlock_irqrestore(&h->lock, flags);
 
 	c = h->cmd_pool + i;
-- 
1.8.3.1


