Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A27FC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhLTOEr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbhLTOEo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2570C06173F
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:43 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso4439592pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=PTJ97rgkvY7Y8POCU/LTgzQbSJimLRw18qyaoWRtTmE=;
        b=g/meLerxFwCxAQhg1/OvTYY7wVyWw1VSQ0D/UMYSFMprQHp7NVDy2jfusRdml+0y6C
         NxiSWJ2sYcA3/vlR07Znw0r4aS8T3FWeFASSYBMUHRHs9Dop00vJte4skl2irQr+6Spe
         kdY6oTa8E8lztbn832VIirXViadicUmAtZEjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=PTJ97rgkvY7Y8POCU/LTgzQbSJimLRw18qyaoWRtTmE=;
        b=S7yvNcEwlXb3vd0cq+uvjhwx+L0CuQ98dEukHoR1alh1zUmWOQbHBPp7yrBvq117Oq
         EmF32EPY55xhLDmw3SWIsLfAqy9W+laFh3m/SsHMmi4OTOAIXuRiG4+yqlk4EL2NB0qR
         lKDjuP9/hP/r9Fr4aEgUaMHzHlTU9iNu7xT+JAnGofnjRn7sIXiGWaCMGnLPiaqhU4+f
         jWjJvl8kc7+ao09FCaIt6EP3133xkWfYuewLPtPlVinJtMZ2XYJN/w5TTWyyCz1MvQGU
         MYHMNfEphEx7jOWcjsBcHnBFHlyqDt7MAGetxhxvcN98YNz1WR0Vxbj4VfB5h0jPBE0N
         Dtkw==
X-Gm-Message-State: AOAM531jUDJG0yYX7OLJUpjUz2QXX4ZXMiWxZWZUyFynfv06+WfhnqXG
        slzCw1QggwtT3901xpDCwPOyu7hUL/CgZCBbjoAymMrgpBhOLLEWIf1VZebcoosqnStiQBIggwj
        HhAARKhMiOmZ221dqNtIEONVNJJanupDRwEQrwMbchlEPR/fAEo3Fm5PkiiGRG8qy74u1Zsk9Wk
        7pksrwfWNj
X-Google-Smtp-Source: ABdhPJyBF+Rz2jOYfB0dH4OKF/rMWLxuBI0SvI0jDV/XI2oDAUDVngF5SP1vVk2ps3bjD908ZOtV5A==
X-Received: by 2002:a17:902:ed52:b0:148:da08:9a6 with SMTP id y18-20020a170902ed5200b00148da0809a6mr66709plb.89.1640009082011;
        Mon, 20 Dec 2021 06:04:42 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:41 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 18/25] mpi3mr: Add Event acknowledgment logic
Date:   Mon, 20 Dec 2021 19:41:52 +0530
Message-Id: <20211220141159.16117-19-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000cc363005d3945ec1"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000cc363005d3945ec1
Content-Transfer-Encoding: 8bit

Add Event acknowledgment logic.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  30 +++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c |  48 +++++++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c | 158 +++++++++++++++++++++++++++++++-
 3 files changed, 224 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 24b65bb..2602957 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -96,7 +96,11 @@ extern int prot_mask;
 #define MPI3MR_HOSTTAG_DEVRMCMD_MAX	(MPI3MR_HOSTTAG_DEVRMCMD_MIN + \
 						MPI3MR_NUM_DEVRMCMD - 1)
 
-#define MPI3MR_INTERNAL_CMDS_RESVD     MPI3MR_HOSTTAG_DEVRMCMD_MAX
+#define MPI3MR_INTERNAL_CMDS_RESVD	MPI3MR_HOSTTAG_DEVRMCMD_MAX
+#define MPI3MR_NUM_EVTACKCMD		4
+#define MPI3MR_HOSTTAG_EVTACKCMD_MIN	(MPI3MR_HOSTTAG_DEVRMCMD_MAX + 1)
+#define MPI3MR_HOSTTAG_EVTACKCMD_MAX	(MPI3MR_HOSTTAG_EVTACKCMD_MIN + \
+					MPI3MR_NUM_EVTACKCMD - 1)
 
 /* Reduced resource count definition for crash kernel */
 #define MPI3MR_HOST_IOS_KDUMP		128
