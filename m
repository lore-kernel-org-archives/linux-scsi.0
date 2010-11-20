From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer derefs
 in scsi_error.c and reduce size as well
Date: Sat, 20 Nov 2010 21:30:39 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1011202127131.24071@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net> <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com> <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>
 <AANLkTim1MChiEa9rBL0ZfSCak6G2x4ivK47Svd6swEBS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTim1MChiEa9rBL0ZfSCak6G2x4ivK47Svd6swEBS@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, "David S. Miller" <davem@davemloft.net>, Mike Anderson <andmike@us.ibm.com>, Russell King <rmk@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 18 Nov 2010, Linus Torvalds wrote:

> On Thu, Nov 18, 2010 at 12:49 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> >
> > Fair enough. Seeing your version of this and looking a second time at mine
> > I have to agree completely.
> > You are absolutely right in stating that the compiler will handle this
> > just fine, so it's only a readabillity issue and your version is a *lot*
> > more readable than what I came up with.
> 
> Btw, one thing to look out for is all those function calls: it really
> looks like many of them would be better off not having to dereference
> the thing inside each helper function, but just have it dereferenced
> in the caller.
> 
> You might trying passing in "struct Scsi_Host *host" to a lot of those
> helper functions in addition to the 'scmd' part. There's a lot of
> "scmd->device->host" going on, and even if you remove some of them
> _within_ a function, if you really want to get rid of them you should
> probably do one of them in the caller.
> 
> That's why the queuecommand() function was changed to take
> 
>     struct Scsi_Host *h, struct scsi_cmnd *
> 
> as its arguments, because that host is used so commonly. And passing
> two arguments is usually free (ie almost all architectures pass it in
> registers), and that host variable almost always already exists in the
> caller because the caller already needed it.
> 
> So if you changed the functions that only take "scsi_cmnd *" as an
> argument to match the new queuecommand() interface, I bet you'd get
> more cleanups. And the interfaces would match.
> 
Ok, I tried doing that (see patch below), but the result ended up as a 
larger object file.

   text    data     bss     dec     hex filename
  11861       6       6   11873    2e61 drivers/scsi/scsi_error.o

So, I think (the 'interfaces matching' argument aside) that I'll stick to 
my previous version of the patch. Do you disagree?
If not, perhaps you could ACK the previous version?


This is the alternative I tried:

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 824b8fc..c44a08e 100644
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
 
@@ -91,27 +91,26 @@ EXPORT_SYMBOL_GPL(scsi_schedule_eh);
  * Return value:
  *	0 on failure.
  */
-int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
+int scsi_eh_scmd_add(struct Scsi_Host *h, struct scsi_cmnd *scmd, int eh_flag)
 {
-	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
 	int ret = 0;
 
-	if (!shost->ehandler)
+	if (!h->ehandler)
 		return 0;
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsi_host_set_state(shost, SHOST_RECOVERY))
-		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
+	spin_lock_irqsave(h->host_lock, flags);
+	if (scsi_host_set_state(h, SHOST_RECOVERY))
+		if (scsi_host_set_state(h, SHOST_CANCEL_RECOVERY))
 			goto out_unlock;
 
 	ret = 1;
 	scmd->eh_eflags |= eh_flag;
-	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
-	shost->host_failed++;
-	scsi_eh_wakeup(shost);
+	list_add_tail(&scmd->eh_entry, &h->eh_cmd_q);
+	h->host_failed++;
+	scsi_eh_wakeup(h);
  out_unlock:
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(h->host_lock, flags);
 	return ret;
 }
 
@@ -125,7 +124,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
  *     normal completion function determines that the timer has already
  *     fired, then it mustn't do anything.
  */
-enum blk_eh_timer_return scsi_times_out(struct request *req)
+enum blk_eh_timer_return scsi_times_out(struct Scsi_Host *h, struct request *req)
 {
 	struct scsi_cmnd *scmd = req->special;
 	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
@@ -133,13 +132,14 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
-	if (scmd->device->host->transportt->eh_timed_out)
-		rtn = scmd->device->host->transportt->eh_timed_out(scmd);
-	else if (scmd->device->host->hostt->eh_timed_out)
-		rtn = scmd->device->host->hostt->eh_timed_out(scmd);
+	if (h->transportt->eh_timed_out)
+		rtn = h->transportt->eh_timed_out(scmd);
+	else if (h->hostt->eh_timed_out)
+		rtn = h->hostt->eh_timed_out(scmd);
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
-		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
+		     !scsi_eh_scmd_add(scmd->device->host, scmd,
+				       SCSI_EH_CANCEL_CMD))) {
 		scmd->result |= DID_TIME_OUT << 16;
 		rtn = BLK_EH_HANDLED;
 	}
