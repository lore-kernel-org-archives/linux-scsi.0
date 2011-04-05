From: Michal Marek <mmarek@suse.cz>
Subject: [PATCH 23/34] scsi/wd33c93: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:10 +0200
Message-ID: <1302015561-21047-24-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/scsi/wd33c93.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 5f697e0..6c983a2 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -2052,8 +2052,7 @@ wd33c93_init(struct Scsi_Host *instance, const wd33c93_regs regs,
 	for (i = 0; i < MAX_SETUP_ARGS; i++)
 		printk("%s,", setup_args[i]);
 	printk("\n");
-	printk("           Version %s - %s, Compiled %s at %s\n",
-	       WD33C93_VERSION, WD33C93_DATE, __DATE__, __TIME__);
+	printk("           Version %s - %s\n", WD33C93_VERSION, WD33C93_DATE);
 }
 
 int
@@ -2133,8 +2132,8 @@ wd33c93_proc_info(struct Scsi_Host *instance, char *buf, char **start, off_t off
 	bp = buf;
 	*bp = '\0';
 	if (hd->proc & PR_VERSION) {
-		sprintf(tbuf, "\nVersion %s - %s. Compiled %s %s",
-			WD33C93_VERSION, WD33C93_DATE, __DATE__, __TIME__);
+		sprintf(tbuf, "\nVersion %s - %s.",
+			WD33C93_VERSION, WD33C93_DATE);
 		strcat(bp, tbuf);
 	}
 	if (hd->proc & PR_INFO) {
-- 
1.7.4.1
