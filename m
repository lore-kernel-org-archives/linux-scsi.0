From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 6/6] ncr5380: Call scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd() as and when appropriate
Date: Tue, 23 Feb 2016 10:07:09 +1100
Message-ID: <20160222230705.504653698@telegraphics.com.au>
References: <20160222230703.994951661@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:58223 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbcBVXNQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2016 18:13:16 -0500
Content-Disposition: inline; filename=ncr5380-autosense-command
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This bug causes the wrong command to have its sense pointer overwritten,
which sometimes leads to a NULL pointer deref. Fix this by checking which
command is being requeued before restoring the scsi_eh_save data.

It turns out that some targets will disconnect a REQUEST SENSE command.
The autosense algorithm doesn't anticipate this. Hence multiple commands
can end up undergoing autosense simultaneously, and they will all try to
use the same scsi_eh_save struct, which won't work. Defer autosense when
the scsi_eh_save storage is in use by another command.

Fixes: f27db8eb98a1 ("ncr5380: Fix autosense bugs")
Reported-and-tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |    4 ++--
 drivers/scsi/atari_NCR5380.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-02-23 10:07:01.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-02-23 10:07:02.000000000 +1100
@@ -760,7 +760,7 @@ static struct scsi_cmnd *dequeue_next_cm
 	struct NCR5380_cmd *ncmd;
 	struct scsi_cmnd *cmd;
 
-	if (list_empty(&hostdata->autosense)) {
+	if (hostdata->sensing || list_empty(&hostdata->autosense)) {
 		list_for_each_entry(ncmd, &hostdata->unissued, list) {
 			cmd = NCR5380_to_scmd(ncmd);
 			dsprintk(NDEBUG_QUEUES, instance, "dequeue: cmd=%p target=%d busy=0x%02x lun=%llu\n",
@@ -793,7 +793,7 @@ static void requeue_cmd(struct Scsi_Host
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
 
-	if (hostdata->sensing) {
+	if (hostdata->sensing == cmd) {
 		scsi_eh_restore_cmnd(cmd, &hostdata->ses);
 		list_add(&ncmd->list, &hostdata->autosense);
 		hostdata->sensing = NULL;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-02-23 10:07:01.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-02-23 10:07:02.000000000 +1100
@@ -862,7 +862,7 @@ static struct scsi_cmnd *dequeue_next_cm
 	struct NCR5380_cmd *ncmd;
 	struct scsi_cmnd *cmd;
 
-	if (list_empty(&hostdata->autosense)) {
+	if (hostdata->sensing || list_empty(&hostdata->autosense)) {
 		list_for_each_entry(ncmd, &hostdata->unissued, list) {
 			cmd = NCR5380_to_scmd(ncmd);
 			dsprintk(NDEBUG_QUEUES, instance, "dequeue: cmd=%p target=%d busy=0x%02x lun=%llu\n",
@@ -901,7 +901,7 @@ static void requeue_cmd(struct Scsi_Host
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
 
-	if (hostdata->sensing) {
+	if (hostdata->sensing == cmd) {
 		scsi_eh_restore_cmnd(cmd, &hostdata->ses);
 		list_add(&ncmd->list, &hostdata->autosense);
 		hostdata->sensing = NULL;


