From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Need help with another aic94xx sequencer problem
Date: Sun, 27 Aug 2006 22:26:39 -0500
Message-ID: <1156735599.3460.29.camel@mulgrave.il.steeleye.com>
References: <20060824085841.27630.qmail@web31810.mail.mud.yahoo.com>
	 <1156429369.1024.14.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45448 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932309AbWH1D0t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Aug 2006 23:26:49 -0400
In-Reply-To: <1156429369.1024.14.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>, "Hammer, Jack" <Jack_Hammer@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2006-08-24 at 09:22 -0500, James Bottomley wrote:
> On Thu, 2006-08-24 at 01:58 -0700, Luben Tuikov wrote:
> > The sequencer response is correct but incomplete.  The interpretation
> > is a bad compromize between SSP and STP.
> > 
> > TF_TMF_NO_CTX should be interpreted as TMF_RESP_FUNC_ESUPP to get
> > "best of both worlds", and then upper layers would do the proper
> > thing depending on the protocol.
> 
> OK ... I can do that easily; that should cause the error handler to try
> with a bigger hammer.

So, let's try this as the first order fix.

James

Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_tmf.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_tmf.c	2006-08-26 09:35:05.000000000 -0500
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_tmf.c	2006-08-26 09:37:54.000000000 -0500
@@ -462,13 +462,15 @@ int asd_abort_task(struct sas_task *task
 		if (task->task_state_flags & SAS_TASK_STATE_DONE)
 			res = TMF_RESP_FUNC_COMPLETE;
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		goto out_done; break;
+		goto out_done;
 	case TF_TMF_NO_TAG + 0xFF00:
 	case TF_TMF_TAG_FREE + 0xFF00: /* the tag is in the free list */
-	case TF_TMF_NO_CTX + 0xFF00: /* not in seq, or proto != SSP */
 	case TF_TMF_NO_CONN_HANDLE + 0xFF00: /* no such device */
 		res = TMF_RESP_FUNC_COMPLETE;
-		goto out_done; break;
+		goto out_done;
+	case TF_TMF_NO_CTX + 0xFF00: /* not in seq, or proto != SSP */
+		res = TMF_RESP_FUNC_ESUPP;
+		goto out;
 	}
 out_done:
 	if (res == TMF_RESP_FUNC_COMPLETE) {
@@ -558,10 +560,12 @@ static int asd_initiate_ssp_tmf(struct d
 		break;
 	case TF_TMF_NO_TAG + 0xFF00:
 	case TF_TMF_TAG_FREE + 0xFF00: /* the tag is in the free list */
-	case TF_TMF_NO_CTX + 0xFF00: /* not in seq, or proto != SSP */
 	case TF_TMF_NO_CONN_HANDLE + 0xFF00: /* no such device */
 		res = TMF_RESP_FUNC_COMPLETE;
 		break;
+	case TF_TMF_NO_CTX + 0xFF00: /* not in seq, or proto != SSP */
+		res = TMF_RESP_FUNC_ESUPP;
+		break;
 	default:
 		ASD_DPRINTK("%s: converting result 0x%x to TMF_RESP_FUNC_FAILED\n",
 			    __FUNCTION__, res);


