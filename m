From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] lk 2.4.27 error handling, ad infinitum
Date: Thu, 02 Sep 2004 19:57:27 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4136EE87.2080409@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040703080107000303090605"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:48774 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268128AbUIBJ6P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2004 05:58:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Saeed.Bishara@il.marvell.com

This is a multi-part message in MIME format.
--------------040703080107000303090605
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

dougg wrote:
 > The following scenario has been brought to my attention.
 >
 > While handling a error (e.g. a timeout) the
 > scsi_send_eh_cmnd() function issues a (stalled) queued command.
 > Now that command hits a repeatable failure (e.g. MEDIUM ERROR).
 >
 > In this scaenario it would seem that the "goto retry" forms
 > an infinite loop re-issuing that command on the same (broken)
 > block.
 >
 > Comments?

No comments, so how about this patch. When the eh retries are
exhausted the code drops through to FAILED state. If a command
in foreground (i.e. not sent by the eh handler) exceeds it retries
then SUCCESS is returned??

Doug Gilbert

--------------040703080107000303090605
Content-Type: text/x-patch;
 name="scsi_error2427_retry.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_error2427_retry.diff"

--- linux/drivers/scsi/scsi_error.c	2004-04-17 19:30:54.000000000 +1000
+++ linux/drivers/scsi/scsi_error.c2427retry	2004-09-02 19:45:07.858674640 +1000
@@ -664,7 +664,9 @@
 			SCpnt->eh_state = SUCCESS;
 			break;
 		case NEEDS_RETRY:
-			goto retry;
+			if ((++SCpnt->retries) < SCpnt->allowed)
+				goto retry;
+			/* fall through to FAILED if retries exceeded */
 		case FAILED:
 		default:
 			SCpnt->eh_state = FAILED;

--------------040703080107000303090605--
