Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D647C43461
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 15:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A278208B3
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 15:28:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oqF92tzz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgICP2s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 11:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgICP2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 11:28:44 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E12C061244;
        Thu,  3 Sep 2020 08:28:43 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l9so3315937wme.3;
        Thu, 03 Sep 2020 08:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wIxpdRCj1s7fQvYFi+76SQ2zqdM6TKxliOnrG7ifpaI=;
        b=oqF92tzzJvdZINwbGVC2JPL+maLMrKU9VlNDhzzwEG/ZKktvFvoEwdnbg2OPpqFwgm
         tPmsVLMj22i89aXIt8Art9bVrGuorDxkxws4yKDg/OmM/67dhLxvIEqJOwHXBAwSlNME
         f0lw0sKL8tVVAaZF0XeUVUCPUSf6g+ef96JhdJL3dXtKQ+6KtHDVgyWjSr0wz5vZJDKO
         ysXaQo0FXNxpblmcX3rr19DeDA4nS8GM1pT1I5bz2JU1QFgEVz74cyUe5JMtFuvMP2Ci
         Y8C7uFTJYxNHkNDvMT+onAl1VYb9iYV/awmN4kmnr32Y/868LgHRTxDBo3F6NWf3+SEr
         8roA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wIxpdRCj1s7fQvYFi+76SQ2zqdM6TKxliOnrG7ifpaI=;
        b=huNWVPDgyEt0WBnRwPAmosjK91GKT7z4HX4xF+kzOloYXWSfNFzwJNBOzOQTlMCoZh
         8zDBFYzDwZgU3fKr+IIk7lHBCpCO5Y2SRO3nR3eeELzO5RJXyVB+26KqH75savyVLFU7
         VYoECypyHT8XGQ9flcE7PlmvRowQ116TSdEVXajfMoqFYC7NLtbArESIgKtR5mLWwwGj
         UgC6WaGAYPCyfJgB42xrGJ1uK49pE/0WvOSHlOHW1iu+WMbQjtKyuVQE1S77vvqb/+2k
         Hf/aY+OA2o76H7xLoff37HCD3ZimbeukdLXDse1acPXDqQ52y2RgAzGXhYSv9su4LtM2
         aFqQ==
X-Gm-Message-State: AOAM532jRD6f2jghp+RSS1rT90+/3RfGOMIn4eNaUf0fzCI69a7dK62U
        188uqvKiXCyZL+DasVEbUL4=
X-Google-Smtp-Source: ABdhPJyfOE/AD6zGTgcvHSFi9NsWiwEkM7eVMGwlOjeKPYzx6Xg73mZtSk7l7wRYUahwW5CevbcXnQ==
X-Received: by 2002:a1c:a953:: with SMTP id s80mr3029583wme.70.1599146921368;
        Thu, 03 Sep 2020 08:28:41 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id 32sm5750210wrh.18.2020.09.03.08.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 08:28:40 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/3] scsi: mpt: Remove unnecessary sleepFlag argument from functions
Date:   Thu,  3 Sep 2020 16:28:30 +0100
Message-Id: <20200903152832.484908-2-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903152832.484908-1-alex.dewar90@gmail.com>
References: <20200903152832.484908-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Almost all of the functions defined in mptbase.{c,h} are only ever
called with sleepFlag == CAN_SLEEP, so this parameter is unnecessary.
Remove it.

I implemented this by fixing up a single function at a time to make sure
that each was being called from a non-atomic context.

One exception is the function WaitForDoorbellAck, which does use the
sleepFlag argument, so that one was left in place.

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/message/fusion/mptbase.c  | 380 +++++++++++-------------------
 drivers/message/fusion/mptbase.h  |   6 +-
 drivers/message/fusion/mptctl.c   |  12 +-
 drivers/message/fusion/mptsas.c   |   8 +-
 drivers/message/fusion/mptscsih.c |  13 +-
 drivers/message/fusion/mptspi.c   |   2 +-
 6 files changed, 160 insertions(+), 261 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 9903e9660a38..b7136257b455 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -159,29 +159,29 @@ static u8 last_drv_idx;
 static irqreturn_t mpt_interrupt(int irq, void *bus_id);
 static int	mptbase_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
 		MPT_FRAME_HDR *reply);
-static int	mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes,
-			u32 *req, int replyBytes, u16 *u16reply, int maxwait,
-			int sleepFlag);
-static int	mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag);
+static int mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes,
+					u32 *req, int replyBytes, u16 *u16reply,
+					int maxwait);
+static int mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason);
 static void	mpt_detect_bound_ports(MPT_ADAPTER *ioc, struct pci_dev *pdev);
 static void	mpt_adapter_disable(MPT_ADAPTER *ioc);
 static void	mpt_adapter_dispose(MPT_ADAPTER *ioc);
 
 static void	MptDisplayIocCapabilities(MPT_ADAPTER *ioc);
-static int	MakeIocReady(MPT_ADAPTER *ioc, int force, int sleepFlag);
-static int	GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason);
-static int	GetPortFacts(MPT_ADAPTER *ioc, int portnum, int sleepFlag);
-static int	SendIocInit(MPT_ADAPTER *ioc, int sleepFlag);
-static int	SendPortEnable(MPT_ADAPTER *ioc, int portnum, int sleepFlag);
-static int	mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag);
-static int	mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag);
-static int	mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag);
-static int	KickStart(MPT_ADAPTER *ioc, int ignore, int sleepFlag);
-static int	SendIocReset(MPT_ADAPTER *ioc, u8 reset_type, int sleepFlag);
+static int	MakeIocReady(MPT_ADAPTER *ioc, int force);
+static int	GetIocFacts(MPT_ADAPTER *ioc, int reason);
+static int	GetPortFacts(MPT_ADAPTER *ioc, int portnum);
+static int	SendIocInit(MPT_ADAPTER *ioc);
+static int	SendPortEnable(MPT_ADAPTER *ioc, int portnum);
+static int	mpt_do_upload(MPT_ADAPTER *ioc);
+static int	mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader);
+static int	mpt_diag_reset(MPT_ADAPTER *ioc, int ignore);
+static int	KickStart(MPT_ADAPTER *ioc, int ignore);
+static int	SendIocReset(MPT_ADAPTER *ioc, u8 reset_type);
 static int	PrimeIocFifos(MPT_ADAPTER *ioc);
 static int	WaitForDoorbellAck(MPT_ADAPTER *ioc, int howlong, int sleepFlag);
-static int	WaitForDoorbellInt(MPT_ADAPTER *ioc, int howlong, int sleepFlag);
-static int	WaitForDoorbellReply(MPT_ADAPTER *ioc, int howlong, int sleepFlag);
+static int	WaitForDoorbellInt(MPT_ADAPTER *ioc, int howlong);
+static int	WaitForDoorbellReply(MPT_ADAPTER *ioc, int howlong);
 static int	GetLanConfigPages(MPT_ADAPTER *ioc);
 static int	GetIoUnitPage2(MPT_ADAPTER *ioc);
 int		mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
@@ -190,10 +190,9 @@ static int	mpt_readScsiDevicePageHeaders(MPT_ADAPTER *ioc, int portnum);
 static void 	mpt_read_ioc_pg_1(MPT_ADAPTER *ioc);
 static void 	mpt_read_ioc_pg_4(MPT_ADAPTER *ioc);
 static void	mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc);
-static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch,
-	int sleepFlag);
+static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch);
 static int	SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp);
-static int	mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int sleepFlag);
+static int	mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value);
 static int	mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init);
 
 #ifdef CONFIG_PROC_FS
