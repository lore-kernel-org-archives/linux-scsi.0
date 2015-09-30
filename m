From: Christoph Hellwig <hch@infradead.org>
Subject: Re: twa generates WARNING upon boot
Date: Wed, 30 Sep 2015 09:08:35 -0700
Message-ID: <20150930160835.GA16534@infradead.org>
References: <68ee66bf9581d10b0ab813e5006869ec.squirrel@atoth.sote.hu>
 <CAHtARFHdFOVHZ2_-JT9_nvRZmbF+cffRrtaaE4DSZSrJwU6BCA@mail.gmail.com>
 <d8e4bcdc939f0926a63f5c4a35fb8e0c.squirrel@atoth.sote.hu>
 <1443548266.2207.19.camel@HansenPartnership.com>
 <1443549768.2207.22.camel@HansenPartnership.com>
 <95d34bcc4c0fcf84d02d76a4443ba07c.squirrel@atoth.sote.hu>
 <1443551581.2207.26.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbI3QIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 12:08:47 -0400
Content-Disposition: inline
In-Reply-To: <1443551581.2207.26.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "\"T?th Attila\"" <atoth@atoth.sote.hu>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi all,

I'd like to propose the following patch intead.  It uses a helper
to check the conditions for the copied commands, and also fixes another
place to use it which uses a different and I think buggy check:

This avoids the usage of scsi_cmnd.SCp which I'd like to get rid of
mid-term.

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index add419d..74eac90 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -212,6 +212,17 @@ static const struct file_operations twa_fops = {
 	.llseek		= noop_llseek,
 };
 
+/*
+ * The controllers use an inline buffer instead of a mapped SGL for small,
+ * single entry buffers.  Note that we treat a zero-length transfer like
+ * a mapped SGL.
+ */
+static bool twa_command_mapped(struct scsi_cmnd *cmd)
+{
+	return scsi_sg_count(cmd) != 1 ||
+		scsi_bufflen(cmd) >= TW_MIN_SGL_LENGTH;
+}
+
 /* This function will complete an aen request from the isr */
 static int twa_aen_complete(TW_Device_Extension *tw_dev, int request_id)
 {
@@ -1339,7 +1350,8 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 				}
 
 				/* Now complete the io */
-				scsi_dma_unmap(cmd);
+				if (twa_command_mapped(cmd))
+					scsi_dma_unmap(cmd);
 				cmd->scsi_done(cmd);
 				tw_dev->state[request_id] = TW_S_COMPLETED;
 				twa_free_request_id(tw_dev, request_id);
@@ -1582,7 +1594,8 @@ static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
 				struct scsi_cmnd *cmd = tw_dev->srb[i];
 
 				cmd->result = (DID_RESET << 16);
-				scsi_dma_unmap(cmd);
+				if (twa_command_mapped(cmd))
+					scsi_dma_unmap(cmd);
 				cmd->scsi_done(cmd);
 			}
 		}
@@ -1765,12 +1778,14 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 	retval = twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL);
 	switch (retval) {
 	case SCSI_MLQUEUE_HOST_BUSY:
-		scsi_dma_unmap(SCpnt);
+		if (twa_command_mapped(cmd))
+			scsi_dma_unmap(SCpnt);
 		twa_free_request_id(tw_dev, request_id);
 		break;
 	case 1:
 		SCpnt->result = (DID_ERROR << 16);
-		scsi_dma_unmap(SCpnt);
+		if (twa_command_mapped(cmd))
+			scsi_dma_unmap(SCpnt);
 		done(SCpnt);
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		twa_free_request_id(tw_dev, request_id);
@@ -1831,8 +1846,7 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 		/* Map sglist from scsi layer to cmd packet */
 
 		if (scsi_sg_count(srb)) {
-			if ((scsi_sg_count(srb) == 1) &&
-			    (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH)) {
+			if (!twa_command_mapped(srb)) {
 				if (srb->sc_data_direction == DMA_TO_DEVICE ||
 				    srb->sc_data_direction == DMA_BIDIRECTIONAL)
 					scsi_sg_copy_to_buffer(srb,
@@ -1905,7 +1919,7 @@ static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
 {
 	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
 
-	if (scsi_bufflen(cmd) < TW_MIN_SGL_LENGTH &&
+	if (!twa_command_mapped(srb) &&
 	    (cmd->sc_data_direction == DMA_FROM_DEVICE ||
 	     cmd->sc_data_direction == DMA_BIDIRECTIONAL)) {
 		if (scsi_sg_count(cmd) == 1) {
