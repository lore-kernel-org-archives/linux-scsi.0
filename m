From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 10/20] scsi/g_NCR5380: No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:16 -0300
Message-ID: <1257711436.4759.116.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [190.108.161.231] ([190.108.161.231]:40534 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755253AbZKHUZt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Nov 2009 15:25:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/g_NCR5380.c |   10 +++++-----
 drivers/scsi/g_NCR5380.h |    6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 75585a5..0d0c3ed 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -774,7 +774,7 @@ static int sprint_command(char *buffer, int len, unsigned char *command)
  *	Print out the target and command data in hex
  */
 
-static int sprint_Scsi_Cmnd(char *buffer, int len, Scsi_Cmnd * cmd)
+static int sprint_Scsi_Cmnd(char *buffer, int len, struct scsi_cmnd * cmd)
 {
 	int start = len;
 	PRINTP("host number %d destination target %d, lun %d\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
@@ -807,7 +807,7 @@ static int generic_NCR5380_proc_info(struct Scsi_Host *scsi_ptr, char *buffer, c
 	unsigned long flags;
 	unsigned char status;
 	int i;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	struct NCR5380_hostdata *hostdata;
 #ifdef NCR5380_STATS
 	struct scsi_device *dev;
@@ -886,17 +886,17 @@ static int generic_NCR5380_proc_info(struct Scsi_Host *scsi_ptr, char *buffer, c
 	if (!hostdata->connected) {
 		PRINTP("No currently connected command\n");
 	} else {
-		len += sprint_Scsi_Cmnd(buffer, len, (Scsi_Cmnd *) hostdata->connected);
+		len += sprint_Scsi_Cmnd(buffer, len, (struct scsi_cmnd *) hostdata->connected);
 	}
 
 	PRINTP("issue_queue\n");
 
-	for (ptr = (Scsi_Cmnd *) hostdata->issue_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
+	for (ptr = (struct scsi_Cmnd *) hostdata->issue_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		len += sprint_Scsi_Cmnd(buffer, len, ptr);
 
 	PRINTP("disconnected_queue\n");
 
-	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
+	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		len += sprint_Scsi_Cmnd(buffer, len, ptr);
 
 	*start = buffer + offset;
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index df0b3f6..a49e789 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -43,11 +43,11 @@
 #endif
 
 #ifndef ASM
-static int generic_NCR5380_abort(Scsi_Cmnd *);
+static int generic_NCR5380_abort(struct scsi_cmnd *);
 static int generic_NCR5380_detect(struct scsi_host_template *);
 static int generic_NCR5380_release_resources(struct Scsi_Host *);
-static int generic_NCR5380_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int generic_NCR5380_bus_reset(Scsi_Cmnd *);
+static int generic_NCR5380_queue_command(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int generic_NCR5380_bus_reset(struct scsi_cmnd *);
 static const char* generic_NCR5380_info(struct Scsi_Host *);
 
 #ifndef CMD_PER_LUN



