From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 12/16] SCSI: g_NCR5380: remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:20:25 -0400
Message-ID: <1310710825.3184.63.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Change this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/g_NCR5380.c |   10 +++++-----
 drivers/scsi/g_NCR5380.h |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 81182ba..4a8047f 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -775,7 +775,7 @@ static int sprint_command(char *buffer, int len, unsigned char *command)
  *	Print out the target and command data in hex
  */
 
-static int sprint_Scsi_Cmnd(char *buffer, int len, Scsi_Cmnd * cmd)
+static int sprint_Scsi_Cmnd(char *buffer, int len, struct scsi_cmnd * cmd)
 {
 	int start = len;
 	PRINTP("host number %d destination target %d, lun %d\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
@@ -808,7 +808,7 @@ static int generic_NCR5380_proc_info(struct Scsi_Host *scsi_ptr, char *buffer, c
 	unsigned long flags;
 	unsigned char status;
 	int i;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	struct NCR5380_hostdata *hostdata;
 #ifdef NCR5380_STATS
 	struct scsi_device *dev;
@@ -887,17 +887,17 @@ static int generic_NCR5380_proc_info(struct Scsi_Host *scsi_ptr, char *buffer, c
 	if (!hostdata->connected) {
 		PRINTP("No currently connected command\n");
 	} else {
-		len += sprint_Scsi_Cmnd(buffer, len, (Scsi_Cmnd *) hostdata->connected);
+		len += sprint_Scsi_Cmnd(buffer, len, (struct scsi_cmnd *) hostdata->connected);
 	}
 
 	PRINTP("issue_queue\n");
 
-	for (ptr = (Scsi_Cmnd *) hostdata->issue_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
+	for (ptr = (struct scsi_cmnd *) hostdata->issue_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		len += sprint_Scsi_Cmnd(buffer, len, ptr);
 
 	PRINTP("disconnected_queue\n");
 
-	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
+	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		len += sprint_Scsi_Cmnd(buffer, len, ptr);
 
 	*start = buffer + offset;
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index 1bcdb7b..271670f 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -43,11 +43,11 @@
 #endif
 
 #ifndef ASM
-static int generic_NCR5380_abort(Scsi_Cmnd *);
+static int generic_NCR5380_abort(struct scsi_cmnd *);
 static int generic_NCR5380_detect(struct scsi_host_template *);
 static int generic_NCR5380_release_resources(struct Scsi_Host *);
 static int generic_NCR5380_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
-static int generic_NCR5380_bus_reset(Scsi_Cmnd *);
+static int generic_NCR5380_bus_reset(struct scsi_cmnd *);
 static const char* generic_NCR5380_info(struct Scsi_Host *);
 
 #ifndef CMD_PER_LUN
-- 
1.7.4.1
