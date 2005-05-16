From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] saved and restore result for timed out commands
Date: Mon, 16 May 2005 10:42:15 -0700
Message-ID: <20050516174215.GA23974@us.ibm.com>
References: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org> <20050510225831.GA4181@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40889 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261460AbVEPRmv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 13:42:51 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j4GHgpku027734
	for <linux-scsi@vger.kernel.org>; Mon, 16 May 2005 13:42:51 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4GHgpV8136622
	for <linux-scsi@vger.kernel.org>; Mon, 16 May 2005 13:42:51 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j4GHgom0024199
	for <linux-scsi@vger.kernel.org>; Mon, 16 May 2005 13:42:51 -0400
Content-Disposition: inline
In-Reply-To: <20050510225831.GA4181@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

Save and restore the scmd->result, so that timed out commands do not
return the result of the TEST UNIT READY or the start/stop commands. Code
is already in place to save and restore the result for the request sense
case.

The previous version of this patch erroneously removed the "if" check,
instead add a comment as to why the "if" is needed.

Signed-off-by: Patrick Mansfield <patmans@us.ibm.com>

diff -uprN -X /home/patman/dontdiff scsi-misc-2.6.git/drivers/scsi/scsi_error.c to-res-scsi-misc-2.6.git/drivers/scsi/scsi_error.c
--- scsi-misc-2.6.git/drivers/scsi/scsi_error.c	2005-05-09 14:19:41.000000000 -0700
+++ to-res-scsi-misc-2.6.git/drivers/scsi/scsi_error.c	2005-05-16 10:01:11.000000000 -0700
@@ -770,6 +770,7 @@ static int scsi_eh_tur(struct scsi_cmnd 
 {
 	static unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
 	int retry_cnt = 1, rtn;
+	int saved_result;
 
 retry_tur:
 	memcpy(scmd->cmnd, tur_command, sizeof(tur_command));
@@ -780,6 +781,7 @@ retry_tur:
 	 */
 	memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
 
+	saved_result = scmd->result;
 	scmd->request_buffer = NULL;
 	scmd->request_bufflen = 0;
 	scmd->use_sg = 0;
@@ -794,6 +796,7 @@ retry_tur:
 	 * the original request, so let's restore the original data. (db)
 	 */
 	scsi_setup_cmd_retry(scmd);
+	scmd->result = saved_result;
 
 	/*
 	 * hey, we are done.  let's look to see what happened.
@@ -896,6 +899,7 @@ static int scsi_eh_try_stu(struct scsi_c
 {
 	static unsigned char stu_command[6] = {START_STOP, 0, 0, 0, 1, 0};
 	int rtn;
+	int saved_result;
 
 	if (!scmd->device->allow_restart)
 		return 1;
@@ -908,6 +912,7 @@ static int scsi_eh_try_stu(struct scsi_c
 	 */
 	memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
 
+	saved_result = scmd->result;
 	scmd->request_buffer = NULL;
 	scmd->request_bufflen = 0;
 	scmd->use_sg = 0;
@@ -922,6 +927,7 @@ static int scsi_eh_try_stu(struct scsi_c
 	 * the original request, so let's restore the original data. (db)
 	 */
 	scsi_setup_cmd_retry(scmd);
+	scmd->result = saved_result;
 
 	/*
 	 * hey, we are done.  let's look to see what happened.
@@ -1561,6 +1567,11 @@ static void scsi_eh_flush_done_q(struct 
 							  scmd));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 		} else {
+			/*
+			 * If just we got sense for the device (called
+			 * scsi_eh_get_sense), scmd->result is already
+			 * set, do not set DRIVER_TIMEOUT.
+			 */
 			if (!scmd->result)
 				scmd->result |= (DRIVER_TIMEOUT << 24);
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