@@ -404,7 +403,7 @@ mpt_fault_reset_work(struct work_struct *work)
 		       ioc->name, ioc_raw_state & MPI_DOORBELL_DATA_MASK);
 		printk(MYIOC_s_WARN_FMT "Issuing HardReset from %s!!\n",
 		       ioc->name, __func__);
-		rc = mpt_HardResetHandler(ioc, CAN_SLEEP);
+		rc = mpt_HardResetHandler(ioc);
 		printk(MYIOC_s_WARN_FMT "%s: HardReset: %s\n", ioc->name,
 		       __func__, (rc == 0) ? "success" : "failed");
 		ioc_raw_state = mpt_GetIocState(ioc, 0);
@@ -1170,7 +1169,6 @@ mpt_add_chain_64bit(void *pAddr, u8 next, u16 length, dma_addr_t dma_addr)
  *	@ioc: Pointer to MPT adapter structure
  *	@reqBytes: Size of the request in bytes
  *	@req: Pointer to MPT request frame
- *	@sleepFlag: Use schedule if CAN_SLEEP else use udelay.
  *
  *	This routine is used exclusively to send MptScsiTaskMgmt
  *	requests since they are required to be sent via doorbell handshake.
@@ -1181,7 +1179,7 @@ mpt_add_chain_64bit(void *pAddr, u8 next, u16 length, dma_addr_t dma_addr)
  *	Returns 0 for success, non-zero for failure.
  */
 int
-mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag)
+mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req)
 {
 	int	r = 0;
 	u8	*req_as_bytes;
@@ -1212,7 +1210,7 @@ mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req,
 			 ((reqBytes/4)<<MPI_DOORBELL_ADD_DWORDS_SHIFT)));
 
 	/* Wait for IOC doorbell int */
-	if ((ii = WaitForDoorbellInt(ioc, 5, sleepFlag)) < 0) {
+	if ((ii = WaitForDoorbellInt(ioc, 5)) < 0) {
 		return ii;
 	}
 
@@ -1225,7 +1223,7 @@ mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req,
 
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
-	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0) {
+	if ((r = WaitForDoorbellAck(ioc, 5, CAN_SLEEP)) < 0) {
 		return -2;
 	}
 
@@ -1239,13 +1237,13 @@ mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req,
 			(req_as_bytes[(ii*4) + 2] << 16) |
 			(req_as_bytes[(ii*4) + 3] << 24));
 		CHIPREG_WRITE32(&ioc->chip->Doorbell, word);
-		if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0) {
+		if ((r = WaitForDoorbellAck(ioc, 5, CAN_SLEEP)) < 0) {
 			r = -3;
 			break;
 		}
 	}
 
-	if (r >= 0 && WaitForDoorbellInt(ioc, 10, sleepFlag) >= 0)
+	if (r >= 0 && WaitForDoorbellInt(ioc, 10) >= 0)
 		r = 0;
 	else
 		r = -4;
@@ -1261,7 +1259,6 @@ mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req,
  * mpt_host_page_access_control - control the IOC's Host Page Buffer access
  * @ioc: Pointer to MPT adapter structure
  * @access_control_value: define bits below
- * @sleepFlag: Specifies whether the process can sleep
  *
  * Provides mechanism for the host driver to control the IOC's
  * Host Page Buffer access.
@@ -1276,7 +1273,7 @@ mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req,
  */
 
 static int
-mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int sleepFlag)
+mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value)
 {
 	int	 r = 0;
 
@@ -1293,7 +1290,7 @@ mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int slee
 		 (access_control_value<<12)));
 
 	/* Wait for IOC to clear Doorbell Status bit */
-	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0) {
+	if ((r = WaitForDoorbellAck(ioc, 5, NO_SLEEP)) < 0) {
 		return -2;
 	}else
 		return 0;
@@ -2005,8 +2002,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_remove_ioc;
 	}
 
-	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
-	    CAN_SLEEP)) != 0){
+	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP)) != 0) {
 		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
 		    ioc->name, r);
 
@@ -2158,7 +2154,7 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
 	    device_state);
 
 	/* put ioc into READY_STATE */
-	if (SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
+	if (SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET)) {
 		printk(MYIOC_s_ERR_FMT
 		"pci-suspend:  IOC msg unit reset failed!\n", ioc->name);
 	}
