Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F4E480328
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 11:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521195; cv=none; b=GNrdfdUDOnvc3PoCfG3pDFWU+2baQLzJ++7+ntJY7pa/iAx+lUmGZu/WA89iFA4VNMp0jMs9x7PkXX3xUIqOvbBBtb0Ii9KHYHnltiEEfkpO04t6SLyyMVCPewUYbABCvg2C++2t4xGYTY+YfQ25PXur58sCMSy/lJyEgtAm/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521195; c=relaxed/simple;
	bh=hT5k6cyZeDMooh/0qvkIqLlW1BpeBZY33X1UEatweGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NojO3eHpXgyXQpad3N+e1MU1vEycDuLhXq67fS3OKrUHGSDxQeem8U8XcDZSjDcBsU/9yvDaGHdlRDAwrT22db/9gVnvooyz7xlFxou1tQflHmLi5fIsJKq1uBr/P/Uwe9MFlQ7CW9HqiTtPGBm2k1t3byn60T+ojFjF93MZPZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DWkxiy9Y; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DWkxiy9Y"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so809006a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 04:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788521192; x=1789125992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZB5xgFs2rIaPu37zzhEnQSlnutqDH592OYaPBeZ04QI=;
        b=DWkxiy9Yj6ByB0k98565PTzzvUshh+j+SblOIusdIkMuEoBmchSHWVGD7ipmMBugh6
         UNqvEM5pwQapfPrjgNYpWQeFrPf0VbXmRSzrLNcMhlzvQ2oGladPqUNv1d+s1LEs1rpM
         A9aITyPLpn+QR4SGlq4t9NChs/tp9gHe6uL34gpVN1E/sfOTvsCw/Ibo0sUGBxOlYYfK
         oBhYLI2P/o8U57z3s6TMmPsZP65ibkQXJhCIfjRQWug93inDWClxxGK/qs/TkH9N8Sp+
         Gbwd/yIj0VWbXYr4nh1N82SUAuR4cekPl8Vt/45zN12kpOv6v5gkA9ahgjuRddBIWUo6
         L8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788521192; x=1789125992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZB5xgFs2rIaPu37zzhEnQSlnutqDH592OYaPBeZ04QI=;
        b=tMyJwMO8g4lNZe5L+WiPWQEUqhBGgPRq9+ZLFIKhoEJ+Au66dmSSP6Y+W7WIMBWyCQ
         H5Mlx6+jiUoKHvnRrtDFPvCDtkqMmFG9qpDkmD90mhxwbX96zQD65e+X1kAjQazwwF3b
         ZeySvP0V0QhniYPPM5woLDVtPY1ZHNPBoroq6aQFs9CQWwdq4T24FPqgNPEhDYZMryzI
         x70wbIfvt36IN9LjFnGoGG1jEIaXR5sNySmtgHII5VYAHmdI8Avu/9HWJffBMrNDcGRl
         I1Pp2OBX6PiQIRG7H5LR5YTbTm0cXSO8tfVplceWbSQUMMtc1u437FGj4737LSyEFRsr
         PS1g==
X-Forwarded-Encrypted: i=1; AKwUvBy6DTugW5vHfSmTK5CdL7yr2pxoPmqlKt0T+cuNNC2nqQaqNQiDdJGaUEBmoHWDWZYpkMZibrxCOZJJ@vger.kernel.org
X-Gm-Message-State: AFuF++laZTK4mcgVHd321yPtOUjTeydejEZxFY5Up9tFmLaAeqjehGh6
	Q91F34iSk0SHSLgm2tL+BBEDdh2wihaoMgXNTPaHl+5RbPpPCS9BCCU3
