From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill qlogicpti inquiry sniffing
Date: Sat, 12 Nov 2005 10:12:51 +0100
Message-ID: <20051112091251.GA15402@lst.de>
References: <20051017120229.GA5834@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051017120229.GA5834@lst.de>
Sender: sparclinux-owner@vger.kernel.org
To: jejb@steeleye.com, davem@davemloft.net, tcallawa@redhat.com
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 17, 2005 at 02:02:29PM +0200, Christoph Hellwig wrote:
> Inquiry sniffing is a really bad idea, and sneaking a patch in without
> talking to the scsi maintainers doesn't make it any better ;-)
> 
> Could one of the sparc people please test the patch below to kill it?

ping?


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/qlogicpti.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qlogicpti.c	2005-10-17 13:53:19.000000000 +0200
+++ linux-2.6/drivers/scsi/qlogicpti.c	2005-10-17 13:55:07.000000000 +0200
@@ -312,8 +312,6 @@
 		}
 		qpti->dev_param[i].device_enable = 1;
 	}
-	/* this is very important to set! */
-	qpti->sbits = 1 << qpti->scsi_id;
 }
 
 static int qlogicpti_reset_hardware(struct Scsi_Host *host)
@@ -1119,155 +1117,6 @@
 	host->sg_tablesize = QLOGICPTI_MAX_SG(num_free);
 }
 