@@ -2235,7 +2231,7 @@ mpt_resume(struct pci_dev *pdev)
 	if (ioc->bus_type == SAS && (pdev->device ==
 	    MPI_MANUFACTPAGE_DEVID_SAS1068E || pdev->device ==
 	    MPI_MANUFACTPAGE_DEVID_SAS1064E)) {
-		if (KickStart(ioc, 1, CAN_SLEEP) < 0) {
+		if (KickStart(ioc, 1) < 0) {
 			printk(MYIOC_s_WARN_FMT "pci-resume: Cannot recover\n",
 			    ioc->name);
 			goto out;
@@ -2244,8 +2240,7 @@ mpt_resume(struct pci_dev *pdev)
 
 	/* bring ioc to operational state */
 	printk(MYIOC_s_INFO_FMT "Sending mpt_do_ioc_recovery\n", ioc->name);
-	recovery_state = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
-						 CAN_SLEEP);
+	recovery_state = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP);
 	if (recovery_state != 0)
 		printk(MYIOC_s_WARN_FMT "pci-resume: Cannot recover, "
 		    "error:[%x]\n", ioc->name, recovery_state);
@@ -2278,7 +2273,6 @@ mpt_signal_reset(u8 index, MPT_ADAPTER *ioc, int reset_phase)
  *	mpt_do_ioc_recovery - Initialize or recover MPT adapter.
  *	@ioc: Pointer to MPT adapter structure
  *	@reason: Event word / reason
- *	@sleepFlag: Use schedule if CAN_SLEEP else use udelay.
  *
  *	This routine performs all the steps necessary to bring the IOC
  *	to a OPERATIONAL state.
@@ -2296,7 +2290,7 @@ mpt_signal_reset(u8 index, MPT_ADAPTER *ioc, int reset_phase)
  *		-6 if failed to upload firmware
  */
 static int
-mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
+mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason)
 {
 	int	 hard_reset_done = 0;
 	int	 alt_ioc_ready = 0;
@@ -2332,7 +2326,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	if (reason == MPT_HOSTEVENT_IOC_BRINGUP)
 		hard = 0;
 
-	if ((hard_reset_done = MakeIocReady(ioc, hard, sleepFlag)) < 0) {
+	if ((hard_reset_done = MakeIocReady(ioc, hard)) < 0) {
 		if (hard_reset_done == -4) {
 			printk(MYIOC_s_WARN_FMT "Owned by PEER..skipping!\n",
 			    ioc->name);
@@ -2357,7 +2351,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	 * and 1 if a hard reset was performed.
 	 */
 	if (hard_reset_done && reset_alt_ioc_active && ioc->alt_ioc) {
-		if ((rc = MakeIocReady(ioc->alt_ioc, 0, sleepFlag)) == 0)
+		if ((rc = MakeIocReady(ioc->alt_ioc, 0)) == 0)
 			alt_ioc_ready = 1;
 		else
 			printk(MYIOC_s_WARN_FMT
@@ -2367,7 +2361,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 
 	for (ii=0; ii<5; ii++) {
 		/* Get IOC facts! Allow 5 retries */
-		if ((rc = GetIocFacts(ioc, sleepFlag, reason)) == 0)
+		if ((rc = GetIocFacts(ioc, reason)) == 0)
 			break;
 	}
 
@@ -2381,13 +2375,13 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	}
 
 	if (alt_ioc_ready) {
-		if ((rc = GetIocFacts(ioc->alt_ioc, sleepFlag, reason)) != 0) {
+		if ((rc = GetIocFacts(ioc->alt_ioc, reason)) != 0) {
 			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 			    "Initial Alt IocFacts failed rc=%x\n",
 			    ioc->name, rc));
 			/* Retry - alt IOC was initialized once
 			 */
-			rc = GetIocFacts(ioc->alt_ioc, sleepFlag, reason);
+			rc = GetIocFacts(ioc->alt_ioc, reason);
 		}
 		if (rc) {
 			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
@@ -2460,7 +2454,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	 */
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "SendIocInit\n",
 	    ioc->name));
-	if ((ret == 0) && ((rc = SendIocInit(ioc, sleepFlag)) != 0))
+	if ((ret == 0) && ((rc = SendIocInit(ioc)) != 0))
 		ret = -4;
 // NEW!
 	if (alt_ioc_ready && ((rc = PrimeIocFifos(ioc->alt_ioc)) != 0)) {
@@ -2472,7 +2466,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	}
 
 	if (alt_ioc_ready) {
-		if ((rc = SendIocInit(ioc->alt_ioc, sleepFlag)) != 0) {
+		if ((rc = SendIocInit(ioc->alt_ioc)) != 0) {
 			alt_ioc_ready = 0;
 			reset_alt_ioc_active = 0;
 			printk(MYIOC_s_WARN_FMT
@@ -2489,7 +2483,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 			/* Controller is not operational, cannot do upload
 			 */
 			if (ret == 0) {
-				rc = mpt_do_upload(ioc, sleepFlag);
+				rc = mpt_do_upload(ioc);
 				if (rc == 0) {
 					if (ioc->alt_ioc && ioc->alt_ioc->cached_fw) {
 						/*
@@ -2520,11 +2514,11 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 			"SendEventNotification\n",
 		    ioc->name));
-		ret = SendEventNotification(ioc, 1, sleepFlag);	/* 1=Enable */
+		ret = SendEventNotification(ioc, 1);	/* 1=Enable */
 	}
 
 	if (ioc->alt_ioc && alt_ioc_ready && !ioc->alt_ioc->facts.EventState)
-		rc = SendEventNotification(ioc->alt_ioc, 1, sleepFlag);
+		rc = SendEventNotification(ioc->alt_ioc, 1);
 
 	if (ret == 0) {
 		/* Enable! (reply interrupt) */
@@ -2705,7 +2699,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 			"%s: Pushing FW onto adapter\n", __func__, ioc->name));
 		if ((ret = mpt_downloadboot(ioc, (MpiFwHeader_t *)
-		    ioc->cached_fw, CAN_SLEEP)) < 0) {
+		    ioc->cached_fw)) < 0) {
 			printk(MYIOC_s_WARN_FMT
 			    ": firmware downloadboot failure (%d)!\n",
 			    ioc->name, ret);
@@ -2716,8 +2710,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 	 * Put the controller into ready state (if its not already)
 	 */
 	if (mpt_GetIocState(ioc, 1) != MPI_IOC_STATE_READY) {
-		if (!SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET,
-		    CAN_SLEEP)) {
+		if (!SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET)) {
 			if (mpt_GetIocState(ioc, 1) != MPI_IOC_STATE_READY)
 				printk(MYIOC_s_ERR_FMT "%s:  IOC msg unit "
 				    "reset failed to put ioc in ready state!\n",
@@ -2793,7 +2786,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 
 	if (ioc->HostPageBuffer != NULL) {
 		if((ret = mpt_host_page_access_control(ioc,
-		    MPI_DB_HPBAC_FREE_BUFFER, NO_SLEEP)) != 0) {
+		    MPI_DB_HPBAC_FREE_BUFFER)) != 0) {
 			printk(MYIOC_s_ERR_FMT
 			   ": %s: host page buffers free failed (%d)!\n",
 			    ioc->name, __func__, ret);
@@ -2907,7 +2900,6 @@ MptDisplayIocCapabilities(MPT_ADAPTER *ioc)
  *	MakeIocReady - Get IOC to a READY state, using KickStart if needed.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@force: Force hard KickStart of IOC
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	Returns:
  *		 1 - DIAG reset and READY
@@ -2918,7 +2910,7 @@ MptDisplayIocCapabilities(MPT_ADAPTER *ioc)
  *		-4 - IOC owned by a PEER
  */
 static int
-MakeIocReady(MPT_ADAPTER *ioc, int force, int sleepFlag)
+MakeIocReady(MPT_ADAPTER *ioc, int force)
 {
 	u32	 ioc_state;
 	int	 statefault = 0;
@@ -2981,14 +2973,14 @@ MakeIocReady(MPT_ADAPTER *ioc, int force, int sleepFlag)
 			return -4;
 		else {
 			if ((statefault == 0 ) && (force == 0)) {
-				if ((r = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag)) == 0)
+				if ((r = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET)) == 0)
 					return 0;
 			}
 			statefault = 3;
 		}
 	}
 
-	hard_reset_done = KickStart(ioc, statefault||force, sleepFlag);
+	hard_reset_done = KickStart(ioc, statefault||force);
 	if (hard_reset_done < 0)
 		return -1;
 
@@ -2996,7 +2988,7 @@ MakeIocReady(MPT_ADAPTER *ioc, int force, int sleepFlag)
 	 *  Loop here waiting for IOC to come READY.
 	 */
 	ii = 0;
-	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 5;	/* 5 seconds */
+	cntdn = 5 * HZ;	/* 5 seconds */
 
 	while ((ioc_state = mpt_GetIocState(ioc, 1)) != MPI_IOC_STATE_READY) {
 		if (ioc_state == MPI_IOC_STATE_OPERATIONAL) {
@@ -3004,7 +2996,7 @@ MakeIocReady(MPT_ADAPTER *ioc, int force, int sleepFlag)
 			 *  BIOS or previous driver load left IOC in OP state.
 			 *  Reset messaging FIFOs.
 			 */
-			if ((r = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag)) != 0) {
+			if ((r = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET)) != 0) {
 				printk(MYIOC_s_ERR_FMT "IOC msg unit reset failed!\n", ioc->name);
 				return -2;
 			}
@@ -3013,7 +3005,7 @@ MakeIocReady(MPT_ADAPTER *ioc, int force, int sleepFlag)
 			 *  Something is wrong.  Try to get IOC back
 			 *  to a known state.
 			 */
-			if ((r = SendIocReset(ioc, MPI_FUNCTION_IO_UNIT_RESET, sleepFlag)) != 0) {
+			if ((r = SendIocReset(ioc, MPI_FUNCTION_IO_UNIT_RESET)) != 0) {
 				printk(MYIOC_s_ERR_FMT "IO unit reset failed!\n", ioc->name);
 				return -3;
 			}
@@ -3027,11 +3019,7 @@ MakeIocReady(MPT_ADAPTER *ioc, int force, int sleepFlag)
 			return -ETIME;
 		}
 
-		if (sleepFlag == CAN_SLEEP) {
-			msleep(1);
-		} else {
-			mdelay (1);	/* 1 msec delay */
-		}
+		msleep(1);
 
 	}
 
@@ -3071,13 +3059,12 @@ mpt_GetIocState(MPT_ADAPTER *ioc, int cooked)
 /**
  *	GetIocFacts - Send IOCFacts request to MPT adapter.
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@sleepFlag: Specifies whether the process can sleep
  *	@reason: If recovery, only update facts.
  *
  *	Returns 0 for success, non-zero for failure.
  */
 static int
-GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
+GetIocFacts(MPT_ADAPTER *ioc, int reason)
 {
 	IOCFacts_t		 get_facts;
 	IOCFactsReply_t		*facts;
@@ -3116,8 +3103,8 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
 	/* No non-zero fields in the get_facts request are greater than
 	 * 1 byte in size, so we can just fire it off as is.
 	 */
-	r = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&get_facts,
-			reply_sz, (u16*)facts, 5 /*seconds*/, sleepFlag);
+	r = mpt_handshake_req_reply_wait(ioc, req_sz, (u32 *)&get_facts,
+					 reply_sz, (u16 *)facts, 5);
 	if (r != 0)
 		return r;
 
@@ -3228,7 +3215,7 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
 				ioc->name, ioc->req_sz, ioc->req_depth));
 
 			/* Get port facts! */
-			if ( (r = GetPortFacts(ioc, 0, sleepFlag)) != 0 )
+			if ( (r = GetPortFacts(ioc, 0)) != 0 )
 				return r;
 		}
 	} else {
@@ -3247,12 +3234,11 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
  *	GetPortFacts - Send PortFacts request to MPT adapter.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@portnum: Port number
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	Returns 0 for success, non-zero for failure.
  */
 static int
-GetPortFacts(MPT_ADAPTER *ioc, int portnum, int sleepFlag)
+GetPortFacts(MPT_ADAPTER *ioc, int portnum)
 {
 	PortFacts_t		 get_pfacts;
 	PortFactsReply_t	*pfacts;
@@ -3288,8 +3274,8 @@ GetPortFacts(MPT_ADAPTER *ioc, int portnum, int sleepFlag)
 	/* No non-zero fields in the get_pfacts request are greater than
 	 * 1 byte in size, so we can just fire it off as is.
 	 */
-	ii = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&get_pfacts,
-				reply_sz, (u16*)pfacts, 5 /*seconds*/, sleepFlag);
+	ii = mpt_handshake_req_reply_wait(ioc, req_sz, (u32 *)&get_pfacts,
+					  reply_sz, (u16 *)pfacts, 5);
 	if (ii != 0)
 		return ii;
 
@@ -3328,14 +3314,13 @@ GetPortFacts(MPT_ADAPTER *ioc, int portnum, int sleepFlag)
 /**
  *	SendIocInit - Send IOCInit request to MPT adapter.
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	Send IOCInit followed by PortEnable to bring IOC to OPERATIONAL state.
  *
  *	Returns 0 for success, non-zero for failure.
  */
 static int
-SendIocInit(MPT_ADAPTER *ioc, int sleepFlag)
+SendIocInit(MPT_ADAPTER *ioc)
 {
 	IOCInit_t		 ioc_init;
 	MPIDefaultReply_t	 init_reply;
@@ -3398,8 +3383,10 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepFlag)
 	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending IOCInit (req @ %p)\n",
 			ioc->name, &ioc_init));
 
-	r = mpt_handshake_req_reply_wait(ioc, sizeof(IOCInit_t), (u32*)&ioc_init,
-				sizeof(MPIDefaultReply_t), (u16*)&init_reply, 10 /*seconds*/, sleepFlag);
+	r = mpt_handshake_req_reply_wait(ioc, sizeof(IOCInit_t),
+					 (u32 *)&ioc_init,
+					 sizeof(MPIDefaultReply_t),
+					 (u16 *)&init_reply, 10);
 	if (r != 0) {
 		printk(MYIOC_s_ERR_FMT "Sending IOCInit failed(%d)!\n",ioc->name, r);
 		return r;
@@ -3412,7 +3399,7 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepFlag)
 	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending PortEnable (req @ %p)\n",
 			ioc->name, &ioc_init));
 
-	if ((r = SendPortEnable(ioc, 0, sleepFlag)) != 0) {
+	if ((r = SendPortEnable(ioc, 0)) != 0) {
 		printk(MYIOC_s_ERR_FMT "Sending PortEnable failed(%d)!\n",ioc->name, r);
 		return r;
 	}
@@ -3422,14 +3409,10 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepFlag)
 	 *  LoopInit and TargetDiscovery!
 	 */
 	count = 0;
-	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 60;	/* 60 seconds */
+	cntdn = 60 * HZ; /* 60 seconds */
 	state = mpt_GetIocState(ioc, 1);
 	while (state != MPI_IOC_STATE_OPERATIONAL && --cntdn) {
-		if (sleepFlag == CAN_SLEEP) {
-			msleep(1);
-		} else {
-			mdelay(1);
-		}
+		msleep(1);
 
 		if (!cntdn) {
 			printk(MYIOC_s_ERR_FMT "Wait IOC_OP state timeout(%d)!\n",
@@ -3452,14 +3435,13 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepFlag)
  *	SendPortEnable - Send PortEnable request to MPT adapter port.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@portnum: Port number to enable
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	Send PortEnable to bring IOC to OPERATIONAL state.
  *
  *	Returns 0 for success, non-zero for failure.
  */
 static int
-SendPortEnable(MPT_ADAPTER *ioc, int portnum, int sleepFlag)
+SendPortEnable(MPT_ADAPTER *ioc, int portnum)
 {
 	PortEnable_t		 port_enable;
 	MPIDefaultReply_t	 reply_buf;
@@ -3487,12 +3469,14 @@ SendPortEnable(MPT_ADAPTER *ioc, int portnum, int sleepFlag)
 	 */
 	if (ioc->ir_firmware || ioc->bus_type == SAS) {
 		rc = mpt_handshake_req_reply_wait(ioc, req_sz,
-		(u32*)&port_enable, reply_sz, (u16*)&reply_buf,
-		300 /*seconds*/, sleepFlag);
+						  (u32 *)&port_enable,
+						  reply_sz, (u16 *)&reply_buf,
+						  300);
 	} else {
 		rc = mpt_handshake_req_reply_wait(ioc, req_sz,
-		(u32*)&port_enable, reply_sz, (u16*)&reply_buf,
-		30 /*seconds*/, sleepFlag);
+						  (u32 *)&port_enable,
+						  reply_sz, (u16 *)&reply_buf,
+						  30);
 	}
 	return rc;
 }
@@ -3564,7 +3548,6 @@ mpt_free_fw_memory(MPT_ADAPTER *ioc)
 /**
  *	mpt_do_upload - Construct and Send FWUpload request to MPT adapter port.
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	Returns 0 for success, >0 for handshake failure
  *		<0 for fw upload failure.
@@ -3575,7 +3558,7 @@ mpt_free_fw_memory(MPT_ADAPTER *ioc)
  *	IOC from running in degraded mode.
  */
 static int
-mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
+mpt_do_upload(MPT_ADAPTER *ioc)
 {
 	u8			 reply[sizeof(FWUploadReply_t)];
 	FWUpload_t		*prequest;
@@ -3596,8 +3579,7 @@ mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": FW Image  @ %p[%p], sz=%d[%x] bytes\n",
 	    ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
 
-	prequest = (sleepFlag == NO_SLEEP) ? kzalloc(ioc->req_sz, GFP_ATOMIC) :
-	    kzalloc(ioc->req_sz, GFP_KERNEL);
+	prequest = kzalloc(ioc->req_sz, GFP_KERNEL);
 	if (!prequest) {
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "fw upload failed "
 		    "while allocating memory \n", ioc->name));
@@ -3629,7 +3611,7 @@ mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
 	DBG_DUMP_FW_REQUEST_FRAME(ioc, (u32 *)prequest);
 
 	ii = mpt_handshake_req_reply_wait(ioc, request_size, (u32 *)prequest,
-	    reply_sz, (u16 *)preply, 65 /*seconds*/, sleepFlag);
+					  reply_sz, (u16 *)preply, 65);
 
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "FW Upload completed "
 	    "rc=%x \n", ioc->name, ii));
