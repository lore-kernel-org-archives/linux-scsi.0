From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Deadlock in usb-storage error handling
Date: Thu, 20 Mar 2014 11:22:58 -0700
Message-ID: <1395339778.2244.41.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1403201233150.858-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41119 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933560AbaCTSXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2014 14:23:02 -0400
In-Reply-To: <Pine.LNX.4.44L0.1403201233150.858-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andreas Reis <andreas.reis@gmail.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2014-03-20 at 12:34 -0400, Alan Stern wrote:
> On Thu, 20 Mar 2014, James Bottomley wrote:
> 
> > OK, so I think we have three things to do
> > 
> >      1. Investigate SCSI and fix it's abort state problem that's causing
> >         it not to send the abort second time around
> >      2. Fix usb-storage to fail a reset it can't do (i.e. device reset
> >         with outstanding commands)
> >      3. Find out why we're sending a spurious request sense.
> > 
> > I can look at 1 and 3 if you want to take 2.
> 
> It's a deal!  Thanks for your help.

And this looks to be 3: a bug in the way we attach sense data to
commands (we shouldn't look for attached sense if the device error code
didn't imply there would be any).

James

---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 771c16b..d020149 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1157,6 +1157,15 @@ int scsi_eh_get_sense(struct list_head *work_q,
 					     __func__));
 			break;
 		}
+		if (status_byte(scmd->result) != CHECK_CONDITION)
+			/*
+			 * don't request sense if there's no check condition
+			 * status because the error we're processing isn't one
+			 * that has a sense code (and some devices get
+			 * confused by sense requests out of the blue)
+			 */
+			continue;
+
 		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
 						  "%s: requesting sense\n",
 						  current->comm));



