From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.24-rc3
Date: Sun, 25 Nov 2007 13:24:25 +0200
Message-ID: <1195989865.3427.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:58444 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117AbXKYLYf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Nov 2007 06:24:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a bit of a rash of bug fixes.  The qla1280 is actually a bug fix
(in spite of the title---it's actually correcting an existing problem
with the qla1280 implementation of accessors that broke the current
driver).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Alan Cox (1):
      aacraid: fix security weakness

Jeff Garzik (1):
      NCR5380: Fix bugs and canonicalize irq handler usage

Jes Sorensen (1):
      qla1280: convert to use the data buffer accessors

Martin Peschke (2):
      zfcp: fix cleanup of dismissed error recovery actions
      zfcp: fix dismissal of error recovery actions

Salyzyn, Mark (2):
      aacraid: fix up le32 issues in BlinkLED
      aacraid: fix potential panic in thread stop

Stephen Rothwell (1):
      aacraid: don't assign cpu_to_le32(constant) to u8

Tony Battersby (2):
      iscsi: return data transfer residual for data-out commands
      iscsi_tcp: fix potential lockup with write commands

and the diffstat:

 s390/scsi/zfcp_erp.c   |   18 +-
 scsi/aacraid/commsup.c |    8 -
 scsi/aacraid/linit.c   |    7 
 scsi/atari_scsi.c      |   10 -
 scsi/dtc.c             |    5 
 scsi/g_NCR5380.c       |    5 
 scsi/iscsi_tcp.c       |  139 ++++++++---------
 scsi/iscsi_tcp.h       |   34 ++--
 scsi/libiscsi.c        |    3 
 scsi/mac_scsi.c        |    4 
 scsi/pas16.c           |    5 
 scsi/qla1280.c         |  387 +++++++++++++++++++++----------------------------
 scsi/sun3_scsi.c       |    4 
 scsi/sun3_scsi_vme.c   |    4 
 scsi/t128.c            |    5 
 15 files changed, 292 insertions(+), 346 deletions(-)

The actual diffs are below.

James

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 5552b75..07fa824 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -977,7 +977,9 @@ static void zfcp_erp_action_dismiss(struct zfcp_erp_action *erp_action)
 	debug_text_event(adapter->erp_dbf, 2, "a_adis");
 	debug_event(adapter->erp_dbf, 2, &erp_action->action, sizeof (int));
 
-	zfcp_erp_async_handler_nolock(erp_action, ZFCP_STATUS_ERP_DISMISSED);
+	erp_action->status |= ZFCP_STATUS_ERP_DISMISSED;
+	if (zfcp_erp_action_exists(erp_action) == ZFCP_ERP_ACTION_RUNNING)
+		zfcp_erp_action_ready(erp_action);
 }
 
 int
