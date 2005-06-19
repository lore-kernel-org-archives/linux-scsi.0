From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] use list_for_each_entry_safe in scsi_error.c
Date: Sun, 19 Jun 2005 13:43:56 +0200
Message-ID: <20050619114356.GG18801@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:16556 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262252AbVFSLn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 07:43:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c	2005-06-19 12:30:01.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_error.c	2005-06-19 12:41:43.000000000 +0200
@@ -662,12 +662,10 @@
 static int scsi_eh_get_sense(struct list_head *work_q,
 			     struct list_head *done_q)
 {
-	struct list_head *lh, *lh_sf;
-	struct scsi_cmnd *scmd;
+	struct scsi_cmnd *scmd, *next;
 	int rtn;
 
-	list_for_each_safe(lh, lh_sf, work_q) {
-		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
 		    SCSI_SENSE_VALID(scmd))
 			continue;
@@ -798,12 +796,10 @@
 static int scsi_eh_abort_cmds(struct list_head *work_q,
 			      struct list_head *done_q)
 {
-	struct list_head *lh, *lh_sf;
-	struct scsi_cmnd *scmd;
+	struct scsi_cmnd *scmd, *next;
 	int rtn;
 
-	list_for_each_safe(lh, lh_sf, work_q) {
-		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
 			continue;
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
@@ -918,8 +914,7 @@
 			      struct list_head *work_q,
 			      struct list_head *done_q)
 {
-	struct list_head *lh, *lh_sf;
-	struct scsi_cmnd *scmd, *stu_scmd;
+	struct scsi_cmnd *scmd, *stu_scmd, *next;
 	struct scsi_device *sdev;
 
 	shost_for_each_device(sdev, shost) {
@@ -940,8 +935,8 @@
 		if (!scsi_eh_try_stu(stu_scmd)) {
 			if (!scsi_device_online(sdev) ||
 			    !scsi_eh_tur(stu_scmd)) {
-				list_for_each_safe(lh, lh_sf, work_q) {
-					scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+				list_for_each_entry_safe(scmd, next,
+							  work_q, eh_entry) {
 					if (scmd->device == sdev)
 						scsi_eh_finish_cmd(scmd, done_q);
 				}
@@ -972,8 +967,7 @@
 				    struct list_head *work_q,
 				    struct list_head *done_q)
 {
-	struct list_head *lh, *lh_sf;
-	struct scsi_cmnd *scmd, *bdr_scmd;
+	struct scsi_cmnd *scmd, *bdr_scmd, *next;
 	struct scsi_device *sdev;
 	int rtn;
 
@@ -995,11 +989,8 @@
 		if (rtn == SUCCESS) {
 			if (!scsi_device_online(sdev) ||
 			    !scsi_eh_tur(bdr_scmd)) {
-				list_for_each_safe(lh, lh_sf,
-						   work_q) {
-					scmd = list_entry(lh, struct
-							  scsi_cmnd,
-							  eh_entry);
+				list_for_each_entry_safe(scmd, next,
+							 work_q, eh_entry) {
 					if (scmd->device == sdev)
 						scsi_eh_finish_cmd(scmd,
 								   done_q);
@@ -1082,9 +1073,7 @@
 			     struct list_head *work_q,
 			     struct list_head *done_q)
 {
-	struct list_head *lh, *lh_sf;
-	struct scsi_cmnd *scmd;
-	struct scsi_cmnd *chan_scmd;
+	struct scsi_cmnd *scmd, *chan_scmd, *next;
 	unsigned int channel;
 	int rtn;
 
@@ -1115,9 +1104,7 @@
 						  channel));
 		rtn = scsi_try_bus_reset(chan_scmd);
 		if (rtn == SUCCESS) {
-			list_for_each_safe(lh, lh_sf, work_q) {
-				scmd = list_entry(lh, struct scsi_cmnd,
-						  eh_entry);
+			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd->device->channel)
 					if (!scsi_device_online(scmd->device) ||
 					    !scsi_eh_tur(scmd))
@@ -1142,9 +1129,8 @@
 static int scsi_eh_host_reset(struct list_head *work_q,
 			      struct list_head *done_q)
 {
+	struct scsi_cmnd *scmd, *next;
 	int rtn;
-	struct list_head *lh, *lh_sf;
-	struct scsi_cmnd *scmd;
 
 	if (!list_empty(work_q)) {
 		scmd = list_entry(work_q->next,
@@ -1155,8 +1141,7 @@
 
 		rtn = scsi_try_host_reset(scmd);
 		if (rtn == SUCCESS) {
-			list_for_each_safe(lh, lh_sf, work_q) {
-				scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (!scsi_device_online(scmd->device) ||
 				    (!scsi_eh_try_stu(scmd) && !scsi_eh_tur(scmd)) ||
 				    !scsi_eh_tur(scmd))
@@ -1180,11 +1165,9 @@
 static void scsi_eh_offline_sdevs(struct list_head *work_q,
 				  struct list_head *done_q)
 {
-	struct list_head *lh, *lh_sf;
-	struct scsi_cmnd *scmd;
+	struct scsi_cmnd *scmd, *next;
 
-	list_for_each_safe(lh, lh_sf, work_q) {
-		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		printk(KERN_INFO "scsi: Device offlined - not"
 		       		" ready after error recovery: host"
 				" %d channel %d id %d lun %d\n",
@@ -1512,12 +1495,10 @@
  **/
 static void scsi_eh_flush_done_q(struct list_head *done_q)
 {
-	struct list_head *lh, *lh_sf;
-	struct scsi_cmnd *scmd;
+	struct scsi_cmnd *scmd, *next;
 
-	list_for_each_safe(lh, lh_sf, done_q) {
-		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
-		list_del_init(lh);
+	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
+		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
 		    !blk_noretry_request(scmd->request) &&
 		    (++scmd->retries < scmd->allowed)) {
