From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Tue, 17 Aug 2004 19:17:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817171737.GA17646@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E5704DE66BB@exa-atlanta> <20040817164614.GA16953@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:25324 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268349AbUHQRRt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 13:17:49 -0400
Content-Disposition: inline
In-Reply-To: <20040817164614.GA16953@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, fukuchi.masao@jp.fujitsu.com

Okay, here's an untested patch that gets rid of the fusion pendingQ in
favour of using the scsi midlayer queueing, this should reduce the
number of commands that are pending in fusion to a minimum.  We still
have to get rid of the doneQ aswell, but I want to understand the full
implications first.


--- 1.25/drivers/message/fusion/mptbase.h	2004-08-10 00:42:45 +02:00
+++ edited/drivers/message/fusion/mptbase.h	2004-08-17 21:07:50 +02:00
@@ -1031,7 +1031,6 @@
 	u8			 *memQ;
 	DONE_Q_TRACKER		  freeQ;
 	DONE_Q_TRACKER		  doneQ;		/* Holds Linux formmatted requests */
-	DONE_Q_TRACKER		  pendingQ;		/* Holds MPI formmatted requests */
 	MPT_Q_TRACKER		  taskQ;		/* TM request Q */
 	spinlock_t		  freedoneQlock;
 	int			  taskQcnt;
--- 1.45/drivers/message/fusion/mptscsih.c	2004-08-03 01:01:01 +02:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-08-17 21:12:35 +02:00
@@ -168,8 +168,6 @@
 static void	copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
 static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);
 static u32	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
-static MPT_FRAME_HDR *mptscsih_search_pendingQ(MPT_SCSI_HOST *hd, int scpnt_idx);
-static void	post_pendingQ_commands(MPT_SCSI_HOST *hd);
 
 static int	mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout, int sleepFlag);
 static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout, int sleepFlag);
@@ -1002,11 +1000,6 @@
 			/* Command found.
 			 */
 
-			/* Search pendingQ, if found,
-			 * delete from Q.
-			 */
-			mptscsih_search_pendingQ(hd, ii);
-
 			/* Null ScsiLookup index
 			 */
 			hd->ScsiLookup[ii] = NULL;
@@ -1346,7 +1339,6 @@
 	 */
 	Q_INIT(&hd->freeQ, MPT_DONE_Q);
 	Q_INIT(&hd->doneQ, MPT_DONE_Q);
-	Q_INIT(&hd->pendingQ, MPT_DONE_Q);
 	spin_lock_init(&hd->freedoneQlock);
 
 	mem = hd->memQ;
@@ -2043,16 +2034,9 @@
 			(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt, done));
 
 	if (hd->resetPending) {
-		/* Prevent new commands from being issued
-		 * while reloading the FW. Reset timer to 60 seconds,
-		 * as the FW can take some time to come ready.
-		 * For New EH, cmds on doneQ posted to FW.
-		 */
-		did_errcode = 1;
-		mod_timer(&SCpnt->eh_timeout, jiffies + (HZ * 60));
 		dtmprintk((MYIOC_s_WARN_FMT "qcmd: SCpnt=%p timeout + 60HZ\n",
 			(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt));
-		goto did_error;
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/*
@@ -2061,8 +2045,7 @@
 	if ((mf = mpt_get_msg_frame(ScsiDoneCtx, hd->ioc)) == NULL) {
 		dprintk((MYIOC_s_WARN_FMT "QueueCmd, no msg frames!!\n",
 				hd->ioc->name));
-		did_errcode = 2;
-		goto did_error;
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	pScsiReq = (SCSIIORequest_t *) mf;
@@ -2211,64 +2194,17 @@
 			dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
 					hd->ioc->name, SCpnt, mf, my_idx));
 			DBG_DUMP_REQUEST_FRAME(mf)
-		} else {
-			ddvtprintk((MYIOC_s_INFO_FMT "Pending cmd=%p idx %d\n",
-					hd->ioc->name, SCpnt, my_idx));
-			/* Place this command on the pendingQ if possible */
-			spin_lock_irqsave(&hd->freedoneQlock, flags);
-			if (!Q_IS_EMPTY(&hd->freeQ)) {
-				buffer = hd->freeQ.head;
-				Q_DEL_ITEM(buffer);
-
-				/* Save the mf pointer
-				 */
-				buffer->argp = (void *)mf;
-
-				/* Add to the pendingQ
-				 */
-				Q_ADD_TAIL(&hd->pendingQ.head, buffer, MPT_DONE_Q);
-				spin_unlock_irqrestore(&hd->freedoneQlock, flags);
-			} else {
-				spin_unlock_irqrestore(&hd->freedoneQlock, flags);
-				SCpnt->result = (DID_BUS_BUSY << 16);
-				SCpnt->scsi_done(SCpnt);
-			}
-		}
-	} else {
-		mptscsih_freeChainBuffers(hd->ioc, my_idx);
-		mpt_free_msg_frame(hd->ioc, mf);
-		did_errcode = 3;
-		goto did_error;
-	}
+		} else
+			goto fail;
+	} else
+		goto fail;
 
 	return 0;
 