@@ -1063,7 +1065,7 @@ zfcp_erp_thread(void *data)
 				 &adapter->status)) {
 
 		write_lock_irqsave(&adapter->erp_lock, flags);
-		next = adapter->erp_ready_head.prev;
+		next = adapter->erp_ready_head.next;
 		write_unlock_irqrestore(&adapter->erp_lock, flags);
 
 		if (next != &adapter->erp_ready_head) {
@@ -1153,15 +1155,13 @@ zfcp_erp_strategy(struct zfcp_erp_action *erp_action)
 
 	/*
 	 * check for dismissed status again to avoid follow-up actions,
-	 * failing of targets and so on for dismissed actions
+	 * failing of targets and so on for dismissed actions,
+	 * we go through down() here because there has been an up()
 	 */
-	retval = zfcp_erp_strategy_check_action(erp_action, retval);
+	if (erp_action->status & ZFCP_STATUS_ERP_DISMISSED)
+		retval = ZFCP_ERP_CONTINUES;
 
 	switch (retval) {
-	case ZFCP_ERP_DISMISSED:
-		/* leave since this action has ridden to its ancestors */
-		debug_text_event(adapter->erp_dbf, 6, "a_st_dis2");
-		goto unlock;
 	case ZFCP_ERP_NOMEM:
 		/* no memory to continue immediately, let it sleep */
 		if (!(erp_action->status & ZFCP_STATUS_ERP_LOWMEM)) {
@@ -3089,7 +3089,7 @@ zfcp_erp_action_enqueue(int action,
 	++adapter->erp_total_count;
 
 	/* finally put it into 'ready' queue and kick erp thread */
-	list_add(&erp_action->list, &adapter->erp_ready_head);
+	list_add_tail(&erp_action->list, &adapter->erp_ready_head);
 	up(&adapter->erp_ready_sem);
 	retval = 0;
  out:
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 240a0bb..abce48c 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1339,10 +1339,10 @@ int aac_check_health(struct aac_dev * aac)
 			aif = (struct aac_aifcmd *)hw_fib->data;
 			aif->command = cpu_to_le32(AifCmdEventNotify);
 		 	aif->seqnum = cpu_to_le32(0xFFFFFFFF);
-		 	aif->data[0] = cpu_to_le32(AifEnExpEvent);
-			aif->data[1] = cpu_to_le32(AifExeFirmwarePanic);
-		 	aif->data[2] = cpu_to_le32(AifHighPriority);
-			aif->data[3] = cpu_to_le32(BlinkLED);
+			aif->data[0] = AifEnExpEvent;
+			aif->data[1] = AifExeFirmwarePanic;
+			aif->data[2] = AifHighPriority;
+			aif->data[3] = BlinkLED;
 
 			/*
 			 * Put the FIB onto the
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 038980b..9dd331b 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -636,7 +636,7 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
 static int aac_cfg_ioctl(struct inode *inode,  struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 	return aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
 }
@@ -691,7 +691,7 @@ static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 
 static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 	return aac_compat_do_ioctl((struct aac_dev *)file->private_data, cmd, arg);
 }
@@ -950,7 +950,8 @@ static struct scsi_host_template aac_driver_template = {
 
 static void __aac_shutdown(struct aac_dev * aac)
 {
-	kthread_stop(aac->thread);
+	if (aac->aif_thread)
+		kthread_stop(aac->thread);
 	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
 	free_irq(aac->pdev->irq, aac);
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 6f8403b..f5732d8 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -393,7 +393,7 @@ static irqreturn_t scsi_tt_intr(int irq, void *dummy)
 
 #endif /* REAL_DMA */
 
-	NCR5380_intr(0, 0);
+	NCR5380_intr(irq, dummy);
 
 #if 0
 	/* To be sure the int is not masked */
@@ -458,7 +458,7 @@ static irqreturn_t scsi_falcon_intr(int irq, void *dummy)
 
 #endif /* REAL_DMA */
 
-	NCR5380_intr(0, 0);
+	NCR5380_intr(irq, dummy);
 	return IRQ_HANDLED;
 }
 
@@ -684,7 +684,7 @@ int atari_scsi_detect(struct scsi_host_template *host)
 		 * interrupt after having cleared the pending flag for the DMA
 		 * interrupt. */
 		if (request_irq(IRQ_TT_MFP_SCSI, scsi_tt_intr, IRQ_TYPE_SLOW,
-				 "SCSI NCR5380", scsi_tt_intr)) {
+				 "SCSI NCR5380", instance)) {
 			printk(KERN_ERR "atari_scsi_detect: cannot allocate irq %d, aborting",IRQ_TT_MFP_SCSI);
 			scsi_unregister(atari_scsi_host);
 			atari_stram_free(atari_dma_buffer);
@@ -701,7 +701,7 @@ int atari_scsi_detect(struct scsi_host_template *host)
 					 IRQ_TYPE_PRIO, "Hades DMA emulator",
 					 hades_dma_emulator)) {
 				printk(KERN_ERR "atari_scsi_detect: cannot allocate irq %d, aborting (MACH_IS_HADES)",IRQ_AUTO_2);
-				free_irq(IRQ_TT_MFP_SCSI, scsi_tt_intr);
+				free_irq(IRQ_TT_MFP_SCSI, instance);
 				scsi_unregister(atari_scsi_host);
 				atari_stram_free(atari_dma_buffer);
 				atari_dma_buffer = 0;
@@ -761,7 +761,7 @@ int atari_scsi_detect(struct scsi_host_template *host)
 int atari_scsi_release(struct Scsi_Host *sh)
 {
 	if (IS_A_TT())
-		free_irq(IRQ_TT_MFP_SCSI, scsi_tt_intr);
+		free_irq(IRQ_TT_MFP_SCSI, sh);
 	if (atari_dma_buffer)
 		atari_stram_free(atari_dma_buffer);
 	return 1;
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index 2596165..c2677ba 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -277,7 +277,8 @@ found:
 		/* With interrupts enabled, it will sometimes hang when doing heavy
 		 * reads. So better not enable them until I finger it out. */
 		if (instance->irq != SCSI_IRQ_NONE)
-			if (request_irq(instance->irq, dtc_intr, IRQF_DISABLED, "dtc", instance)) {
+			if (request_irq(instance->irq, dtc_intr, IRQF_DISABLED,
+					"dtc", instance)) {
 				printk(KERN_ERR "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
 			}
@@ -459,7 +460,7 @@ static int dtc_release(struct Scsi_Host *shost)
 	NCR5380_local_declare();
 	NCR5380_setup(shost);
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 607336f..75585a5 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -460,7 +460,8 @@ int __init generic_NCR5380_detect(struct scsi_host_template * tpnt)
 			instance->irq = NCR5380_probe_irq(instance, 0xffff);
 
 		if (instance->irq != SCSI_IRQ_NONE)
-			if (request_irq(instance->irq, generic_NCR5380_intr, IRQF_DISABLED, "NCR5380", instance)) {
+			if (request_irq(instance->irq, generic_NCR5380_intr,
+					IRQF_DISABLED, "NCR5380", instance)) {
 				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
 			}
@@ -513,7 +514,7 @@ int generic_NCR5380_release_resources(struct Scsi_Host *instance)
 	NCR5380_setup(instance);
 	
 	if (instance->irq != SCSI_IRQ_NONE)
-		free_irq(instance->irq, NULL);
+		free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
 
 #ifndef CONFIG_SCSI_G_NCR5380_MEM
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4bcf916..57ce225 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -197,7 +197,7 @@ iscsi_tcp_cleanup_ctask(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	if (unlikely(!sc))
 		return;
 
-	tcp_ctask->xmstate = XMSTATE_IDLE;
+	tcp_ctask->xmstate = XMSTATE_VALUE_IDLE;
 	tcp_ctask->r2t = NULL;
 }
 
@@ -409,7 +409,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 	tcp_ctask->exp_datasn = r2tsn + 1;
 	__kfifo_put(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*));
-	tcp_ctask->xmstate |= XMSTATE_SOL_HDR_INIT;
+	set_bit(XMSTATE_BIT_SOL_HDR_INIT, &tcp_ctask->xmstate);
 	list_move_tail(&ctask->running, &conn->xmitqueue);
 
 	scsi_queue_work(session->host, &conn->xmitwork);
@@ -1254,7 +1254,7 @@ static void iscsi_set_padding(struct iscsi_tcp_cmd_task *tcp_ctask,
 
 	tcp_ctask->pad_count = ISCSI_PAD_LEN - tcp_ctask->pad_count;
 	debug_scsi("write padding %d bytes\n", tcp_ctask->pad_count);
-	tcp_ctask->xmstate |= XMSTATE_W_PAD;
+	set_bit(XMSTATE_BIT_W_PAD, &tcp_ctask->xmstate);
 }
 
 /**
@@ -1269,7 +1269,7 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task *ctask)
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
 	BUG_ON(__kfifo_len(tcp_ctask->r2tqueue));
-	tcp_ctask->xmstate = XMSTATE_CMD_HDR_INIT;
+	tcp_ctask->xmstate = 1 << XMSTATE_BIT_CMD_HDR_INIT;
 }
 
 /**
@@ -1283,10 +1283,10 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task *ctask)
  *	xmit.
  *
  *	Management xmit state machine consists of these states:
- *		XMSTATE_IMM_HDR_INIT	- calculate digest of PDU Header
- *		XMSTATE_IMM_HDR 	- PDU Header xmit in progress
- *		XMSTATE_IMM_DATA 	- PDU Data xmit in progress
- *		XMSTATE_IDLE		- management PDU is done
+ *		XMSTATE_BIT_IMM_HDR_INIT - calculate digest of PDU Header
+ *		XMSTATE_BIT_IMM_HDR      - PDU Header xmit in progress
+ *		XMSTATE_BIT_IMM_DATA     - PDU Data xmit in progress
+ *		XMSTATE_VALUE_IDLE       - management PDU is done
  **/
 static int
 iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
@@ -1297,12 +1297,12 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 	debug_scsi("mtask deq [cid %d state %x itt 0x%x]\n",
 		conn->id, tcp_mtask->xmstate, mtask->itt);
 
-	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR_INIT) {
+	if (test_bit(XMSTATE_BIT_IMM_HDR_INIT, &tcp_mtask->xmstate)) {
 		iscsi_buf_init_iov(&tcp_mtask->headbuf, (char*)mtask->hdr,
 				   sizeof(struct iscsi_hdr));
 
 		if (mtask->data_count) {
-			tcp_mtask->xmstate |= XMSTATE_IMM_DATA;
+			set_bit(XMSTATE_BIT_IMM_DATA, &tcp_mtask->xmstate);
 			iscsi_buf_init_iov(&tcp_mtask->sendbuf,
 					   (char*)mtask->data,
 					   mtask->data_count);
@@ -1315,21 +1315,20 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 					(u8*)tcp_mtask->hdrext);
 
 		tcp_mtask->sent = 0;
-		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR_INIT;
-		tcp_mtask->xmstate |= XMSTATE_IMM_HDR;
+		clear_bit(XMSTATE_BIT_IMM_HDR_INIT, &tcp_mtask->xmstate);
+		set_bit(XMSTATE_BIT_IMM_HDR, &tcp_mtask->xmstate);
 	}
 
-	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR) {
+	if (test_bit(XMSTATE_BIT_IMM_HDR, &tcp_mtask->xmstate)) {
 		rc = iscsi_sendhdr(conn, &tcp_mtask->headbuf,
 				   mtask->data_count);
 		if (rc)
 			return rc;
-		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR;
+		clear_bit(XMSTATE_BIT_IMM_HDR, &tcp_mtask->xmstate);
 	}
 
-	if (tcp_mtask->xmstate & XMSTATE_IMM_DATA) {
+	if (test_and_clear_bit(XMSTATE_BIT_IMM_DATA, &tcp_mtask->xmstate)) {
 		BUG_ON(!mtask->data_count);
-		tcp_mtask->xmstate &= ~XMSTATE_IMM_DATA;
 		/* FIXME: implement.
 		 * Virtual buffer could be spreaded across multiple pages...
 		 */
@@ -1339,13 +1338,13 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 			rc = iscsi_sendpage(conn, &tcp_mtask->sendbuf,
 					&mtask->data_count, &tcp_mtask->sent);
 			if (rc) {
-				tcp_mtask->xmstate |= XMSTATE_IMM_DATA;
+				set_bit(XMSTATE_BIT_IMM_DATA, &tcp_mtask->xmstate);
 				return rc;
 			}
 		} while (mtask->data_count);
 	}
 
-	BUG_ON(tcp_mtask->xmstate != XMSTATE_IDLE);
+	BUG_ON(tcp_mtask->xmstate != XMSTATE_VALUE_IDLE);
 	if (mtask->hdr->itt == RESERVED_ITT) {
 		struct iscsi_session *session = conn->session;
 
@@ -1365,7 +1364,7 @@ iscsi_send_cmd_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	int rc = 0;
 
-	if (tcp_ctask->xmstate & XMSTATE_CMD_HDR_INIT) {
+	if (test_bit(XMSTATE_BIT_CMD_HDR_INIT, &tcp_ctask->xmstate)) {
 		tcp_ctask->sent = 0;
 		tcp_ctask->sg_count = 0;
 		tcp_ctask->exp_datasn = 0;
@@ -1390,21 +1389,21 @@ iscsi_send_cmd_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 					 (u8*)tcp_ctask->hdrext);
-		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_INIT;
-		tcp_ctask->xmstate |= XMSTATE_CMD_HDR_XMIT;
+		clear_bit(XMSTATE_BIT_CMD_HDR_INIT, &tcp_ctask->xmstate);
+		set_bit(XMSTATE_BIT_CMD_HDR_XMIT, &tcp_ctask->xmstate);
 	}
 
-	if (tcp_ctask->xmstate & XMSTATE_CMD_HDR_XMIT) {
+	if (test_bit(XMSTATE_BIT_CMD_HDR_XMIT, &tcp_ctask->xmstate)) {
 		rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->imm_count);
 		if (rc)
 			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_XMIT;
+		clear_bit(XMSTATE_BIT_CMD_HDR_XMIT, &tcp_ctask->xmstate);
 
 		if (sc->sc_data_direction != DMA_TO_DEVICE)
 			return 0;
 
 		if (ctask->imm_count) {
-			tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
+			set_bit(XMSTATE_BIT_IMM_DATA, &tcp_ctask->xmstate);
 			iscsi_set_padding(tcp_ctask, ctask->imm_count);
 
 			if (ctask->conn->datadgst_en) {
@@ -1414,9 +1413,10 @@ iscsi_send_cmd_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 			}
 		}
 
-		if (ctask->unsol_count)
-			tcp_ctask->xmstate |=
-					XMSTATE_UNS_HDR | XMSTATE_UNS_INIT;
+		if (ctask->unsol_count) {
+			set_bit(XMSTATE_BIT_UNS_HDR, &tcp_ctask->xmstate);
+			set_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate);
+		}
 	}
 	return rc;
 }
@@ -1428,25 +1428,25 @@ iscsi_send_padding(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	int sent = 0, rc;
 
-	if (tcp_ctask->xmstate & XMSTATE_W_PAD) {
+	if (test_bit(XMSTATE_BIT_W_PAD, &tcp_ctask->xmstate)) {
 		iscsi_buf_init_iov(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
 				   tcp_ctask->pad_count);
 		if (conn->datadgst_en)
 			crypto_hash_update(&tcp_conn->tx_hash,
 					   &tcp_ctask->sendbuf.sg,
 					   tcp_ctask->sendbuf.sg.length);
-	} else if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_PAD))
+	} else if (!test_bit(XMSTATE_BIT_W_RESEND_PAD, &tcp_ctask->xmstate))
 		return 0;
 
-	tcp_ctask->xmstate &= ~XMSTATE_W_PAD;
-	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_PAD;
+	clear_bit(XMSTATE_BIT_W_PAD, &tcp_ctask->xmstate);
+	clear_bit(XMSTATE_BIT_W_RESEND_PAD, &tcp_ctask->xmstate);
 	debug_scsi("sending %d pad bytes for itt 0x%x\n",
 		   tcp_ctask->pad_count, ctask->itt);
 	rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf, &tcp_ctask->pad_count,
 			   &sent);
 	if (rc) {
 		debug_scsi("padding send failed %d\n", rc);
-		tcp_ctask->xmstate |= XMSTATE_W_RESEND_PAD;
+		set_bit(XMSTATE_BIT_W_RESEND_PAD, &tcp_ctask->xmstate);
 	}
 	return rc;
 }
@@ -1465,11 +1465,11 @@ iscsi_send_digest(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	tcp_ctask = ctask->dd_data;
 	tcp_conn = conn->dd_data;
 
-	if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_DATA_DIGEST)) {
+	if (!test_bit(XMSTATE_BIT_W_RESEND_DATA_DIGEST, &tcp_ctask->xmstate)) {
 		crypto_hash_final(&tcp_conn->tx_hash, (u8*)digest);
 		iscsi_buf_init_iov(buf, (char*)digest, 4);
 	}
-	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_DATA_DIGEST;
+	clear_bit(XMSTATE_BIT_W_RESEND_DATA_DIGEST, &tcp_ctask->xmstate);
 
 	rc = iscsi_sendpage(conn, buf, &tcp_ctask->digest_count, &sent);
 	if (!rc)
@@ -1478,7 +1478,7 @@ iscsi_send_digest(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	else {
 		debug_scsi("sending digest 0x%x failed for itt 0x%x!\n",
 			  *digest, ctask->itt);
-		tcp_ctask->xmstate |= XMSTATE_W_RESEND_DATA_DIGEST;
+		set_bit(XMSTATE_BIT_W_RESEND_DATA_DIGEST, &tcp_ctask->xmstate);
 	}
 	return rc;
 }
@@ -1526,8 +1526,8 @@ iscsi_send_unsol_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	struct iscsi_data_task *dtask;
 	int rc;
 
-	tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
-	if (tcp_ctask->xmstate & XMSTATE_UNS_INIT) {
+	set_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate);
+	if (test_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate)) {
 		dtask = &tcp_ctask->unsol_dtask;
 
 		iscsi_prep_unsolicit_data_pdu(ctask, &dtask->hdr);
@@ -1537,14 +1537,14 @@ iscsi_send_unsol_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 					(u8*)dtask->hdrext);
 
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_INIT;
+		clear_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate);
 		iscsi_set_padding(tcp_ctask, ctask->data_count);
 	}
 
 	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->data_count);
 	if (rc) {
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
-		tcp_ctask->xmstate |= XMSTATE_UNS_HDR;
+		clear_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate);
+		set_bit(XMSTATE_BIT_UNS_HDR, &tcp_ctask->xmstate);
 		return rc;
 	}
 
