From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer derefs
 in scsi_error.c and reduce size as well
Date: Wed, 22 Dec 2010 21:23:42 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1012222119400.32358@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net>  <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com>  <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>  <AANLkTim1MChiEa9rBL0ZfSCak6G2x4ivK47Svd6swEBS@mail.gmail.com>
  <alpine.LNX.2.00.1011202127131.24071@swampdragon.chaosbits.net>  <AANLkTi=_r2YvDv0wj6qY_DqXntvHwfKNavTv8AKF+iXm@mail.gmail.com>  <alpine.LNX.2.00.1011211941240.19813@swampdragon.chaosbits.net> <1292953070.3034.12.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292953070.3034.12.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, "David S. Miller" <davem@davemloft.net>, Mike Anderson <andmike@us.ibm.com>, Russell King <rmk@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 21 Dec 2010, James Bottomley wrote:

> On Sun, 2010-11-21 at 19:48 +0100, Jesper Juhl wrote:
> > On Sat, 20 Nov 2010, Linus Torvalds wrote:
> > 
> > > On Sat, Nov 20, 2010 at 12:30 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > > >
> > > > Ok, I tried doing that (see patch below)
> > > 
> > > Actually, you kind of chose exactly the reverse of the functions I'd
> > > have chosen.
> > > 
> > > Try doing the added parameter to the small static helper functions.
> > > Those are the ones that tend to get inlined, and then the parameter
> > > should actually result in _fewer_ pointer reloads.
> > > 
> > > So the ones like this:
> > > 
> > > >  static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
> > [...]
> > 
> > I see your point now.
> > 
> > I tried this with most of the functions where it seemed that it could 
> > possibly be a gain, but in the end it turned out that only the one you 
> > pointed out above actually saw any benefit, so that's the only one I 
> > changed.
> > 
> > In the end, the object size is down to this:
> > 
> >    text    data     bss     dec     hex filename
> >   18713     128    4704   23545    5bf9 drivers/scsi/scsi_error.o
> > 
> > from this:
> > 
> >    text    data     bss     dec     hex filename
> >   18790     128    4712   23630    5c4e drivers/scsi/scsi_error.o
> > 
> > 
> > and the patch looks like this now:
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> This is rejecting against scsi-misc:
> 
...
> 
> Could you respin so it applies, please?
> 

Sure. The following applies against the tip of Linus' tree as of right now 
(head at 90a8a73c06cc32b609a880d48449d7083327e11a).

We are now down to this as far as size goes:

   text    data     bss     dec     hex filename
  18691     128    4696   23515    5bdb drivers/scsi/scsi_error.o


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 scsi_error.c |   94 ++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 49 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 30ac116..b37e10f 100644
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
@@ -214,7 +215,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 
 	SCSI_LOG_ERROR_RECOVERY(2, printk("Total of %d commands on %d"
 					  " devices require eh work\n",
-				  total_failures, devices_failed));
+				   total_failures, devices_failed));
 }
 #endif
 
@@ -294,7 +295,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 			return NEEDS_RETRY;
 		}
 		/*
-		 * if the device is in the process of becoming ready, we 
+		 * if the device is in the process of becoming ready, we
 		 * should retry.
 		 */
 		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
@@ -488,7 +489,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
  */
 static void scsi_eh_done(struct scsi_cmnd *scmd)
 {
-	struct completion     *eh_action;
+	struct completion *eh_action;
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s scmd: %p result: %x\n",
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
@@ -605,27 +610,28 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
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
 }
 
-static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
+static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
 {
-	if (!scmd->device->host->hostt->eh_abort_handler)
+	if (!hostt->eh_abort_handler)
 		return FAILED;
 
-	return scmd->device->host->hostt->eh_abort_handler(scmd);
+	return hostt->eh_abort_handler(scmd);
 }
 
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 {
-	if (scsi_try_to_abort_cmd(scmd) != SUCCESS)
+	if (scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd) != SUCCESS)
 		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
 			if (scsi_try_target_reset(scmd) != SUCCESS)
 				if (scsi_try_bus_reset(scmd) != SUCCESS)
@@ -845,7 +851,7 @@ EXPORT_SYMBOL(scsi_eh_finish_cmd);
  *
  * Description:
  *    See if we need to request sense information.  if so, then get it
- *    now, so we have a better idea of what to do.  
+ *    now, so we have a better idea of what to do.
  *
  * Notes:
  *    This has the unfortunate side effect that if a shost adapter does
@@ -957,7 +963,7 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
 						  "0x%p\n", current->comm,
 						  scmd));
-		rtn = scsi_try_to_abort_cmd(scmd);
+		rtn = scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
 			if (!scsi_device_online(scmd->device) ||
@@ -965,7 +971,6 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 			    !scsi_eh_tur(scmd)) {
 				scsi_eh_finish_cmd(scmd, done_q);
 			}
-				
 		} else
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting"
 							  " cmd failed:"
@@ -1009,7 +1014,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
  *
  * Notes:
  *    If commands are failing due to not ready, initializing command required,
- *	try revalidating the device, which will end up sending a start unit. 
+ *	try revalidating the device, which will end up sending a start unit.
  */
 static int scsi_eh_stu(struct Scsi_Host *shost,
 			      struct list_head *work_q,
@@ -1063,7 +1068,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
  *    Try a bus device reset.  Still, look to see whether we have multiple
  *    devices that are jammed or not - if we have multiple devices, it
  *    makes no sense to try bus_device_reset - we really would need to try
- *    a bus_reset instead. 
+ *    a bus_reset instead.
  */
 static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				    struct list_head *work_q,
@@ -1174,7 +1179,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 }
 
 /**
- * scsi_eh_bus_reset - send a bus reset 
+ * scsi_eh_bus_reset - send a bus reset
  * @shost:	&scsi host being recovered.
  * @work_q:     &list_head for pending commands.
  * @done_q:	&list_head for processed commands.
@@ -1191,7 +1196,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	 * we really want to loop over the various channels, and do this on
 	 * a channel by channel basis.  we should also check to see if any
 	 * of the failed commands are on soft_reset devices, and if so, skip
-	 * the reset.  
+	 * the reset.
 	 */
 
 	for (channel = 0; channel <= shost->max_channel; channel++) {
@@ -1233,7 +1238,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 }
 
 /**
- * scsi_eh_host_reset - send a host reset 
+ * scsi_eh_host_reset - send a host reset
  * @work_q:	list_head for processed commands.
  * @done_q:	list_head for processed commands.
  */
@@ -1386,7 +1391,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 		/*
 		 * when the low level driver returns did_soft_error,
-		 * it is responsible for keeping an internal retry counter 
+		 * it is responsible for keeping an internal retry counter
 		 * in order to avoid endless loops (db)
 		 *
 		 * actually this is a bug in this function here.  we should
@@ -1424,7 +1429,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 			 */
 			break;
 		/* fallthrough */
-
 	case DID_BUS_BUSY:
 	case DID_PARITY:
 		goto maybe_retry;
@@ -1983,7 +1987,7 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
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
