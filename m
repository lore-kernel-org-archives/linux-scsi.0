From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] scsi/pcmcia/nsp_cs: time_out reaches -1
Date: Wed, 25 Feb 2009 14:34:06 +0100
Message-ID: <49A548CE.1040803@gmail.com>
References: <499948C3.2000500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:10548 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZBYNeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2009 08:34:09 -0500
Received: by qw-out-2122.google.com with SMTP id 5so35188qwi.37
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2009 05:34:06 -0800 (PST)
In-Reply-To: <499948C3.2000500@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yokota@netlab.is.tsukuba.ac.jp, James.Bottomley@HansenPartnership.com
Cc: linux-pcmcia@lists.infradead.org, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

I sent the first in a previous patch, but didn't notice the other issues
below initially. (should I make a delta patch? and how do you do that?)
--------------------------->8-------------8<------------------------------
With a postfix decrement timeouts will reach -1 rather than 0, so the
errors do not appear.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 11a61ea..70b60ad 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -530,7 +530,7 @@ static int nsp_negate_signal(struct scsi_cmnd *SCpnt, unsigned char mask,
 		if (reg == 0xff) {
 			break;
 		}
-	} while ((time_out-- != 0) && (reg & mask) != 0);
+	} while ((--time_out != 0) && (reg & mask) != 0);
 
 	if (time_out == 0) {
 		nsp_msg(KERN_DEBUG, " %s signal off timeut", str);
@@ -801,7 +801,7 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
 
 	data->FifoCount = ocount;
 
-	if (time_out == 0) {
+	if (time_out < 0) {
 		nsp_msg(KERN_DEBUG, "pio read timeout resid=%d this_residual=%d buffers_residual=%d",
 			scsi_get_resid(SCpnt), SCpnt->SCp.this_residual,
 			SCpnt->SCp.buffers_residual);
@@ -897,7 +897,7 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 
 	data->FifoCount = ocount;
 
-	if (time_out == 0) {
+	if (time_out < 0) {
 		nsp_msg(KERN_DEBUG, "pio write timeout resid=0x%x",
 		                                        scsi_get_resid(SCpnt));
 	}
