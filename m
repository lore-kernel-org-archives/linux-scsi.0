From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Fri, 3 May 2013 18:23:22 +0000
Message-ID: <1367605401.5981.45.camel@dabdike>
References: <1366870200-6492-1-git-send-email-hare@suse.de>
	 <20130503102400.Horde.TQF1IJir309Rg8iARNPkSKA@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:36940 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3ECSX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 May 2013 14:23:27 -0400
In-Reply-To: <20130503102400.Horde.TQF1IJir309Rg8iARNPkSKA@imap.linux.ibm.com>
Content-Language: en-US
Content-ID: <1386F6F301BB1A49855755364871F436@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

On Fri, 2013-05-03 at 10:24 -0400, wenxiong@linux.vnet.ibm.com wrote:
> Quoting Hannes Reinecke <hare@suse.de>:
> 
> > scsi_send_eh_cmnd() is calling queuecommand() directly, so
> > it needs to check the return value here.
> > The only valid return codes for queuecommand() are 'busy'
> > states, so we need to wait for a bit to allow the LLDD
> > to recover.
> >
> > Based on an earlier patch from Wen Xiong.
> >
> > Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> > Cc: Brian King <brking@linux.vnet.ibm.com>
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> >
> Hi James,
> 
> I have verified this patch with two new ipr adapters. EEH error can be  
> recoery successfully.
> Do you have any question about this new patch?

Yes, it's not correct: stall_for is in jiffies not msec, so
msleep(stall_for) is taking far too long.  Plus you don't know that
stall_for is a divisor of timeleft, so timeleft -= stall_for could wrap
and cause the retry loop to go on effectively forever.

I think the below is the correct patch, so I'll commit it unless there
are objections.

James

---
>From a74498dda7acf6f5fb99e43df54f2c1f5c6beec9 Mon Sep 17 00:00:00 2001
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
Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..cfd1ef2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -791,22 +792,33 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
 	DECLARE_COMPLETION_ONSTACK(done);
-	unsigned long timeleft;
+	unsigned long timeleft = timeout;
 	struct scsi_eh_save ses;
+	const unsigned long stall_for = min(msecs_to_jiffies(10), 1UL);
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
+		timeleft = 0;
+		rtn = NEEDS_RETRY;
+	} else
+		timeleft = wait_for_completion_timeout(&done, timeout);
 
 	shost->eh_action = NULL;
 
-	scsi_log_completion(scmd, SUCCESS);
+	scsi_log_completion(scmd, rtn);
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s: scmd: %p, timeleft: %ld\n",
@@ -837,7 +849,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 			rtn = FAILED;
 			break;
 		}
-	} else {
+	} else if (!rtn) {
 		scsi_abort_eh_cmnd(scmd);
 		rtn = FAILED;
 	}