@@ -3666,7 +3648,6 @@ mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
  *	mpt_downloadboot - DownloadBoot code
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@pFwHeader: Pointer to firmware header info
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	FwDownloadBoot requires Programmed IO access.
  *
@@ -3676,7 +3657,7 @@ mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
  *		<0 for fw upload failure.
  */
 static int
-mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
+mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader)
 {
 	MpiExtImageHeader_t	*pExtImage;
 	u32			 fwSize;
@@ -3701,12 +3682,8 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, (MPI_DIAG_PREVENT_IOC_BOOT | MPI_DIAG_DISABLE_ARM));
 
 	/* wait 1 msec */
-	if (sleepFlag == CAN_SLEEP) {
-		msleep(1);
-	} else {
-		mdelay (1);
-	}
-
+	msleep(1);
+	mdelay(1);
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val | MPI_DIAG_RESET_ADAPTER);
 
@@ -3718,11 +3695,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
 			break;
 		}
 		/* wait .1 sec */
-		if (sleepFlag == CAN_SLEEP) {
-			msleep (100);
-		} else {
-			mdelay (100);
-		}
+		msleep (100);
 	}
 
 	if ( count == 30 ) {
@@ -3808,11 +3781,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
 		    MPI_DIAG_CLEAR_FLASH_BAD_SIG);
 
 		/* wait 1 msec */