@@ -1565,16 +1565,15 @@ iscsi_send_unsol_pdu(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	int rc;
 
-	if (tcp_ctask->xmstate & XMSTATE_UNS_HDR) {
+	if (test_and_clear_bit(XMSTATE_BIT_UNS_HDR, &tcp_ctask->xmstate)) {
 		BUG_ON(!ctask->unsol_count);
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_HDR;
 send_hdr:
 		rc = iscsi_send_unsol_hdr(conn, ctask);
 		if (rc)
 			return rc;
 	}
 
-	if (tcp_ctask->xmstate & XMSTATE_UNS_DATA) {
+	if (test_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate)) {
 		struct iscsi_data_task *dtask = &tcp_ctask->unsol_dtask;
 		int start = tcp_ctask->sent;
 
@@ -1584,14 +1583,14 @@ send_hdr:
 		ctask->unsol_count -= tcp_ctask->sent - start;
 		if (rc)
 			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
+		clear_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate);
 		/*
 		 * Done with the Data-Out. Next, check if we need
 		 * to send another unsolicited Data-Out.
 		 */
 		if (ctask->unsol_count) {
 			debug_scsi("sending more uns\n");
-			tcp_ctask->xmstate |= XMSTATE_UNS_INIT;
+			set_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate);
 			goto send_hdr;
 		}
 	}
