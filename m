From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 14:14:57 +1100
Message-ID: <1195528497.6970.35.camel@pasglop>
References: <1195501874.6539.5.camel@pasglop>
	 <20071119.143115.251022325.davem@davemloft.net>
	 <1195518864.6970.23.camel@pasglop>
	 <20071119.164611.64664648.davem@davemloft.net>  <ada8x4ty8e1.fsf@cisco.com>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:51355 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXKTDPS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 22:15:18 -0500
In-Reply-To: <ada8x4ty8e1.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

FYI, Here's what I have for the SCSI change. I haven't updated drivers
to care for the new return code though, help appreciated with that as I
don't know much about these drivers.

Index: linux-work/drivers/scsi/scsi_error.c
===================================================================
--- linux-work.orig/drivers/scsi/scsi_error.c	2007-11-20 13:26:18.000000000 +1100
+++ linux-work/drivers/scsi/scsi_error.c	2007-11-20 13:43:05.000000000 +1100
@@ -602,8 +602,9 @@ static void scsi_abort_eh_cmnd(struct sc
  * @cmnd is ignored and this functions sets up a REQUEST_SENSE command
  * and cmnd buffers to read @sense_bytes into @scmd->sense_buffer.
  **/
-void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
-			unsigned char *cmnd, int cmnd_size, unsigned sense_bytes)
+int scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
+		      unsigned char *cmnd, int cmnd_size, unsigned sense_bytes,
+		      gfp_t gfp_mask)
 {
 	struct scsi_device *sdev = scmd->device;
 
@@ -622,12 +623,20 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd 
 	ses->use_sg = scmd->use_sg;
 	ses->resid = scmd->resid;
 	ses->result = scmd->result;
+	sg_init_table(&ses->sense_sgl, 1);
 
 	if (sense_bytes) {
+		struct page *pg;
+
+		if (sdev->host->hostt->unchecked_isa_dma)
+			gfp_mask |= __GFP_DMA;
 		scmd->request_bufflen = min_t(unsigned,
 		                       sizeof(scmd->sense_buffer), sense_bytes);
-		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
-		                                       scmd->request_bufflen);
+		pg = alloc_page(gfp_mask);
+		if (!pg)
+			return FAILED;
+		memset(page_address(pg), 0, scmd->request_bufflen);
+		sg_set_page(&ses->sense_sgl, pg, scmd->request_bufflen, 0);
 		scmd->request_buffer = &ses->sense_sgl;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
 		scmd->use_sg = 1;
@@ -658,6 +667,8 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd 
 	 * untransferred sense data should be interpreted as being zero.
 	 */
 	memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
+
+	return SUCCESS;
 }
 EXPORT_SYMBOL(scsi_eh_prep_cmnd);
 
@@ -670,9 +681,17 @@ EXPORT_SYMBOL(scsi_eh_prep_cmnd);
  **/
 void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 {
+	struct page *pg;
+
 	/*
 	 * Restore original data
 	 */
+	pg = sg_page(&ses->sense_sgl);
+	if (pg) {
+		memcpy(scmd->sense_buffer, page_address(pg),
+		       scmd->request_bufflen);
+		__free_page(pg);
+	}
 	scmd->cmd_len = ses->cmd_len;
 	memcpy(scmd->cmnd, ses->cmnd, sizeof(scmd->cmnd));
 	scmd->sc_data_direction = ses->data_direction;
@@ -709,7 +728,10 @@ static int scsi_send_eh_cmnd(struct scsi
 	struct scsi_eh_save ses;
 	int rtn;
 
-	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
+	if (scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes,
+			      GFP_KERNEL) != SUCCESS)
+		return FAILED;
+
 	shost->eh_action = &done;
 
 	spin_lock_irqsave(shost->host_lock, flags);
Index: linux-work/include/scsi/scsi_eh.h
===================================================================
--- linux-work.orig/include/scsi/scsi_eh.h	2007-11-20 13:36:44.000000000 +1100
+++ linux-work/include/scsi/scsi_eh.h	2007-11-20 13:42:49.000000000 +1100
@@ -81,9 +81,10 @@ struct scsi_eh_save {
 	struct scatterlist sense_sgl;
 };
 
-extern void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
+extern int scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
 		struct scsi_eh_save *ses, unsigned char *cmnd,
-		int cmnd_size, unsigned sense_bytes);
+		int cmnd_size, unsigned sense_bytes,
+		gfp_t gfp_mask);
 
 extern void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd,
 		struct scsi_eh_save *ses);
Index: linux-work/drivers/scsi/NCR5380.c
===================================================================
--- linux-work.orig/drivers/scsi/NCR5380.c	2007-11-20 13:46:41.000000000 +1100
+++ linux-work/drivers/scsi/NCR5380.c	2007-11-20 13:46:47.000000000 +1100
@@ -2283,7 +2283,7 @@ static void NCR5380_information_transfer
 					}
 
 					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
-						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
+						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0, GFP_ATOMIC);
 
 						dprintk(NDEBUG_AUTOSENSE, ("scsi%d : performing request sense\n", instance->host_no));
 
Index: linux-work/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux-work.orig/drivers/scsi/atari_NCR5380.c	2007-11-20 13:46:55.000000000 +1100
+++ linux-work/drivers/scsi/atari_NCR5380.c	2007-11-20 13:47:00.000000000 +1100
@@ -2240,7 +2240,7 @@ static void NCR5380_information_transfer
 
 					if ((cmd->cmnd[0] != REQUEST_SENSE) &&
 					    (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
-						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
+						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0, GFP_ATOMIC);
 
 						ASEN_PRINTK("scsi%d: performing request sense\n", HOSTNO);
 
Index: linux-work/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux-work.orig/drivers/scsi/sun3_NCR5380.c	2007-11-20 13:46:27.000000000 +1100
+++ linux-work/drivers/scsi/sun3_NCR5380.c	2007-11-20 13:46:33.000000000 +1100
@@ -2261,7 +2261,7 @@ static void NCR5380_information_transfer
 
 		    if ((cmd->cmnd[0] != REQUEST_SENSE) && 
 			(status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
-			scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
+			scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0, GFP_ATOMIC);
 			ASEN_PRINTK("scsi%d: performing request sense\n",
 				    HOSTNO);
 			/* this is initialized from initialize_SCp 


