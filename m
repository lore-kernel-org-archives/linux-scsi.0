From: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Subject: Re: [PATCH] lk 2.4.27 error handling, ad infinitum
Date: Thu, 02 Sep 2004 14:44:23 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41370797.1020403@il.marvell.com>
References: <4136EE87.2080409@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shosh.galileo.co.il ([199.203.130.250]:58677 "EHLO
	il.marvell.com") by vger.kernel.org with ESMTP id S268263AbUIBLoh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Sep 2004 07:44:37 -0400
In-Reply-To: <4136EE87.2080409@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI development list <linux-scsi@vger.kernel.org>

falling into FAILED status will put the device in offline state, isn't it?
saeed

Douglas Gilbert wrote:

> dougg wrote:
> > The following scenario has been brought to my attention.
> >
> > While handling a error (e.g. a timeout) the
> > scsi_send_eh_cmnd() function issues a (stalled) queued command.
> > Now that command hits a repeatable failure (e.g. MEDIUM ERROR).
> >
> > In this scaenario it would seem that the "goto retry" forms
> > an infinite loop re-issuing that command on the same (broken)
> > block.
> >
> > Comments?
>
> No comments, so how about this patch. When the eh retries are
> exhausted the code drops through to FAILED state. If a command
> in foreground (i.e. not sent by the eh handler) exceeds it retries
> then SUCCESS is returned??
>
> Doug Gilbert
>
>------------------------------------------------------------------------
>
>--- linux/drivers/scsi/scsi_error.c	2004-04-17 19:30:54.000000000 +1000
>+++ linux/drivers/scsi/scsi_error.c2427retry	2004-09-02 19:45:07.858674640 +1000
>@@ -664,7 +664,9 @@
> 			SCpnt->eh_state = SUCCESS;
> 			break;
> 		case NEEDS_RETRY:
>-			goto retry;
>+			if ((++SCpnt->retries) < SCpnt->allowed)
>+				goto retry;
>+			/* fall through to FAILED if retries exceeded */
> 		case FAILED:
> 		default:
> 			SCpnt->eh_state = FAILED;
>  
>