@@ -674,11 +678,15 @@ struct scmd_priv {
  * @chain_buf_lock: Chain buffer list lock
  * @host_tm_cmds: Command tracker for task management commands
  * @dev_rmhs_cmds: Command tracker for device removal commands
+ * @evtack_cmds: Command tracker for event ack commands
  * @devrem_bitmap_sz: Device removal bitmap size
  * @devrem_bitmap: Device removal bitmap
  * @dev_handle_bitmap_sz: Device handle bitmap size
  * @removepend_bitmap: Remove pending bitmap
  * @delayed_rmhs_list: Delayed device removal list
+ * @evtack_cmds_bitmap_sz: Event Ack bitmap size
+ * @evtack_cmds_bitmap: Event Ack bitmap
+ * @delayed_evtack_cmds_list: Delayed event acknowledgment list
  * @ts_update_counter: Timestamp update counter
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
@@ -800,11 +808,15 @@ struct mpi3mr_ioc {
 
 	struct mpi3mr_drv_cmd host_tm_cmds;
 	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
+	struct mpi3mr_drv_cmd evtack_cmds[MPI3MR_NUM_EVTACKCMD];
 	u16 devrem_bitmap_sz;
 	void *devrem_bitmap;
 	u16 dev_handle_bitmap_sz;
 	void *removepend_bitmap;
 	struct list_head delayed_rmhs_list;
+	u16 evtack_cmds_bitmap_sz;
+	void *evtack_cmds_bitmap;
+	struct list_head delayed_evtack_cmds_list;
 
 	u32 ts_update_counter;
 	u8 reset_in_progress;
@@ -862,6 +874,18 @@ struct delayed_dev_rmhs_node {
 	u8 iou_rc;
 };
 
+/**
+ * struct delayed_evt_ack_node - Delayed event ack node
+ * @list: list head
+ * @event: MPI3 event ID
+ * @event_ctx: event context
+ */
+struct delayed_evt_ack_node {
+	struct list_head list;
+	u8 event;
+	u32 event_ctx;
+};
+
 int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
 void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
 int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
@@ -898,7 +922,7 @@ void mpi3mr_ioc_disable_intr(struct mpi3mr_ioc *mrioc);
 void mpi3mr_ioc_enable_intr(struct mpi3mr_ioc *mrioc);
 
 enum mpi3mr_iocstate mpi3mr_get_iocstate(struct mpi3mr_ioc *mrioc);
-int mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
+int mpi3mr_process_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
 			  u32 event_ctx);
 
 void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout);
@@ -906,7 +930,7 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_host_io(struct mpi3mr_ioc *mrioc);
 void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc);
 void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc);
-void mpi3mr_flush_delayed_rmhs_list(struct mpi3mr_ioc *mrioc);
+void mpi3mr_flush_delayed_cmd_lists(struct mpi3mr_ioc *mrioc);
 void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
 void mpi3mr_print_fault_info(struct mpi3mr_ioc *mrioc);
 void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4050195..b513dca 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -312,6 +312,12 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host_tag,
 		return &mrioc->dev_rmhs_cmds[idx];
 	}
 
+	if (host_tag >= MPI3MR_HOSTTAG_EVTACKCMD_MIN &&
+	    host_tag <= MPI3MR_HOSTTAG_EVTACKCMD_MAX) {
+		idx = host_tag - MPI3MR_HOSTTAG_EVTACKCMD_MIN;
+		return &mrioc->evtack_cmds[idx];
+	}
+
 	return NULL;
 }
 
@@ -2691,6 +2697,13 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 			goto out_failed;
 	}
 
+	for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++) {
+		mrioc->evtack_cmds[i].reply = kzalloc(mrioc->reply_sz,
+		    GFP_KERNEL);
+		if (!mrioc->evtack_cmds[i].reply)
+			goto out_failed;
+	}
+
 	mrioc->host_tm_cmds.reply = kzalloc(mrioc->reply_sz, GFP_KERNEL);
 	if (!mrioc->host_tm_cmds.reply)
 		goto out_failed;
@@ -2711,6 +2724,14 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->devrem_bitmap)
 		goto out_failed;
 
