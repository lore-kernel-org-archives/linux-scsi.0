From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH][resend][SCSI] Reduce number of sequential pointer derefs in
 scsi_error.c and reduce size as well
Date: Thu, 18 Nov 2010 20:30:21 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:35993 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab0KRTnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 14:43:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, "David S. Miller" <davem@davemloft.net>, Mike Anderson <andmike@us.ibm.com>, Russell King <rmk@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

Hi everyone,

This is the fourth time I send this patch. For some reason it seems unable 
to get any feedback at all. I'd really appreciate a clear ACK or NACK on 
it and I'll keep resending it until it's either merged or I get a NACK 
with a reason.
It is fairly trivial, so I'm naturally hoping for ACK+Merge (I really 
would like to just get it out of my queue), but if that doesn't happen 
please let me know why not.

This time around I've chosen to broaden the Cc list quite a bit in the 
hope of getting some sort of feedback from someone (previously it was 
just submitted to linux-kernel, linux-scsi and the SCSI maintainer).

The patch was previously submitted on
	24 April 2008
	27 April 2008
	14 November 2010


This patch reduces the number of sequential pointer derefs in 
drivers/scsi/scsi_error.c (and also removes a bit of trailing whitespace 
this time around since I got fed up with it and thought that perhaps that 
would help trigger a response - if nothing else then just a "do that in a 
separate patch" would be an improvement).

It's on top of Linus' git tree as of just now (HEAD is at 
2d42dc3feb6649c0e08641b0a6f0e0bad22aeeb2)

The bennefits are:

 - makes the code easier to read. Lots of sequential derefs of the same 
   pointers is not easy on the eye.

 - theoretically at least, just dereferencing the pointers once can allow 
   the compiler to generate slightly faster code, so in theory this could 
   also be a micro speed optimization.

 - reduces size
   before:
   	   text    data     bss     dec     hex filename
   	  11861       6       6   11873    2e61 drivers/scsi/scsi_error.o
   after:
   	   text    data     bss     dec     hex filename
   	  11829       6       6   11841    2e41 drivers/scsi/scsi_error.o

 - gets rid of annoying trailing whitespace.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 scsi_error.c |   86 ++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 824b8fc..ee91327 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -3,14 +3,14 @@
  *
  *  SCSI error/timeout handling
  *      Initial versions: Eric Youngdale.  Based upon conversations with
- *                        Leonard Zubkoff and David Miller at Linux Expo, 
+ *                        Leonard Zubkoff and David Miller at Linux Expo,
  *                        ideas originating from all over the place.
  *
  *	Restructured scsi_unjam_host and associated functions.
  *	September 04, 2002 Mike Anderson (andmike@us.ibm.com)
  *
  *	Forward port of Russell King's (rmk@arm.linux.org.uk) changes and
- *	minor  cleanups.
+ *	minor cleanups.
  *	September 30, 2002 Mike Anderson (andmike@us.ibm.com)
  */
 
@@ -129,14 +129,15 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 {
 	struct scsi_cmnd *scmd = req->special;
 	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
+	struct Scsi_Host *host = scmd->device->host;
 
 	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
-	if (scmd->device->host->transportt->eh_timed_out)
-		rtn = scmd->device->host->transportt->eh_timed_out(scmd);
-	else if (scmd->device->host->hostt->eh_timed_out)
-		rtn = scmd->device->host->hostt->eh_timed_out(scmd);
+	if (host->transportt->eh_timed_out)
+		rtn = host->transportt->eh_timed_out(scmd);
+	else if (host->hostt->eh_timed_out)
+		rtn = host->hostt->eh_timed_out(scmd);
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
@@ -195,7 +196,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 				++total_failures;
 				if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD)
 					++cmd_cancel;
-				else 
+				else
 					++cmd_failed;
 			}
 		}
@@ -294,7 +295,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 			return NEEDS_RETRY;
 		}
 		/*
-		 * if the device is in the process of becoming ready, we 
+		 * if the device is in the process of becoming ready, we
 		 * should retry.
 		 */
 		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
@@ -507,22 +508,23 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_host_template *hostt = host->hostt;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
 					  __func__));
 
-	if (!scmd->device->host->hostt->eh_host_reset_handler)
+	if (!hostt->eh_host_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
+	rtn = hostt->eh_host_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
-				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(host->host_lock, flags);
+		scsi_report_bus_reset(host, scmd_channel(scmd));
+		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
 	return rtn;
@@ -536,22 +538,23 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_host_template *hostt = host->hostt;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
 					  __func__));
 
