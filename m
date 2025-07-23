Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F42A1F4190;
	Wed, 23 Jul 2025 20:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753302372; cv=none; b=PeTDFbQGGN2DVYpGaTxwWiVIU5Uyvi6NHylMu4nI3UIVu09A1eUDf67r3Ij4XWCvimTWYK/MA/i9tQ01Z/5dFuh+sz4VWY/YoMl1ewm0DbU9ZQXPSutjJqw4bQAh0S2mUL8/eaeHU9whaqpsW7qHLIyPhnPih6ofk5MwftHmKhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753302372; c=relaxed/simple;
	bh=L6C3ZXS7OYXdygUrvLhsmQ2vg5HfbHLfxImXH9n5XbY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gj3hsnlV8tDsbqhb/HYLWEYMS/KdD9b31SEMIMDBMLtbGNmKzyVbgaMTfMLWH8cZjJQ5+n2S3SRHUySKgpmL/2GHBm8hbxbeT5XTFiOHOSbS+HfHh7L4lBcWL4subibgC2gfpoNMIXsCgfoqMncNiaGzGyFcx4ImrM7U3wwIio8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q8zGXiSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q8zGXiSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6E0C4CEE7;
	Wed, 23 Jul 2025 20:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753302371;
	bh=L6C3ZXS7OYXdygUrvLhsmQ2vg5HfbHLfxImXH9n5XbY=;
	h=From:To:Cc:Subject:Date:From;
	b=q8zGXiSV90RwYPHuqt8Obnaws9RbhySBVi0Q65cHmLhDLmKaWI0PbVAOt9gwgjYlU
	 U/djty3NOeLGIPAbfcgycbSktukOi8j3TuhnRvgE31el3+HQuwAPg8w4efQk0AjKKD
	 /6hGcPYwvJE3ngX8OG5OXW5azFRjoYuOkqBF/7UWwuBFB88tEgxVyNA9Ki/NUThkR/
	 ZuFRNz+6oAZj0xWuaGu3N2LSggxPJMQPW8DHFPU3+mP0FnnJgTTXyznv/IZgeBQBpC
	 V8l+WcB58TpAwwkvh4q8TrRSeJ8dJyyEoVAIGERzDNm38g56y2KzGM2kh3rEz0JAA7
	 K/tebTqnxzc4g==
From: Bjorn Helgaas <helgaas@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] scsi: Fix typos
Date: Wed, 23 Jul 2025 15:26:06 -0500
Message-ID: <20250723202608.2909276-1-helgaas@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bjorn Helgaas <bhelgaas@google.com>

