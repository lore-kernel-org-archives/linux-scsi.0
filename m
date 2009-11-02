From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Mon, 02 Nov 2009 11:45:57 -0600
Message-ID: <1257183957.2472.156.camel@mulgrave.site>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E9134556F@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39979 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059AbZKBRqD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2009 12:46:03 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E9134556F@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

On Mon, 2009-11-02 at 13:05 +0530, Penchala Narasimha Reddy Chilakala,
TLS-Chennai wrote:
> Please let me know your opinion on the explanation given by me in the
> previous e-mail to the issue raised by you so that I will proceed
> further based on your feedback as lot of IBM customers and RedHat have
> been waiting for this patch to come in linux-scsi upstream even though
> we have given private build to some of the IBM customers like Cisco
> and SAP?

I need the warning fixed.

How about this as the fix suggestion on top of your original patch:

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index d29af45..1712ebe 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -535,11 +535,11 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 				}
 				udelay(5);
 			}
-		} else
-			down_interruptible(&fibptr->event_wait);
-
+		} else if (down_interruptible(&fibptr->event_wait)) {
+			fibptr->done = 2;
+		}
 		spin_lock_irqsave(&fibptr->event_lock, flags);
-		if (fibptr->done == 0) {
+		if ((fibptr->done == 0) || (fibptr->done == 2)) {
 			fibptr->done = 2; /* Tell interrupt we aborted */
 			spin_unlock_irqrestore(&fibptr->event_lock, flags);
 			return -ERESTARTSYS;

It preserves the original code, even though setting fibptr->done to 2 is
a bit superfluous, it makes it much more obvious to someone looking at
the diff what the actual fix is.

James