-		if (sleepFlag == CAN_SLEEP) {
-			msleep (1);
-		} else {
-			mdelay (1);
-		}
+		msleep (1);
 	}
 
 	if (ioc->errata_flag_1064)
@@ -3832,8 +3801,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
 
 	if (ioc->bus_type == SAS) {
 		ioc_state = mpt_GetIocState(ioc, 0);
-		if ( (GetIocFacts(ioc, sleepFlag,
-				MPT_HOSTEVENT_IOC_BRINGUP)) != 0 ) {
+		if ( (GetIocFacts(ioc, MPT_HOSTEVENT_IOC_BRINGUP)) != 0 ) {
 			ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "GetIocFacts failed: IocState=%x\n",
 					ioc->name, ioc_state));
 			return -EFAULT;
@@ -3848,7 +3816,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
 			if (ioc->bus_type == SAS) {
 				return 0;
 			}
-			if ((SendIocInit(ioc, sleepFlag)) != 0) {
+			if ((SendIocInit(ioc)) != 0) {
 				ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 					"downloadboot: SendIocInit failed\n",
 					ioc->name));
@@ -3859,11 +3827,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
 					ioc->name));
 			return 0;
 		}
-		if (sleepFlag == CAN_SLEEP) {
-			msleep (10);
-		} else {
-			mdelay (10);
-		}
+		msleep (10);
 	}
 	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"downloadboot failed! IocState=%x\n",ioc->name, ioc_state));
@@ -3875,18 +3839,15 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
  *	KickStart - Perform hard reset of MPT adapter.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@force: Force hard reset
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	This routine places MPT adapter in diagnostic mode via the
  *	WriteSequence register, and then performs a hard reset of adapter
  *	via the Diagnostic register.
  *
- *	Inputs:   sleepflag - CAN_SLEEP (non-interrupt thread)
- *			or NO_SLEEP (interrupt thread, use mdelay)
- *		  force - 1 if doorbell active, board fault state
+ *	Inputs:  force - 1 if doorbell active, board fault state
  *				board operational, IOC_RECOVERY or
  *				IOC_BRINGUP and there is an alt_ioc.
- *			  0 else
+ *			 0 else
  *
  *	Returns:
  *		 1 - hard reset, READY
@@ -3897,7 +3858,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
  *		-3 - reset but bad FW bit
  */
 static int
-KickStart(MPT_ADAPTER *ioc, int force, int sleepFlag)
+KickStart(MPT_ADAPTER *ioc, int force)
 {
 	int hard_reset_done = 0;
 	u32 ioc_state=0;
@@ -3908,23 +3869,19 @@ KickStart(MPT_ADAPTER *ioc, int force, int sleepFlag)
 		/* Always issue a Msg Unit Reset first. This will clear some
 		 * SCSI bus hang conditions.
 		 */
-		SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag);
+		SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET);
 
-		if (sleepFlag == CAN_SLEEP) {
-			msleep (1000);
-		} else {
-			mdelay (1000);
-		}
+		msleep (1000);
 	}
 
-	hard_reset_done = mpt_diag_reset(ioc, force, sleepFlag);
+	hard_reset_done = mpt_diag_reset(ioc, force);
 	if (hard_reset_done < 0)
 		return hard_reset_done;
 
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Diagnostic reset successful!\n",
 		ioc->name));
 
-	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 2;	/* 2 seconds */
+	cntdn = 2 * HZ;	/* 2 seconds */
 	for (cnt=0; cnt<cntdn; cnt++) {
 		ioc_state = mpt_GetIocState(ioc, 1);
 		if ((ioc_state == MPI_IOC_STATE_READY) || (ioc_state == MPI_IOC_STATE_OPERATIONAL)) {
@@ -3932,11 +3889,7 @@ KickStart(MPT_ADAPTER *ioc, int force, int sleepFlag)
  					ioc->name, cnt));
 			return hard_reset_done;
 		}
-		if (sleepFlag == CAN_SLEEP) {
-			msleep (10);
-		} else {
-			mdelay (10);
-		}
+		msleep (10);
 	}
 
 	dinitprintk(ioc, printk(MYIOC_s_ERR_FMT "Failed to come READY after reset! IocState=%x\n",
@@ -3950,8 +3903,6 @@ KickStart(MPT_ADAPTER *ioc, int force, int sleepFlag)
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@ignore: Set if to honor and clear to ignore
  *		the reset history bit
- *	@sleepFlag: CAN_SLEEP if called in a non-interrupt thread,
- *		else set to NO_SLEEP (use mdelay instead)
  *
  *	This routine places the adapter in diagnostic mode via the
  *	WriteSequence register and then performs a hard reset of adapter
@@ -3964,7 +3915,7 @@ KickStart(MPT_ADAPTER *ioc, int force, int sleepFlag)
  *		 -3  diagnostic reset failed
  */
 static int
-mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
+mpt_diag_reset(MPT_ADAPTER *ioc, int ignore)
 {
 	u32 diag0val;
 	u32 doorbell;
@@ -3986,10 +3937,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 			"address=%p\n",  ioc->name, __func__,
 			&ioc->chip->Doorbell, &ioc->chip->Reset_1078));
 		CHIPREG_WRITE32(&ioc->chip->Reset_1078, 0x07);
-		if (sleepFlag == CAN_SLEEP)
-			msleep(1);
-		else
-			mdelay(1);
+		msleep(1);
 
 		/*
 		 * Call each currently registered protocol IOC reset handler
@@ -4017,10 +3965,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 			}
 
 			/* wait 1 sec */
-			if (sleepFlag == CAN_SLEEP)
-				msleep(1000);
-			else
-				mdelay(1000);
+			msleep(1000);
 		}
 		return -1;
 	}
@@ -4051,11 +3996,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 			CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_5TH_KEY_VALUE);
 
 			/* wait 100 msec */
-			if (sleepFlag == CAN_SLEEP) {
-				msleep (100);
-			} else {
-				mdelay (100);
-			}
+			msleep (100);
 
 			count++;
 			if (count > 20) {
@@ -4130,13 +4071,9 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "cached_fw: diag0val=%x count=%d\n",
 					ioc->name, diag0val, count));
 				/* wait 1 sec */