+	mrioc->evtack_cmds_bitmap_sz = MPI3MR_NUM_EVTACKCMD / 8;
+	if (MPI3MR_NUM_EVTACKCMD % 8)
+		mrioc->evtack_cmds_bitmap_sz++;
+	mrioc->evtack_cmds_bitmap = kzalloc(mrioc->evtack_cmds_bitmap_sz,
+	    GFP_KERNEL);
+	if (!mrioc->evtack_cmds_bitmap)
+		goto out_failed;
+
 	mrioc->num_reply_bufs = mrioc->facts.max_reqs + MPI3MR_NUM_EVT_REPLIES;
 	mrioc->reply_free_qsz = mrioc->num_reply_bufs + 1;
 	mrioc->num_sense_bufs = mrioc->facts.max_reqs / MPI3MR_SENSEBUF_FACTOR;
@@ -3030,17 +3051,17 @@ out:
 }
 
 /**
- * mpi3mr_send_event_ack - Send event acknowledgment
+ * mpi3mr_process_event_ack - Process event acknowledgment
  * @mrioc: Adapter instance reference
  * @event: MPI3 event ID
- * @event_ctx: Event context
+ * @event_ctx: event context
  *
  * Send event acknowledgment through admin queue and wait for
  * it to complete.
  *
  * Return: 0 on success, non-zero on failures.
  */
-int mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
+int mpi3mr_process_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
 	u32 event_ctx)
 {
 	struct mpi3_event_ack_request evtack_req;
@@ -3803,8 +3824,13 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
 			memset(mrioc->dev_rmhs_cmds[i].reply, 0,
 			    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
+		for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++)
+			memset(mrioc->evtack_cmds[i].reply, 0,
+			    sizeof(*mrioc->evtack_cmds[i].reply));
 		memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
 		memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
+		memset(mrioc->evtack_cmds_bitmap, 0,
+		    mrioc->evtack_cmds_bitmap_sz);
 	}
 
 	for (i = 0; i < mrioc->num_queues; i++) {
@@ -3898,12 +3924,20 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 	kfree(mrioc->host_tm_cmds.reply);
 	mrioc->host_tm_cmds.reply = NULL;
 
+	for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++) {
+		kfree(mrioc->evtack_cmds[i].reply);
+		mrioc->evtack_cmds[i].reply = NULL;
+	}
+
 	kfree(mrioc->removepend_bitmap);
 	mrioc->removepend_bitmap = NULL;
 
 	kfree(mrioc->devrem_bitmap);
 	mrioc->devrem_bitmap = NULL;
 
+	kfree(mrioc->evtack_cmds_bitmap);
+	mrioc->evtack_cmds_bitmap = NULL;
+
 	kfree(mrioc->chain_bitmap);
 	mrioc->chain_bitmap = NULL;
 
@@ -4079,6 +4113,11 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
 		cmdptr = &mrioc->dev_rmhs_cmds[i];
 		mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
 	}
+
+	for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++) {
+		cmdptr = &mrioc->evtack_cmds[i];
+		mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+	}
 }
 
 /**
@@ -4176,10 +4215,11 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		goto out;
 	}
 
-	mpi3mr_flush_delayed_rmhs_list(mrioc);
+	mpi3mr_flush_delayed_cmd_lists(mrioc);
 	mpi3mr_flush_drv_cmds(mrioc);
 	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
 	memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
+	memset(mrioc->evtack_cmds_bitmap, 0, mrioc->evtack_cmds_bitmap_sz);
 	mpi3mr_cleanup_fwevt_list(mrioc);
 	mpi3mr_flush_host_io(mrioc);
 	mpi3mr_invalidate_devhandles(mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 38e1043..728d6ce 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -34,6 +34,9 @@ MODULE_PARM_DESC(logging_level,
 	" bits for enabling additional logging info (default=0)");
 
 /* Forward declarations*/
+static void mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
+	struct mpi3mr_drv_cmd *cmdparam, u32 event_ctx);
+
 /**
  * mpi3mr_host_tag_for_scmd - Get host tag for a scmd
  * @mrioc: Adapter instance reference
@@ -1336,7 +1339,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 
 evt_ack:
 	if (fwevt->send_ack)
-		mpi3mr_send_event_ack(mrioc, fwevt->event_id,
+		mpi3mr_process_event_ack(mrioc, fwevt->event_id,
 		    fwevt->evt_ctx);
 out:
 	/* Put fwevt reference count to neutralize kref_init increment */
