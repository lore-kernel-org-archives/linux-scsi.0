From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] scsi_eh_prep_cmnd should save scmd->underflow
Date: Mon, 21 Jul 2008 10:25:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807211023400.2428-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55786 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753352AbYGUOZx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jul 2008 10:25:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "Andrew J. Kroll" <a@oo.ms>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1116) fixes a bug in scsi_eh_prep_cmnd() and
scsi_eh_restore_cmnd().  These routines are supposed to save any
values they change and restore them later, but someone forgot to
save & restore scmd->underflow.

This fixes part of the problem reported in Bugzilla #9638.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_error.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_error.c
+++ usb-2.6/drivers/scsi/scsi_error.c
@@ -653,6 +653,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd 
 	ses->sdb = scmd->sdb;
 	ses->next_rq = scmd->request->next_rq;
 	ses->result = scmd->result;
+	ses->underflow = scmd->underflow;
 
 	scmd->cmnd = ses->eh_cmnd;
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
@@ -711,6 +712,7 @@ void scsi_eh_restore_cmnd(struct scsi_cm
 	scmd->sdb = ses->sdb;
 	scmd->request->next_rq = ses->next_rq;
 	scmd->result = ses->result;
+	scmd->underflow = ses->underflow;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
 
Index: usb-2.6/include/scsi/scsi_eh.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_eh.h
+++ usb-2.6/include/scsi/scsi_eh.h
@@ -73,6 +73,7 @@ extern int scsi_reset_provider(struct sc
 struct scsi_eh_save {
 	/* saved state */
 	int result;
+	unsigned underflow;
 	enum dma_data_direction data_direction;
 	unsigned char cmd_len;
 	unsigned char *cmnd;

