From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: sg driver and the error handler
Date: Tue, 10 May 2005 15:58:31 -0700
Message-ID: <20050510225831.GA4181@us.ibm.com>
References: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:43224 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261839AbVEJW6i
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2005 18:58:38 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j4AMwbT9629278
	for <linux-scsi@vger.kernel.org>; Tue, 10 May 2005 18:58:37 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4AMwb6d252532
	for <linux-scsi@vger.kernel.org>; Tue, 10 May 2005 16:58:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j4AMwa4b027371
	for <linux-scsi@vger.kernel.org>; Tue, 10 May 2005 16:58:37 -0600
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hi Alan -

On Tue, May 10, 2005 at 02:51:44PM -0400, Alan Stern wrote:
> When a command injected through the sg driver encounters any sort of
> error, the usual retry mechanism and error handler are brought into play.  
> Since sg sets the number of retries to 0 by default, the retry mechanism
> shouldn't cause any difficulty.  But the error handler does.  IMO it
> should never get involved with requests coming through sg -- sg should
> provide access that is as transparent as possible so that userspace
> programs will have a clean shot at managing their device.

The error handler is mainly a timeout handler, so it has to run to cancel
the timed out command, we can't complete the timed out command back to the
upper level until we know the HBA is no longer using it.

> Consider a case that just came up.  A USB CD drive causes a phase error
> when it receives a certain READ BUFFER command (buggy firmware on the
> drive, never mind that now).  You would expect the user program to receive
> from sg a host_status value indicating DID_ERROR or something of the sort.
> 
> Instead the error handler takes charge and sends out one or two TEST UNIT 
> READY commands.  The status information finally received by the user 
> program is the status from the TEST UNIT READY, not from the failed READ 
> BUFFER!  How's a program supposed to cope with that sort of obfuscation?

:-(

> Something in the SCSI stack (scsi_io_completion ?) should check for 
> requests coming in via sg and should know to complete the requests 
> immediately.  No requeuing and no error handling.

> Does this sound like a feasible thing to implement?

No per above. I think there are still some cases where sg or SG_IO
commands are not immediately returned, I think for some certain ASC codes,
some of those probably should be retried, as should cases like QUEUE FULL.

As you say, what you really want is the correct result going back to the
user, not the result of the TUR.

So save and restore the result in scsi_eh_tur, and also in scsi_eh_try_stu.
The request sense one already saves and restores it.

And always set result |= (DRIVER_TIMEOUT << 24) if we are not requeueing
the IO.

Like (only compile tested) this, against scsi-misc git tree of a few days
ago. Hopefully, sg or SG_IO programs can handle DRIVER_TIMEOUT :-/ but it
is certainly better than returning as if no error occurred.

What do you think?

diff -uprN -X /home/patman/dontdiff scsi-misc-2.6.git/drivers/scsi/scsi_error.c to-res-scsi-misc-2.6.git/drivers/scsi/scsi_error.c
--- scsi-misc-2.6.git/drivers/scsi/scsi_error.c	2005-05-09 14:19:41.000000000 -0700
+++ to-res-scsi-misc-2.6.git/drivers/scsi/scsi_error.c	2005-05-10 15:49:01.000000000 -0700
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
@@ -1561,8 +1567,7 @@ static void scsi_eh_flush_done_q(struct 
 							  scmd));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 		} else {
-			if (!scmd->result)
-				scmd->result |= (DRIVER_TIMEOUT << 24);
+			scmd->result |= (DRIVER_TIMEOUT << 24);
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
 							" cmd: %p\n",
 							current->comm, scmd));


-- Patrick Mansfield
