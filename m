From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 02/11] hpsa: do not attempt to flush the cache on locked up
	controllers
Date: Thu, 07 Nov 2013 10:45:34 -0600
Message-ID: <20131107164534.3504.62538.stgit@beardog.cce.hp.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:26923 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3KGQpg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 11:45:36 -0500
In-Reply-To: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
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
index 1264b51..20fc598 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4884,6 +4884,15 @@ static void hpsa_flush_cache(struct ctlr_info *h)
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