X-Gm-Gg: AYBFou2+Nw6CbojQ9oHkw2B6xykxyfAQERjeAbckQTK68535cCQx3L0/2Oe8FKfIKUr
	iEvbHzIZHckz35do/iHyEnyVIcZPzaxPXs67ZmoZuXRp3GjgZ3B0q32XrZ4TZFNAL0/F2cEKRbk
	usWluVySaOhDy8D1upSMJEctGMgd+OwwZE0naKCXwNTWUUhc2FTx2jv/87ufgRYdk2wuJWgESAZ
	ZgQOyi1osbGSoUt6SoTsXTg9jFDTnTxGfcS2Ftygz8ALe119fAOdm9lMd6Fyzw1iBKBqiTCUcYc
	HAEhjOBxSMxTKtIXQfsMBy2GeM7A9we5aNtivNh2ufADBWZCqyAhi105KAr8RkZpUFKan7q4GLD
	X36W+Jq64qTcK2GnMayZy+kvDMhOR4wQIL1Ix11fbHoTwjzOV8QEHEZuO+WrXinpms1cnFPEeaV
	FhjzeinIOj1CNAEXexJap0alB0dA0l8UmTt6Xl+p/0W23hZNPk3WBMfkDVYrufaRVbknuOGIo32
	O97y9TYxfVeUlg=
X-Received: by 2002:a17:90b:17d2:b0:380:f389:447b with SMTP id 98e67ed59e1d1-39b2613e70emr7424626a91.11.1788521192259;
        Fri, 04 Sep 2026 04:26:32 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm6698786eec.21.2026.09.04.04.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:26:31 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] scsi: isci: fix typos in comments