-static unsigned int scsi_rbuf_get(struct scsi_cmnd *cmd, unsigned char **buf_out)
-{
-	unsigned char *buf;
-	unsigned int buflen;
-
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
-
-		sg = (struct scatterlist *) cmd->request_buffer;
-		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
-		buflen = sg->length;
-	} else {
-		buf = cmd->request_buffer;
-		buflen = cmd->request_bufflen;
-	}
-
-	*buf_out = buf;
-	return buflen;
-}
-
-static void scsi_rbuf_put(struct scsi_cmnd *cmd, unsigned char *buf)
-{
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
-
-		sg = (struct scatterlist *) cmd->request_buffer;
-		kunmap_atomic(buf - sg->offset, KM_IRQ0);
-	}
-}
-
-/*
- * Until we scan the entire bus with inquiries, go throught this fella...
- */
-static void ourdone(struct scsi_cmnd *Cmnd)
-{
-	struct qlogicpti *qpti = (struct qlogicpti *) Cmnd->device->host->hostdata;
-	int tgt = Cmnd->device->id;
-	void (*done) (struct scsi_cmnd *);
-
-	/* This grot added by DaveM, blame him for ugliness.
-	 * The issue is that in the 2.3.x driver we use the
-	 * host_scribble portion of the scsi command as a
-	 * completion linked list at interrupt service time,
-	 * so we have to store the done function pointer elsewhere.
-	 */
-	done = (void (*)(struct scsi_cmnd *))
-		(((unsigned long) Cmnd->SCp.Message)
-#ifdef __sparc_v9__
-		 | ((unsigned long) Cmnd->SCp.Status << 32UL)
-#endif
-		 );
-
-	if ((qpti->sbits & (1 << tgt)) == 0) {
-		int ok = host_byte(Cmnd->result) == DID_OK;
-		if (Cmnd->cmnd[0] == 0x12 && ok) {
-			unsigned char *iqd;
-			unsigned int iqd_len;
-
-			iqd_len = scsi_rbuf_get(Cmnd, &iqd);
-
-			/* tags handled in midlayer */
-			/* enable sync mode? */
-			if (iqd[7] & 0x10) {
-				qpti->dev_param[tgt].device_flags |= 0x10;
-			} else {
-				qpti->dev_param[tgt].synchronous_offset = 0;
-				qpti->dev_param[tgt].synchronous_period = 0;
-			}
-			/* are we wide capable? */
-			if (iqd[7] & 0x20) {
-				qpti->dev_param[tgt].device_flags |= 0x20;
-			}
-
-			scsi_rbuf_put(Cmnd, iqd);
-
-			qpti->sbits |= (1 << tgt);
-		} else if (!ok) {
-			qpti->sbits |= (1 << tgt);
-		}
-	}
-	done(Cmnd);
-}
-
-static int qlogicpti_queuecommand(struct scsi_cmnd *Cmnd, void (*done)(struct scsi_cmnd *));
-
-static int qlogicpti_queuecommand_slow(struct scsi_cmnd *Cmnd,
-				       void (*done)(struct scsi_cmnd *))
-{
-	struct qlogicpti *qpti = (struct qlogicpti *) Cmnd->device->host->hostdata;
-
-	/*
-	 * done checking this host adapter?
-	 * If not, then rewrite the command
-	 * to finish through ourdone so we
-	 * can peek at Inquiry data results.
-	 */
-	if (qpti->sbits && qpti->sbits != 0xffff) {
-		/* See above about in ourdone this ugliness... */
-		Cmnd->SCp.Message = ((unsigned long)done) & 0xffffffff;
-#ifdef CONFIG_SPARC64
-		Cmnd->SCp.Status = ((unsigned long)done >> 32UL) & 0xffffffff;
-#endif
-		return qlogicpti_queuecommand(Cmnd, ourdone);
-	}
-
-	/*
-	 * We've peeked at all targets for this bus- time
-	 * to set parameters for devices for real now.
-	 */
-	if (qpti->sbits == 0xffff) {
-		int i;
-		for(i = 0; i < MAX_TARGETS; i++) {
-			u_short param[6];
-			param[0] = MBOX_SET_TARGET_PARAMS;
-			param[1] = (i << 8);
-			param[2] = (qpti->dev_param[i].device_flags << 8);
-			if (qpti->dev_param[i].device_flags & 0x10) {
-				param[3] = (qpti->dev_param[i].synchronous_offset << 8) |
-					qpti->dev_param[i].synchronous_period;
-			} else {
-				param[3] = 0;
-			}
-			(void) qlogicpti_mbox_command(qpti, param, 0);
-		}
-		/*
-		 * set to zero so any traverse through ourdone
-		 * doesn't start the whole process again,
-		 */
-		qpti->sbits = 0;
-	}
-
-	/* check to see if we're done with all adapters... */
-	for (qpti = qptichain; qpti != NULL; qpti = qpti->next) {
-		if (qpti->sbits) {
-			break;
-		}
-	}
-
-	/*
-	 * if we hit the end of the chain w/o finding adapters still
-	 * capability-configuring, then we're done with all adapters
-	 * and can rock on..
-	 */
-	if (qpti == NULL)
-		Cmnd->device->host->hostt->queuecommand = qlogicpti_queuecommand;
-
-	return qlogicpti_queuecommand(Cmnd, done);
-}
-
 /*
  * The middle SCSI layer ensures that queuecommand never gets invoked
  * concurrently with itself or the interrupt handler (though the
@@ -1551,11 +1400,46 @@
 	return return_status;
 }
 
+static int qlogicpti_slave_configure(struct scsi_device *sdev)
+{
+	struct qlogicpti *qpti = (struct qlogicpti *) sdev->host->hostdata;
+	int tgt = sdev->id;
+	u_short param[6];
+
+	/* enable sync mode? */
+	if (sdev->sdtr) {
+		qpti->dev_param[tgt].device_flags |= 0x10;
+	} else {
+		qpti->dev_param[tgt].synchronous_offset = 0;
+		qpti->dev_param[tgt].synchronous_period = 0;
+	}
+
+	/* are we wide capable? */
+	/* XXX(hch): 0x60 aka sdev->wdtr means wide capable */
+	if (sdev->inquiry[7] & 0x20)
+		qpti->dev_param[tgt].device_flags |= 0x20;
+
+	param[0] = MBOX_SET_TARGET_PARAMS;
+	param[1] = (tgt << 8);
+	param[2] = (qpti->dev_param[tgt].device_flags << 8);
+
+	if (qpti->dev_param[tgt].device_flags & 0x10) {
+		param[3] = (qpti->dev_param[tgt].synchronous_offset << 8) |
+			    qpti->dev_param[tgt].synchronous_period;
+	} else {
+		param[3] = 0;
+	}
+
+	qlogicpti_mbox_command(qpti, param, 0);
+	return 0;
+}
+
 static struct scsi_host_template driver_template = {
 	.detect			= qlogicpti_detect,
 	.release		= qlogicpti_release,
 	.info			= qlogicpti_info,
-	.queuecommand		= qlogicpti_queuecommand_slow,
+	.slave_configure	= qlogicpti_slave_configure,
+	.queuecommand		= qlogicpti_queuecommand,
 	.eh_abort_handler	= qlogicpti_abort,
 	.eh_bus_reset_handler	= qlogicpti_reset,
 	.can_queue		= QLOGICPTI_REQ_QUEUE_LEN,
Index: linux-2.6/drivers/scsi/qlogicpti.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qlogicpti.h	2005-10-17 13:52:34.000000000 +0200
+++ linux-2.6/drivers/scsi/qlogicpti.h	2005-10-17 13:53:43.000000000 +0200
@@ -379,9 +379,7 @@
 #define SREG_SPMASK               0x03   /* Mask for switch pack       */
 	unsigned char             swsreg;
 	unsigned int	
-		gotirq	:	1,	/* this instance got an irq */
-		is_pti	: 	1,	/* Non-zero if this is a PTI board. */
-		sbits	:	16;	/* syncmode known bits */
+		is_pti	: 	1;	/* Non-zero if this is a PTI board. */
 };
 
 /* How to twiddle them bits... */
