Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6083C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 870B360E73
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhIUSsD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 14:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhIUSrv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 14:47:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF314C061574
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:22 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y8so385139pfa.7
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UFiHITzdJzMalW9fucFNnq1XWvVUw19IzNB1DVS7tqQ=;
        b=WD3l/v4zP560UzFRMCCJ02psfX2WrGBhEwUxhYc2oImXw7UmDZ8UuBBg1huSzaQEE1
         prkfjUnfQb/u70uZUqFJdmQpSoJsUanFMp6RIdkz6pb3IIgxRwdSvBcqc3Tf4g13hs/w
         ZEUW4uUIrxPFs6UUr6q44S/uh8mbrTJggZRHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UFiHITzdJzMalW9fucFNnq1XWvVUw19IzNB1DVS7tqQ=;
        b=mj9WiIwL3gTiJlMdDMwYoxA9DGbLMXn72wO5diFrrSKy4Gg4Tbhxaf7WvT/5tzRO3Y
         XAvHlw9PhAOX9JpGhAT4djsRcLECtTiHdMNm8strFcXDQXuJOBAy3ECm+gbQJlH0tUvX
         EttPi1I0moKs83BPexbCiRccyDWBB8DsAbjSi84I6QroKyO6m1hL6d7YHOSNlCiMPcOs
         WnOdUC3YhMvndxWCD+Pk2w71yz/4AiibRebuVEVxQIX+DcpJspJ6UdGnGAwRrYxSdh6O
         /EhGA6hXkvnwp7KmgYkyjF6OvPQOV2tlHvkgD7JYO9znsmvXVp1DifSko8IkAXnv6k8e
         42Ug==
X-Gm-Message-State: AOAM531xQmnuLEc1rgiQoz0643L4MlQdKJeWaEsVAlqavasM1KJdUAL5
        U2fyrVBZhY3YHh7uO42kFBiWzQA2ruNPKu2wfTPQzEP10CtbGOQmlnwUMDCG9D00D3pvut3/dBs
        DxvTd/SAcnCSJ1VqQ4C6yCPy4fTCSeklkTMhea38Vvk7aDtHV6V8WGtyY8I1c1EfZVsHZTNNWl/
        W6iw2Ewh6Q
X-Google-Smtp-Source: ABdhPJwhMYQBT9JCjv3rBSVSVEkJD9RQQ7DV1DrjSnFcyk+CzaUTRsLXQnLNJmeziq++BzOOtvSopA==
X-Received: by 2002:a63:d0d:: with SMTP id c13mr29248342pgl.294.1632249981351;
        Tue, 21 Sep 2021 11:46:21 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f144sm18258897pfa.24.2021.09.21.11.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 11:46:20 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 5/7] mpi3mr: PEL support added
Date:   Wed, 22 Sep 2021 00:15:58 +0530
Message-Id: <20210921184600.64427-6-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210921184600.64427-1-kashyap.desai@broadcom.com>
References: <20210921184600.64427-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000605b5605cc85d07f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000605b5605cc85d07f

This patch includes driver support for the management applications to
enable the persistent event log notification with the controller and the
driver will notify the application once a PEL entry is returned by the
firmware through an AEN and the management applications will issue direct
MPI Passthru calls to get the individual entries.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  33 ++++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 205 ++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 283 +++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  23 +++
 4 files changed, 544 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 391708c72563..6108fe562bed 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -88,6 +88,8 @@ extern int prot_mask;
 #define MPI3MR_HOSTTAG_INVALID		0xFFFF
 #define MPI3MR_HOSTTAG_INITCMDS		1
 #define MPI3MR_HOSTTAG_IOCTLCMDS	2
+#define MPI3MR_HOSTTAG_PEL_ABORT		3
+#define MPI3MR_HOSTTAG_PEL_WAIT		4
 #define MPI3MR_HOSTTAG_BLK_TMS		5
 
 #define MPI3MR_NUM_DEVRMCMD		1
@@ -148,6 +150,7 @@ extern int prot_mask;
 #define MPI3MR_DEFAULT_MDTS	(128 * 1024)
 /* Command retry count definitions */
 #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
+#define MPI3MR_PEL_RETRY_COUNT 3
 
 /* Default target device queue depth */
 #define MPI3MR_DEFAULT_SDEV_QD	32
