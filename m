From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/38] Rearrange buffer formatting in printk()
Date: Mon, 29 Sep 2014 13:58:56 +0200
Message-ID: <1411991947-130166-28-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Move buffer formatting to the start of the function as it
doesn't require to be done under any locks.
No functional change, required by the next patch.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kernel/printk/printk.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1ce7706..d13675e 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1633,8 +1633,18 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (level == SCHED_MESSAGE_LOGLEVEL) {
 		level = -1;
 		in_sched = true;
+
+		/*
+		 * The printf needs to come first; we need the syslog
+		 * prefix which might be passed-in as a parameter.
+		 */
+		text_len = scnprintf(text, sizeof(textbuf),
+				     KERN_WARNING "[sched_delayed] ");
 	}
 
+	text_len += vscnprintf(text + text_len,
+			       sizeof(textbuf) - text_len, fmt, args);
+
 	boot_delay_msec(level);
 	printk_delay();
 
@@ -1676,17 +1686,6 @@ asmlinkage int vprintk_emit(int facility, int level,
 					 strlen(recursion_msg));
 	}
 
-	/*
-	 * The printf needs to come first; we need the syslog
-	 * prefix which might be passed-in as a parameter.
-	 */
-	if (in_sched)
-		text_len = scnprintf(text, sizeof(textbuf),
-				     KERN_WARNING "[sched_delayed] ");
-
-	text_len += vscnprintf(text + text_len,
-			       sizeof(textbuf) - text_len, fmt, args);
-
 	/* mark and strip a trailing newline */
 	if (text_len && text[text_len-1] == '\n') {
 		text_len--;
-- 
1.8.5.2
