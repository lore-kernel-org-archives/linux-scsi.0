From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 1/2] SCSI tape: fix buffer position in partial write
Date: Sun, 4 May 2008 22:28:58 +0300 (EEST)
Message-ID: <alpine.LSU.1.10.0805042228200.5805@kai.makisara.local>
References: <alpine.LSU.1.10.0805042211490.5805@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:41722 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbYEDT3M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 15:29:12 -0400
In-Reply-To: <alpine.LSU.1.10.0805042211490.5805@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Mike Christie noticed a bogus memset. It can be removed as dead code since the
number of bytes in the driver buffer in fixed block mode is always a multiple
of the tape block size.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
---
The patch is against 2.6.26-rc1.

 drivers/scsi/st.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6.26-rc1-q/drivers/scsi/st.c
===================================================================
--- linux-2.6.26-rc1-q.orig/drivers/scsi/st.c
+++ linux-2.6.26-rc1-q/drivers/scsi/st.c
@@ -630,7 +630,7 @@ static int cross_eof(struct scsi_tape * 
 /* Flush the write buffer (never need to write if variable blocksize). */
 static int st_flush_write_buffer(struct scsi_tape * STp)
 {
-	int offset, transfer, blks;
+	int transfer, blks;
 	int result;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_request *SRpnt;
@@ -643,14 +643,10 @@ static int st_flush_write_buffer(struct 
 	result = 0;
 	if (STp->dirty == 1) {
 
-		offset = (STp->buffer)->buffer_bytes;
-		transfer = ((offset + STp->block_size - 1) /
-			    STp->block_size) * STp->block_size;
+		transfer = STp->buffer->buffer_bytes;
                 DEBC(printk(ST_DEB_MSG "%s: Flushing %d bytes.\n",
                                tape_name(STp), transfer));
 
-		memset((STp->buffer)->b_data + offset, 0, transfer - offset);
-
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = WRITE_6;
 		cmd[1] = 1;