@@ -702,6 +705,16 @@ struct scmd_priv {
  * @current_event: Firmware event currently in process
  * @driver_info: Driver, Kernel, OS information to firmware
  * @change_count: Topology change count
+ * @pel_enabled: Persistent Event Log(PEL) enabled or not
+ * @pel_abort_requested: PEL abort is requested or not
+ * @pel_class: PEL Class identifier
+ * @pel_locale: PEL Locale identifier
+ * @pel_cmds: Command tracker for PEL wait command
+ * @pel_abort_cmd: Command tracker for PEL abort command
+ * @pel_newest_seqnum: Newest PEL sequenece number
+ * @pel_seqnum_virt: PEL sequence number virtual address
+ * @pel_seqnum_dma: PEL sequence number DMA address
+ * @pel_seqnum_sz: PEL sequenece number size
  * @op_reply_q_offset: Operational reply queue offset with MSIx
  * @logdata_buf: Circular buffer to store log data entries
  * @logdata_buf_idx: Index of entry in buffer to store
@@ -834,6 +847,17 @@ struct mpi3mr_ioc {
 	struct mpi3mr_fwevt *current_event;
 	struct mpi3_driver_info_layout driver_info;
 	u16 change_count;
+	bool pel_enabled;
+	bool pel_abort_requested;
+	u8 pel_class;
+	u16 pel_locale;
+	struct mpi3mr_drv_cmd pel_cmds;
+	struct mpi3mr_drv_cmd pel_abort_cmd;
+	u32 pel_newest_seqnum;
+	void *pel_seqnum_virt;
+	dma_addr_t pel_seqnum_dma;
+	u32 pel_seqnum_sz;
+
 	u16 op_reply_q_offset;
 
 	u8 *logdata_buf;
@@ -851,6 +875,7 @@ struct mpi3mr_ioc {
  * @send_ack: Event acknowledgment required or not
  * @process_evt: Bottomhalf processing required or not
  * @evt_ctx: Event context to send in Ack
+ * @evt_data_size: size of the event data in bytes
  * @ref_count: kref count
  * @event_data: Actual MPI3 event data
  */
@@ -862,6 +887,7 @@ struct mpi3mr_fwevt {
 	bool send_ack;
 	bool process_evt;
 	u32 evt_ctx;
+	u16 evt_data_size;
 	struct kref ref_count;
 	char event_data[0] __aligned(4);
 };
@@ -898,6 +924,8 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 				     dma_addr_t phys_addr);
 void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
 				     u64 sense_buf_dma);
+void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
+				struct mpi3mr_drv_cmd *drv_cmd);
 
 void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc);
 void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
@@ -925,6 +953,8 @@ void mpi3mr_ioc_enable_intr(struct mpi3mr_ioc *mrioc);
 enum mpi3mr_iocstate mpi3mr_get_iocstate(struct mpi3mr_ioc *mrioc);
 int mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
 			  u32 event_ctx);
+int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd);
 
 void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout);
 void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc);
@@ -935,5 +965,8 @@ void mpi3mr_flush_delayed_rmhs_list(struct mpi3mr_ioc *mrioc);
 
 void mpi3mr_app_init(void);
 void mpi3mr_app_exit(void);
+void mpi3mr_app_send_aen(struct mpi3mr_ioc *mrioc);
+void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+				u16 event_data_size);
 
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 021615889dcd..f8e7d2713fe4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -192,6 +192,157 @@ static long mpi3mr_get_logdata(struct mpi3mr_ioc *mrioc,
 	return 0;
 }
 
