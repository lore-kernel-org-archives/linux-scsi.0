From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Sat, 4 May 2013 18:20:52 +0000
Message-ID: <1367691652.2052.8.camel@dabdike>
References: <1366870200-6492-1-git-send-email-hare@suse.de>
	  <20130503102400.Horde.TQF1IJir309Rg8iARNPkSKA@imap.linux.ibm.com>
	 <1367605401.5981.45.camel@dabdike> <51853F38.9040805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:44844 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760473Ab3EDSU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 May 2013 14:20:56 -0400
In-Reply-To: <51853F38.9040805@acm.org>
Content-Language: en-US
Content-ID: <B3F51FEADAAAC14DB86F84B3D23F5DA6@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

On Sat, 2013-05-04 at 19:02 +0200, Bart Van Assche wrote:
> On 05/03/13 20:23, James Bottomley wrote:
> > +	const unsigned long stall_for = min(msecs_to_jiffies(10), 1UL);
> 
> Hello James,
> 
> Can you please clarify what the intention of this statement is ? Is the 
> purpose of this statement to avoid that stall_for would be zero in case 
> HZ < 100 ? If that is the case, maybe you meant max() instead of min() ? 
> Also, are you aware that msecs_to_jiffies() already rounds up the result 
> of the division ?

Yes, I thought afterwards I should dump the bogus min statement as well.
Plus HZ/10 is actually 100ms, so the value is 10x wrong.  I've fixed it
up below (plus a bit of comment rework and some style fixes).

Thanks,

James

---

>From 4bd9ef9789ad86656d8e52e8fff5422b741097e1 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Thu, 25 Apr 2013 08:10:00 +0200
Subject: [PATCH] [SCSI] Handle MLQUEUE busy response in scsi_send_eh_cmnd

scsi_send_eh_cmnd() is calling queuecommand() directly, so
it needs to check the return value here.
The only valid return codes for queuecommand() are 'busy'
states, so we need to wait for a bit to allow the LLDD
to recover.

Based on an earlier patch from Wen Xiong.

[jejb: fix confusion between msec and jiffies values and other issues]
[bvanassche: correct stall_for interval]
Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..f43de1e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -791,32 +792,48 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
 	DECLARE_COMPLETION_ONSTACK(done);
-	unsigned long timeleft;
+	unsigned long timeleft = timeout;
 	struct scsi_eh_save ses;
+	const unsigned long stall_for = msecs_to_jiffies(100);
 	int rtn;
 
+retry:
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
 	shost->eh_action = &done;
 
 	scsi_log_send(scmd);
 	scmd->scsi_done = scsi_eh_done;
-	shost->hostt->queuecommand(shost, scmd);
-
-	timeleft = wait_for_completion_timeout(&done, timeout);
+	rtn = shost->hostt->queuecommand(shost, scmd);
+	if (rtn) {
+		if (timeleft > stall_for) {
+			scsi_eh_restore_cmnd(scmd, &ses);
+			timeleft -= stall_for;
+			msleep(jiffies_to_msecs(stall_for));
+			goto retry;
+		}
+		/* signal not to enter either branch of the if () below */
+		timeleft = 0;
+		rtn = NEEDS_RETRY;
+	} else {
+		timeleft = wait_for_completion_timeout(&done, timeout);
+	}
 
 	shost->eh_action = NULL;
 
-	scsi_log_completion(scmd, SUCCESS);
+	scsi_log_completion(scmd, rtn);
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s: scmd: %p, timeleft: %ld\n",
 			__func__, scmd, timeleft));
 
 	/*
-	 * If there is time left scsi_eh_done got called, and we will
-	 * examine the actual status codes to see whether the command
-	 * actually did complete normally, else tell the host to forget
-	 * about this command.
+	 * If there is time left scsi_eh_done got called, and we will examine
+	 * the actual status codes to see whether the command actually did
+	 * complete normally, else if we have a zero return and no time left,
+	 * the command must still be pending, so abort it and return FAILED.
+	 * If we never actually managed to issue the command, because
+	 * ->queuecommand() kept returning non zero, use the rtn = FAILED
+	 * value above (so don't execute either branch of the if)
 	 */
 	if (timeleft) {
 		rtn = scsi_eh_completed_normally(scmd);
@@ -837,7 +854,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 			rtn = FAILED;
 			break;
 		}
-	} else {
+	} else if (!rtn) {
 		scsi_abort_eh_cmnd(scmd);
 		rtn = FAILED;
 	}