-				if (sleepFlag == CAN_SLEEP) {
-					msleep (1000);
-				} else {
-					mdelay (1000);
-				}
+				msleep (1000);
 			}
-			if ((count = mpt_downloadboot(ioc, cached_fw, sleepFlag)) < 0) {
+			if ((count = mpt_downloadboot(ioc, cached_fw)) < 0) {
 				printk(MYIOC_s_WARN_FMT
 					"firmware downloadboot failure (%d)!\n", ioc->name, count);
 			}
@@ -4161,11 +4098,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 				}
 
 				/* wait 1 sec */
-				if (sleepFlag == CAN_SLEEP) {
-					msleep (1000);
-				} else {
-					mdelay (1000);
-				}
+				msleep (1000);
 			}
 
 			if (doorbell != MPI_IOC_STATE_READY)
@@ -4200,11 +4133,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 		CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_5TH_KEY_VALUE);
 
 		/* wait 100 msec */
-		if (sleepFlag == CAN_SLEEP) {
-			msleep (100);
-		} else {
-			mdelay (100);
-		}
+		msleep (100);
 
 		count++;
 		if (count > 20) {
@@ -4259,14 +4188,13 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@reset_type: reset type, expected values are
  *	%MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET or %MPI_FUNCTION_IO_UNIT_RESET
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	Send IOCReset request to the MPT adapter.
  *
  *	Returns 0 for success, non-zero for failure.
  */
 static int
-SendIocReset(MPT_ADAPTER *ioc, u8 reset_type, int sleepFlag)
+SendIocReset(MPT_ADAPTER *ioc, u8 reset_type)
 {
 	int r;
 	u32 state;
@@ -4275,32 +4203,25 @@ SendIocReset(MPT_ADAPTER *ioc, u8 reset_type, int sleepFlag)
 	drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending IOC reset(0x%02x)!\n",
 			ioc->name, reset_type));
 	CHIPREG_WRITE32(&ioc->chip->Doorbell, reset_type<<MPI_DOORBELL_FUNCTION_SHIFT);
-	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0)
+	if ((r = WaitForDoorbellAck(ioc, 5, CAN_SLEEP)) < 0)
 		return r;
 
 	/* FW ACK'd request, wait for READY state
 	 */
 	count = 0;
-	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 15;	/* 15 seconds */
+	cntdn = 15 * HZ;	/* 15 seconds */
 
 	while ((state = mpt_GetIocState(ioc, 1)) != MPI_IOC_STATE_READY) {
 		cntdn--;
 		count++;
 		if (!cntdn) {
-			if (sleepFlag != CAN_SLEEP)
-				count *= 10;
-
 			printk(MYIOC_s_ERR_FMT
 			    "Wait IOC_READY state (0x%x) timeout(%d)!\n",
 			    ioc->name, state, (int)((count+5)/HZ));
 			return -ETIME;
 		}
 
-		if (sleepFlag == CAN_SLEEP) {
-			msleep(1);
-		} else {
-			mdelay (1);	/* 1 msec delay */
-		}
+		msleep(1);
 	}
 
 	/* TODO!
@@ -4646,7 +4567,6 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
  *	@replyBytes: Expected size of the reply in bytes
  *	@u16reply: Pointer to area where reply should be written
  *	@maxwait: Max wait time for a reply (in seconds)
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	NOTES: It is the callers responsibility to byte-swap fields in the
  *	request which are greater than 1 byte in size.  It is also the
@@ -4657,7 +4577,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
  */
 static int
 mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes, u32 *req,