+/**
+ * mpi3mr_app_pel_abort - sends PEL abort request
+ * @mrioc: Adapter instance reference
+ *
+ * This function sends PEL abort request to the firmware through
+ * admin request queue.
+ *
+ * Return: 0 on success, Non-zero on failure
+ */
+static int mpi3mr_app_pel_abort(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3_pel_req_action_abort pel_abort_req;
+	struct mpi3_pel_reply *pel_reply;
+	int retval = 0;
+	u16 pe_log_status;
+
+	if (mrioc->reset_in_progress ||
+		mrioc->block_ioctls) {
+		dbgprint(mrioc, "%s: reset %d blocked ioctl %d\n",
+				__func__, mrioc->reset_in_progress,
+				mrioc->block_ioctls);
+		return -1;
+	}
+
+	memset(&pel_abort_req, 0, sizeof(pel_abort_req));
+	mutex_lock(&mrioc->pel_abort_cmd.mutex);
+	if (mrioc->pel_abort_cmd.state & MPI3MR_CMD_PENDING) {
+		dbgprint(mrioc, "%s: command is in use\n", __func__);
+		mutex_unlock(&mrioc->pel_abort_cmd.mutex);
+		return -1;
+	}
+	mrioc->pel_abort_cmd.state = MPI3MR_CMD_PENDING;
+	mrioc->pel_abort_cmd.is_waiting = 1;
+	mrioc->pel_abort_cmd.callback = NULL;
+	pel_abort_req.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_PEL_ABORT);
+	pel_abort_req.function = MPI3_FUNCTION_PERSISTENT_EVENT_LOG;
+	pel_abort_req.action = MPI3_PEL_ACTION_ABORT;
+	pel_abort_req.abort_host_tag = cpu_to_le16(MPI3MR_HOSTTAG_PEL_WAIT);
+
+	mrioc->pel_abort_requested = true;
+	init_completion(&mrioc->pel_abort_cmd.done);
+	retval = mpi3mr_admin_request_post(mrioc, &pel_abort_req,
+	    sizeof(pel_abort_req), 0);
+	if (retval) {
+		mrioc->pel_abort_requested = false;
+		goto out_unlock;
+	}
+
+	wait_for_completion_timeout(&mrioc->pel_abort_cmd.done,
+	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
+	if (!(mrioc->pel_abort_cmd.state & MPI3MR_CMD_COMPLETE)) {
+		mrioc->pel_abort_cmd.is_waiting = 0;
+		dbgprint(mrioc, "%s: command timedout\n", __func__);
+		if (!(mrioc->pel_abort_cmd.state & MPI3MR_CMD_RESET))
+			mpi3mr_soft_reset_handler(mrioc,
+			    MPI3MR_RESET_FROM_PELABORT_TIMEOUT, 1);
+		retval = -1;
+		goto out_unlock;
+	}
+	if ((mrioc->pel_abort_cmd.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	     != MPI3_IOCSTATUS_SUCCESS) {
+		dbgprint(mrioc,
+		    "%s: command failed, ioc_status(0x%04x) log_info(0x%08x)\n",
+		    __func__, (mrioc->pel_abort_cmd.ioc_status &
+		    MPI3_IOCSTATUS_STATUS_MASK),
+		    mrioc->pel_abort_cmd.ioc_loginfo);
+		retval = -1;
+		goto out_unlock;
+	}
+	if (mrioc->pel_abort_cmd.state & MPI3MR_CMD_REPLY_VALID) {
+		pel_reply = (struct mpi3_pel_reply *)mrioc->pel_abort_cmd.reply;
+		pe_log_status = le16_to_cpu(pel_reply->pe_log_status);
+		if (pe_log_status != MPI3_PEL_STATUS_SUCCESS) {
+			dbgprint(mrioc,
+			    "%s: command failed, pel_status(0x%04x)\n",
+			    __func__, pe_log_status);
+			retval = -1;
+		}
+	}
+
+out_unlock:
+	mrioc->pel_abort_cmd.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->pel_abort_cmd.mutex);
+	return retval;
+}
+
+/**
+ * mpi3mr_app_pel_enable - Handler for PEL enable driver IOCTL
+ * @mrioc: Adapter instance reference
+ * @data_out_buf: User buffer containing PEL enable data
+ * @data_out_sz: length of the user buffer.
+ *
+ * This function is the handler for PEL enable driver IOCTL.
+ * Validates the application given class and locale and if
+ * requires aborts the existing PEL wait request and/or issues
+ * new PEL wait request to the firmware and returns.
+ *
+ * Return: 0 on success and proper error codes on failure.
+ */
+static long mpi3mr_app_pel_enable(struct mpi3mr_ioc *mrioc,
+	void __user *data_out_buf, uint32_t data_out_sz)
+{
+	long rval = 0;
+	struct mpi3mr_ioctl_out_pel_enable pel_enable;
+	u8 tmp_class;
+	u16 tmp_locale;
+
+	if (copy_from_user(&pel_enable, data_out_buf, sizeof(pel_enable)))
+		return -EFAULT;
+
+	if (pel_enable.pel_class > MPI3_PEL_CLASS_FAULT) {
+		dbgprint(mrioc, "%s: out of range class %d sent\n",
+			__func__, pel_enable.pel_class);
+		return -EINVAL;
+	}
+
+	if (mrioc->pel_enabled) {
+		if ((mrioc->pel_class <= pel_enable.pel_class) &&
+		    !((mrioc->pel_locale & pel_enable.pel_locale) ^
+		      pel_enable.pel_locale))
+			return 0;
+
+		pel_enable.pel_locale |= mrioc->pel_locale;
+		if (mrioc->pel_class < pel_enable.pel_class)
+			pel_enable.pel_class = mrioc->pel_class;
+
+		rval = mpi3mr_app_pel_abort(mrioc);
+
+		if (rval)
+			return rval;
+
+	}
+
+	tmp_class = mrioc->pel_class;
+	tmp_locale = mrioc->pel_locale;
+	mrioc->pel_class = pel_enable.pel_class;
+	mrioc->pel_locale = pel_enable.pel_locale;
+	mrioc->pel_enabled = true;
+	rval = mpi3mr_pel_get_seqnum_post(mrioc, NULL);
+	if (rval) {
+		mrioc->pel_class = tmp_class;
+		mrioc->pel_locale = tmp_locale;
+		mrioc->pel_enabled = false;
+		dbgprint(mrioc,
+		    "%s: pel get sequence number failed, status(%ld)\n",
+		    __func__, rval);
+	}
+
+	return rval;
+}
+
 /**
  * mpi3mr_get_change_count - Get topology change count
  * @mrioc: Adapter instance reference
@@ -350,6 +501,10 @@ mpi3mr_ioctl_process_drv_cmds(struct file *file, void __user *arg)
 		rval = mpi3mr_get_logdata(mrioc, karg.data_in_buf,
 					karg.data_in_size);
 		break;
+	case MPI3MR_DRVIOCTL_OPCODE_PELENABLE:
+		rval = mpi3mr_app_pel_enable(mrioc, karg.data_out_buf,
+		    karg.data_out_size);
+		break;
 	case MPI3MR_DRVIOCTL_OPCODE_GETCHGCNT:
 		rval = mpi3mr_get_change_count(mrioc, karg.data_in_buf,
 					karg.data_in_size);
@@ -799,6 +954,56 @@ static long mpi3mr_ioctl(struct file *file, unsigned int cmd,
 	return rval;
 }
 
+/**
+ * mpi3mr_app_send_aen - Notify applications about an AEN
+ * @mrioc: Adapter instance reference
+ *
+ * Sends async signal SIGIO to indicate there is an async event
+ * from the firmware to the event monitoring applications.
+ *
+ * Return:Nothing
+ */
+void mpi3mr_app_send_aen(struct mpi3mr_ioc *mrioc)
+{
+	dbgprint(mrioc, "%s: invoked\n", __func__);
+	if (mpi3mr_app_async_queue) {
+		dbgprint(mrioc, "%s: sending signal\n", __func__);
+		kill_fasync(&mpi3mr_app_async_queue, SIGIO, POLL_IN);
+	}
+}
+
+/**
+ * mpi3mr_app_save_logdata - Save Log Data events
+ * @mrioc: Adapter instance reference
+ * @event_data: event data associated with log data event
+ * @event_data_size: event data size to copy
+ *
+ * If log data event caching is enabled by the applicatiobns,
+ * then this function saves the log data in the circular queue
+ * and Sends async signal SIGIO to indicate there is an async
+ * event from the firmware to the event monitoring applications.
+ *
+ * Return:Nothing
+ */
+void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+	u16 event_data_size)
+{
+	u32 index = mrioc->logdata_buf_idx, sz;
+	struct mpi3mr_logdata_entry *entry;
+
+	if (!(mrioc->logdata_buf))
+		return;
+
+	entry = (struct mpi3mr_logdata_entry *)
+		(mrioc->logdata_buf + (index * mrioc->logdata_entry_sz));
+	entry->valid_entry = 1;
+	sz = min(mrioc->logdata_entry_sz, event_data_size);
+	memcpy(entry->data, event_data, sz);
+	mrioc->logdata_buf_idx =
+		((++index) % MPI3MR_IOCTL_LOGDATA_MAX_ENTRIES);
+	mpi3mr_app_send_aen(mrioc);
+}
+
 /**
  * mpi3mr_app_fasync - fasync callback
  * @fd: File descriptor
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 7da07fe71cfe..b57b89df0519 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -25,6 +25,9 @@ static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
 }
 #endif
 
+static void mpi3mr_pel_wait_complete(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd);
+
 static inline bool
 mpi3mr_check_req_qfull(struct op_req_qinfo *op_req_q)
 {
@@ -291,6 +294,10 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host_tag,
 		return &mrioc->ioctl_cmds;
 	case MPI3MR_HOSTTAG_BLK_TMS:
 		return &mrioc->host_tm_cmds;
+	case MPI3MR_HOSTTAG_PEL_ABORT:
+		return &mrioc->pel_abort_cmd;
+	case MPI3MR_HOSTTAG_PEL_WAIT:
+		return &mrioc->pel_cmds;
 	case MPI3MR_HOSTTAG_INVALID:
 		if (def_reply && def_reply->function ==
 		    MPI3_FUNCTION_EVENT_NOTIFICATION)
@@ -2481,6 +2488,14 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->host_tm_cmds.reply)
 		goto out_failed;
 
+	mrioc->pel_cmds.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
+	if (!mrioc->pel_cmds.reply)
+		goto out_failed;
+
+	mrioc->pel_abort_cmd.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
+	if (!mrioc->pel_abort_cmd.reply)
+		goto out_failed;
+
 	mrioc->dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
 	if (mrioc->facts.max_devhandle % 8)
 		mrioc->dev_handle_bitmap_sz++;
@@ -3414,6 +3429,16 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		goto out_failed;
 	}
 
+	if (!mrioc->pel_seqnum_virt) {
+		mrioc->pel_seqnum_sz = sizeof(struct mpi3_pel_seq);
+		mrioc->pel_seqnum_virt = dma_alloc_coherent(&mrioc->pdev->dev,
+		    mrioc->pel_seqnum_sz, &mrioc->pel_seqnum_dma,
+		    GFP_KERNEL);
+		if (!mrioc->pel_seqnum_virt)
+			goto out_failed;
+	}
+
+
 	for (i = 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
 		mrioc->event_masks[i] = -1;
 
@@ -3524,6 +3549,10 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 	memset(mrioc->ioctl_cmds.reply, 0, sizeof(*mrioc->ioctl_cmds.reply));
 	memset(mrioc->host_tm_cmds.reply, 0,
 	    sizeof(*mrioc->host_tm_cmds.reply));
+	memset(mrioc->pel_cmds.reply, 0,
+	    sizeof(*mrioc->pel_cmds.reply));
+	memset(mrioc->pel_abort_cmd.reply, 0,
+	    sizeof(*mrioc->pel_abort_cmd.reply));
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
 		memset(mrioc->dev_rmhs_cmds[i].reply, 0,
 		    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
@@ -3624,6 +3653,12 @@ static void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 	kfree(mrioc->host_tm_cmds.reply);
 	mrioc->host_tm_cmds.reply = NULL;
 
+	kfree(mrioc->pel_cmds.reply);
+	mrioc->pel_cmds.reply = NULL;
+
+	kfree(mrioc->pel_abort_cmd.reply);
+	mrioc->pel_abort_cmd.reply = NULL;
+
 	kfree(mrioc->removepend_bitmap);
 	mrioc->removepend_bitmap = NULL;
 
@@ -3665,6 +3700,12 @@ static void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		mrioc->admin_req_base = NULL;
 	}
 
+	if (mrioc->pel_seqnum_virt) {
+		dma_free_coherent(&mrioc->pdev->dev, mrioc->pel_seqnum_sz,
+		    mrioc->pel_seqnum_virt, mrioc->pel_seqnum_dma);
+		mrioc->pel_seqnum_virt = NULL;
+	}
+
 	kfree(mrioc->logdata_buf);
 	mrioc->logdata_buf = NULL;
 }
@@ -3822,6 +3863,13 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
 		cmdptr = &mrioc->dev_rmhs_cmds[i];
 		mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
 	}
+
+	cmdptr = &mrioc->pel_cmds;
+	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+
+	cmdptr = &mrioc->pel_abort_cmd;
+	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+
 }
 
 /**
@@ -3859,6 +3907,236 @@ int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
+/**
+ * mpi3mr_pel_wait_post - Issue PEL Wait
+ * @mrioc: Adapter instance reference
+ * @drv_cmd: Internal command tracker
+ *
+ * Issue PEL Wait MPI request through admin queue and return.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_pel_wait_post(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd)
+{
+	struct mpi3_pel_req_action_wait pel_wait;
+
+	mrioc->pel_abort_requested = false;
+
+	memset(&pel_wait, 0, sizeof(pel_wait));
+	drv_cmd->state = MPI3MR_CMD_PENDING;
+	drv_cmd->is_waiting = 0;
+	drv_cmd->callback = mpi3mr_pel_wait_complete;
+	drv_cmd->ioc_status = 0;
+	drv_cmd->ioc_loginfo = 0;
+	pel_wait.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_PEL_WAIT);
+	pel_wait.function = MPI3_FUNCTION_PERSISTENT_EVENT_LOG;
+	pel_wait.action = MPI3_PEL_ACTION_WAIT;
+	pel_wait.starting_sequence_number = cpu_to_le32(mrioc->pel_newest_seqnum);
+	pel_wait.locale = cpu_to_le16(mrioc->pel_locale);
+	pel_wait.class = cpu_to_le16(mrioc->pel_class);
+	pel_wait.wait_time = MPI3_PEL_WAITTIME_INFINITE_WAIT;
+	ioc_info(mrioc, "Issuing PELWait: seqnum %d class %d locale 0x%08x\n",
+	    mrioc->pel_newest_seqnum, mrioc->pel_class, mrioc->pel_locale);
+
+	if (mpi3mr_admin_request_post(mrioc, &pel_wait, sizeof(pel_wait), 0))
+		ioc_err(mrioc, "Issuing PELWait: Admin post failed\n");
+	else {
+		drv_cmd->state = MPI3MR_CMD_NOTUSED;
+		drv_cmd->callback = NULL;
+		drv_cmd->retry_count = 0;
+		mrioc->pel_enabled = false;
+	}
+
+	return;
+}
+
+/**
+ * mpi3mr_pel_get_seqnum_post - Issue PEL Get Sequence number
+ * @mrioc: Adapter instance reference
+ * @drv_cmd: Internal command tracker
+ *
+ * Issue PEL get sequence number MPI request through admin queue
+ * and return.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd)
+{
+	struct mpi3_pel_req_action_get_sequence_numbers pel_getseq_req;
+	u8 sgl_flags = MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
+	int retval = 0;
+
+	memset(&pel_getseq_req, 0, sizeof(pel_getseq_req));
+	mrioc->pel_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->pel_cmds.is_waiting = 0;
+	mrioc->pel_cmds.ioc_status = 0;
+	mrioc->pel_cmds.ioc_loginfo = 0;
+	mrioc->pel_cmds.callback = mpi3mr_pel_get_seqnum_complete;
+	pel_getseq_req.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_PEL_WAIT);
+	pel_getseq_req.function = MPI3_FUNCTION_PERSISTENT_EVENT_LOG;
+	pel_getseq_req.action = MPI3_PEL_ACTION_GET_SEQNUM;
+	mpi3mr_add_sg_single(&pel_getseq_req.sgl, sgl_flags,
+	    mrioc->pel_seqnum_sz, mrioc->pel_seqnum_dma);
+
+	retval = mpi3mr_admin_request_post(mrioc, &pel_getseq_req,
+			sizeof(pel_getseq_req), 0);
+	if (retval) {
+		if (drv_cmd) {
+			drv_cmd->state = MPI3MR_CMD_NOTUSED;
+			drv_cmd->callback = NULL;
+			drv_cmd->retry_count = 0;
+		}
+		mrioc->pel_enabled = false;
+	}
+
+	return retval;
+}
+
+/**
+ * mpi3mr_pel_wait_complete - PELWait Completion callback
+ * @mrioc: Adapter instance reference
+ * @drv_cmd: Internal command tracker
+ *
+ * This is a callback handler for the PELWait request and
+ * firmware completes a PELWait request when it is aborted or a
+ * new PEL entry is available. This sends AEN to the application
+ * and if the PELwait completion is not due to PELAbort then
+ * this will send a request for new PEL Sequence number
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_pel_wait_complete(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd)
+{
+	struct mpi3_pel_reply *pel_reply = NULL;
+	u16 ioc_status, pe_log_status;
+	bool do_retry = false;
+
+	if (drv_cmd->state & MPI3MR_CMD_RESET)
+		goto cleanup_drv_cmd;
+
+	ioc_status = drv_cmd->ioc_status & MPI3_IOCSTATUS_STATUS_MASK;
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "%s: Failed ioc_status(0x%04x) Loginfo(0x%08x)\n",
+			__func__, ioc_status, drv_cmd->ioc_loginfo);
+		do_retry = true;
+	}
+
+	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
+		pel_reply = (struct mpi3_pel_reply *)drv_cmd->reply;
+
+	if (!pel_reply) {
+		ioc_err(mrioc, "%s: Failed No Reply\n", __func__);
+		goto out_failed;
+	}
+
+	pe_log_status = le16_to_cpu(pel_reply->pe_log_status);
+	if ((pe_log_status != MPI3_PEL_STATUS_SUCCESS) &&
+	    (pe_log_status != MPI3_PEL_STATUS_ABORTED)) {
+		ioc_err(mrioc, "%s: Failed pe_log_status(0x%04x)\n",
+			__func__, pe_log_status);
+		do_retry = true;
+	}
+
+	if (do_retry) {
+		if (drv_cmd->retry_count < MPI3MR_PEL_RETRY_COUNT) {
+			drv_cmd->retry_count++;
+			ioc_info(mrioc, "%s: retry=%d\n",
+			    __func__,  drv_cmd->retry_count);
+			mpi3mr_pel_wait_post(mrioc, drv_cmd);
+			return;
+		}
+		ioc_err(mrioc, "%s: failed after all retries\n", __func__);
+		goto out_failed;
+	}
+	mpi3mr_app_send_aen(mrioc);
+	if (!mrioc->pel_abort_requested) {
+		mrioc->pel_cmds.retry_count = 0;
+		mpi3mr_pel_get_seqnum_post(mrioc, &mrioc->pel_cmds);
+	}
+
+	return;
+
+out_failed:
+	mrioc->pel_enabled = false;
+cleanup_drv_cmd:
+	drv_cmd->state = MPI3MR_CMD_NOTUSED;
+	drv_cmd->callback = NULL;
+	drv_cmd->retry_count = 0;
+}
+
+/**
+ * mpi3mr_pel_get_seqnum_complete - PELGetSeqNum Completion callback
+ * @mrioc: Adapter instance reference
+ * @drv_cmd: Internal command tracker
+ *
+ * This is a callback handler for the PEL get sequence number
+ * request and a new PEL wait request will be issued to the
+ * firmware from this
+ *
+ * Return: Nothing.
+ */
+void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd)
+{
+	struct mpi3_pel_reply *pel_reply = NULL;
+	struct mpi3_pel_seq *pel_seqnum_virt;
+	u16 ioc_status;
+	bool do_retry = false;
+
+	pel_seqnum_virt = (struct mpi3_pel_seq *)mrioc->pel_seqnum_virt;
+
+	if (drv_cmd->state & MPI3MR_CMD_RESET)
+		goto cleanup_drv_cmd;
+
+	ioc_status = drv_cmd->ioc_status & MPI3_IOCSTATUS_STATUS_MASK;
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "%s: Failed ioc_status(0x%04x) Loginfo(0x%08x)\n",
+			__func__, ioc_status, drv_cmd->ioc_loginfo);
+		do_retry = true;
+	}
+
+	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
+		pel_reply = (struct mpi3_pel_reply *)drv_cmd->reply;
+	if (!pel_reply) {
+		ioc_err(mrioc, "%s: Failed No Reply\n", __func__);
+		goto out_failed;
+	}
+
+	if (le16_to_cpu(pel_reply->pe_log_status) != MPI3_PEL_STATUS_SUCCESS) {
+		ioc_err(mrioc, "%s: Failed pe_log_status(0x%04x)\n", __func__,
+		    le16_to_cpu(pel_reply->pe_log_status));
+		do_retry = true;
+	}
+
+	if (do_retry) {
+		if (drv_cmd->retry_count < MPI3MR_PEL_RETRY_COUNT) {
+			drv_cmd->retry_count++;
+			ioc_info(mrioc, "%s: retry=%d\n",
+			    __func__,  drv_cmd->retry_count);
+			mpi3mr_pel_get_seqnum_post(mrioc, drv_cmd);
+			return;
+		}
+
+		ioc_err(mrioc, "%s: failed after all retries\n", __func__);
+		goto out_failed;
+	}
+	mrioc->pel_newest_seqnum = le32_to_cpu(pel_seqnum_virt->newest) + 1;
+	drv_cmd->retry_count = 0;
+	mpi3mr_pel_wait_post(mrioc, drv_cmd);
+
+	return;
+
+out_failed:
+	mrioc->pel_enabled = false;
+cleanup_drv_cmd:
+	drv_cmd->state = MPI3MR_CMD_NOTUSED;
+	drv_cmd->callback = NULL;
+	drv_cmd->retry_count = 0;
+}
+
 /**
  * mpi3mr_soft_reset_handler - Reset the controller
  * @mrioc: Adapter instance reference
@@ -3964,6 +4242,11 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 out:
 	if (!retval) {
 		mrioc->reset_in_progress = 0;
+		mrioc->pel_abort_requested = 0;
+		if (mrioc->pel_enabled) {
+			mrioc->pel_cmds.retry_count = 0;
+			mpi3mr_pel_get_seqnum_post(mrioc, &mrioc->pel_cmds);
+		}
 		scsi_unblock_requests(mrioc->shost);
 		mpi3mr_rfresh_tgtdevs(mrioc);
 		mrioc->ts_update_counter = 0;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index cd53c4920207..149ba3fdfceb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1255,6 +1255,23 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	}
 }
 
+/**
+ * mpi3mr_logdata_evt_bh -  Log data event bottomhalf
+ * @mrioc: Adapter instance reference
+ * @fwevt: Firmware event reference
+ *
+ * Extracts the event data and calls application interfacing
+ * function to process the event further.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_fwevt *fwevt)
+{
+	mpi3mr_app_save_logdata(mrioc, fwevt->event_data,
+	    fwevt->evt_data_size);
+}
+
 /**
  * mpi3mr_fwevt_bh - Firmware event bottomhalf handler
  * @mrioc: Adapter instance reference
@@ -1307,6 +1324,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 		mpi3mr_pcietopochg_evt_bh(mrioc, fwevt);
 		break;
 	}
+	case MPI3_EVENT_LOG_DATA:
+	{
+		mpi3mr_logdata_evt_bh(mrioc, fwevt);
+		break;
+	}
 	default:
 		break;
 	}
@@ -1906,6 +1928,7 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		break;
 	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
+	case MPI3_EVENT_LOG_DATA:
 	{
 		process_evt_bh = 1;
 		break;
-- 
2.18.1


--000000000000605b5605cc85d07f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPyK9kokphkOo5npV0D0mg+dc/gc
APZUC6ZZpbKQ5FM+MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDkyMTE4NDYyMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCNa11AcOghzhjjxQlZNst81HBnPJVsmiei8jFVc+0Msa4G
rD1WXwl2RCBkp570/Jpe+0gW6+lbXShVkE67vkUFcWu4zb0xI2EizAroPe+JIdD7Lqi20/yUn6ab
khh4d6IU+tJWojVN3cy3l3p/Z+oNcqAbiTD0d7m/46pjLuFUlL5+SDupGQCaW1/NOKNNShQHUslW
DuSBqIOmqBr27hi4O2diuYtobosfA0ViP+pO8MQMhjjYqOvRKMKQx/gHI2Sf3Jcb/ediDrj80fkc
Gb/BMSWfgCmnR9Siuay118snXaJKs2lTnw/CHTHbMUdYPWT8ljt4ytbV1eHwOHyDRBi0
--000000000000605b5605cc85d07f--
