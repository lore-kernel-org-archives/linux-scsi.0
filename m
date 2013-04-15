From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/1] scsi: Handle MLQUEUE busy response in
 scsi_send_eh_cmnd
Date: Mon, 15 Apr 2013 15:33:23 -0700
Message-ID: <1366065203.7609.18.camel@dabdike>
References: <20130415183949.678757952@linux.vnet.ibm.com>
	 <1366058730.7609.8.camel@dabdike> <516C7765.8020801@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55525 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756521Ab3DOWd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Apr 2013 18:33:26 -0400
In-Reply-To: <516C7765.8020801@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: wenxiong@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Mon, 2013-04-15 at 16:55 -0500, Brian King wrote:
> On 04/15/2013 03:45 PM, James Bottomley wrote:
> > On Mon, 2013-04-15 at 13:39 -0500, wenxiong@linux.vnet.ibm.com wrote:
> >> In scsi_send_eh_cmnd(), this fix will check the return code of queuecomamnd
> >> when sending commands and retry for a bit if the driver returns a
> >> busy response.
> > 
> > This is already handled by the timeout, I think.  If a driver
> > continuously returns MLQUEUE BUSY, then we'll fail the request after the
> > timeout on the command expires.
> 
> If we get a timeout in scsi_send_eh_cmnd we call scsi_abort_eh_cmnd. If the
> abort works, we return FAILED out of scsi_send_eh_cmnd, which results in
> no retry being performed, since scsi_eh_tur only retries once and
> only if NEEDS_RETRY is returned. Or am I missing something?

Sorry, I'm not being clear.  It comes with being at a conference.  What
I mean is that if you do this, the criterion for success or failure
should be the amount of time left not the number of retries.  This is
what the non-eh submission path also does for retries of events that
don't count against the retry limit ... so something like this patch
(uncompiled and untested #include stddisclaimer.h)

James

----
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..93ab4f4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -793,6 +793,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	DECLARE_COMPLETION_ONSTACK(done);
 	unsigned long timeleft;
 	struct scsi_eh_save ses;
+	const int stall_for = min(HZ/10,1); /* 100 ms */
 	int rtn;
 
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
@@ -802,6 +803,8 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	scmd->scsi_done = scsi_eh_done;
 	shost->hostt->queuecommand(shost, scmd);
 
+  retry:
+
 	timeleft = wait_for_completion_timeout(&done, timeout);
 
 	shost->eh_action = NULL;
@@ -831,8 +834,12 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 		case TARGET_ERROR:
 			break;
 		case ADD_TO_MLQUEUE:
-			rtn = NEEDS_RETRY;
-			break;
+			if (timeleft > stall_for) {
+				timeout = timeleft - stall_for;
+				msleep(stall_for);
+				goto retry;
+			}
+			/* fall through */
 		default:
 			rtn = FAILED;
 			break;



