From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer in scsi_cmnd
Date: Fri, 21 Dec 2007 13:30:08 +1100
Message-ID: <20071221023011.4C4BADDDFA@ozlabs.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:35989 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbXLUCaM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 21:30:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org

The sense buffer ins scsi_cmnd can nowadays be DMA'ed into directly
by some low level drivers (that typically happens with USB mass
storage).

This is a problem on non cache coherent architectures such as
embedded PowerPCs where the sense buffer can share cache lines with
other structure members, which leads to various forms of corruption.

This uses the newly defined __dma_buffer annotation to enforce that
on such platforms, the sense_buffer is contained within its own
cache line. This has no effect on cache coherent architectures.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 include/scsi/scsi_cmnd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-merge.orig/include/scsi/scsi_cmnd.h	2007-12-21 13:07:14.000000000 +1100
+++ linux-merge/include/scsi/scsi_cmnd.h	2007-12-21 13:07:29.000000000 +1100
@@ -88,7 +88,7 @@ struct scsi_cmnd {
 				   	   working on */
 
 #define SCSI_SENSE_BUFFERSIZE 	96
-	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
+	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE] __dma_buffer;
 				/* obtained by REQUEST SENSE when
 				 * CHECK CONDITION is received on original
 				 * command (auto-sense) */
