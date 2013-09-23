From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 01/10] hpsa: do not attempt to flush the cache on locked up
	controllers
Date: Mon, 23 Sep 2013 13:33:30 -0500
Message-ID: <20130923183330.19995.23690.stgit@beardog.cce.hp.com>
References: <20130923183128.19995.7669.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:19515 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab3IWSdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 14:33:31 -0400
In-Reply-To: <20130923183128.19995.7669.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

There's no point in trying since it can't work, and if you do
try, it will just hang the system on shutdown.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 891c86b..d6ddc7f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4942,6 +4942,15 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 {
 	char *flush_buf;
 	struct CommandList *c;
+	unsigned long flags;
+
+	/* Don't bother trying to flush the cache if locked up */
+	spin_lock_irqsave(&h->lock, flags);
+	if (unlikely(h->lockup_detected)) {
+		spin_unlock_irqrestore(&h->lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&h->lock, flags);
 
 	flush_buf = kzalloc(4, GFP_KERNEL);
 	if (!flush_buf)