-did_error:
-	dprintk((MYIOC_s_WARN_FMT "_qcmd did_errcode=%d (sc=%p)\n",
-			hd->ioc->name, did_errcode, SCpnt));
-	/* Just wish OS to issue a retry */
-	SCpnt->result = (DID_BUS_BUSY << 16);
-	spin_lock_irqsave(&hd->freedoneQlock, flags);
-	if (!Q_IS_EMPTY(&hd->freeQ)) {
-		dtmprintk((MYIOC_s_WARN_FMT "SCpnt=%p to doneQ\n",
-			(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt));
-		buffer = hd->freeQ.head;
-		Q_DEL_ITEM(buffer);
-
-		/* Set the scsi_cmnd pointer
-		 */
-		buffer->argp = (void *)SCpnt;
-
-		/* Add to the doneQ
-		 */
-		Q_ADD_TAIL(&hd->doneQ.head, buffer, MPT_DONE_Q);
-		spin_unlock_irqrestore(&hd->freedoneQlock, flags);
-	} else {
-		spin_unlock_irqrestore(&hd->freedoneQlock, flags);
-		SCpnt->scsi_done(SCpnt);
-	}
-
-	return 0;
+ fail:
+	mptscsih_freeChainBuffers(hd->ioc, my_idx);
+	mpt_free_msg_frame(hd->ioc, mf);
+	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2551,7 +2487,7 @@
  *
  *	Returns SUCCESS or FAILED.
  */
-int
+static int
 mptscsih_abort(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
@@ -2595,18 +2531,6 @@
 		return SUCCESS;
 	}
 
-	/* If this command is pended, then timeout/hang occurred
-	 * during DV. Post command and flush pending Q
-	 * and then following up with the reset request.
-	 */
-	if ((mf = mptscsih_search_pendingQ(hd, scpnt_idx)) != NULL) {
-		mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);
-		post_pendingQ_commands(hd);
-		dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "
-			   "Posting pended cmd! (sc=%p)\n",
-			   hd->ioc->name, SCpnt));
-	}
-
 	/* Most important!  Set TaskMsgContext to SCpnt's MsgContext!
 	 * (the IO to be ABORT'd)
 	 *
@@ -3257,102 +3181,6 @@
 	return -1;
 }
 
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* Search the pendingQ for a command with specific index.
- * If found, delete and return mf pointer
- * If not found, return NULL
- */
-static MPT_FRAME_HDR *
-mptscsih_search_pendingQ(MPT_SCSI_HOST *hd, int scpnt_idx)
-{
-	unsigned long	 flags;
-	MPT_DONE_Q	*buffer;
-	MPT_FRAME_HDR	*mf = NULL;
-	MPT_FRAME_HDR	*cmdMfPtr;
-
-	ddvtprintk((MYIOC_s_INFO_FMT ": search_pendingQ ...", hd->ioc->name));
-	cmdMfPtr = MPT_INDEX_2_MFPTR(hd->ioc, scpnt_idx);
-	spin_lock_irqsave(&hd->freedoneQlock, flags);
-	if (!Q_IS_EMPTY(&hd->pendingQ)) {
-		buffer = hd->pendingQ.head;
-		do {
-			mf = (MPT_FRAME_HDR *) buffer->argp;
-			if (mf == cmdMfPtr) {
-				Q_DEL_ITEM(buffer);
-
-				/* clear the arg pointer
-				 */
-				buffer->argp = NULL;
-
-				/* Add to the freeQ
-				 */
-				Q_ADD_TAIL(&hd->freeQ.head, buffer, MPT_DONE_Q);
-				break;
-			}
-			mf = NULL;
-		} while ((buffer = buffer->forw) != (MPT_DONE_Q *) &hd->pendingQ);
-	}
-	spin_unlock_irqrestore(&hd->freedoneQlock, flags);
-	ddvtprintk((" ...return %p\n", mf));
-	return mf;
-}
-
-/* Post all commands on the pendingQ to the FW.
- * Lock Q when deleting/adding members
- * Lock io_request_lock for OS callback.
- */
-static void
-post_pendingQ_commands(MPT_SCSI_HOST *hd)
-{
-	MPT_FRAME_HDR	*mf;
-	MPT_DONE_Q	*buffer;
-	unsigned long	 flags;
-
-	/* Flush the pendingQ.
-	 */
-	ddvtprintk((MYIOC_s_INFO_FMT ": post_pendingQ_commands\n", hd->ioc->name));
-	while (1) {
-		spin_lock_irqsave(&hd->freedoneQlock, flags);
-		if (Q_IS_EMPTY(&hd->pendingQ)) {
-			spin_unlock_irqrestore(&hd->freedoneQlock, flags);
-			break;
-		}
-
-		buffer = hd->pendingQ.head;
-		/* Delete from Q
-		 */
-		Q_DEL_ITEM(buffer);
-
-		mf = (MPT_FRAME_HDR *) buffer->argp;
-		buffer->argp = NULL;
-
-		/* Add to the freeQ
-		 */
-		Q_ADD_TAIL(&hd->freeQ.head, buffer, MPT_DONE_Q);
-		spin_unlock_irqrestore(&hd->freedoneQlock, flags);
-
-		if (!mf) {
-			/* This should never happen */
-			printk(MYIOC_s_WARN_FMT "post_pendingQ_commands: mf %p\n", hd->ioc->name, (void *) mf);
-			continue;
-		}
-
-		mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);
-
-#if defined(MPT_DEBUG_DV) || defined(MPT_DEBUG_DV_TINY)
-		{
-			u16		 req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
-			struct scsi_cmnd	*sc = hd->ScsiLookup[req_idx];
-			printk(MYIOC_s_INFO_FMT "Issued SCSI cmd (sc=%p) idx=%d (mf=%p)\n",
-					hd->ioc->name, sc, req_idx, mf);
-		}
-#endif
-	}
-
-	return;
-}
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static int
 mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
@@ -5174,11 +5003,6 @@
 							}
 						}
 					}
-
-					/* Post OS IOs that were pended while
-					 * DV running.
-					 */
-					post_pendingQ_commands(hd);
 
 					if (hd->ioc->spi_data.noQas)
 						mptscsih_qas_check(hd, id);
