From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH 2.4] make SCSI error handler preserve data transfer residual
Date: Thu, 13 May 2004 10:38:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04May13.103833edt.332233@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:29199 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S262361AbUEMOig
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 10:38:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When a SCSI command fails, the error handler in 2.4.x may send a command
such as request sense which clobbers the data transfer residual value of
the original command.  This patch against 2.4.26 makes the error handler
save and restore the data transfer residual so that the value passed
back to the upper level reflects the residual of the original command
rather than the error handler's internal command.

Anthony J. Battersby
Cybernetics

--- linux-2.4.26-vanilla/drivers/scsi/scsi_error.c	Wed Apr 14 09:05:31
2004
+++ linux-2.4.26-scsi/drivers/scsi/scsi_error.c	Thu May 13 10:16:24 2004
@@ -410,6 +410,7 @@
 	{REQUEST_SENSE, 0, 0, 0, 255, 0};
 	unsigned char scsi_result0[256], *scsi_result = NULL;
 	int saved_result;
+	int saved_resid;

 	ASSERT_LOCK(&io_request_lock, 0);

@@ -436,6 +437,7 @@
 	memset((void *) scsi_result, 0, 256);

 	saved_result = SCpnt->result;
+	saved_resid = SCpnt->resid;
 	SCpnt->request_buffer = scsi_result;
 	SCpnt->request_bufflen = 256;
 	SCpnt->use_sg = 0;
@@ -461,6 +463,7 @@
 	memcpy((void *) SCpnt->cmnd, (void *) SCpnt->data_cmnd,
 	       sizeof(SCpnt->data_cmnd));
 	SCpnt->result = saved_result;
+	SCpnt->resid = saved_resid;
 	SCpnt->request_buffer = SCpnt->buffer;
 	SCpnt->request_bufflen = SCpnt->bufflen;
 	SCpnt->use_sg = SCpnt->old_use_sg;
@@ -484,6 +487,7 @@
 {
 	static unsigned char tur_command[6] =
 	{TEST_UNIT_READY, 0, 0, 0, 0, 0};
+	int saved_resid;

 	memcpy((void *) SCpnt->cmnd, (void *) tur_command,
 	       sizeof(tur_command));
@@ -497,6 +501,7 @@
 	 */
 	memset((void *) SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));

+	saved_resid = SCpnt->resid;
 	SCpnt->request_buffer = NULL;
 	SCpnt->request_bufflen = 0;
 	SCpnt->use_sg = 0;
@@ -512,6 +517,7 @@
 	 */
 	memcpy((void *) SCpnt->cmnd, (void *) SCpnt->data_cmnd,
 	       sizeof(SCpnt->data_cmnd));
+	SCpnt->resid = saved_resid;
 	SCpnt->request_buffer = SCpnt->buffer;
 	SCpnt->request_bufflen = SCpnt->bufflen;
 	SCpnt->use_sg = SCpnt->old_use_sg;