-		int replyBytes, u16 *u16reply, int maxwait, int sleepFlag)
+		int replyBytes, u16 *u16reply, int maxwait)
 {
 	MPIDefaultReply_t *mptReply;
 	int failcnt = 0;
@@ -4683,7 +4603,7 @@ mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes, u32 *req,
 	/*
 	 * Wait for IOC's doorbell handshake int
 	 */
-	if ((t = WaitForDoorbellInt(ioc, 5, sleepFlag)) < 0)
+	if ((t = WaitForDoorbellInt(ioc, 5)) < 0)
 		failcnt++;
 
 	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HandShake request start reqBytes=%d, WaitCnt=%d%s\n",
@@ -4699,7 +4619,7 @@ mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes, u32 *req,
 	 * our handshake request.
 	 */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
-	if (!failcnt && (t = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0)
+	if (!failcnt && (t = WaitForDoorbellAck(ioc, 5, CAN_SLEEP)) < 0)
 		failcnt++;
 
 	if (!failcnt) {
@@ -4717,7 +4637,7 @@ mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes, u32 *req,
 				    (req_as_bytes[(ii*4) + 3] << 24));
 
 			CHIPREG_WRITE32(&ioc->chip->Doorbell, word);
-			if ((t = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0)
+			if ((t = WaitForDoorbellAck(ioc, 5, CAN_SLEEP)) < 0)
 				failcnt++;
 		}
 
@@ -4730,7 +4650,7 @@ mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes, u32 *req,
 		/*
 		 * Wait for completion of doorbell handshake reply from the IOC
 		 */
-		if (!failcnt && (t = WaitForDoorbellReply(ioc, maxwait, sleepFlag)) < 0)
+		if (!failcnt && (t = WaitForDoorbellReply(ioc, maxwait)) < 0)
 			failcnt++;
 
 		dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HandShake reply count=%d%s\n",
@@ -4804,7 +4724,6 @@ WaitForDoorbellAck(MPT_ADAPTER *ioc, int howlong, int sleepFlag)
  *	WaitForDoorbellInt - Wait for IOC to set its doorbell interrupt bit
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@howlong: How long to wait (in seconds)
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	This routine waits (up to ~2 seconds max) for IOC doorbell interrupt
  *	(MPI_HIS_DOORBELL_INTERRUPT) to be set in the IntStatus register.
@@ -4812,29 +4731,19 @@ WaitForDoorbellAck(MPT_ADAPTER *ioc, int howlong, int sleepFlag)
  *	Returns a negative value on failure, else wait loop count.
  */
 static int
-WaitForDoorbellInt(MPT_ADAPTER *ioc, int howlong, int sleepFlag)
+WaitForDoorbellInt(MPT_ADAPTER *ioc, int howlong)
 {
 	int cntdn;
 	int count = 0;
 	u32 intstat=0;
 
 	cntdn = 1000 * howlong;
-	if (sleepFlag == CAN_SLEEP) {
-		while (--cntdn) {
-			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
-			if (intstat & MPI_HIS_DOORBELL_INTERRUPT)
-				break;
-			msleep(1);
-			count++;
-		}
-	} else {
-		while (--cntdn) {
-			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
-			if (intstat & MPI_HIS_DOORBELL_INTERRUPT)
-				break;
-			udelay (1000);
-			count++;
-		}
+	while (--cntdn) {
+		intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
+		if (intstat & MPI_HIS_DOORBELL_INTERRUPT)
+			break;
+		msleep(1);
+		count++;
 	}
 
 	if (cntdn) {
@@ -4853,7 +4762,6 @@ WaitForDoorbellInt(MPT_ADAPTER *ioc, int howlong, int sleepFlag)
  *	WaitForDoorbellReply - Wait for and capture an IOC handshake reply.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@howlong: How long to wait (in seconds)
- *	@sleepFlag: Specifies whether the process can sleep
  *
  *	This routine polls the IOC for a handshake reply, 16 bits at a time.
  *	Reply is cached to IOC private area large enough to hold a maximum
@@ -4862,7 +4770,7 @@ WaitForDoorbellInt(MPT_ADAPTER *ioc, int howlong, int sleepFlag)
  *	Returns a negative value on failure, else size of reply in WORDS.
  */
 static int
-WaitForDoorbellReply(MPT_ADAPTER *ioc, int howlong, int sleepFlag)
+WaitForDoorbellReply(MPT_ADAPTER *ioc, int howlong)
 {
 	int u16cnt = 0;
 	int failcnt = 0;
@@ -4877,12 +4785,12 @@ WaitForDoorbellReply(MPT_ADAPTER *ioc, int howlong, int sleepFlag)
 	 * Get first two u16's so we can look at IOC's intended reply MsgLength
 	 */
 	u16cnt=0;
-	if ((t = WaitForDoorbellInt(ioc, howlong, sleepFlag)) < 0) {
+	if ((t = WaitForDoorbellInt(ioc, howlong)) < 0) {
 		failcnt++;
 	} else {
 		hs_reply[u16cnt++] = le16_to_cpu(CHIPREG_READ32(&ioc->chip->Doorbell) & 0x0000FFFF);
 		CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
-		if ((t = WaitForDoorbellInt(ioc, 5, sleepFlag)) < 0)
+		if ((t = WaitForDoorbellInt(ioc, 5)) < 0)
 			failcnt++;
 		else {
 			hs_reply[u16cnt++] = le16_to_cpu(CHIPREG_READ32(&ioc->chip->Doorbell) & 0x0000FFFF);
@@ -4899,7 +4807,7 @@ WaitForDoorbellReply(MPT_ADAPTER *ioc, int howlong, int sleepFlag)
 	 * reply 16 bits at a time.
 	 */
 	for (u16cnt=2; !failcnt && u16cnt < (2 * mptReply->MsgLength); u16cnt++) {
-		if ((t = WaitForDoorbellInt(ioc, 5, sleepFlag)) < 0)
+		if ((t = WaitForDoorbellInt(ioc, 5)) < 0)
 			failcnt++;
 		hword = le16_to_cpu(CHIPREG_READ32(&ioc->chip->Doorbell) & 0x0000FFFF);
 		/* don't overflow our IOC hs_reply[] buffer! */
@@ -4908,7 +4816,7 @@ WaitForDoorbellReply(MPT_ADAPTER *ioc, int howlong, int sleepFlag)
 		CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 	}
 
-	if (!failcnt && (t = WaitForDoorbellInt(ioc, 5, sleepFlag)) < 0)
+	if (!failcnt && (t = WaitForDoorbellInt(ioc, 5)) < 0)
 		failcnt++;
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
@@ -5120,7 +5028,7 @@ mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
 			printk(MYIOC_s_WARN_FMT
 			       "Issuing Reset from %s!!, doorbell=0x%08x\n",
 			       ioc->name, __func__, mpt_GetIocState(ioc, 0));
-			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+			mpt_Soft_Hard_ResetHandler(ioc);
 			mpt_free_msg_frame(ioc, mf);
 		}
 		goto out;
@@ -6270,10 +6178,9 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
  *	SendEventNotification - Send EventNotification (on or off) request to adapter
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@EvSwitch: Event switch flags
- *	@sleepFlag: Specifies whether the process can sleep
  */
 static int
-SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch, int sleepFlag)
+SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch)
 {
 	EventNotification_t	evn;
 	MPIDefaultReply_t	reply_buf;
@@ -6290,8 +6197,7 @@ SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch, int sleepFlag)
 	    ioc->name, EvSwitch, &evn));
 
 	return mpt_handshake_req_reply_wait(ioc, sizeof(EventNotification_t),
-	    (u32 *)&evn, sizeof(MPIDefaultReply_t), (u16 *)&reply_buf, 30,
-	    sleepFlag);
+	    (u32 *)&evn, sizeof(MPIDefaultReply_t), (u16 *)&reply_buf, 30);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -6527,10 +6433,10 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 		       "Issuing Reset from %s!!, doorbell=0x%08x\n",
 		       ioc->name, __func__, mpt_GetIocState(ioc, 0));
 		if (retry_count == 0) {
-			if (mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP) != 0)
+			if (mpt_Soft_Hard_ResetHandler(ioc) != 0)
 				retry_count++;
 		} else
-			mpt_HardResetHandler(ioc, CAN_SLEEP);
+			mpt_HardResetHandler(ioc);
 
 		mpt_free_msg_frame(ioc, mf);
 		/* attempt one retry for a timed out command */
@@ -6956,7 +6862,6 @@ EXPORT_SYMBOL(mpt_halt_firmware);
 /**
  *	mpt_SoftResetHandler - Issues a less expensive reset
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@sleepFlag: Indicates if sleep or schedule must be called.
  *
  *	Returns 0 for SUCCESS or -1 if FAILED.
  *
@@ -6967,7 +6872,7 @@ EXPORT_SYMBOL(mpt_halt_firmware);
  *	to READY state.
  **/
 static int
-mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
+mpt_SoftResetHandler(MPT_ADAPTER *ioc)
 {
 	int		 rc;
 	int		 ii;
@@ -7024,7 +6929,7 @@ mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	ioc->active = 0;
 	time_count = jiffies;
 
-	rc = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag);
+	rc = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET);
 
 	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
 		if (MptResetHandlers[cb_idx])
@@ -7040,14 +6945,10 @@ mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 
 	for (ii = 0; ii < 5; ii++) {
 		/* Get IOC facts! Allow 5 retries */
-		rc = GetIocFacts(ioc, sleepFlag,
-			MPT_HOSTEVENT_IOC_RECOVER);
+		rc = GetIocFacts(ioc, MPT_HOSTEVENT_IOC_RECOVER);
 		if (rc == 0)
 			break;
-		if (sleepFlag == CAN_SLEEP)
-			msleep(100);
-		else
-			mdelay(100);
+		msleep(100);
 	}
 	if (ii == 5)
 		goto out;
@@ -7056,11 +6957,11 @@ mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	if (rc != 0)
 		goto out;
 
-	rc = SendIocInit(ioc, sleepFlag);
+	rc = SendIocInit(ioc);
 	if (rc != 0)
 		goto out;
 
-	rc = SendEventNotification(ioc, 1, sleepFlag);
+	rc = SendEventNotification(ioc, 1);
 	if (rc != 0)
 		goto out;
 
@@ -7100,20 +7001,19 @@ mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 /**
  *	mpt_Soft_Hard_ResetHandler - Try less expensive reset
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@sleepFlag: Indicates if sleep or schedule must be called.
  *
  *	Returns 0 for SUCCESS or -1 if FAILED.
  *	Try for softreset first, only if it fails go for expensive
  *	HardReset.
  **/
 int
