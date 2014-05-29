From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH v2, repost] hpsa: remove unneeded loop
Date: Thu, 29 May 2014 16:02:19 +0200
Message-ID: <53873DEB.1080504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902AbaE2OD3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2014 10:03:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

Originally this was first patch in a series, but while the  other patches
were accepted, this one was forgotten.
The code below is adapted for the latest sources.

The cmd_pool_bits is protected everywhere with a spinlock,
we don't need the test_and_set_bit, set_bit is enough and the loop
can be removed too.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9a6e4a2..c8267f3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4680,15 +4680,12 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
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


