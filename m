From: Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH 1/3] m68k/atari - convert atari_scsi falcon_get_lock() to use wait_event()
Date: Sat,  1 Mar 2014 20:51:03 +1300
Message-ID: <1393660265-19384-2-git-send-email-schmitz@debian.org>
References: <1393660265-19384-1-git-send-email-schmitz@debian.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1393660265-19384-1-git-send-email-schmitz@debian.org>
Sender: linux-m68k-owner@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, arnd@arndb.de, Michael Schmitz <schmitz@debian.org>
List-Id: linux-scsi@vger.kernel.org

sleep_on is known broken and going away. The atari_scsi driver is one of
two remaining users in the falcon_get_lock() function, which is a rather
crazy piece of code. This does not attempt to fix the driver's locking
scheme in general, but at least prevents falcon_get_lock from going to
sleep when no other thread holds the same lock or tries to get it,
and we no longer schedule with irqs disabled.

MSch: fixed completion conditions missed in Arnds' original RFC patch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michael Schmitz <schmitz@debian.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/atari_scsi.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index a3e6c8a..296c936 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -90,6 +90,7 @@
 #include <linux/init.h>
 #include <linux/nvram.h>
 #include <linux/bitops.h>
+#include <linux/wait.h>
 
 #include <asm/setup.h>
 #include <asm/atarihw.h>
@@ -549,8 +550,10 @@ static void falcon_get_lock(void)
 
 	local_irq_save(flags);
 
-	while (!in_irq() && falcon_got_lock && stdma_others_waiting())
-		sleep_on(&falcon_fairness_wait);
+	wait_event_cmd(falcon_fairness_wait,
+		in_interrupt() || !falcon_got_lock || !stdma_others_waiting(),
+		local_irq_restore(flags),
+		local_irq_save(flags));
 
 	while (!falcon_got_lock) {
 		if (in_irq())
@@ -562,7 +565,10 @@ static void falcon_get_lock(void)
 			falcon_trying_lock = 0;
 			wake_up(&falcon_try_wait);
 		} else {
-			sleep_on(&falcon_try_wait);
+			wait_event_cmd(falcon_try_wait,
+				falcon_got_lock && !falcon_trying_lock,
+				local_irq_restore(flags),
+				local_irq_save(flags));
 		}
 	}
 
-- 
1.7.0.4
