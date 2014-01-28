From: Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH 1/3] m68k/atari - atari_scsi: fix wait_event completion conditions
Date: Wed, 29 Jan 2014 12:55:22 +1300
Message-ID: <1390953324-19962-2-git-send-email-schmitz@debian.org>
References: <1388664474-1710039-3-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41269 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033AbaA1Xzs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jan 2014 18:55:48 -0500
In-Reply-To: <1388664474-1710039-3-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, arnd@arndb.de, Michael Schmitz <schmitz@debian.org>

Fix patch by ArndB changing falcon_get_lock to use wait_event.
Some of the completion conditions had been missed when converting
from while() {} to do {} until() logic.

Signed-off-by: Michael Schmitz <schmitz@debian.org>
---
 drivers/scsi/atari_scsi.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 1986ecb..cc1b013 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -550,10 +550,10 @@ static void falcon_get_lock(void)
 
 	local_irq_save(flags);
 
-       wait_event_cmd(falcon_fairness_wait,
-                      !in_irq() && falcon_got_lock && stdma_others_waiting(),
-                      local_irq_restore(flags),
-                      local_irq_save(flags));
+	wait_event_cmd(falcon_fairness_wait,
+		in_irq() || !falcon_got_lock || !stdma_others_waiting(),
+		local_irq_restore(flags),
+		local_irq_save(flags));
 
 	while (!falcon_got_lock) {
 		if (in_irq())
@@ -566,9 +566,9 @@ static void falcon_get_lock(void)
 			wake_up(&falcon_try_wait);
 		} else {
                        wait_event_cmd(falcon_try_wait,
-                                      !falcon_got_lock && !falcon_trying_lock,
-                                      local_irq_restore(flags),
-                                      local_irq_save(flags));
+				falcon_got_lock && !falcon_trying_lock,
+				local_irq_restore(flags),
+				local_irq_save(flags));
 		}
 	}
 
-- 
1.7.0.4