@@ -1607,7 +1606,7 @@ static int iscsi_send_sol_pdu(struct iscsi_conn *conn,
 	struct iscsi_data_task *dtask;
 	int left, rc;
 
-	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR_INIT) {
+	if (test_bit(XMSTATE_BIT_SOL_HDR_INIT, &tcp_ctask->xmstate)) {
 		if (!tcp_ctask->r2t) {
 			spin_lock_bh(&session->lock);
 			__kfifo_get(tcp_ctask->r2tqueue, (void*)&tcp_ctask->r2t,
@@ -1621,19 +1620,19 @@ send_hdr:
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &r2t->headbuf,
 					(u8*)dtask->hdrext);
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR_INIT;
-		tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
+		clear_bit(XMSTATE_BIT_SOL_HDR_INIT, &tcp_ctask->xmstate);
+		set_bit(XMSTATE_BIT_SOL_HDR, &tcp_ctask->xmstate);
 	}
 
-	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR) {
+	if (test_bit(XMSTATE_BIT_SOL_HDR, &tcp_ctask->xmstate)) {
 		r2t = tcp_ctask->r2t;
 		dtask = &r2t->dtask;
 
 		rc = iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count);
 		if (rc)
 			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
-		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
+		clear_bit(XMSTATE_BIT_SOL_HDR, &tcp_ctask->xmstate);
+		set_bit(XMSTATE_BIT_SOL_DATA, &tcp_ctask->xmstate);
 
 		if (conn->datadgst_en) {
 			iscsi_data_digest_init(conn->dd_data, tcp_ctask);
@@ -1646,7 +1645,7 @@ send_hdr:
 			r2t->sent);
 	}
 
-	if (tcp_ctask->xmstate & XMSTATE_SOL_DATA) {
+	if (test_bit(XMSTATE_BIT_SOL_DATA, &tcp_ctask->xmstate)) {
 		r2t = tcp_ctask->r2t;
 		dtask = &r2t->dtask;
 
@@ -1655,7 +1654,7 @@ send_hdr:
 				     &dtask->digestbuf, &dtask->digest);
 		if (rc)
 			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
+		clear_bit(XMSTATE_BIT_SOL_DATA, &tcp_ctask->xmstate);
 
 		/*
 		 * Done with this Data-Out. Next, check if we have
@@ -1700,32 +1699,32 @@ send_hdr:
  *	xmit stages.
  *
  *iscsi_send_cmd_hdr()
- *	XMSTATE_CMD_HDR_INIT - prepare Header and Data buffers Calculate
- *	                       Header Digest
- *	XMSTATE_CMD_HDR_XMIT - Transmit header in progress
+ *	XMSTATE_BIT_CMD_HDR_INIT - prepare Header and Data buffers Calculate
+ *	                           Header Digest
+ *	XMSTATE_BIT_CMD_HDR_XMIT - Transmit header in progress
  *
  *iscsi_send_padding
- *	XMSTATE_W_PAD        - Prepare and send pading
- *	XMSTATE_W_RESEND_PAD - retry send pading
+ *	XMSTATE_BIT_W_PAD        - Prepare and send pading
+ *	XMSTATE_BIT_W_RESEND_PAD - retry send pading
  *
  *iscsi_send_digest
- *	XMSTATE_W_RESEND_DATA_DIGEST - Finalize and send Data Digest
- *	XMSTATE_W_RESEND_DATA_DIGEST - retry sending digest
+ *	XMSTATE_BIT_W_RESEND_DATA_DIGEST - Finalize and send Data Digest
+ *	XMSTATE_BIT_W_RESEND_DATA_DIGEST - retry sending digest
  *
  *iscsi_send_unsol_hdr
- *	XMSTATE_UNS_INIT     - prepare un-solicit data header and digest
- *	XMSTATE_UNS_HDR      - send un-solicit header
+ *	XMSTATE_BIT_UNS_INIT     - prepare un-solicit data header and digest
+ *	XMSTATE_BIT_UNS_HDR      - send un-solicit header
  *
  *iscsi_send_unsol_pdu
- *	XMSTATE_UNS_DATA     - send un-solicit data in progress
+ *	XMSTATE_BIT_UNS_DATA     - send un-solicit data in progress
  *
  *iscsi_send_sol_pdu
- *	XMSTATE_SOL_HDR_INIT - solicit data header and digest initialize
- *	XMSTATE_SOL_HDR      - send solicit header
- *	XMSTATE_SOL_DATA     - send solicit data
+ *	XMSTATE_BIT_SOL_HDR_INIT - solicit data header and digest initialize
+ *	XMSTATE_BIT_SOL_HDR      - send solicit header
+ *	XMSTATE_BIT_SOL_DATA     - send solicit data
  *
  *iscsi_tcp_ctask_xmit
- *	XMSTATE_IMM_DATA     - xmit managment data (??)
+ *	XMSTATE_BIT_IMM_DATA     - xmit managment data (??)
  **/
 static int
 iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
@@ -1742,13 +1741,13 @@ iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	if (ctask->sc->sc_data_direction != DMA_TO_DEVICE)
 		return 0;
 
-	if (tcp_ctask->xmstate & XMSTATE_IMM_DATA) {
+	if (test_bit(XMSTATE_BIT_IMM_DATA, &tcp_ctask->xmstate)) {
 		rc = iscsi_send_data(ctask, &tcp_ctask->sendbuf, &tcp_ctask->sg,
 				     &tcp_ctask->sent, &ctask->imm_count,
 				     &tcp_ctask->immbuf, &tcp_ctask->immdigest);
 		if (rc)
 			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_IMM_DATA;
+		clear_bit(XMSTATE_BIT_IMM_DATA, &tcp_ctask->xmstate);
 	}
 
 	rc = iscsi_send_unsol_pdu(conn, ctask);
@@ -1981,7 +1980,7 @@ static void
 iscsi_tcp_mgmt_init(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 {
 	struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
-	tcp_mtask->xmstate = XMSTATE_IMM_HDR_INIT;
+	tcp_mtask->xmstate = 1 << XMSTATE_BIT_IMM_HDR_INIT;
 }
 
 static int
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 7eba44d..68c36cc 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -32,21 +32,21 @@
 #define IN_PROGRESS_PAD_RECV		0x4
 
 /* xmit state machine */
-#define XMSTATE_IDLE			0x0
-#define XMSTATE_CMD_HDR_INIT		0x1
-#define XMSTATE_CMD_HDR_XMIT		0x2
-#define XMSTATE_IMM_HDR			0x4
-#define XMSTATE_IMM_DATA		0x8
-#define XMSTATE_UNS_INIT		0x10
-#define XMSTATE_UNS_HDR			0x20
-#define XMSTATE_UNS_DATA		0x40
-#define XMSTATE_SOL_HDR			0x80
-#define XMSTATE_SOL_DATA		0x100
-#define XMSTATE_W_PAD			0x200
-#define XMSTATE_W_RESEND_PAD		0x400
-#define XMSTATE_W_RESEND_DATA_DIGEST	0x800
-#define XMSTATE_IMM_HDR_INIT		0x1000
-#define XMSTATE_SOL_HDR_INIT		0x2000
+#define XMSTATE_VALUE_IDLE			0
+#define XMSTATE_BIT_CMD_HDR_INIT		0
+#define XMSTATE_BIT_CMD_HDR_XMIT		1
+#define XMSTATE_BIT_IMM_HDR			2
+#define XMSTATE_BIT_IMM_DATA			3
+#define XMSTATE_BIT_UNS_INIT			4
+#define XMSTATE_BIT_UNS_HDR			5
+#define XMSTATE_BIT_UNS_DATA			6
+#define XMSTATE_BIT_SOL_HDR			7
+#define XMSTATE_BIT_SOL_DATA			8
+#define XMSTATE_BIT_W_PAD			9
+#define XMSTATE_BIT_W_RESEND_PAD		10
+#define XMSTATE_BIT_W_RESEND_DATA_DIGEST	11
+#define XMSTATE_BIT_IMM_HDR_INIT		12
+#define XMSTATE_BIT_SOL_HDR_INIT		13
 
 #define ISCSI_PAD_LEN			4
 #define ISCSI_SG_TABLESIZE		SG_ALL
@@ -122,7 +122,7 @@ struct iscsi_data_task {
 struct iscsi_tcp_mgmt_task {
 	struct iscsi_hdr	hdr;
 	char			hdrext[sizeof(__u32)]; /* Header-Digest */
-	int			xmstate;	/* mgmt xmit progress */
+	unsigned long		xmstate;	/* mgmt xmit progress */
 	struct iscsi_buf	headbuf;	/* header buffer */
 	struct iscsi_buf	sendbuf;	/* in progress buffer */
 	int			sent;
@@ -150,7 +150,7 @@ struct iscsi_tcp_cmd_task {
 	int			pad_count;		/* padded bytes */
 	struct iscsi_buf	headbuf;		/* header buf (xmit) */
 	struct iscsi_buf	sendbuf;		/* in progress buffer*/
-	int			xmstate;		/* xmit xtate machine */
+	unsigned long		xmstate;		/* xmit xtate machine */
 	int			sent;
 	struct scatterlist	*sg;			/* per-cmd SG list  */
 	struct scatterlist	*bad_sg;		/* assert statement */
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index efceed4..8b57af5 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -291,9 +291,6 @@ invalid_datalen:
 			   min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
 	}
 
-	if (sc->sc_data_direction == DMA_TO_DEVICE)
-		goto out;
-
 	if (rhdr->flags & ISCSI_FLAG_CMD_UNDERFLOW) {
 		int res_count = be32_to_cpu(rhdr->residual_count);
 
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index abe2bda..3b09ab2 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -303,7 +303,7 @@ int macscsi_detect(struct scsi_host_template * tpnt)
 
     if (instance->irq != SCSI_IRQ_NONE)
 	if (request_irq(instance->irq, NCR5380_intr, IRQ_FLG_SLOW, 
-		"ncr5380", instance)) {
+			"ncr5380", instance)) {
 	    printk(KERN_WARNING "scsi%d: IRQ%d not free, interrupts disabled\n",
 		   instance->host_no, instance->irq);
 	    instance->irq = SCSI_IRQ_NONE;
@@ -326,7 +326,7 @@ int macscsi_detect(struct scsi_host_template * tpnt)
 int macscsi_release (struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
-		free_irq (shpnt->irq, NCR5380_intr);
+		free_irq(shpnt->irq, shpnt);
 	NCR5380_exit(shpnt);
 
 	return 0;
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
index ee59656..f2018b4 100644
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -453,7 +453,8 @@ int __init pas16_detect(struct scsi_host_template * tpnt)
 	    instance->irq = NCR5380_probe_irq(instance, PAS16_IRQS);
 
 	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, pas16_intr, IRQF_DISABLED, "pas16", instance)) {
+	    if (request_irq(instance->irq, pas16_intr, IRQF_DISABLED,
+			    "pas16", instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
 		instance->irq = SCSI_IRQ_NONE;
@@ -604,7 +605,7 @@ static inline int NCR5380_pwrite (struct Scsi_Host *instance, unsigned char *src
 static int pas16_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->dma_channel != 0xff)
 		free_dma(shost->dma_channel);
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 3aeb68b..146d540 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1310,14 +1310,7 @@ qla1280_done(struct scsi_qla_host *ha)
 		}
 
 		/* Release memory used for this I/O */
-		if (cmd->use_sg) {
-			pci_unmap_sg(ha->pdev, cmd->request_buffer,
-					cmd->use_sg, cmd->sc_data_direction);
-		} else if (cmd->request_bufflen) {
-			pci_unmap_single(ha->pdev, sp->saved_dma_handle,
-					cmd->request_bufflen,
-					cmd->sc_data_direction);
-		}
+		scsi_dma_unmap(cmd);
 
 		/* Call the mid-level driver interrupt handler */
 		CMD_HANDLE(sp->cmd) = (unsigned char *)INVALID_HANDLE;
@@ -1406,14 +1399,14 @@ qla1280_return_status(struct response * sts, struct scsi_cmnd *cp)
 		break;
 
 	case CS_DATA_UNDERRUN:
-		if ((cp->request_bufflen - residual_length) <
+		if ((scsi_bufflen(cp) - residual_length) <
 		    cp->underflow) {
 			printk(KERN_WARNING
 			       "scsi: Underflow detected - retrying "
 			       "command.\n");
 			host_status = DID_ERROR;
 		} else {
-			cp->resid = residual_length;
+			scsi_set_resid(cp, residual_length);
 			host_status = DID_OK;
 		}
 		break;
@@ -2775,33 +2768,28 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	struct device_reg __iomem *reg = ha->iobase;
 	struct scsi_cmnd *cmd = sp->cmd;
 	cmd_a64_entry_t *pkt;
-	struct scatterlist *sg = NULL, *s;
 	__le32 *dword_ptr;
 	dma_addr_t dma_handle;
 	int status = 0;
 	int cnt;
 	int req_cnt;
-	u16 seg_cnt;
+	int seg_cnt;
 	u8 dir;
 
 	ENTER("qla1280_64bit_start_scsi:");
 
 	/* Calculate number of entries and segments required. */
 	req_cnt = 1;
-	if (cmd->use_sg) {
-		sg = (struct scatterlist *) cmd->request_buffer;
-		seg_cnt = pci_map_sg(ha->pdev, sg, cmd->use_sg,
-				     cmd->sc_data_direction);
-
+	seg_cnt = scsi_dma_map(cmd);
+	if (seg_cnt > 0) {
 		if (seg_cnt > 2) {
 			req_cnt += (seg_cnt - 2) / 5;
 			if ((seg_cnt - 2) % 5)
 				req_cnt++;
 		}
-	} else if (cmd->request_bufflen) {	/* If data transfer. */
-		seg_cnt = 1;
-	} else {
-		seg_cnt = 0;
+	} else if (seg_cnt < 0) {
+		status = 1;
+		goto out;
 	}
 
 	if ((req_cnt + 2) >= ha->req_q_cnt) {
@@ -2889,124 +2877,104 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	 * Load data segments.
 	 */
 	if (seg_cnt) {	/* If data transfer. */
+		struct scatterlist *sg, *s;
 		int remseg = seg_cnt;
+
+		sg = scsi_sglist(cmd);
+
 		/* Setup packet address segment pointer. */
 		dword_ptr = (u32 *)&pkt->dseg_0_address;
 
-		if (cmd->use_sg) {	/* If scatter gather */
-			/* Load command entry data segments. */
-			for_each_sg(sg, s, seg_cnt, cnt) {
-				if (cnt == 2)
+		/* Load command entry data segments. */
+		for_each_sg(sg, s, seg_cnt, cnt) {
+			if (cnt == 2)
+				break;
+
+			dma_handle = sg_dma_address(s);
+#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
+			if (ha->flags.use_pci_vchannel)
+				sn_pci_set_vchan(ha->pdev,
+						 (unsigned long *)&dma_handle,
+						 SCSI_BUS_32(cmd));
+#endif
+			*dword_ptr++ =
+				cpu_to_le32(pci_dma_lo32(dma_handle));
+			*dword_ptr++ =
+				cpu_to_le32(pci_dma_hi32(dma_handle));
+			*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
+			dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
+				cpu_to_le32(pci_dma_hi32(dma_handle)),
+				cpu_to_le32(pci_dma_lo32(dma_handle)),
+				cpu_to_le32(sg_dma_len(sg_next(s))));
+			remseg--;
+		}
+		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
+			"command packet data - b %i, t %i, l %i \n",
+			SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
+			SCSI_LUN_32(cmd));
+		qla1280_dump_buffer(5, (char *)pkt,
+				    REQUEST_ENTRY_SIZE);
+
+		/*
+		 * Build continuation packets.
+		 */
+		dprintk(3, "S/G Building Continuation...seg_cnt=0x%x "
+			"remains\n", seg_cnt);
+
+		while (remseg > 0) {
+			/* Update sg start */
+			sg = s;
+			/* Adjust ring index. */
+			ha->req_ring_index++;
+			if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
+				ha->req_ring_index = 0;
+				ha->request_ring_ptr =
+					ha->request_ring;
+			} else
+				ha->request_ring_ptr++;
+
+			pkt = (cmd_a64_entry_t *)ha->request_ring_ptr;
+
+			/* Zero out packet. */
+			memset(pkt, 0, REQUEST_ENTRY_SIZE);
+
+			/* Load packet defaults. */
+			((struct cont_a64_entry *) pkt)->entry_type =
+				CONTINUE_A64_TYPE;
+			((struct cont_a64_entry *) pkt)->entry_count = 1;
+			((struct cont_a64_entry *) pkt)->sys_define =
+				(uint8_t)ha->req_ring_index;
+			/* Setup packet address segment pointer. */
+			dword_ptr =
+				(u32 *)&((struct cont_a64_entry *) pkt)->dseg_0_address;
+
+			/* Load continuation entry data segments. */
+			for_each_sg(sg, s, remseg, cnt) {
+				if (cnt == 5)
 					break;
 				dma_handle = sg_dma_address(s);
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 				if (ha->flags.use_pci_vchannel)
 					sn_pci_set_vchan(ha->pdev,
-							(unsigned long *)&dma_handle,
+							 (unsigned long *)&dma_handle,
 							 SCSI_BUS_32(cmd));
 #endif
 				*dword_ptr++ =
 					cpu_to_le32(pci_dma_lo32(dma_handle));
 				*dword_ptr++ =
 					cpu_to_le32(pci_dma_hi32(dma_handle));
-				*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
-				dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
+				*dword_ptr++ =
+					cpu_to_le32(sg_dma_len(s));
+				dprintk(3, "S/G Segment Cont. phys_addr=%x %x, len=0x%x\n",
 					cpu_to_le32(pci_dma_hi32(dma_handle)),
 					cpu_to_le32(pci_dma_lo32(dma_handle)),
-					cpu_to_le32(sg_dma_len(sg_next(s))));
-				remseg--;
+					cpu_to_le32(sg_dma_len(s)));
 			}
-			dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
-				"command packet data - b %i, t %i, l %i \n",
-				SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
-				SCSI_LUN_32(cmd));
-			qla1280_dump_buffer(5, (char *)pkt,
-					    REQUEST_ENTRY_SIZE);
-
-			/*
-			 * Build continuation packets.
-			 */
-			dprintk(3, "S/G Building Continuation...seg_cnt=0x%x "
-				"remains\n", seg_cnt);
-
-			while (remseg > 0) {
-				/* Update sg start */
-				sg = s;
-				/* Adjust ring index. */
-				ha->req_ring_index++;
-				if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
-					ha->req_ring_index = 0;
-					ha->request_ring_ptr =
-						ha->request_ring;
-				} else
-						ha->request_ring_ptr++;
-
-				pkt = (cmd_a64_entry_t *)ha->request_ring_ptr;
-
-				/* Zero out packet. */
-				memset(pkt, 0, REQUEST_ENTRY_SIZE);
-
-				/* Load packet defaults. */
-				((struct cont_a64_entry *) pkt)->entry_type =
-					CONTINUE_A64_TYPE;
-				((struct cont_a64_entry *) pkt)->entry_count = 1;
-				((struct cont_a64_entry *) pkt)->sys_define =
-					(uint8_t)ha->req_ring_index;
-				/* Setup packet address segment pointer. */
-				dword_ptr =
-					(u32 *)&((struct cont_a64_entry *) pkt)->dseg_0_address;
-
-				/* Load continuation entry data segments. */
-				for_each_sg(sg, s, remseg, cnt) {
-					if (cnt == 5)
-						break;
-					dma_handle = sg_dma_address(s);
-#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
-				if (ha->flags.use_pci_vchannel)
-					sn_pci_set_vchan(ha->pdev, 
-							(unsigned long *)&dma_handle,
-							 SCSI_BUS_32(cmd));
-#endif
-					*dword_ptr++ =
-						cpu_to_le32(pci_dma_lo32(dma_handle));
-					*dword_ptr++ =
-						cpu_to_le32(pci_dma_hi32(dma_handle));
-					*dword_ptr++ =
-						cpu_to_le32(sg_dma_len(s));
-					dprintk(3, "S/G Segment Cont. phys_addr=%x %x, len=0x%x\n",
-						cpu_to_le32(pci_dma_hi32(dma_handle)),
-						cpu_to_le32(pci_dma_lo32(dma_handle)),
-						cpu_to_le32(sg_dma_len(s)));
-				}
-				remseg -= cnt;
-				dprintk(5, "qla1280_64bit_start_scsi: "
-					"continuation packet data - b %i, t "
-					"%i, l %i \n", SCSI_BUS_32(cmd),
-					SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
-				qla1280_dump_buffer(5, (char *)pkt,
-						    REQUEST_ENTRY_SIZE);
-			}
-		} else {	/* No scatter gather data transfer */
-			dma_handle = pci_map_single(ha->pdev,
-					cmd->request_buffer,
-					cmd->request_bufflen,
-					cmd->sc_data_direction);
-
-			sp->saved_dma_handle = dma_handle;
-#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
-			if (ha->flags.use_pci_vchannel)
-				sn_pci_set_vchan(ha->pdev, 
-						(unsigned long *)&dma_handle,
-						 SCSI_BUS_32(cmd));
-#endif
-			*dword_ptr++ = cpu_to_le32(pci_dma_lo32(dma_handle));
-			*dword_ptr++ = cpu_to_le32(pci_dma_hi32(dma_handle));
-			*dword_ptr = cpu_to_le32(cmd->request_bufflen);
-
-			dprintk(5, "qla1280_64bit_start_scsi: No scatter/"
-				"gather command packet data - b %i, t %i, "
-				"l %i \n", SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
-				SCSI_LUN_32(cmd));
+			remseg -= cnt;
+			dprintk(5, "qla1280_64bit_start_scsi: "
+				"continuation packet data - b %i, t "
+				"%i, l %i \n", SCSI_BUS_32(cmd),
+				SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
 			qla1280_dump_buffer(5, (char *)pkt,
 					    REQUEST_ENTRY_SIZE);
 		}
@@ -3068,12 +3036,11 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	struct device_reg __iomem *reg = ha->iobase;
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct cmd_entry *pkt;
-	struct scatterlist *sg = NULL, *s;
 	__le32 *dword_ptr;
 	int status = 0;
 	int cnt;
 	int req_cnt;
-	uint16_t seg_cnt;
+	int seg_cnt;
 	dma_addr_t dma_handle;
 	u8 dir;
 
@@ -3083,18 +3050,8 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		cmd->cmnd[0]);
 
 	/* Calculate number of entries and segments required. */
-	req_cnt = 1;
-	if (cmd->use_sg) {
-		/*
-		 * We must build an SG list in adapter format, as the kernel's
-		 * SG list cannot be used directly because of data field size
-		 * (__alpha__) differences and the kernel SG list uses virtual
-		 * addresses where we need physical addresses.
-		 */
-		sg = (struct scatterlist *) cmd->request_buffer;
-		seg_cnt = pci_map_sg(ha->pdev, sg, cmd->use_sg,
-				     cmd->sc_data_direction);
-
+	seg_cnt = scsi_dma_map(cmd);
+	if (seg_cnt) {
 		/*
 		 * if greater than four sg entries then we need to allocate
 		 * continuation entries
@@ -3106,14 +3063,9 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		}
 		dprintk(3, "S/G Transfer cmd=%p seg_cnt=0x%x, req_cnt=%x\n",
 			cmd, seg_cnt, req_cnt);
-	} else if (cmd->request_bufflen) {	/* If data transfer. */
-		dprintk(3, "No S/G transfer t=%x cmd=%p len=%x CDB=%x\n",
-			SCSI_TCN_32(cmd), cmd, cmd->request_bufflen,
-			cmd->cmnd[0]);
-		seg_cnt = 1;
-	} else {
-		/* dprintk(1, "No data transfer \n"); */
-		seg_cnt = 0;
+	} else if (seg_cnt < 0) {
+		status = 1;
+		goto out;
 	}
 
 	if ((req_cnt + 2) >= ha->req_q_cnt) {
@@ -3194,91 +3146,84 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	 * Load data segments.
 	 */
 	if (seg_cnt) {
+		struct scatterlist *sg, *s;
 		int remseg = seg_cnt;
+
+		sg = scsi_sglist(cmd);
+
 		/* Setup packet address segment pointer. */
 		dword_ptr = &pkt->dseg_0_address;
 
-		if (cmd->use_sg) {	/* If scatter gather */
-			dprintk(3, "Building S/G data segments..\n");
-			qla1280_dump_buffer(1, (char *)sg, 4 * 16);
+		dprintk(3, "Building S/G data segments..\n");
+		qla1280_dump_buffer(1, (char *)sg, 4 * 16);
+
+		/* Load command entry data segments. */
+		for_each_sg(sg, s, seg_cnt, cnt) {
+			if (cnt == 4)
+				break;
+			*dword_ptr++ =
+				cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
+			*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
+			dprintk(3, "S/G Segment phys_addr=0x%lx, len=0x%x\n",
+				(pci_dma_lo32(sg_dma_address(s))),
+				(sg_dma_len(s)));
+			remseg--;
+		}
+		/*
+		 * Build continuation packets.
+		 */
+		dprintk(3, "S/G Building Continuation"
+			"...seg_cnt=0x%x remains\n", seg_cnt);
+		while (remseg > 0) {
+			/* Continue from end point */
+			sg = s;
+			/* Adjust ring index. */
+			ha->req_ring_index++;
+			if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
+				ha->req_ring_index = 0;
+				ha->request_ring_ptr =
+					ha->request_ring;
+			} else
+				ha->request_ring_ptr++;
+
+			pkt = (struct cmd_entry *)ha->request_ring_ptr;
+
+			/* Zero out packet. */
+			memset(pkt, 0, REQUEST_ENTRY_SIZE);
+
+			/* Load packet defaults. */
+			((struct cont_entry *) pkt)->
+				entry_type = CONTINUE_TYPE;
+			((struct cont_entry *) pkt)->entry_count = 1;
 
-			/* Load command entry data segments. */
-			for_each_sg(sg, s, seg_cnt, cnt) {
-				if (cnt == 4)
+			((struct cont_entry *) pkt)->sys_define =
+				(uint8_t) ha->req_ring_index;
+
+			/* Setup packet address segment pointer. */
+			dword_ptr =
+				&((struct cont_entry *) pkt)->dseg_0_address;
+
+			/* Load continuation entry data segments. */
+			for_each_sg(sg, s, remseg, cnt) {
+				if (cnt == 7)
 					break;
 				*dword_ptr++ =
 					cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
-				*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
-				dprintk(3, "S/G Segment phys_addr=0x%lx, len=0x%x\n",
-					(pci_dma_lo32(sg_dma_address(s))),
-					(sg_dma_len(s)));
-				remseg--;
-			}
-			/*
-			 * Build continuation packets.
-			 */
-			dprintk(3, "S/G Building Continuation"
-				"...seg_cnt=0x%x remains\n", seg_cnt);
-			while (remseg > 0) {
-				/* Continue from end point */
-				sg = s;
-				/* Adjust ring index. */
-				ha->req_ring_index++;
-				if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
-					ha->req_ring_index = 0;
-					ha->request_ring_ptr =
-						ha->request_ring;
-				} else
-					ha->request_ring_ptr++;
-
-				pkt = (struct cmd_entry *)ha->request_ring_ptr;
-
-				/* Zero out packet. */
-				memset(pkt, 0, REQUEST_ENTRY_SIZE);
-
-				/* Load packet defaults. */
-				((struct cont_entry *) pkt)->
-					entry_type = CONTINUE_TYPE;
-				((struct cont_entry *) pkt)->entry_count = 1;
-
-				((struct cont_entry *) pkt)->sys_define =
-					(uint8_t) ha->req_ring_index;
-
-				/* Setup packet address segment pointer. */
-				dword_ptr =
-					&((struct cont_entry *) pkt)->dseg_0_address;
-
-				/* Load continuation entry data segments. */
-				for_each_sg(sg, s, remseg, cnt) {
-					if (cnt == 7)
-						break;
-					*dword_ptr++ =
-						cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
-					*dword_ptr++ =
-						cpu_to_le32(sg_dma_len(s));
-					dprintk(1,
-						"S/G Segment Cont. phys_addr=0x%x, "
-						"len=0x%x\n",
-						cpu_to_le32(pci_dma_lo32(sg_dma_address(s))),
-						cpu_to_le32(sg_dma_len(s)));
-				}
-				remseg -= cnt;
-				dprintk(5, "qla1280_32bit_start_scsi: "
-					"continuation packet data - "
-					"scsi(%i:%i:%i)\n", SCSI_BUS_32(cmd),
-					SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
-				qla1280_dump_buffer(5, (char *)pkt,
-						    REQUEST_ENTRY_SIZE);
+				*dword_ptr++ =
+					cpu_to_le32(sg_dma_len(s));
+				dprintk(1,
+					"S/G Segment Cont. phys_addr=0x%x, "
+					"len=0x%x\n",
+					cpu_to_le32(pci_dma_lo32(sg_dma_address(s))),
+					cpu_to_le32(sg_dma_len(s)));
 			}
-		} else {	/* No S/G data transfer */
-			dma_handle = pci_map_single(ha->pdev,
-					cmd->request_buffer,
-					cmd->request_bufflen,
-					cmd->sc_data_direction);
-			sp->saved_dma_handle = dma_handle;
-
-			*dword_ptr++ = cpu_to_le32(pci_dma_lo32(dma_handle));
-			*dword_ptr = cpu_to_le32(cmd->request_bufflen);
+			remseg -= cnt;
+			dprintk(5, "qla1280_32bit_start_scsi: "
+				"continuation packet data - "
+				"scsi(%i:%i:%i)\n", SCSI_BUS_32(cmd),
+				SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
+			qla1280_dump_buffer(5, (char *)pkt,
+					    REQUEST_ENTRY_SIZE);
 		}
 	} else {	/* No data transfer at all */
 		dprintk(5, "qla1280_32bit_start_scsi: No data, command "
@@ -4086,9 +4031,9 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 	for (i = 0; i < cmd->cmd_len; i++) {
 		printk("0x%02x ", cmd->cmnd[i]);
 	}
-	printk("  seg_cnt =%d\n", cmd->use_sg);
+	printk("  seg_cnt =%d\n", scsi_sg_count(cmd));
 	printk("  request buffer=0x%p, request buffer len=0x%x\n",
-	       cmd->request_buffer, cmd->request_bufflen);
+	       scsi_sglist(cmd), scsi_bufflen(cmd));
 	/* if (cmd->use_sg)
 	   {
 	   sg = (struct scatterlist *) cmd->request_buffer;
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 5e46d84..e606cf0 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -268,7 +268,7 @@ int sun3scsi_detect(struct scsi_host_template * tpnt)
         ((struct NCR5380_hostdata *)instance->hostdata)->ctrl = 0;
 
 	if (request_irq(instance->irq, scsi_sun3_intr,
-			     0, "Sun3SCSI-5380", NULL)) {
+			     0, "Sun3SCSI-5380", instance)) {
 #ifndef REAL_DMA
 		printk("scsi%d: IRQ%d not free, interrupts disabled\n",
 		       instance->host_no, instance->irq);
@@ -310,7 +310,7 @@ int sun3scsi_detect(struct scsi_host_template * tpnt)
 int sun3scsi_release (struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
-		free_irq (shpnt->irq, NULL);
+		free_irq(shpnt->irq, shpnt);
 
 	iounmap((void *)sun3_scsi_regp);
 
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index 7cb4a31..02d9727 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -230,7 +230,7 @@ static int sun3scsi_detect(struct scsi_host_template * tpnt)
         ((struct NCR5380_hostdata *)instance->hostdata)->ctrl = 0;
 
 	if (request_irq(instance->irq, scsi_sun3_intr,
-			     0, "Sun3SCSI-5380VME", NULL)) {
+			0, "Sun3SCSI-5380VME", instance)) {
 #ifndef REAL_DMA
 		printk("scsi%d: IRQ%d not free, interrupts disabled\n",
 		       instance->host_no, instance->irq);
@@ -279,7 +279,7 @@ static int sun3scsi_detect(struct scsi_host_template * tpnt)
 int sun3scsi_release (struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
-		free_irq (shpnt->irq, NULL);
+		free_irq(shpnt->irq, shpnt);
 
 	iounmap((void *)sun3_scsi_regp);
 
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index 248d60b..041eaaa 100644
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -259,7 +259,8 @@ found:
 	    instance->irq = NCR5380_probe_irq(instance, T128_IRQS);
 
 	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, t128_intr, IRQF_DISABLED, "t128", instance)) {
+	    if (request_irq(instance->irq, t128_intr, IRQF_DISABLED, "t128",
+			    instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
 		instance->irq = SCSI_IRQ_NONE;
@@ -295,7 +296,7 @@ static int t128_release(struct Scsi_Host *shost)
 	NCR5380_local_declare();
 	NCR5380_setup(shost);
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);