Date: Fri,  4 Sep 2026 16:56:17 +0530
Message-ID: <20260904112623.4208-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904112623.4208-1-hemanth.selam@gmail.com>
References: <20260904112623.4208-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/scsi/isci/host.c                      |  4 ++--
 drivers/scsi/isci/phy.h                       |  2 +-
 drivers/scsi/isci/port.c                      |  2 +-
 drivers/scsi/isci/port_config.c               |  2 +-
 drivers/scsi/isci/registers.h                 | 14 +++++++-------
 drivers/scsi/isci/remote_device.c             |  4 ++--
 drivers/scsi/isci/remote_device.h             |  2 +-
 drivers/scsi/isci/remote_node_context.h       |  2 +-
 drivers/scsi/isci/request.c                   | 12 ++++++------
 drivers/scsi/isci/scu_task_context.h          | 12 ++++++------
 drivers/scsi/isci/unsolicited_frame_control.c |  2 +-
 11 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 1592fc552e6c..bb5e6e302042 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -338,7 +338,7 @@ static void sci_controller_unsolicited_frame(struct isci_host *ihost, u32 ent)
 		if (index == SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX) {
 			/*
 			 * This is a signature fis or a frame from a direct attached SATA
-			 * device that has not yet been created.  In either case forwared
+			 * device that has not yet been created.  In either case forwarded
 			 * the frame to the PE and let it take care of the frame data. */
 			index = SCU_GET_PROTOCOL_ENGINE_INDEX(ent);
 			iphy = &ihost->phys[index];
@@ -374,7 +374,7 @@ static void sci_controller_event_completion(struct isci_host *ihost, u32 ent)
 
 	switch (scu_get_event_type(ent)) {
 	case SCU_EVENT_TYPE_SMU_COMMAND_ERROR:
-		/* / @todo The driver did something wrong and we need to fix the condtion. */
+		/* / @todo The driver did something wrong and we need to fix the condition. */
 		dev_err(&ihost->pdev->dev,
 			"%s: SCIC Controller 0x%p received SMU command error "
 			"0x%x\n",
diff --git a/drivers/scsi/isci/phy.h b/drivers/scsi/isci/phy.h
index 5aaf95b14b2e..8c90e89ccced 100644
--- a/drivers/scsi/isci/phy.h
+++ b/drivers/scsi/isci/phy.h
@@ -342,7 +342,7 @@ enum sci_phy_counter_id {
  *		     machine.
  * @SCI_PHY_STOPPED: phy has successfully been stopped.  In this state
  *		     no new IO operations are permitted on this phy.
- * @SCI_PHY_STARTING: the phy is in the process of becomming ready.  In
+ * @SCI_PHY_STARTING: the phy is in the process of becoming ready.  In
  *		      this state no new IO operations are permitted on
  *		      this phy.
  * @SCI_PHY_SUB_INITIAL: Initial state
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 0dea0abb9927..7b48d4c00036 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -666,7 +666,7 @@ static void sci_port_invalid_link_up(struct isci_port *iport, struct isci_phy *i
 	struct isci_host *ihost = iport->owning_controller;
 
 	/*
-	 * Check to see if we have alreay reported this link as bad and if
+	 * Check to see if we have already reported this link as bad and if
 	 * not go ahead and tell the SCI_USER that we have discovered an
 	 * invalid link.
 	 */
diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index d709c9df823c..4c4b23fc88a2 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -557,7 +557,7 @@ static void sci_apc_agent_configure_ports(struct isci_host *ihost,
 	/*
 	 * Check to see if the start timer operations should instead map to an
 	 * add phy operation.  This is caused because we have been waiting to
-	 * add a phy to a port but could not becuase the automatic port
+	 * add a phy to a port but could not because the automatic port
 	 * configuration engine had a choice of possible ports for the phy.
 	 * Since we have gone through a timeout we are going to restrict the
 	 * choice to the smallest possible port. */
diff --git a/drivers/scsi/isci/registers.h b/drivers/scsi/isci/registers.h
index 63468cfe3e4a..ecf3b5b2e7ca 100644
--- a/drivers/scsi/isci/registers.h
+++ b/drivers/scsi/isci/registers.h
@@ -909,13 +909,13 @@ struct scu_iit_entry {
  * To calculate the offset for other functions use
  *       BAR0 + FN# * SystemPageSize * 2
  *
- * The TCA is only accessable from FN#0 (Physical Function) and each
+ * The TCA is only accessible from FN#0 (Physical Function) and each
  * is programmed by (BAR0 + SCU_SMU_TCA_OFFSET + (FN# * 0x04)) or
  *    TCA0 for FN#0 is at BAR0 + 0x0400
  *    TCA1 for FN#1 is at BAR0 + 0x0404
  *    etc.
  * ----------------------------------------------------------------------------
- * Accessable to all FN#s */
+ * Accessible to all FN#s */
 #define SCU_SMU_PCP_OFFSET          0x0000
 #define SCU_SMU_AMR_OFFSET          0x0004
 #define SCU_SMU_ISR_OFFSET          0x0010
@@ -929,7 +929,7 @@ struct scu_iit_entry {
 #define SCU_SMU_CQPR_OFFSET         0x0040
 #define SCU_SMU_CQGR_OFFSET         0x0044
 #define SCU_SMU_CQC_OFFSET          0x0048
-/* Accessable to FN#0 only */
+/* Accessible to FN#0 only */
 #define SCU_SMU_RNCLBAR_OFFSET      0x0080
 #define SCU_SMU_RNCUBAR_OFFSET      0x0084
 #define SCU_SMU_DCC_OFFSET          0x0090
@@ -938,9 +938,9 @@ struct scu_iit_entry {
 #define SCU_SMU_SCUSRCR_OFFSET      0x009C
 #define SCU_SMU_SMAW_OFFSET         0x00A0
 #define SCU_SMU_SMDW_OFFSET         0x00A4
-/* Accessable to FN#0 only */
+/* Accessible to FN#0 only */
 #define SCU_SMU_TCA_OFFSET          0x0400
-/* Accessable to all FN#s */
+/* Accessible to all FN#s */
 #define SCU_SMU_MT_MLAR0_OFFSET     0x2000
 #define SCU_SMU_MT_MUAR0_OFFSET     0x2004
 #define SCU_SMU_MT_MDR0_OFFSET      0x2008
@@ -994,7 +994,7 @@ struct smu_registers {
 	u32 reserved_6x[4];
 	u32 reserved_7x[4];
 /*
- * Accessable to FN#0 only
+ * Accessible to FN#0 only
  * 0x0080 RNCLBAR */
 	u32 remote_node_context_lower;
 /* 0x0084 RNCUBAR */
@@ -1027,7 +1027,7 @@ struct smu_registers {
 	u32 reserved_2xx[64];
 	u32 reserved_3xx[64];
 /*
- * Accessable to FN#0 only
+ * Accessible to FN#0 only
  * 0x0400 TCA */
 	u32 task_context_assignment[256];
 /* MSI-X registers not included */
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 4c7462965ea1..33742de2e876 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -646,7 +646,7 @@ enum sci_status sci_remote_device_start_io(struct isci_host *ihost,
 		break;
 	case SCI_STP_DEV_IDLE: {
 		/* handle the start io operation for a sata device that is in
-		 * the command idle state. - Evalute the type of IO request to
+		 * the command idle state. - Evaluate the type of IO request to
 		 * be started - If its an NCQ request change to NCQ substate -
 		 * If its any other command change to the CMD substate
 		 *
@@ -964,7 +964,7 @@ static void sci_remote_device_initial_state_enter(struct sci_base_state_machine
  * successfully destructed or if some failure occurred. enum sci_status This value
  * is returned if the device is successfully destructed.
  * SCI_FAILURE_INVALID_REMOTE_DEVICE This value is returned if the supplied
- * device isn't valid (e.g. it's already been destoryed, the handle isn't
+ * device isn't valid (e.g. it's already been destroyed, the handle isn't
  * valid, etc.).
  */
 static enum sci_status sci_remote_device_destruct(struct isci_remote_device *idev)
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index c1fdf45751cd..e7c923909920 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -189,7 +189,7 @@ enum sci_status sci_remote_device_stop(
  * requests until this command is complete.
  *
  * @SCI_STP_DEV_NCQ: This is the NCQ state for the STP remote device.
- * This state is entered when the device is processing an NCQ reuqest.
+ * This state is entered when the device is processing an NCQ request.
  * It will remain in this state so long as there is one or more NCQ
  * requests being processed.
  *
diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index c7ee81d01125..e069d7ca78ef 100644
--- a/drivers/scsi/isci/remote_node_context.h
+++ b/drivers/scsi/isci/remote_node_context.h
@@ -102,7 +102,7 @@ typedef void (*scics_sds_remote_node_context_callback)(void *);
  * transition to the posting state.
  *
  * @SCI_RNC_RESUMING: transition state that will post an RNC resume to the
- * hardare.  Once the event notification of resume complete is received the
+ * hardware.  Once the event notification of resume complete is received the
  * remote node context will transition to the ready state.
  *
  * @SCI_RNC_READY: state that the remote node context must be in to accept io
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index bb89a2e33eb4..a061e2698316 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -539,7 +539,7 @@ static void scu_sata_request_construct_task_context(
 	/*
 	 * Copy the physical address for the command buffer to the SCU Task
 	 * Context. We must offset the command buffer by 4 bytes because the
-	 * first 4 bytes are transfered in the body of the TC.
+	 * first 4 bytes are transferred in the body of the TC.
 	 */
 	dma_addr = sci_io_request_get_dma_addr(ireq,
 						((char *) &ireq->stp.cmd) +
@@ -613,7 +613,7 @@ static void sci_stp_optimized_request_construct(struct isci_request *ireq,
 	/* Copy over the SGL elements */
 	sci_request_build_sgl(ireq);
 
-	/* Copy over the number of bytes to be transfered */
+	/* Copy over the number of bytes to be transferred */
 	task_context->transfer_length_bytes = len;
 
 	if (dir == DMA_TO_DEVICE) {
@@ -1310,7 +1310,7 @@ stp_request_non_data_await_h2d_tc_event(struct isci_request *ireq,
 #define SCU_MAX_FRAME_BUFFER_SIZE  0x400  /* 1K is the maximum SCU frame data payload */
 
 /* transmit DATA_FIS from (current sgl + offset) for input
- * parameter length. current sgl and offset is alreay stored in the IO request
+ * parameter length. current sgl and offset is already stored in the IO request
  */
 static enum sci_status sci_stp_request_pio_data_out_trasmit_data_frame(
 	struct isci_request *ireq,
@@ -1458,7 +1458,7 @@ static enum sci_status sci_stp_request_pio_data_in_copy_data(
 		if (status == SCI_SUCCESS)
 			stp_req->pio_len = 0;
 	} else {
-		/* We are transfering the whole frame so copy */
+		/* We are transferring the whole frame so copy */
 		status = sci_stp_request_pio_data_in_copy_data_buffer(
 			stp_req, data_buffer, SCU_MAX_FRAME_BUFFER_SIZE);
 
@@ -3298,7 +3298,7 @@ sci_io_request_construct_smp(struct device *dev,
  * @ireq: This parameter points to the isci_request allocated in the
  *    request construct function.
  *
- * SCI_SUCCESS on successfull completion, or specific failure code.
+ * SCI_SUCCESS on successful completion, or specific failure code.
  */
 static enum sci_status isci_smp_request_build(struct isci_request *ireq)
 {
@@ -3324,7 +3324,7 @@ static enum sci_status isci_smp_request_build(struct isci_request *ireq)
  * @idev: This parameter is the handle for the sci core's remote device
  *    object that is the destination for this request.
  *
- * SCI_SUCCESS on successfull completion, or specific failure code.
+ * SCI_SUCCESS on successful completion, or specific failure code.
  */
 static enum sci_status isci_io_request_build(struct isci_host *ihost,
 					     struct isci_request *request,
diff --git a/drivers/scsi/isci/scu_task_context.h b/drivers/scsi/isci/scu_task_context.h
index f258f4014e7f..ec525f76720a 100644
--- a/drivers/scsi/isci/scu_task_context.h
+++ b/drivers/scsi/isci/scu_task_context.h
@@ -171,7 +171,7 @@ typedef enum {
 #define SCU_TASK_REGULAR                  0
 #define SCU_TASK_ABORTED                  1
 
-/* direction bit defintion */
+/* direction bit definition */
 /**
  *
  *
@@ -265,7 +265,7 @@ typedef enum {
 /**
  *
  *
- * SCU_TASK_CONTEXT_PROTOCOL SCU Task context protocol types this is uesd to
+ * SCU_TASK_CONTEXT_PROTOCOL SCU Task context protocol types this is used to
  * program the SCU Task context protocol field in word 0x00.
  */
 #define SCU_TASK_CONTEXT_PROTOCOL_SMP    0x00
@@ -452,7 +452,7 @@ struct scu_sgl_element {
 /**
  * struct scu_sgl_element_pair - This structure is the SCU hardware definition
  *    of a pair of SGL elements. The SCU hardware always works on SGL pairs.
- *    They are refered to in the DS specification as SGL A and SGL B.  Each SGL
+ *    They are referred to in the DS specification as SGL A and SGL B.  Each SGL
  *    pair is followed by the address of the next pair.
  *
  *
@@ -599,7 +599,7 @@ struct scu_task_context {
 	u32 mirrored_node_index:12;
 
 	/**
-	 * This field is programmed with the direction of the SATA reqeust
+	 * This field is programmed with the direction of the SATA request
 	 *    - SCU_SATA_WRITE_DATA_DIRECTION
 	 *    - SCU_SATA_READ_DATA_DIRECTION
 	 */
@@ -671,7 +671,7 @@ struct scu_task_context {
 	u32 strict_ordering:1;
 
 	/**
-	 * This field indicates the type of endianess to be utilized for the
+	 * This field indicates the type of endianness to be utilized for the
 	 * frame.  command, task, and response frames utilized control_frame
 	 * set to 1.
 	 */
@@ -758,7 +758,7 @@ struct scu_task_context {
 
 	/* OFFSET 0x14 */
 	/**
-	 * This filed is set to the number of bytes to be transfered in the request.
+	 * This filed is set to the number of bytes to be transferred in the request.
 	 */
 	u32 transfer_length_bytes:24; /* In terms of bytes */
 
diff --git a/drivers/scsi/isci/unsolicited_frame_control.c b/drivers/scsi/isci/unsolicited_frame_control.c
index 04a6d0d59a22..fb0006e28cc8 100644
--- a/drivers/scsi/isci/unsolicited_frame_control.c
+++ b/drivers/scsi/isci/unsolicited_frame_control.c
@@ -130,7 +130,7 @@ enum sci_status sci_unsolicited_frame_control_get_header(struct sci_unsolicited_
 							 void **frame_header)
 {
 	if (frame_index < SCU_MAX_UNSOLICITED_FRAMES) {
-		/* Skip the first word in the frame since this is a controll word used
+		/* Skip the first word in the frame since this is a control word used
 		 * by the hardware.
 		 */
 		*frame_header = &uf_control->buffers.array[frame_index].header->data;
-- 
2.48.1