Fix typos, most reported by "codespell drivers/scsi".  Mostly touches
comments, no code changes except SCU_LINK_STATUS_DWORD_SYNC_AQUIRED_*,
which is defined but never used.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/scsi/aacraid/commsup.c              |  2 +-
 drivers/scsi/aic7xxx/aic79xx.h              |  4 +--
 drivers/scsi/aic7xxx/aic79xx.seq            |  2 +-
 drivers/scsi/aic7xxx/aic7xxx.h              |  4 +--
 drivers/scsi/aic7xxx/aic7xxx.seq            |  6 ++---
 drivers/scsi/bfa/bfa_fc.h                   |  2 +-
 drivers/scsi/bfa/bfa_fcs_rport.c            |  4 +--
 drivers/scsi/bnx2i/bnx2i_sysfs.c            |  2 +-
 drivers/scsi/esas2r/esas2r_init.c           |  2 +-
 drivers/scsi/fcoe/fcoe.c                    |  2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c               |  4 +--
 drivers/scsi/fnic/fdls_disc.c               |  4 +--
 drivers/scsi/isci/host.h                    |  2 +-
 drivers/scsi/isci/registers.h               |  4 +--
 drivers/scsi/isci/remote_device.h           |  2 +-
 drivers/scsi/isci/remote_node_context.h     |  2 +-
 drivers/scsi/isci/request.c                 |  2 +-
 drivers/scsi/isci/task.c                    |  2 +-
 drivers/scsi/lpfc/lpfc_els.c                |  4 +--
 drivers/scsi/megaraid/megaraid_mbox.c       |  2 +-
 drivers/scsi/megaraid/megaraid_mm.c         |  2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  4 +--
 drivers/scsi/mvsas/mv_sas.h                 |  2 +-
 drivers/scsi/pm8001/pm8001_hwi.h            |  4 +--
 drivers/scsi/pm8001/pm80xx_hwi.h            |  4 +--
 drivers/scsi/pmcraid.c                      |  4 +--
 drivers/scsi/qla1280.c                      |  2 +-
 drivers/scsi/qla2xxx/qla_bsg.h              |  6 ++---
 drivers/scsi/qla2xxx/qla_iocb.c             |  2 +-
 drivers/scsi/qla2xxx/qla_mr.h               |  8 +++---
 drivers/scsi/qla2xxx/qla_sup.c              |  2 +-
 drivers/scsi/qla2xxx/qla_target.c           | 30 ++++++++++-----------
 drivers/scsi/qla2xxx/qla_target.h           |  2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c          |  2 +-
 drivers/scsi/scsi_transport_iscsi.c         |  2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c         |  2 +-
 include/scsi/scsi_transport_fc.h            |  2 +-
 37 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 7d9a4dce236b..3080b0bfc8fa 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2292,7 +2292,7 @@ static int aac_send_hosttime(struct aac_dev *dev, struct timespec64 *now)
  *	aac_command_thread	-	command processing thread
  *	@data: Adapter to monitor
  *
- *	Waits on the commandready event in it's queue. When the event gets set
+ *	Waits on the commandready event in its queue. When the event gets set
  *	it will pull FIBs off it's queue. It will continue to pull FIBs off
  *	until the queue is empty. When the queue is empty it will wait for
  *	more FIBs.
diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index 59e9321815c8..9d7a3601c174 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -837,8 +837,8 @@ struct seeprom_config {
  * BIOS Control Bits
  */
 	uint16_t bios_control;		/* word 16 */
-#define		CFSUPREM	0x0001	/* support all removeable drives */
-#define		CFSUPREMB	0x0002	/* support removeable boot drives */
+#define		CFSUPREM	0x0001	/* support all removable drives */
+#define		CFSUPREMB	0x0002	/* support removable boot drives */
 #define		CFBIOSSTATE	0x000C	/* BIOS Action State */
 #define		    CFBS_DISABLED	0x00
 #define		    CFBS_ENABLED	0x04
diff --git a/drivers/scsi/aic7xxx/aic79xx.seq b/drivers/scsi/aic7xxx/aic79xx.seq
index 3a36d9362a10..fc2bb5eba6c3 100644
--- a/drivers/scsi/aic7xxx/aic79xx.seq
+++ b/drivers/scsi/aic7xxx/aic79xx.seq
@@ -1036,7 +1036,7 @@ p_mesgin:
 
 /*
  * Pushed message loop to allow the kernel to
- * run it's own message state engine.  To avoid an
+ * run its own message state engine.  To avoid an
  * extra nop instruction after signaling the kernel,
  * we perform the phase_lock before checking to see
  * if we should exit the loop and skip the phase_lock
diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index 20857c213c72..814beb07741f 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -785,8 +785,8 @@ struct seeprom_config {
  * BIOS Control Bits
  */
 	uint16_t bios_control;		/* word 16 */
-#define		CFSUPREM	0x0001	/* support all removeable drives */
-#define		CFSUPREMB	0x0002	/* support removeable boot drives */
+#define		CFSUPREM	0x0001	/* support all removable drives */
+#define		CFSUPREMB	0x0002	/* support removable boot drives */
 #define		CFBIOSEN	0x0004	/* BIOS enabled */
 #define		CFBIOS_BUSSCAN	0x0008	/* Have the BIOS Scan the Bus */
 #define		CFSM2DRV	0x0010	/* support more than two drives */
diff --git a/drivers/scsi/aic7xxx/aic7xxx.seq b/drivers/scsi/aic7xxx/aic7xxx.seq
index e60041e8f2d1..6b639ae405d9 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.seq
+++ b/drivers/scsi/aic7xxx/aic7xxx.seq
@@ -319,7 +319,7 @@ ident_messages_done_msg_pending:
 
 		/*
 		 * Pushed message loop to allow the kernel to
-		 * run it's own target mode message state engine.
+		 * run its own target mode message state engine.
 		 */
 host_target_message_loop:
 		mvi	HOST_MSG_LOOP call set_seqint;
@@ -1442,7 +1442,7 @@ p_command_xfer:
 		test	SSTAT0, SDONE jnz . + 2;
 		test    SSTAT1, PHASEMIS jz . - 1;
 		/*
-		 * Wait for our ACK to go-away on it's own
+		 * Wait for our ACK to go-away on its own
 		 * instead of being killed by SCSIEN getting cleared.
 		 */
 		test	SCSISIGI, ACKI jnz .;
@@ -1564,7 +1564,7 @@ p_mesgin:
 
 /*
  * Pushed message loop to allow the kernel to
- * run it's own message state engine.  To avoid an
+ * run its own message state engine.  To avoid an
  * extra nop instruction after signaling the kernel,
  * we perform the phase_lock before checking to see
  * if we should exit the loop and skip the phase_lock
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index 1091aa428533..8a78bf945f70 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -462,7 +462,7 @@ struct fc_rsi_s {
 };
 
 /*
- * structure for PRLI paramater pages, both request & response
+ * structure for PRLI parameter pages, both request & response
  * see FC-PH-X table 113 & 115 for explanation also FCP table 8
  */
 struct fc_prli_params_s {
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index d4bde9bbe75b..1743fad24170 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1987,8 +1987,8 @@ bfa_fcs_rport_gidpn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			/*
 			 * Device's PID has changed. We need to cleanup
 			 * and re-login. If there is another device with
-			 * the the newly discovered pid, send an scn notice
-			 * so that its new pid can be discovered.
+			 * the newly discovered PID, send an scn notice
+			 * so that its new PID can be discovered.
 			 */
 			list_for_each(qe, &rport->port->rport_q) {
 				twin = (struct bfa_fcs_rport_s *) qe;
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index d6b0bbb5176b..2bbbb4ba1ec3 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -33,7 +33,7 @@ static inline struct bnx2i_hba *bnx2i_dev_to_hba(struct device *dev)
  * @attr:	device attribute (unused)
  * @buf:	buffer to return current SQ size parameter
  *
- * Returns current SQ size parameter, this paramater determines the number
+ * Returns current SQ size parameter, this parameter determines the number
  * outstanding iSCSI commands supported on a connection
  */
 static ssize_t bnx2i_show_sq_info(struct device *dev,
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 04a07fe57be2..7668825361da 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -673,7 +673,7 @@ static int __maybe_unused esas2r_resume(struct device *dev)
 		goto error_exit;
 	}
 
-	/* Set up interupt mode */
+	/* Set up interrupt mode */
 	esas2r_setup_interrupts(a, a->intr_mode);
 
 	/*
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index b911fdb387f3..dfe404eb0383 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1418,7 +1418,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	/*
 	 * We now have a valid CPU that we're targeting for
 	 * this skb. We also have this receive thread locked,
-	 * so we're free to queue skbs into it's queue.
+	 * so we're free to queue skbs into its queue.
 	 */
 
 	/*
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 8e4241c295e3..e270d805ff72 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -205,7 +205,7 @@ static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
 		 * that doesn't have a priv (fcf was deleted). However,
 		 * libfcoe will always delete FCFs before trying to add
 		 * them. This is ensured because both recv_adv and
-		 * age_fcfs are protected by the the fcoe_ctlr's mutex.
+		 * age_fcfs are protected by the fcoe_ctlr's mutex.
 		 * This means that we should never get a FCF with a
 		 * non-NULL priv pointer.
 		 */
@@ -689,7 +689,7 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
  *
  * The caller must check that the length is a multiple of 4.
  * The SKB must have enough headroom (28 bytes) and tailroom (8 bytes).
- * The the skb must also be an fc_frame.
+ * The SKB must also be an fc_frame.
  *
  * This is called from the lower-level driver with spinlocks held,
  * so we must not take a mutex here.
diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index f8ab69c51dab..13eb21de4895 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -1512,7 +1512,7 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
  * @iport: Handle to fnic iport
  *
  * This function does not change or check the fabric state.
- * It the caller's responsibility to set the appropriate iport fabric
+ * It's the caller's responsibility to set the appropriate iport fabric
  * state when this is called. Normally it is FDLS_STATE_FABRIC_LOGO.
  * Currently this assumes to be called with fnic lock held.
  */
@@ -1568,7 +1568,7 @@ void fdls_send_fabric_logo(struct fnic_iport_s *iport)
  * @tport: Handle to remote port
  *
  * This function does not change or check the fabric/tport state.
- * It the caller's responsibility to set the appropriate tport/fabric
+ * It's the caller's responsibility to set the appropriate tport/fabric
  * state when this is called. Normally that is fdls_tgt_state_plogo.
  * This could be used to send plogo to nameserver process
  * also not just target processes
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 52388374cf31..e4971ca00769 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -244,7 +244,7 @@ enum sci_controller_states {
 	SCIC_INITIALIZED,
 
 	/**
-	 * This state indicates the the controller is in the process of becoming
+	 * This state indicates the controller is in the process of becoming
 	 * ready (i.e. starting).  In this state no new IO operations are permitted.
 	 * This state is entered from the INITIALIZED state.
 	 */
diff --git a/drivers/scsi/isci/registers.h b/drivers/scsi/isci/registers.h
index 63468cfe3e4a..963a21fef0e7 100644
--- a/drivers/scsi/isci/registers.h
+++ b/drivers/scsi/isci/registers.h
@@ -621,8 +621,8 @@ struct scu_iit_entry {
 	SCU_GEN_VALUE(SCU_LINK_LAYER_SPEED_NEGOTIATION_TIMER_VALUES_ ## name, value)
 
 
-#define SCU_LINK_STATUS_DWORD_SYNC_AQUIRED_SHIFT            (2)
-#define SCU_LINK_STATUS_DWORD_SYNC_AQUIRED_MASK             (0x00000004)
+#define SCU_LINK_STATUS_DWORD_SYNC_ACQUIRED_SHIFT           (2)
+#define SCU_LINK_STATUS_DWORD_SYNC_ACQUIRED_MASK            (0x00000004)
 #define SCU_LINK_STATUS_TRANSMIT_PORT_SELECTION_DONE_SHIFT  (4)
 #define SCU_LINK_STATUS_TRANSMIT_PORT_SELECTION_DONE_MASK   (0x00000010)
 #define SCU_LINK_STATUS_RECEIVER_CREDIT_EXHAUSTED_SHIFT     (5)
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index c1fdf45751cd..0ab1db862de3 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -170,7 +170,7 @@ enum sci_status sci_remote_device_stop(
  * permitted.  This state is entered from the INITIAL state.  This state
  * is entered from the STOPPING state.
  *
- * @SCI_DEV_STARTING: This state indicates the the remote device is in
+ * @SCI_DEV_STARTING: This state indicates the remote device is in
  * the process of becoming ready (i.e. starting).  In this state no new
  * IO operations are permitted.  This state is entered from the STOPPED
  * state.
diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index c7ee81d01125..f22950b12b8b 100644
--- a/drivers/scsi/isci/remote_node_context.h
+++ b/drivers/scsi/isci/remote_node_context.h
@@ -154,7 +154,7 @@ enum sci_remote_node_context_destination_state {
 /**
  * struct sci_remote_node_context - This structure contains the data
  *    associated with the remote node context object.  The remote node context
- *    (RNC) object models the the remote device information necessary to manage
+ *    (RNC) object models the remote device information necessary to manage
  *    the silicon RNC.
  */
 struct sci_remote_node_context {
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 355a0bc0828e..38068aa05102 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -3262,7 +3262,7 @@ sci_io_request_construct_smp(struct device *dev,
 	/*
 	 * 18h ~ 30h, protocol specific
 	 * since commandIU has been build by framework at this point, we just
-	 * copy the frist DWord from command IU to this location. */
+	 * copy the first DWord from command IU to this location. */
 	memcpy(&task_context->type.smp, &cmd, sizeof(u32));
 
 	/*
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 3a25b1a2c52d..aeb2cda92465 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -67,7 +67,7 @@
 /**
 * isci_task_refuse() - complete the request to the upper layer driver in
 *     the case where an I/O needs to be completed back in the submit path.
-* @ihost: host on which the the request was queued
+* @ihost: host on which the request was queued
 * @task: request to complete
 * @response: response code for the completed task.
 * @status: status code for the completed task.
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b1a61eca8295..07ab8a42ab92 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3066,8 +3066,8 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	/* Cleanup path for failed REG_RPI handling. If REG_RPI fails, the
 	 * driver sends a LOGO to the rport to cleanup.  For fabric and
-	 * initiator ports cleanup the node as long as it the node is not
-	 * register with the transport.
+	 * initiator ports cleanup the node as long as the node is not
+	 * registered with the transport.
 	 */
 	if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
 		clear_bit(NLP_NPR_2B_DISC, &ndlp->nlp_flag);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index b610cad83321..22125ce7c98f 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2506,7 +2506,7 @@ megaraid_abort_handler(struct scsi_cmnd *scp)
  * @scp		: reference command
  *
  * Reset handler for the mailbox based controller. First try to find out if
- * the FW is still live, in which case the outstanding commands counter mut go
+ * the FW is still live, in which case the outstanding commands counter must go
  * down to 0. If that happens, also issue the reservation reset command to
  * relinquish (possible) reservations on the logical drives connected to this
  * host.
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 87184e2538b0..f31270134b78 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -502,7 +502,7 @@ mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
  * First we search for a pool with smallest buffer that is >= @xferlen. If
  * that pool has no free buffer, we will try for the next bigger size. If none
  * is available, we will try to allocate the smallest buffer that is >=
- * @xferlen and attach it the pool.
+ * @xferlen and attach it to the pool.
  */
 static int
 mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t *kioc, int xferlen)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a6794f49e9fa..40df7a38e1a8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2554,14 +2554,14 @@ megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
 }
 
 /**
- * megasas_stream_detect -	stream detection on read and and write IOs
+ * megasas_stream_detect -	stream detection on read and write IOs
  * @instance:		Adapter soft state
  * @cmd:		    Command to be prepared
  * @io_info:		IO Request info
  *
  */
 
-/** stream detection on read and and write IOs */
+/** stream detection on read and write IOs */
 static void megasas_stream_detect(struct megasas_instance *instance,
 				  struct megasas_cmd_fusion *cmd,
 				  struct IO_REQUEST_INFO *io_info)
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 09ce3f2241f2..ed921b9dfebe 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -236,7 +236,7 @@ struct mvs_device {
 	u16 reserved;
 };
 
-/* Generate  PHY tunning parameters */
+/* Generate  PHY tuning parameters */
 struct phy_tuning {
 	/* 1 bit,  transmitter emphasis enable	*/
 	u8	trans_emp_en:1;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index fc2127dcb58d..d408c0de9aa1 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -844,8 +844,8 @@ struct set_dev_state_resp {
 					interrupt vector */
 /* bit definition for ODCR register */
 #define ODCR_CLEAR_ALL		0xFFFFFFFF   /* mask all
-					interrupt vector*/
-/* MSIX Interupts */
+					interrupt vector */
+/* MSI-X Interrupts */
 #define MSIX_TABLE_OFFSET		0x2000
 #define MSIX_TABLE_ELEMENT_SIZE		0x10
 #define MSIX_INTERRUPT_CONTROL_OFFSET	0xC
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index eb8fd37b2066..e4811ea5759a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1384,8 +1384,8 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 					interrupt vector */
 /* bit definition for ODCR register */
 #define ODCR_CLEAR_ALL			0xFFFFFFFF /* mask all
-					interrupt vector*/
-/* MSIX Interupts */
+					interrupt vector */
+/* MSI-X Interrupts */
 #define MSIX_TABLE_OFFSET		0x2000
 #define MSIX_TABLE_ELEMENT_SIZE		0x10
 #define MSIX_INTERRUPT_CONTROL_OFFSET	0xC
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 33f403e307eb..2bc421e734fa 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -376,7 +376,7 @@ static struct pmcraid_cmd *pmcraid_get_free_cmd(
 	}
 	spin_unlock_irqrestore(&pinstance->free_pool_lock, lock_flags);
 
-	/* Initialize the command block before giving it the caller */
+	/* Initialize the command block before giving it to the caller */
 	if (cmd != NULL)
 		pmcraid_reinit_cmdblk(cmd);
 	return cmd;
@@ -5051,7 +5051,7 @@ static void pmcraid_init_res_table(struct pmcraid_cmd *cmd)
 			}
 		}
 
-		/* If this is new entry, initialize it and add it the queue */
+		/* If this is new entry, initialize and add it to the queue */
 		if (!found) {
 
 			if (list_empty(&pinstance->free_res_q)) {
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 6af018f1ca22..d609fa581398 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4259,7 +4259,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto error_release_region;
 	}
 
-	/* load the F/W, read paramaters, and init the H/W */
+	/* load the F/W, read parameters, and init the H/W */
 	if (qla1280_initialize_adapter(ha)) {
 		printk(KERN_INFO "qla1x160: Failed to initialize adapter\n");
 		goto error_free_irq;
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index d38dab0a07e8..154bb338508d 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -65,11 +65,11 @@
 #define EXT_STATUS_DPORT_DIAG_IN_PROCESS	41
 #define EXT_STATUS_DPORT_DIAG_NOT_RUNNING	42
 
-/* BSG definations for interpreting CommandSent field */
+/* BSG definitions for interpreting CommandSent field */
 #define INT_DEF_LB_LOOPBACK_CMD         0
 #define INT_DEF_LB_ECHO_CMD             1
 
-/* Loopback related definations */
+/* Loopback related definitions */
 #define INTERNAL_LOOPBACK		0xF1
 #define EXTERNAL_LOOPBACK		0xF2
 #define ENABLE_INTERNAL_LOOPBACK	0x02
@@ -78,7 +78,7 @@
 #define MAX_ELS_FRAME_PAYLOAD		252
 #define ELS_OPCODE_BYTE			0x10
 
-/* BSG Vendor specific definations */
+/* BSG Vendor specific definitions */
 #define A84_ISSUE_WRITE_TYPE_CMD        0
 #define A84_ISSUE_READ_TYPE_CMD         1
 #define A84_CLEANUP_CMD                 2
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 3224044f1775..d4a02221ad9f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -568,7 +568,7 @@ qla2x00_marker(struct scsi_qla_host *vha, struct qla_qpair *qpair,
  *
  * Issue marker
  * Caller CAN have hardware lock held as specified by ha_locked parameter.
- * Might release it, then reaquire.
+ * Might release it, then reacquire.
  */
 int qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
 {
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 3a2bd953a976..464d2e9a93d8 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -497,14 +497,14 @@ struct mr_data_fx00 {
 /*
  * SoC Junction Temperature is stored in
  * bits 9:1 of SoC Junction Temperature Register
- * in a firmware specific format format.
+ * in a firmware specific format.
  * To get the temperature in Celsius degrees
- * the value from this bitfiled should be converted
+ * the value from this bitfield should be converted
  * using this formula:
  * Temperature (degrees C) = ((3,153,000 - (10,000 * X)) / 13,825)
  * where X is the bit field value
  * this macro reads the register, extracts the bitfield value,
- * performs the calcualtions and returns temperature in Celsius
+ * performs the calculations and returns temperature in Celsius
  */
 #define QLAFX00_GET_TEMPERATURE(ha) ((3153000 - (10000 * \
 	((QLAFX00_RD_REG(ha, QLAFX00_SOC_TEMP_REG) & 0x3FE) >> 1))) / 13825)
@@ -520,7 +520,7 @@ struct mr_data_fx00 {
 
 #define QLAFX00_CRITEMP_THRSHLD		80	/* Celsius degrees */
 
-/* Max conncurrent IOs that can be queued */
+/* Max concurrent IOs that can be queued */
 #define QLAFX00_MAX_CANQUEUE		1024
 
 /* IOCTL IOCB abort success */
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 9e7a407ba1b9..72ed61b74c40 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -692,7 +692,7 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 	uint32_t start;
 
 	/* Assign FCP prio region since older adapters may not have FLT, or
-	   FCP prio region in it's FLT.
+	   FCP prio region in its FLT.
 	 */
 	ha->flt_region_fcp_prio = (ha->port_no == 0) ?
 	    fcp_prio_cfg0[def] : fcp_prio_cfg1[def];
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1e81582085e3..067b0c71be8a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -160,7 +160,7 @@ void qlt_do_generation_tick(struct scsi_qla_host *vha, int *dest)
 	wmb();
 }
 
-/* Might release hw lock, then reaquire!! */
+/* Might release hw lock, then reacquire!! */
 static inline int qlt_issue_marker(struct scsi_qla_host *vha, int vha_locked)
 {
 	/* Send marker if required */
@@ -1422,7 +1422,7 @@ static struct fc_port *qlt_create_sess(
 		kref_init(&fcport->sess_kref);
 		/*
 		 * Take an extra reference to ->sess_kref here to handle
-		 * fc_port access across ->tgt.sess_lock reaquire.
+		 * fc_port access across ->tgt.sess_lock reacquire.
 		 */
 		if (!kref_get_unless_zero(&sess->sess_kref)) {
 			ql_dbg(ql_dbg_disc, vha, 0x20f7,
@@ -1654,7 +1654,7 @@ static int qlt_sched_sess_work(struct qla_tgt *tgt, int type,
 }
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  */
 static void qlt_send_notify_ack(struct qla_qpair *qpair,
 	struct imm_ntfy_from_isp *ntfy,
@@ -1807,7 +1807,7 @@ static int qlt_build_abts_resp_iocb(struct qla_tgt_mgmt_cmd *mcmd)
 }
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  */
 static void qlt_24xx_send_abts_resp(struct qla_qpair *qpair,
 	struct abts_recv_from_24xx *abts, uint32_t status,
@@ -1880,7 +1880,7 @@ static void qlt_24xx_send_abts_resp(struct qla_qpair *qpair,
 }
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  */
 static void qlt_24xx_retry_term_exchange(struct scsi_qla_host *vha,
     struct qla_qpair *qpair, response_t *pkt, struct qla_tgt_mgmt_cmd *mcmd)
@@ -2120,7 +2120,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 }
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  */
 static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct abts_recv_from_24xx *abts)
@@ -2191,7 +2191,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 }
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  */
 static void qlt_24xx_send_task_mgmt_ctio(struct qla_qpair *qpair,
 	struct qla_tgt_mgmt_cmd *mcmd, uint32_t resp_code)
@@ -2495,7 +2495,7 @@ static int qlt_check_reserve_free_req(struct qla_qpair *qpair,
 }
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  */
 static inline void *qlt_get_req_pkt(struct req_que *req)
 {
@@ -3549,7 +3549,7 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 	}
 }
 
-/* If hardware_lock held on entry, might drop it, then reaquire */
+/* If hardware_lock held on entry, might drop it, then reacquire */
 /* This function sends the appropriate CTIO to ISP 2xxx or 24xx */
 static int __qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 	struct imm_ntfy_from_isp *ntfy)
@@ -3611,7 +3611,7 @@ static void qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 }
 
 /*
- * If hardware_lock held on entry, might drop it, then reaquire
+ * If hardware_lock held on entry, might drop it, then reacquire
  * This function sends the appropriate CTIO to ISP 2xxx or 24xx
  */
 static int __qlt_send_term_exchange(struct qla_qpair *qpair,
@@ -3824,7 +3824,7 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 EXPORT_SYMBOL(qlt_free_cmd);
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  */
 static int qlt_term_ctio_exchange(struct qla_qpair *qpair, void *ctio,
 	struct qla_tgt_cmd *cmd, uint32_t status)
@@ -3910,7 +3910,7 @@ static void *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 }
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  */
 static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
     struct rsp_que *rsp, uint32_t handle, uint32_t status, void *ctio)
@@ -4900,7 +4900,7 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 }
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  */
 static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	struct imm_ntfy_from_isp *iocb)
@@ -5338,7 +5338,7 @@ static void qlt_handle_imm_notify(struct scsi_qla_host *vha,
 }
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  * This function sends busy to ISP 2xxx or 24xx.
  */
 static int __qlt_send_busy(struct qla_qpair *qpair,
@@ -5890,7 +5890,7 @@ static void qlt_response_pkt(struct scsi_qla_host *vha,
 }
 
 /*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
  */
 void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	uint16_t *mailbox)
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 15a59c125c53..4b907046ec29 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -793,7 +793,7 @@ struct qla_tgt {
 	struct qla_qpair_hint *qphints;
 	/*
 	 * To sync between IRQ handlers and qlt_target_release(). Needed,
-	 * because req_pkt() can drop/reaquire HW lock inside. Protected by
+	 * because req_pkt() can drop/reacquire HW lock inside. Protected by
 	 * HW lock.
 	 */
 	int atio_irq_cmd_count;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index ceaf1c7b1d17..34f479d54eae 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1423,7 +1423,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 		return -EINVAL;
 	}
 	/*
-	 * Format the FCP Initiator port_name into colon seperated values to
+	 * Format the FCP Initiator port_name into colon separated values to
 	 * match the format by tcm_qla2xxx explict ConfigFS NodeACLs.
 	 */
 	memset(&port_name, 0, 36);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0b8c91bf793f..12e3fc7fed69 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2173,7 +2173,7 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 
 	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
 	/*
-	 * qla4xxx can perform it's own scans when it runs in kernel only
+	 * qla4xxx can perform its own scans when it runs in kernel only
 	 * mode. Make sure to flush those scans.
 	 */
 	flush_work(&session->scan_work);
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index f0db17e34ea0..0ea44b05ec4f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -5052,7 +5052,7 @@ static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, u_char ln)
 	int i;
 
 	/*
-	 *  Allocate the task table and and the tag allocation 
+	 *  Allocate the task table and the tag allocation
 	 *  circular buffer. We want both or none.
 	 */
 	lp->itlq_tbl = sym_calloc_dma(SYM_CONF_MAX_TASK*4, "ITLQ_TBL");
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index d02b55261307..fc88da37cc66 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -194,7 +194,7 @@ struct fc_vport_identifiers {
  * ports share the physical link with the Physical port. Each virtual
  * ports has a unique presence on the SAN, and may be instantiated via
  * NPIV, Virtual Fabrics, or via additional ALPAs. As the vport is a
- * unique presence, each vport has it's own view of the fabric,
+ * unique presence, each vport has its own view of the fabric,
  * authentication privilege, and priorities.
  *
  * A virtual port may support 1 or more FC4 roles. Typically it is a
-- 
2.43.0

