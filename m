From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
Subject: [PATCH 3/8] scsi/sg: use printk_ratelimited instead of
 printk_ratelimit
Date: Sat, 4 Jun 2011 17:36:10 +0200
Message-ID: <200c12c3d7ae259146549092a2abe211ec23138d.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
List-Id: linux-scsi@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited.

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 drivers/scsi/sg.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 909ed9e..441a1c5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -50,6 +50,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
 #include <linux/mutex.h>
+#include <linux/ratelimit.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -626,14 +627,15 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	 */
 	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
 		static char cmd[TASK_COMM_LEN];
-		if (strcmp(current->comm, cmd) && printk_ratelimit()) {
-			printk(KERN_WARNING
-			       "sg_write: data in/out %d/%d bytes for SCSI command 0x%x--"
-			       "guessing data in;\n   "
-			       "program %s not setting count and/or reply_len properly\n",
-			       old_hdr.reply_len - (int)SZ_SG_HEADER,
-			       input_size, (unsigned int) cmnd[0],
-			       current->comm);
+		if (strcmp(current->comm, cmd)) {
+			printk_ratelimited(KERN_WARNING
+					   "sg_write: data in/out %d/%d bytes "
+					   "for SCSI command 0x%x-- guessing "
+					   "data in;\n   program %s not setting "
+					   "count and/or reply_len properly\n",
+					   old_hdr.reply_len - (int)SZ_SG_HEADER,
+					   input_size, (unsigned int) cmnd[0],
+					   current->comm);
 			strcpy(cmd, current->comm);
 		}
 	}
-- 
1.7.1