-	if (!scmd->device->host->hostt->eh_bus_reset_handler)
+	if (!hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
+	rtn = hostt->eh_bus_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!hostt->skip_settle_delay)
 			ssleep(BUS_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
-				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(host->host_lock, flags);
+		scsi_report_bus_reset(host, scmd_channel(scmd));
+		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
 	return rtn;
@@ -577,16 +580,18 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_host_template *hostt = host->hostt;
 
-	if (!scmd->device->host->hostt->eh_target_reset_handler)
+	if (!hostt->eh_target_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_target_reset_handler(scmd);
+	rtn = hostt->eh_target_reset_handler(scmd);
 	if (rtn == SUCCESS) {
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(host->host_lock, flags);
 		__starget_for_each_device(scsi_target(scmd->device), NULL,
 					  __scsi_report_device_reset);
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
 	return rtn;
@@ -605,11 +610,12 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
 	int rtn;
+	struct scsi_host_template *hostt = scmd->device->host->hostt;
 
-	if (!scmd->device->host->hostt->eh_device_reset_handler)
+	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
+	rtn = hostt->eh_device_reset_handler(scmd);
 	if (rtn == SUCCESS)
 		__scsi_report_device_reset(scmd->device, NULL);
 	return rtn;
@@ -617,10 +623,9 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 
 static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
-	if (!scmd->device->host->hostt->eh_abort_handler)
-		return FAILED;
-
-	return scmd->device->host->hostt->eh_abort_handler(scmd);
+	int (*eh_abort_handler)(struct scsi_cmnd *) =
+		scmd->device->host->hostt->eh_abort_handler;
+	return eh_abort_handler ? eh_abort_handler(scmd) : FAILED;
 }
 
 /**
@@ -867,7 +872,7 @@ EXPORT_SYMBOL(scsi_eh_finish_cmd);
  *
  * Description:
  *    See if we need to request sense information.  if so, then get it
- *    now, so we have a better idea of what to do.  
+ *    now, so we have a better idea of what to do.
  *
  * Notes:
  *    This has the unfortunate side effect that if a shost adapter does
@@ -987,7 +992,6 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 			    !scsi_eh_tur(scmd)) {
 				scsi_eh_finish_cmd(scmd, done_q);
 			}
-				
 		} else
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting"
 							  " cmd failed:"
@@ -1031,7 +1035,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
  *
  * Notes:
  *    If commands are failing due to not ready, initializing command required,
- *	try revalidating the device, which will end up sending a start unit. 
+ *	try revalidating the device, which will end up sending a start unit.
  */
 static int scsi_eh_stu(struct Scsi_Host *shost,
 			      struct list_head *work_q,
@@ -1085,7 +1089,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
  *    Try a bus device reset.  Still, look to see whether we have multiple
  *    devices that are jammed or not - if we have multiple devices, it
  *    makes no sense to try bus_device_reset - we really would need to try
- *    a bus_reset instead. 
+ *    a bus_reset instead.
  */
 static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				    struct list_head *work_q,
@@ -1196,7 +1200,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 }
 
 /**
- * scsi_eh_bus_reset - send a bus reset 
+ * scsi_eh_bus_reset - send a bus reset
  * @shost:	&scsi host being recovered.
  * @work_q:     &list_head for pending commands.
  * @done_q:	&list_head for processed commands.
@@ -1213,7 +1217,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	 * we really want to loop over the various channels, and do this on
 	 * a channel by channel basis.  we should also check to see if any
 	 * of the failed commands are on soft_reset devices, and if so, skip
-	 * the reset.  
+	 * the reset.
 	 */
 
 	for (channel = 0; channel <= shost->max_channel; channel++) {
@@ -1255,7 +1259,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 }
 
 /**
- * scsi_eh_host_reset - send a host reset 
+ * scsi_eh_host_reset - send a host reset
  * @work_q:	list_head for processed commands.
  * @done_q:	list_head for processed commands.
  */
@@ -1408,7 +1412,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 		/*
 		 * when the low level driver returns did_soft_error,
-		 * it is responsible for keeping an internal retry counter 
+		 * it is responsible for keeping an internal retry counter
 		 * in order to avoid endless loops (db)
 		 *
 		 * actually this is a bug in this function here.  we should
@@ -2005,7 +2009,7 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		if (sb_len > 7)
 			sshdr->additional_length = sense_buffer[7];
 	} else {
-		/* 
+		/*
 		 * fixed format
 		 */
 		if (sb_len > 2)



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

