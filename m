From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 3/6] ncr5380: Dont re-enter NCR5380_select()
Date: Tue, 23 Feb 2016 10:07:06 +1100
Message-ID: <20160222230704.754680814@telegraphics.com.au>
References: <20160222230703.994951661@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-dont-reenter-NCR5380_select
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Calling NCR5380_select() from the abort handler causes various problems.
Firstly, it means potentially re-entering NCR5380_select(). Secondly, it
means that the lock is released, which permits the EH handlers to be
re-entered. The combination results in crashes. Don't do it.

Fixes: 8b00c3d5d40d ("ncr5380: Implement new eh_abort_handler")
Reported-and-tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   16 ++++++++--------
 drivers/scsi/atari_NCR5380.c |   16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-02-23 10:06:57.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-02-23 10:06:58.000000000 +1100
@@ -2302,6 +2302,9 @@ static bool list_del_cmd(struct list_hea
  * If cmd was not found at all then presumably it has already been completed,
  * in which case return SUCCESS to try to avoid further EH measures.
  * If the command has not completed yet, we must not fail to find it.
+ *
+ * The lock protects driver data structures, but EH handlers also use it
+ * to serialize their own execution and prevent their own re-entry.
  */
 
 static int NCR5380_abort(struct scsi_cmnd *cmd)
@@ -2338,14 +2341,11 @@ static int NCR5380_abort(struct scsi_cmn
 	if (list_del_cmd(&hostdata->disconnected, cmd)) {
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: removed %p from disconnected list\n", cmd);
-		cmd->result = DID_ERROR << 16;
-		if (!hostdata->connected)
-			NCR5380_select(instance, cmd);
-		if (hostdata->connected != cmd) {
-			complete_cmd(instance, cmd);
-			result = FAILED;
-			goto out;
-		}
+		/* Can't call NCR5380_select() and send ABORT because that
+		 * means releasing the lock. Need a bus reset.
+		 */
+		result = FAILED;
+		goto out;
 	}
 
 	if (hostdata->connected == cmd) {
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-02-23 10:06:57.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-02-23 10:06:58.000000000 +1100
@@ -2497,6 +2497,9 @@ static bool list_del_cmd(struct list_hea
  * If cmd was not found at all then presumably it has already been completed,
  * in which case return SUCCESS to try to avoid further EH measures.
  * If the command has not completed yet, we must not fail to find it.
+ *
+ * The lock protects driver data structures, but EH handlers also use it
+ * to serialize their own execution and prevent their own re-entry.
  */
 
 static int NCR5380_abort(struct scsi_cmnd *cmd)
@@ -2533,14 +2536,11 @@ static int NCR5380_abort(struct scsi_cmn
 	if (list_del_cmd(&hostdata->disconnected, cmd)) {
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: removed %p from disconnected list\n", cmd);
-		cmd->result = DID_ERROR << 16;
-		if (!hostdata->connected)
-			NCR5380_select(instance, cmd);
-		if (hostdata->connected != cmd) {
-			complete_cmd(instance, cmd);
-			result = FAILED;
-			goto out;
-		}
+		/* Can't call NCR5380_select() and send ABORT because that
+		 * means releasing the lock. Need a bus reset.
+		 */
+		result = FAILED;
+		goto out;
 	}
 
 	if (hostdata->connected == cmd) {
