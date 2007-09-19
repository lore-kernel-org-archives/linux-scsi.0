From: Matthew Wilcox <matthew@wil.cx>
Subject: slave_configure for qlogicpti
Date: Wed, 19 Sep 2007 06:46:37 -0600
Message-ID: <20070919124637.GE7624@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55042 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbXISMqi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Sep 2007 08:46:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>


I haven't even compile-tested this.  But look how much ugly code it
deletes if it works!

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 5948872..346bed6 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -310,8 +310,6 @@ static inline void qlogicpti_set_hostdev_defaults(struct qlogicpti *qpti)
 		}
 		qpti->dev_param[i].device_enable = 1;
 	}
-	/* this is very important to set! */
-	qpti->sbits = 1 << qpti->scsi_id;
 }
 
 static int qlogicpti_reset_hardware(struct Scsi_Host *host)
@@ -981,123 +979,35 @@ static void scsi_rbuf_put(struct scsi_cmnd *cmd, unsigned char *buf)
 	}
 }
 
-/*
- * Until we scan the entire bus with inquiries, go throught this fella...
- */
-static void ourdone(struct scsi_cmnd *Cmnd)
+static int qlogicpti_slave_configure(struct scsi_device *sdev)
 {
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
+	struct qlogicpti *qpti = shost_priv(sdev->host);
+	int tgt = sdev->id;
+	u_short param[6];
 
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
+	/* tags handled in midlayer */
+	/* enable sync mode? */
+	if (sdev->sdtr) {
+		qpti->dev_param[tgt].device_flags |= 0x10;
+	} else {
+		qpti->dev_param[tgt].synchronous_offset = 0;
+		qpti->dev_param[tgt].synchronous_period = 0;
 	}
-
-	/* check to see if we're done with all adapters... */
-	for (qpti = qptichain; qpti != NULL; qpti = qpti->next) {
-		if (qpti->sbits) {
-			break;
-		}
+	/* are we wide capable? */
+	if (sdev->wdtr)
+		qpti->dev_param[tgt].device_flags |= 0x20;
+
+	param[0] = MBOX_SET_TARGET_PARAMS;
+	param[1] = (tgt << 8);
+	param[2] = (qpti->dev_param[tgt].device_flags << 8);
+	if (qpti->dev_param[tgt].device_flags & 0x10) {
+		param[3] = (qpti->dev_param[tgt].synchronous_offset << 8) |
+			qpti->dev_param[tgt].synchronous_period;
+	} else {
+		param[3] = 0;
 	}
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
+	qlogicpti_mbox_command(qpti, param, 0);
+	return 0;
 }
 
 /*
@@ -1390,7 +1300,8 @@ static struct scsi_host_template qpti_template = {
 	.module			= THIS_MODULE,
 	.name			= "qlogicpti",
 	.info			= qlogicpti_info,
-	.queuecommand		= qlogicpti_queuecommand_slow,
+	.queuecommand		= qlogicpti_queuecommand,
+	.slave_configure	= qlogicpti_slave_configure,
 	.eh_abort_handler	= qlogicpti_abort,
 	.eh_bus_reset_handler	= qlogicpti_reset,
 	.can_queue		= QLOGICPTI_REQ_QUEUE_LEN,
diff --git a/drivers/scsi/qlogicpti.h b/drivers/scsi/qlogicpti.h
index 6cd1c07..ef6da2d 100644
--- a/drivers/scsi/qlogicpti.h
+++ b/drivers/scsi/qlogicpti.h
@@ -380,8 +380,7 @@ struct qlogicpti {
 	unsigned char             swsreg;
 	unsigned int	
 		gotirq	:	1,	/* this instance got an irq */
-		is_pti	: 	1,	/* Non-zero if this is a PTI board. */
-		sbits	:	16;	/* syncmode known bits */
+		is_pti	: 	1;	/* Non-zero if this is a PTI board. */
 };
 
 /* How to twiddle them bits... */

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