@@ -195,7 +195,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 				++total_failures;
 				if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD)
 					++cmd_cancel;
-				else 
+				else
 					++cmd_failed;
 			}
 		}
@@ -294,7 +294,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 			return NEEDS_RETRY;
 		}
 		/*
-		 * if the device is in the process of becoming ready, we 
+		 * if the device is in the process of becoming ready, we
 		 * should retry.
 		 */
 		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
@@ -503,26 +503,26 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
  * scsi_try_host_reset - ask host adapter to reset itself
  * @scmd:	SCSI cmd to send hsot reset.
  */
-static int scsi_try_host_reset(struct scsi_cmnd *scmd)
+static int scsi_try_host_reset(struct Scsi_Host *h, struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct scsi_host_template *hostt = h->hostt;
 
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
+		spin_lock_irqsave(h->host_lock, flags);
+		scsi_report_bus_reset(h, scmd_channel(scmd));
+		spin_unlock_irqrestore(h->host_lock, flags);
 	}
 
 	return rtn;
@@ -532,26 +532,26 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
  * scsi_try_bus_reset - ask host to perform a bus reset
  * @scmd:	SCSI cmd to send bus reset.
  */
-static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
+static int scsi_try_bus_reset(struct Scsi_Host *h, struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct scsi_host_template *hostt = h->hostt;
 
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
+		spin_lock_irqsave(h->host_lock, flags);
+		scsi_report_bus_reset(h, scmd_channel(scmd));
+		spin_unlock_irqrestore(h->host_lock, flags);
 	}
 
 	return rtn;
@@ -573,20 +573,21 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
-static int scsi_try_target_reset(struct scsi_cmnd *scmd)
+static int scsi_try_target_reset(struct Scsi_Host *h, struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct scsi_host_template *hostt = h->hostt;
 
-	if (!scmd->device->host->hostt->eh_target_reset_handler)
+	if (!hostt->eh_target_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_target_reset_handler(scmd);
+	rtn = hostt->eh_target_reset_handler(scmd);
 	if (rtn == SUCCESS) {
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(h->host_lock, flags);
 		__starget_for_each_device(scsi_target(scmd->device), NULL,
 					  __scsi_report_device_reset);
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_unlock_irqrestore(h->host_lock, flags);
 	}
 
 	return rtn;
@@ -602,14 +603,16 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
+
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
@@ -617,10 +620,10 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 
 static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
-	if (!scmd->device->host->hostt->eh_abort_handler)
+	struct scsi_host_template *hostt = scmd->device->host->hostt;
+	if (!hostt->eh_abort_handler)
 		return FAILED;
-
-	return scmd->device->host->hostt->eh_abort_handler(scmd);
+	return hostt->eh_abort_handler(scmd);
 }
 
 /**
@@ -647,11 +650,14 @@ static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 {
+	struct Scsi_Host *h;
 	if (__scsi_try_to_abort_cmd(scmd) != SUCCESS)
-		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
-			if (scsi_try_target_reset(scmd) != SUCCESS)
-				if (scsi_try_bus_reset(scmd) != SUCCESS)
-					scsi_try_host_reset(scmd);
+		if (scsi_try_bus_device_reset(scmd) != SUCCESS) {
+			h = scmd->device->host;
+			if (scsi_try_target_reset(h, scmd) != SUCCESS)
+				if (scsi_try_bus_reset(h, scmd) != SUCCESS)
+					scsi_try_host_reset(h, scmd);
+		}
 }
 
 /**
@@ -867,7 +873,7 @@ EXPORT_SYMBOL(scsi_eh_finish_cmd);
  *
  * Description:
  *    See if we need to request sense information.  if so, then get it
- *    now, so we have a better idea of what to do.  
+ *    now, so we have a better idea of what to do.
  *
  * Notes:
  *    This has the unfortunate side effect that if a shost adapter does
@@ -987,7 +993,6 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 			    !scsi_eh_tur(scmd)) {
 				scsi_eh_finish_cmd(scmd, done_q);
 			}
-				
 		} else
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting"
 							  " cmd failed:"
@@ -1031,7 +1036,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
  *
  * Notes:
  *    If commands are failing due to not ready, initializing command required,
- *	try revalidating the device, which will end up sending a start unit. 
+ *	try revalidating the device, which will end up sending a start unit.
  */
 static int scsi_eh_stu(struct Scsi_Host *shost,
 			      struct list_head *work_q,
@@ -1085,7 +1090,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
  *    Try a bus device reset.  Still, look to see whether we have multiple
  *    devices that are jammed or not - if we have multiple devices, it
  *    makes no sense to try bus_device_reset - we really would need to try
- *    a bus_reset instead. 
+ *    a bus_reset instead.
  */
 static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				    struct list_head *work_q,
@@ -1174,7 +1179,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
 						  "to target %d\n",
 						  current->comm, id));