@@ -1400,24 +1403,33 @@ static int mpi3mr_create_tgtdev(struct mpi3mr_ioc *mrioc,
 }
 
 /**
- * mpi3mr_flush_delayed_rmhs_list - Flush pending commands
+ * mpi3mr_flush_delayed_cmd_lists - Flush pending commands
  * @mrioc: Adapter instance reference
  *
- * Flush pending commands in the delayed removal handshake list
- * due to a controller reset or driver removal as a cleanup.
+ * Flush pending commands in the delayed lists due to a
+ * controller reset or driver removal as a cleanup.
  *
  * Return: Nothing
  */
-void mpi3mr_flush_delayed_rmhs_list(struct mpi3mr_ioc *mrioc)
+void mpi3mr_flush_delayed_cmd_lists(struct mpi3mr_ioc *mrioc)
 {
 	struct delayed_dev_rmhs_node *_rmhs_node;
+	struct delayed_evt_ack_node *_evtack_node;
 
+	dprint_reset(mrioc, "flushing delayed dev_remove_hs commands\n");
 	while (!list_empty(&mrioc->delayed_rmhs_list)) {
 		_rmhs_node = list_entry(mrioc->delayed_rmhs_list.next,
 		    struct delayed_dev_rmhs_node, list);
 		list_del(&_rmhs_node->list);
 		kfree(_rmhs_node);
 	}
+	dprint_reset(mrioc, "flushing delayed event ack commands\n");
+	while (!list_empty(&mrioc->delayed_evtack_cmds_list)) {
+		_evtack_node = list_entry(mrioc->delayed_evtack_cmds_list.next,
+		    struct delayed_evt_ack_node, list);
+		list_del(&_evtack_node->list);
+		kfree(_evtack_node);
+	}
 }
 
 /**
@@ -1633,6 +1645,141 @@ out_failed:
 	clear_bit(cmd_idx, mrioc->devrem_bitmap);
 }
 
+/**
+ * mpi3mr_complete_evt_ack - event ack request completion
+ * @mrioc: Adapter instance reference
+ * @drv_cmd: Internal command tracker
+ *
+ * This is the completion handler for non blocking event
+ * acknowledgment sent to the firmware and this will issue any
+ * pending event acknowledgment request.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_complete_evt_ack(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd)
+{
+	u16 cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_EVTACKCMD_MIN;
+	struct delayed_evt_ack_node *delayed_evtack = NULL;
+
+	if (drv_cmd->ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		dprint_event_th(mrioc,
+		    "immediate event ack failed with ioc_status(0x%04x) log_info(0x%08x)\n",
+		    (drv_cmd->ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
+		    drv_cmd->ioc_loginfo);
+	}
+
+	if (!list_empty(&mrioc->delayed_evtack_cmds_list)) {
+		delayed_evtack =
+			list_entry(mrioc->delayed_evtack_cmds_list.next,
+			    struct delayed_evt_ack_node, list);
+		mpi3mr_send_event_ack(mrioc, delayed_evtack->event, drv_cmd,
+		    delayed_evtack->event_ctx);
+		list_del(&delayed_evtack->list);
+		kfree(delayed_evtack);
+		return;
+	}
+	drv_cmd->state = MPI3MR_CMD_NOTUSED;
+	drv_cmd->callback = NULL;
+	clear_bit(cmd_idx, mrioc->evtack_cmds_bitmap);
+}
+
+/**
+ * mpi3mr_send_event_ack - Issue event acknwoledgment request
+ * @mrioc: Adapter instance reference
+ * @event: MPI3 event id
+ * @cmdparam: Internal command tracker
+ * @event_ctx: event context
+ *
+ * Issues event acknowledgment request to the firmware if there
+ * is a free command to send the event ack else it to a pend
+ * list so that it will be processed on a completion of a prior
+ * event acknowledgment .
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
+	struct mpi3mr_drv_cmd *cmdparam, u32 event_ctx)
+{
+	struct mpi3_event_ack_request evtack_req;
+	int retval = 0;
+	u8 retrycount = 5;
+	u16 cmd_idx = MPI3MR_NUM_EVTACKCMD;
+	struct mpi3mr_drv_cmd *drv_cmd = cmdparam;
+	struct delayed_evt_ack_node *delayed_evtack = NULL;
+
+	if (drv_cmd) {
+		dprint_event_th(mrioc,
+		    "sending delayed event ack in the top half for event(0x%02x), event_ctx(0x%08x)\n",
+		    event, event_ctx);
+		goto issue_cmd;
+	}
+	dprint_event_th(mrioc,
+	    "sending event ack in the top half for event(0x%02x), event_ctx(0x%08x)\n",
+	    event, event_ctx);
+	do {
+		cmd_idx = find_first_zero_bit(mrioc->evtack_cmds_bitmap,
+		    MPI3MR_NUM_EVTACKCMD);
+		if (cmd_idx < MPI3MR_NUM_EVTACKCMD) {
+			if (!test_and_set_bit(cmd_idx,
+			    mrioc->evtack_cmds_bitmap))
+				break;
+			cmd_idx = MPI3MR_NUM_EVTACKCMD;
+		}
+	} while (retrycount--);
+
+	if (cmd_idx >= MPI3MR_NUM_EVTACKCMD) {
+		delayed_evtack = kzalloc(sizeof(*delayed_evtack),
+		    GFP_ATOMIC);
+		if (!delayed_evtack)
+			return;
+		INIT_LIST_HEAD(&delayed_evtack->list);
+		delayed_evtack->event = event;
+		delayed_evtack->event_ctx = event_ctx;
+		list_add_tail(&delayed_evtack->list,
+		    &mrioc->delayed_evtack_cmds_list);
+		dprint_event_th(mrioc,
+		    "event ack in the top half for event(0x%02x), event_ctx(0x%08x) is postponed\n",
+		    event, event_ctx);
+		return;
+	}
+	drv_cmd = &mrioc->evtack_cmds[cmd_idx];
+
+issue_cmd:
+	cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_EVTACKCMD_MIN;
+
+	memset(&evtack_req, 0, sizeof(evtack_req));
+	if (drv_cmd->state & MPI3MR_CMD_PENDING) {
+		dprint_event_th(mrioc,
+		    "sending event ack failed due to command in use\n");
+		goto out;
+	}
+	drv_cmd->state = MPI3MR_CMD_PENDING;
+	drv_cmd->is_waiting = 0;
+	drv_cmd->callback = mpi3mr_complete_evt_ack;
+	evtack_req.host_tag = cpu_to_le16(drv_cmd->host_tag);
+	evtack_req.function = MPI3_FUNCTION_EVENT_ACK;
+	evtack_req.event = event;
+	evtack_req.event_context = cpu_to_le32(event_ctx);
+	retval = mpi3mr_admin_request_post(mrioc, &evtack_req,
+	    sizeof(evtack_req), 1);
+	if (retval) {
+		dprint_event_th(mrioc,
+		    "posting event ack request is failed\n");
+		goto out_failed;
+	}
+
+	dprint_event_th(mrioc,
+	    "event ack in the top half for event(0x%02x), event_ctx(0x%08x) is posted\n",
+	    event, event_ctx);
+out:
+	return;
+out_failed:
+	drv_cmd->state = MPI3MR_CMD_NOTUSED;
+	drv_cmd->callback = NULL;
+	clear_bit(cmd_idx, mrioc->evtack_cmds_bitmap);
+}
+
 /**
  * mpi3mr_pcietopochg_evt_th - PCIETopologyChange evt tophalf
  * @mrioc: Adapter instance reference
@@ -3773,6 +3920,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&mrioc->fwevt_list);
 	INIT_LIST_HEAD(&mrioc->tgtdev_list);
 	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
+	INIT_LIST_HEAD(&mrioc->delayed_evtack_cmds_list);
 
 	mutex_init(&mrioc->reset_mutex);
 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
-- 
2.27.0


--000000000000cc363005d3945ec1
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPAckd4NaedVMtA54dKk
AJ34UUft0IH5Uu5oF+jg6CylMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQ0MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCBkKH4hXX+gHJ2VfUzzLI0MTFzHYwJ6JS+rAER
Y0UMpseqHvxuHtZRM1tf/+xisI8iLrAIxCkINNjyD4JT4KZ+0WfOBL23u47lJbqP9Awlfs635/kG
Su67gsKKvbImJNjM56OqnoEb3+zLiNxzv/Ow8JBi1J4zTHkXgcItecydXsuDxm/VC9WfQLv6bhSo
RP41IDGDA+sNNrgvCgu20grbPQAAF6JfmM4NE+JHnzZ1MBeU9NWzL16L5fA68fZzm5Z97nnSS+DE
jEZl/25RrGxR5s98YTbKFQqje2a7G6YqESb8L7Qy4g2KwMdZj60XEh8A+nol+otiPzpEnYaN3Gdj
--000000000000cc363005d3945ec1--
