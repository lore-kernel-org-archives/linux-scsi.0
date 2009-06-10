From: akpm@linux-foundation.org
Subject: [patch 7/7] scsi/pcmcia/nsp_cs: time_out reaches -1
Date: Wed, 10 Jun 2009 12:56:59 -0700
Message-ID: <200906101956.n5AJuxAb009936@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761671AbZFJT5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 15:57:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com

From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement timeouts will reach -1 rather than 0, so the
errors do not appear.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pcmcia/nsp_cs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/pcmcia/nsp_cs.c~scsi-pcmcia-nsp_cs-time_out-reaches-1 drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c~scsi-pcmcia-nsp_cs-time_out-reaches-1
+++ a/drivers/scsi/pcmcia/nsp_cs.c
@@ -530,7 +530,7 @@ static int nsp_negate_signal(struct scsi
 		if (reg == 0xff) {
 			break;
 		}
-	} while ((time_out-- != 0) && (reg & mask) != 0);
+	} while ((--time_out != 0) && (reg & mask) != 0);
 
 	if (time_out == 0) {
 		nsp_msg(KERN_DEBUG, " %s signal off timeut", str);
@@ -801,7 +801,7 @@ static void nsp_pio_read(struct scsi_cmn
 
 	data->FifoCount = ocount;
 
-	if (time_out == 0) {
+	if (time_out < 0) {
 		nsp_msg(KERN_DEBUG, "pio read timeout resid=%d this_residual=%d buffers_residual=%d",
 			scsi_get_resid(SCpnt), SCpnt->SCp.this_residual,
 			SCpnt->SCp.buffers_residual);
@@ -897,7 +897,7 @@ static void nsp_pio_write(struct scsi_cm
 
 	data->FifoCount = ocount;
 
-	if (time_out == 0) {
+	if (time_out < 0) {
 		nsp_msg(KERN_DEBUG, "pio write timeout resid=0x%x",
 		                                        scsi_get_resid(SCpnt));
 	}
_