-		rtn = scsi_try_target_reset(tgtr_scmd);
+		rtn = scsi_try_target_reset(tgtr_scmd->device->host, tgtr_scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (id == scmd_id(scmd))
@@ -1196,7 +1201,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 }
 
 /**
- * scsi_eh_bus_reset - send a bus reset 
+ * scsi_eh_bus_reset - send a bus reset
  * @shost:	&scsi host being recovered.
  * @work_q:     &list_head for pending commands.
  * @done_q:	&list_head for processed commands.
@@ -1213,7 +1218,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	 * we really want to loop over the various channels, and do this on
 	 * a channel by channel basis.  we should also check to see if any
 	 * of the failed commands are on soft_reset devices, and if so, skip
-	 * the reset.  
+	 * the reset.
 	 */
 
 	for (channel = 0; channel <= shost->max_channel; channel++) {
@@ -1234,7 +1239,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BRST chan:"
 						  " %d\n", current->comm,
 						  channel));
-		rtn = scsi_try_bus_reset(chan_scmd);
+		rtn = scsi_try_bus_reset(chan_scmd->device->host, chan_scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd))
@@ -1255,7 +1260,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 }
 
 /**
- * scsi_eh_host_reset - send a host reset 
+ * scsi_eh_host_reset - send a host reset
  * @work_q:	list_head for processed commands.
  * @done_q:	list_head for processed commands.
  */
@@ -1272,7 +1277,7 @@ static int scsi_eh_host_reset(struct list_head *work_q,
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending HRST\n"
 						  , current->comm));
 
-		rtn = scsi_try_host_reset(scmd);
+		rtn = scsi_try_host_reset(scmd->device->host, scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (!scsi_device_online(scmd->device) ||
@@ -1408,7 +1413,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 		/*
 		 * when the low level driver returns did_soft_error,
-		 * it is responsible for keeping an internal retry counter 
+		 * it is responsible for keeping an internal retry counter
 		 * in order to avoid endless loops (db)
 		 *
 		 * actually this is a bug in this function here.  we should
@@ -1922,17 +1927,17 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 			break;
 		/* FALLTHROUGH */
 	case SCSI_TRY_RESET_TARGET:
-		rtn = scsi_try_target_reset(scmd);
+		rtn = scsi_try_target_reset(shost, scmd);
 		if (rtn == SUCCESS)
 			break;
 		/* FALLTHROUGH */
 	case SCSI_TRY_RESET_BUS:
-		rtn = scsi_try_bus_reset(scmd);
+		rtn = scsi_try_bus_reset(shost, scmd);
 		if (rtn == SUCCESS)
 			break;
 		/* FALLTHROUGH */
 	case SCSI_TRY_RESET_HOST:
-		rtn = scsi_try_host_reset(scmd);
+		rtn = scsi_try_host_reset(shost, scmd);
 		break;
 	default:
 		rtn = FAILED;
@@ -2005,7 +2010,7 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		if (sb_len > 7)
 			sshdr->additional_length = sense_buffer[7];
 	} else {
-		/* 
+		/*
 		 * fixed format
 		 */
 		if (sb_len > 2)
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b4056d1..083c02c 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -63,11 +63,13 @@ extern int __init scsi_init_devinfo(void);
 extern void scsi_exit_devinfo(void);
 
 /* scsi_error.c */
-extern enum blk_eh_timer_return scsi_times_out(struct request *req);
+extern enum blk_eh_timer_return scsi_times_out(struct Scsi_Host *h,
+					struct request *req);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
-extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
+extern int scsi_eh_scmd_add(struct Scsi_Host *h, struct scsi_cmnd *scmd,
+			int eh_flag);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
 			struct list_head *done_q);


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
