From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] lk 2.4.27 error handling, ad infinitum
Date: Fri, 03 Sep 2004 10:06:17 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4137B579.1050806@torque.net>
References: <4136EE87.2080409@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060207080902080708020701"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:29075 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S269397AbUICAHw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2004 20:07:52 -0400
In-Reply-To: <4136EE87.2080409@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Saeed.Bishara@il.marvell.com, marcelo.tosatti@cyclades.com

This is a multi-part message in MIME format.
--------------060207080902080708020701
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> dougg wrote:
>  > The following scenario has been brought to my attention.
>  >
>  > While handling a error (e.g. a timeout) the
>  > scsi_send_eh_cmnd() function issues a (stalled) queued command.
>  > Now that command hits a repeatable failure (e.g. MEDIUM ERROR).
>  >
>  > In this scaenario it would seem that the "goto retry" forms
>  > an infinite loop re-issuing that command on the same (broken)
>  > block.
>  >
>  > Comments?
> 
> No comments, so how about this patch. When the eh retries are
> exhausted the code drops through to FAILED state. If a command
> in foreground (i.e. not sent by the eh handler) exceeds it retries
> then SUCCESS is returned??

Saeed reports that breaking out of the retry loop with
eh_state set to SUCCESS does successfully handle the
problem.

Change:
    - break out of a repeatable error retries when already
      in "eh" (error handling) mode

Doug Gilbert


--------------060207080902080708020701
Content-Type: text/x-patch;
 name="scsi_error2427_retry2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_error2427_retry2.diff"

--- linux/drivers/scsi/scsi_error.c	2004-04-17 19:30:54.000000000 +1000
+++ linux/drivers/scsi/scsi_error.c2427retry2	2004-09-03 09:47:27.174358136 +1000
@@ -664,7 +664,10 @@
 			SCpnt->eh_state = SUCCESS;
 			break;
 		case NEEDS_RETRY:
-			goto retry;
+			if ((++SCpnt->retries) < SCpnt->allowed)
+				goto retry;
+			SCpnt->eh_state = SUCCESS;
+			break;
 		case FAILED:
 		default:
 			SCpnt->eh_state = FAILED;

--------------060207080902080708020701--