-mpt_Soft_Hard_ResetHandler(MPT_ADAPTER *ioc, int sleepFlag) {
-	int ret = -1;
+mpt_Soft_Hard_ResetHandler(MPT_ADAPTER *ioc) {
+	int ret;
 
-	ret = mpt_SoftResetHandler(ioc, sleepFlag);
+	ret = mpt_SoftResetHandler(ioc);
 	if (ret == 0)
 		return ret;
-	ret = mpt_HardResetHandler(ioc, sleepFlag);
+	ret = mpt_HardResetHandler(ioc);
 	return ret;
 }
 EXPORT_SYMBOL(mpt_Soft_Hard_ResetHandler);
@@ -7126,21 +7026,17 @@ EXPORT_SYMBOL(mpt_Soft_Hard_ResetHandler);
 /**
  *	mpt_HardResetHandler - Generic reset handler
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@sleepFlag: Indicates if sleep or schedule must be called.
  *
  *	Issues SCSI Task Management call based on input arg values.
  *	If TaskMgmt fails, returns associated SCSI request.
  *
- *	Remark: _HardResetHandler can be invoked from an interrupt thread (timer)
- *	or a non-interrupt thread.  In the former, must not call schedule().
- *
  *	Note: A return of -1 is a FATAL error case, as it means a
  *	FW reload/initialization failed.
  *
  *	Returns 0 for SUCCESS or -1 if FAILED.
  */
 int
-mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
+mpt_HardResetHandler(MPT_ADAPTER *ioc)
 {
 	int	 rc;
 	u8	 cb_idx;
@@ -7195,7 +7091,7 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	}
 
 	time_count = jiffies;
-	rc = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_RECOVER, sleepFlag);
+	rc = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_RECOVER);
 	if (rc != 0) {
 		printk(KERN_WARNING MYNAM
 		       ": WARNING - (%d) Cannot recover %s, doorbell=0x%08x\n",
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 813d46311f6a..3f89c51a9d91 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -927,12 +927,12 @@ extern void	 mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 extern void	 mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 extern void	 mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 
-extern int	 mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag);
+extern int	 mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req);
 extern int	 mpt_verify_adapter(int iocid, MPT_ADAPTER **iocpp);
 extern u32	 mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);
 extern void	 mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buf, int *size, int len, int showlan);
-extern int	 mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
-extern int	 mpt_Soft_Hard_ResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
+extern int	 mpt_HardResetHandler(MPT_ADAPTER *ioc);
+extern int	 mpt_Soft_Hard_ResetHandler(MPT_ADAPTER *ioc);
 extern int	 mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *cfg);
 extern int	 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size);
 extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 24aebad60366..a20a11eea5a4 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -389,7 +389,8 @@ mptctl_do_taskmgmt(MPT_ADAPTER *ioc, u8 tm_type, u8 bus_id, u8 target_id)
 		mpt_put_msg_frame_hi_pri(mptctl_taskmgmt_id, ioc, mf);
 	else {
 		retval = mpt_send_handshake_request(mptctl_taskmgmt_id, ioc,
-		    sizeof(SCSITaskMgmt_t), (u32 *)pScsiTm, CAN_SLEEP);
+						    sizeof(SCSITaskMgmt_t),
+						    (u32 *)pScsiTm);
 		if (retval != 0) {
 			dfailprintk(ioc,
 				printk(MYIOC_s_ERR_FMT
@@ -508,7 +509,7 @@ mptctl_timeout_expired(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 
 	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling Reset! \n",
 		 ioc->name));
-	mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+	mpt_Soft_Hard_ResetHandler(ioc);
 	mpt_free_msg_frame(ioc, mf);
 }
 
@@ -720,7 +721,7 @@ static int mptctl_do_reset(MPT_ADAPTER *iocp, unsigned long arg)
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "mptctl_do_reset called.\n",
 	    iocp->name));
 
-	if (mpt_HardResetHandler(iocp, CAN_SLEEP) != 0) {
+	if (mpt_HardResetHandler(iocp) != 0) {
 		printk (MYIOC_s_ERR_FMT "%s@%d::mptctl_do_reset - reset failed.\n",
 			iocp->name, __FILE__, __LINE__);
 		return -1;
@@ -2177,8 +2178,9 @@ mptctl_do_mpt_command (MPT_ADAPTER *ioc, struct mpt_ioctl_command karg, void __u
 		    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
 			mpt_put_msg_frame_hi_pri(mptctl_id, ioc, mf);
 		else {
-			rc =mpt_send_handshake_request(mptctl_id, ioc,
-				sizeof(SCSITaskMgmt_t), (u32*)mf, CAN_SLEEP);
+			rc = mpt_send_handshake_request(mptctl_id, ioc,
+							sizeof(SCSITaskMgmt_t),
+							(u32 *)mf);
 			if (rc != 0) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				    "send_handshake FAILED! (ioc %p, mf %p)\n",
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 18b91ea1a353..e0508ff16a09 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2123,7 +2123,7 @@ static int mptsas_phy_reset(struct sas_phy *phy, int hard_reset)
 		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_DID_IOCRESET)
 			goto out_unlock;
 		if (!timeleft)
-			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+			mpt_Soft_Hard_ResetHandler(ioc);
 		goto out_unlock;
 	}
 
@@ -2307,7 +2307,7 @@ static void mptsas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_DID_IOCRESET)
 			goto unmap_in;
 		if (!timeleft)
-			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+			mpt_Soft_Hard_ResetHandler(ioc);
 		goto unmap_in;
 	}
 	mf = NULL;
@@ -2919,7 +2919,7 @@ mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
 		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_DID_IOCRESET)
 			goto out_free;
 		if (!timeleft)
-			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+			mpt_Soft_Hard_ResetHandler(ioc);
 		goto out_free;
 	}
 
@@ -4915,7 +4915,7 @@ mptsas_broadcast_primitive_work(struct fw_event_work *fw_event)
 		printk(MYIOC_s_WARN_FMT
 		       "Issuing Reset from %s!! doorbell=0x%08x\n",
 		       ioc->name, __func__, mpt_GetIocState(ioc, 0));
-		mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+		mpt_Soft_Hard_ResetHandler(ioc);
 	}
 	mptsas_free_fw_event(ioc, fw_event);
 }
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index a5ef9faf71c7..3ac8fe46cadf 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1529,7 +1529,7 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, u64 lun,
 			ioc->name, type, ioc_raw_state);
 		printk(MYIOC_s_WARN_FMT "Issuing HardReset from %s!!\n",
 		    ioc->name, __func__);
-		if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0)
+		if (mpt_HardResetHandler(ioc) < 0)
 			printk(MYIOC_s_WARN_FMT "TaskMgmt HardReset "
 			    "FAILED!!\n", ioc->name);
 		return 0;
@@ -1602,7 +1602,8 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, u64 lun,
 		mpt_put_msg_frame_hi_pri(ioc->TaskCtx, ioc, mf);
 	else {
 		retval = mpt_send_handshake_request(ioc->TaskCtx, ioc,
-			sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP);
+						    sizeof(SCSITaskMgmt_t),
+						    (u32 *)pScsiTm);
 		if (retval) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"TaskMgmt handshake FAILED!(mf=%p, rc=%d) \n",
@@ -1641,8 +1642,8 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, u64 lun,
 		       "Issuing Reset from %s!! doorbell=0x%08x\n",
 		       ioc->name, __func__, mpt_GetIocState(ioc, 0));
 		retval = (ioc->bus_type == SAS) ?
-			mpt_HardResetHandler(ioc, CAN_SLEEP) :
-			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+			mpt_HardResetHandler(ioc) :
+			mpt_Soft_Hard_ResetHandler(ioc);
 		mpt_free_msg_frame(ioc, mf);
 	}
 
@@ -1933,7 +1934,7 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
-	retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+	retval = mpt_Soft_Hard_ResetHandler(ioc);
 	if (retval < 0)
 		status = FAILED;
 	else
@@ -2977,7 +2978,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 			       " cmd=0x%02x\n",
 			       ioc->name, __func__, mpt_GetIocState(ioc, 0),
 			       cmd);
-			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+			mpt_Soft_Hard_ResetHandler(ioc);
 			mpt_free_msg_frame(ioc, mf);
 		}
 		goto out;
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index eabc4de5816c..9eb695810bd2 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -666,7 +666,7 @@ mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id)
 		if (!timeleft) {
 			printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
 			    ioc->name, __func__);
-			mpt_HardResetHandler(ioc, CAN_SLEEP);
+			mpt_HardResetHandler(ioc);
 			mpt_free_msg_frame(ioc, mf);
 		}
 		goto out;
-- 
2.28.0

