Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809B7C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Apr 2022 12:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241933AbiDYMae (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 08:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242130AbiDYMaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 08:30:02 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7E36F4AD
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 05:24:44 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n8so26734382plh.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 05:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=0j+aAp5TuaS6+6wjPHHNcki/OWTzBWNWB8yzsGtjfEg=;
        b=aBy0xlfMmTitHx9mcJt2pktUA/wMT35E81DESvQn4K3yY0YDefxs0jgWe7vExWZWdP
         V4yJyy93LhoT8dWjBpPRq35zNyu0OhIdlkwQngz3ggfCHeh0+Tpa6frSlJeZobHngGGm
         wUZXfrXGZklsOvWg/p/k1odJle2caSSWlttnA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=0j+aAp5TuaS6+6wjPHHNcki/OWTzBWNWB8yzsGtjfEg=;
        b=FRoIqbxIh/ia1kC73vljSXIW07Tlu9AtxENwQgZ37/7T+klAadvC5rSPDbKBqRlciC
         PADs6LoUz9SlhwAoKnEUN26VFxU5Ulh3gPZmzcuXjhR0sImdx5rX0DpfHqk3sEEvVmlO
         8MYawMxMEI6ZcNjHTpgmw3sX8ns3qihprub/2hUlG/W0KOSxSwb9w0Y65kpcAE3tC2Pu
         lAYIzPx9+Tr/TLftzHVc+drBPHwb/w5hXjZo8WJDmExpPZFGp9CvWqX2WegVUSxwRLvP
         WKrHmfaMXxAwgLF01i6F3WBtNTp55zM+FZrNOs3A3PeHaR0Tufef4aDV1a1l96Jdv1AG
         TrRA==
X-Gm-Message-State: AOAM532ulLWAQkU6wpuvKocmadCnLHCCPVHyQLuMc6YKIaOnwMKtn4/L
        AbxunxRk+IuJWAHl0i7yKRFjx4fvJKmCCaAGUtiAO+Rg9By3fxKRN1DpV0mNQnAG7+VWjhanYsM
        J3Awwedg5jMJNUHqAjXiTs16SIq2OQyifoKoUjLeXgPn/u3jMvQtX0PTuQK+ZlSawdKAz7qeq81
        Fc45MiMPQ=
X-Google-Smtp-Source: ABdhPJwZ1/Lg5cMchsGIJRViwS+PHKg4gOw4XfmZNEtM63erXu32Op06un5yI5Rnt5YTcdbk/X42wg==
X-Received: by 2002:a17:902:8547:b0:15c:f02f:cd0b with SMTP id d7-20020a170902854700b0015cf02fcd0bmr9878481plo.117.1650889483939;
        Mon, 25 Apr 2022 05:24:43 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm9757722pge.23.2022.04.25.05.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 05:24:43 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        hare@suse.de, himanshu.madhani@oracle.com,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v6 5/8] mpi3mr: add support for PEL commands
Date:   Mon, 25 Apr 2022 08:23:31 -0400
Message-Id: <20220425122334.368142-6-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220425122334.368142-1-sumit.saxena@broadcom.com>
References: <20220425122334.368142-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004a436b05dd79a96c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000004a436b05dd79a96c
Content-Transfer-Encoding: 8bit

This patch includes driver support for the management applications to
enable the persistent event log(PEL) notification. Upon receipt of events,
driver will increment sysfs variable named as event_counter. Application
would poll for event_counter value and any change in it would signal the
applications about events.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  36 +++-
 drivers/scsi/mpi3mr/mpi3mr_app.c | 205 ++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 310 +++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  42 +++++
 4 files changed, 592 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 37be9e28e0b2..cc54231da658 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -53,6 +53,7 @@
 extern spinlock_t mrioc_list_lock;
 extern struct list_head mrioc_list;
 extern int prot_mask;
+extern atomic64_t event_counter;
 
 #define MPI3MR_DRIVER_VERSION	"8.0.0.68.0"
 #define MPI3MR_DRIVER_RELDATE	"10-February-2022"
@@ -91,6 +92,8 @@ extern int prot_mask;
 #define MPI3MR_HOSTTAG_INVALID		0xFFFF
 #define MPI3MR_HOSTTAG_INITCMDS		1
 #define MPI3MR_HOSTTAG_BSG_CMDS		2
+#define MPI3MR_HOSTTAG_PEL_ABORT	3
+#define MPI3MR_HOSTTAG_PEL_WAIT		4
 #define MPI3MR_HOSTTAG_BLK_TMS		5
 
 #define MPI3MR_NUM_DEVRMCMD		16
@@ -152,6 +155,7 @@ extern int prot_mask;
 
 /* Command retry count definitions */
 #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
+#define MPI3MR_PEL_RETRY_COUNT 3
 
 /* Default target device queue depth */
 #define MPI3MR_DEFAULT_SDEV_QD	32
@@ -748,6 +752,16 @@ struct scmd_priv {
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
  * @default_qcount: Total Default queues
  * @active_poll_qcount: Currently active poll queue count
@@ -894,8 +908,20 @@ struct mpi3mr_ioc {
 	struct mpi3mr_fwevt *current_event;
 	struct mpi3_driver_info_layout driver_info;
 	u16 change_count;
-	u16 op_reply_q_offset;
 
+	u8 pel_enabled;
+	u8 pel_abort_requested;
+	u8 pel_class;
+	u16 pel_locale;
+	struct mpi3mr_drv_cmd pel_cmds;
+	struct mpi3mr_drv_cmd pel_abort_cmd;
+
+	u32 pel_newest_seqnum;
+	void *pel_seqnum_virt;
+	dma_addr_t pel_seqnum_dma;
+	u32 pel_seqnum_sz;
+
+	u16 op_reply_q_offset;
 	u16 default_qcount;
 	u16 active_poll_qcount;
 	u16 requested_poll_qcount;
@@ -918,6 +944,7 @@ struct mpi3mr_ioc {
  * @send_ack: Event acknowledgment required or not
  * @process_evt: Bottomhalf processing required or not
  * @evt_ctx: Event context to send in Ack
+ * @event_data_size: size of the event data in bytes
  * @pending_at_sml: waiting for device add/remove API to complete
  * @discard: discard this event
  * @ref_count: kref count
@@ -931,6 +958,7 @@ struct mpi3mr_fwevt {
 	bool send_ack;
 	bool process_evt;
 	u32 evt_ctx;
+	u16 event_data_size;
 	bool pending_at_sml;
 	bool discard;
 	struct kref ref_count;
@@ -1022,5 +1050,11 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	u8 *resp_code, struct scsi_cmnd *scmd);
 struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
 	struct mpi3mr_ioc *mrioc, u16 handle);
+void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd);
+int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd);
+void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+	u16 event_data_size);
 
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 633fd91dbea0..06a1e950bec4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -11,6 +11,95 @@
 #include <linux/bsg-lib.h>
 #include <uapi/scsi/scsi_bsg_mpi3mr.h>
 
+/**
+ * mpi3mr_bsg_pel_abort - sends PEL abort request
+ * @mrioc: Adapter instance reference
+ *
+ * This function sends PEL abort request to the firmware through
+ * admin request queue.
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int mpi3mr_bsg_pel_abort(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3_pel_req_action_abort pel_abort_req;
+	struct mpi3_pel_reply *pel_reply;
+	int retval = 0;
+	u16 pe_log_status;
+
+	if (mrioc->reset_in_progress) {
+		dprint_bsg_err(mrioc, "%s: reset in progress\n", __func__);
+		return -1;
+	}
+	if (mrioc->stop_bsgs) {
+		dprint_bsg_err(mrioc, "%s: bsgs are blocked\n", __func__);
+		return -1;
+	}
+
+	memset(&pel_abort_req, 0, sizeof(pel_abort_req));
+	mutex_lock(&mrioc->pel_abort_cmd.mutex);
+	if (mrioc->pel_abort_cmd.state & MPI3MR_CMD_PENDING) {
+		dprint_bsg_err(mrioc, "%s: command is in use\n", __func__);
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
+	mrioc->pel_abort_requested = 1;
+	init_completion(&mrioc->pel_abort_cmd.done);
+	retval = mpi3mr_admin_request_post(mrioc, &pel_abort_req,
+	    sizeof(pel_abort_req), 0);
+	if (retval) {
+		retval = -1;
+		dprint_bsg_err(mrioc, "%s: admin request post failed\n",
+		    __func__);
+		mrioc->pel_abort_requested = 0;
+		goto out_unlock;
+	}
+
+	wait_for_completion_timeout(&mrioc->pel_abort_cmd.done,
+	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
+	if (!(mrioc->pel_abort_cmd.state & MPI3MR_CMD_COMPLETE)) {
+		mrioc->pel_abort_cmd.is_waiting = 0;
+		dprint_bsg_err(mrioc, "%s: command timedout\n", __func__);
+		if (!(mrioc->pel_abort_cmd.state & MPI3MR_CMD_RESET))
+			mpi3mr_soft_reset_handler(mrioc,
+			    MPI3MR_RESET_FROM_PELABORT_TIMEOUT, 1);
+		retval = -1;
+		goto out_unlock;
+	}
+	if ((mrioc->pel_abort_cmd.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	     != MPI3_IOCSTATUS_SUCCESS) {
+		dprint_bsg_err(mrioc,
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
+			dprint_bsg_err(mrioc,
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
 /**
  * mpi3mr_bsg_verify_adapter - verify adapter number is valid
  * @ioc_number: Adapter number
@@ -107,6 +196,87 @@ static long mpi3mr_get_logdata(struct mpi3mr_ioc *mrioc,
 	return -EINVAL;
 }
 
+/**
+ * mpi3mr_bsg_pel_enable - Handler for PEL enable driver
+ * @mrioc: Adapter instance reference
+ * @job: BSG job pointer
+ *
+ * This function is the handler for PEL enable driver.
+ * Validates the application given class and locale and if
+ * requires aborts the existing PEL wait request and/or issues
+ * new PEL wait request to the firmware and returns.
+ *
+ * Return: 0 on success and proper error codes on failure.
+ */
+static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
+				  struct bsg_job *job)
+{
+	long rval = -EINVAL;
+	struct mpi3mr_bsg_out_pel_enable pel_enable;
+	u8 issue_pel_wait;
+	u8 tmp_class;
+	u16 tmp_locale;
+
+	if (job->request_payload.payload_len != sizeof(pel_enable)) {
+		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
+		    __func__);
+		return rval;
+	}
+
+	sg_copy_to_buffer(job->request_payload.sg_list,
+			  job->request_payload.sg_cnt,
+			  &pel_enable, sizeof(pel_enable));
+
+	if (pel_enable.pel_class > MPI3_PEL_CLASS_FAULT) {
+		dprint_bsg_err(mrioc, "%s: out of range class %d sent\n",
+			__func__, pel_enable.pel_class);
+		rval = 0;
+		goto out;
+	}
+	if (!mrioc->pel_enabled)
+		issue_pel_wait = 1;
+	else {
+		if ((mrioc->pel_class <= pel_enable.pel_class) &&
+		    !((mrioc->pel_locale & pel_enable.pel_locale) ^
+		      pel_enable.pel_locale)) {
+			issue_pel_wait = 0;
+			rval = 0;
+		} else {
+			pel_enable.pel_locale |= mrioc->pel_locale;
+
+			if (mrioc->pel_class < pel_enable.pel_class)
+				pel_enable.pel_class = mrioc->pel_class;
+
+			rval = mpi3mr_bsg_pel_abort(mrioc);
+			if (rval) {
+				dprint_bsg_err(mrioc,
+				    "%s: pel_abort failed, status(%ld)\n",
+				    __func__, rval);
+				goto out;
+			}
+			issue_pel_wait = 1;
+		}
+	}
+	if (issue_pel_wait) {
+		tmp_class = mrioc->pel_class;
+		tmp_locale = mrioc->pel_locale;
+		mrioc->pel_class = pel_enable.pel_class;
+		mrioc->pel_locale = pel_enable.pel_locale;
+		mrioc->pel_enabled = 1;
+		rval = mpi3mr_pel_get_seqnum_post(mrioc, NULL);
+		if (rval) {
+			mrioc->pel_class = tmp_class;
+			mrioc->pel_locale = tmp_locale;
+			mrioc->pel_enabled = 0;
+			dprint_bsg_err(mrioc,
+			    "%s: pel get sequence number failed, status(%ld)\n",
+			    __func__, rval);
+		}
+	}
+
+out:
+	return rval;
+}
 /**
  * mpi3mr_get_all_tgt_info - Get all target information
  * @mrioc: Adapter instance reference
@@ -372,6 +542,9 @@ static long mpi3mr_bsg_process_drv_cmds(struct bsg_job *job)
 	case MPI3MR_DRVBSG_OPCODE_GETLOGDATA:
 		rval = mpi3mr_get_logdata(mrioc, job);
 		break;
+	case MPI3MR_DRVBSG_OPCODE_PELENABLE:
+		rval = mpi3mr_bsg_pel_enable(mrioc, job);
+		break;
 	case MPI3MR_DRVBSG_OPCODE_UNKNOWN:
 	default:
 		pr_err("%s: unsupported driver command opcode %d\n",
@@ -897,6 +1070,38 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 	return rval;
 }
 
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
+		((++index) % MPI3MR_BSG_LOGDATA_MAX_ENTRIES);
+	atomic64_inc(&event_counter);
+}
+
 /**
  * mpi3mr_bsg_request - bsg request entry point
  * @job: BSG job reference
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 480730721f50..74e09727a1b8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -15,6 +15,8 @@ mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u32 reset_reason);
 static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc);
 static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	struct mpi3_ioc_facts_data *facts_data);
+static void mpi3mr_pel_wait_complete(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd);
 
 static int poll_queues;
 module_param(poll_queues, int, 0444);
@@ -301,6 +303,10 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host_tag,
 		return &mrioc->bsg_cmds;
 	case MPI3MR_HOSTTAG_BLK_TMS:
 		return &mrioc->host_tm_cmds;
+	case MPI3MR_HOSTTAG_PEL_ABORT:
+		return &mrioc->pel_abort_cmd;
+	case MPI3MR_HOSTTAG_PEL_WAIT:
+		return &mrioc->pel_cmds;
 	case MPI3MR_HOSTTAG_INVALID:
 		if (def_reply && def_reply->function ==
 		    MPI3_FUNCTION_EVENT_NOTIFICATION)
@@ -2837,6 +2843,14 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->host_tm_cmds.reply)
 		goto out_failed;
 
+	mrioc->pel_cmds.reply = kzalloc(mrioc->reply_sz, GFP_KERNEL);
+	if (!mrioc->pel_cmds.reply)
+		goto out_failed;
+
+	mrioc->pel_abort_cmd.reply = kzalloc(mrioc->reply_sz, GFP_KERNEL);
+	if (!mrioc->pel_abort_cmd.reply)
+		goto out_failed;
+
 	mrioc->dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
 	if (mrioc->facts.max_devhandle % 8)
 		mrioc->dev_handle_bitmap_sz++;
@@ -3734,6 +3748,16 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
+	if (!mrioc->pel_seqnum_virt) {
+		dprint_init(mrioc, "allocating memory for pel_seqnum_virt\n");
+		mrioc->pel_seqnum_sz = sizeof(struct mpi3_pel_seq);
+		mrioc->pel_seqnum_virt = dma_alloc_coherent(&mrioc->pdev->dev,
+		    mrioc->pel_seqnum_sz, &mrioc->pel_seqnum_dma,
+		    GFP_KERNEL);
+		if (!mrioc->pel_seqnum_virt)
+			goto out_failed_noretry;
+	}
+
 	retval = mpi3mr_enable_events(mrioc);
 	if (retval) {
 		ioc_err(mrioc, "failed to enable events %d\n",
@@ -3843,6 +3867,16 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed;
 	}
 
+	if (!mrioc->pel_seqnum_virt) {
+		dprint_reset(mrioc, "allocating memory for pel_seqnum_virt\n");
+		mrioc->pel_seqnum_sz = sizeof(struct mpi3_pel_seq);
+		mrioc->pel_seqnum_virt = dma_alloc_coherent(&mrioc->pdev->dev,
+		    mrioc->pel_seqnum_sz, &mrioc->pel_seqnum_dma,
+		    GFP_KERNEL);
+		if (!mrioc->pel_seqnum_virt)
+			goto out_failed_noretry;
+	}
+
 	if (mrioc->shost->nr_hw_queues > mrioc->num_op_reply_q) {
 		ioc_err(mrioc,
 		    "cannot create minimum number of operational queues expected:%d created:%d\n",
@@ -3958,6 +3992,10 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		    sizeof(*mrioc->bsg_cmds.reply));
 		memset(mrioc->host_tm_cmds.reply, 0,
 		    sizeof(*mrioc->host_tm_cmds.reply));
+		memset(mrioc->pel_cmds.reply, 0,
+		    sizeof(*mrioc->pel_cmds.reply));
+		memset(mrioc->pel_abort_cmd.reply, 0,
+		    sizeof(*mrioc->pel_abort_cmd.reply));
 		for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
 			memset(mrioc->dev_rmhs_cmds[i].reply, 0,
 			    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
@@ -4064,6 +4102,12 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 	kfree(mrioc->host_tm_cmds.reply);
 	mrioc->host_tm_cmds.reply = NULL;
 
+	kfree(mrioc->pel_cmds.reply);
+	mrioc->pel_cmds.reply = NULL;
+
+	kfree(mrioc->pel_abort_cmd.reply);
+	mrioc->pel_abort_cmd.reply = NULL;
+
 	for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++) {
 		kfree(mrioc->evtack_cmds[i].reply);
 		mrioc->evtack_cmds[i].reply = NULL;
@@ -4112,6 +4156,16 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		    mrioc->admin_req_base, mrioc->admin_req_dma);
 		mrioc->admin_req_base = NULL;
 	}
+
+	if (mrioc->pel_seqnum_virt) {
+		dma_free_coherent(&mrioc->pdev->dev, mrioc->pel_seqnum_sz,
+		    mrioc->pel_seqnum_virt, mrioc->pel_seqnum_dma);
+		mrioc->pel_seqnum_virt = NULL;
+	}
+
+	kfree(mrioc->logdata_buf);
+	mrioc->logdata_buf = NULL;
+
 }
 
 /**
@@ -4260,6 +4314,254 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
 		cmdptr = &mrioc->evtack_cmds[i];
 		mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
 	}
+
+	cmdptr = &mrioc->pel_cmds;
+	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+
+	cmdptr = &mrioc->pel_abort_cmd;
+	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+
+}
+
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
+	dprint_bsg_info(mrioc, "sending pel_wait seqnum(%d), class(%d), locale(0x%08x)\n",
+	    mrioc->pel_newest_seqnum, mrioc->pel_class, mrioc->pel_locale);
+
+	if (mpi3mr_admin_request_post(mrioc, &pel_wait, sizeof(pel_wait), 0)) {
+		dprint_bsg_err(mrioc,
+			    "Issuing PELWait: Admin post failed\n");
+		drv_cmd->state = MPI3MR_CMD_NOTUSED;
+		drv_cmd->callback = NULL;
+		drv_cmd->retry_count = 0;
+		mrioc->pel_enabled = false;
+	}
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
+		dprint_bsg_err(mrioc,
+		    "pel_wait: failed with ioc_status(0x%04x), log_info(0x%08x)\n",
+		    ioc_status, drv_cmd->ioc_loginfo);
+		do_retry = true;
+	}
+
+	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
+		pel_reply = (struct mpi3_pel_reply *)drv_cmd->reply;
+
+	if (!pel_reply) {
+		dprint_bsg_err(mrioc,
+		    "pel_wait: failed due to no reply\n");
+		goto out_failed;
+	}
+
+	pe_log_status = le16_to_cpu(pel_reply->pe_log_status);
+	if ((pe_log_status != MPI3_PEL_STATUS_SUCCESS) &&
+	    (pe_log_status != MPI3_PEL_STATUS_ABORTED)) {
+		ioc_err(mrioc, "%s: Failed pe_log_status(0x%04x)\n",
+			__func__, pe_log_status);
+		dprint_bsg_err(mrioc,
+		    "pel_wait: failed due to pel_log_status(0x%04x)\n",
+		    pe_log_status);
+		do_retry = true;
+	}
+
+	if (do_retry) {
+		if (drv_cmd->retry_count < MPI3MR_PEL_RETRY_COUNT) {
+			drv_cmd->retry_count++;
+			dprint_bsg_err(mrioc, "pel_wait: retrying(%d)\n",
+			    drv_cmd->retry_count);
+			mpi3mr_pel_wait_post(mrioc, drv_cmd);
+			return;
+		}
+		dprint_bsg_err(mrioc,
+		    "pel_wait: failed after all retries(%d)\n",
+		    drv_cmd->retry_count);
+		goto out_failed;
+	}
+	atomic64_inc(&event_counter);
+	if (!mrioc->pel_abort_requested) {
+		mrioc->pel_cmds.retry_count = 0;
+		mpi3mr_pel_get_seqnum_post(mrioc, &mrioc->pel_cmds);
+	}
+
+	return;
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
+		dprint_bsg_err(mrioc,
+		    "pel_get_seqnum: failed with ioc_status(0x%04x), log_info(0x%08x)\n",
+		    ioc_status, drv_cmd->ioc_loginfo);
+		do_retry = true;
+	}
+
+	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
+		pel_reply = (struct mpi3_pel_reply *)drv_cmd->reply;
+	if (!pel_reply) {
+		dprint_bsg_err(mrioc,
+		    "pel_get_seqnum: failed due to no reply\n");
+		goto out_failed;
+	}
+
+	if (le16_to_cpu(pel_reply->pe_log_status) != MPI3_PEL_STATUS_SUCCESS) {
+		dprint_bsg_err(mrioc,
+		    "pel_get_seqnum: failed due to pel_log_status(0x%04x)\n",
+		    le16_to_cpu(pel_reply->pe_log_status));
+		do_retry = true;
+	}
+
+	if (do_retry) {
+		if (drv_cmd->retry_count < MPI3MR_PEL_RETRY_COUNT) {
+			drv_cmd->retry_count++;
+			dprint_bsg_err(mrioc,
+			    "pel_get_seqnum: retrying(%d)\n",
+			    drv_cmd->retry_count);
+			mpi3mr_pel_get_seqnum_post(mrioc, drv_cmd);
+			return;
+		}
+
+		dprint_bsg_err(mrioc,
+		    "pel_get_seqnum: failed after all retries(%d)\n",
+		    drv_cmd->retry_count);
+		goto out_failed;
+	}
+	mrioc->pel_newest_seqnum = le32_to_cpu(pel_seqnum_virt->newest) + 1;
+	drv_cmd->retry_count = 0;
+	mpi3mr_pel_wait_post(mrioc, drv_cmd);
+
+	return;
+out_failed:
+	mrioc->pel_enabled = false;
+cleanup_drv_cmd:
+	drv_cmd->state = MPI3MR_CMD_NOTUSED;
+	drv_cmd->callback = NULL;
+	drv_cmd->retry_count = 0;
 }
 
 /**
@@ -4383,6 +4685,12 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	if (!retval) {
 		mrioc->diagsave_timeout = 0;
 		mrioc->reset_in_progress = 0;
+		mrioc->pel_abort_requested = 0;
+		if (mrioc->pel_enabled) {
+			mrioc->pel_cmds.retry_count = 0;
+			mpi3mr_pel_wait_post(mrioc, &mrioc->pel_cmds);
+		}
+
 		mpi3mr_rfresh_tgtdevs(mrioc);
 		mrioc->ts_update_counter = 0;
 		spin_lock_irqsave(&mrioc->watchdog_lock, flags);
@@ -4392,6 +4700,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 			    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
 		spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
 		mrioc->stop_bsgs = 0;
+		if (mrioc->pel_enabled)
+			atomic64_inc(&event_counter);
 	} else {
 		mpi3mr_issue_reset(mrioc,
 		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 450574fc1fec..19298136edb6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -14,6 +14,7 @@ LIST_HEAD(mrioc_list);
 DEFINE_SPINLOCK(mrioc_list_lock);
 static int mrioc_ids;
 static int warn_non_secure_ctlr;
+atomic64_t event_counter;
 
 MODULE_AUTHOR(MPI3MR_DRIVER_AUTHOR);
 MODULE_DESCRIPTION(MPI3MR_DRIVER_DESC);
@@ -1415,6 +1416,23 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
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
+	    fwevt->event_data_size);
+}
+
 /**
  * mpi3mr_fwevt_bh - Firmware event bottomhalf handler
  * @mrioc: Adapter instance reference
@@ -1467,6 +1485,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
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
@@ -2298,6 +2321,7 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		break;
 	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
+	case MPI3_EVENT_LOG_DATA:
 	{
 		process_evt_bh = 1;
 		break;
@@ -4568,6 +4592,12 @@ static struct pci_driver mpi3mr_pci_driver = {
 #endif
 };
 
+static ssize_t event_counter_show(struct device_driver *dd, char *buf)
+{
+	return sprintf(buf, "%llu\n", atomic64_read(&event_counter));
+}
+static DRIVER_ATTR_RO(event_counter);
+
 static int __init mpi3mr_init(void)
 {
 	int ret_val;
@@ -4576,6 +4606,16 @@ static int __init mpi3mr_init(void)
 	    MPI3MR_DRIVER_VERSION);
 
 	ret_val = pci_register_driver(&mpi3mr_pci_driver);
+	if (ret_val) {
+		pr_err("%s failed to load due to pci register driver failure\n",
+		    MPI3MR_DRIVER_NAME);
+		return ret_val;
+	}
+
+	ret_val = driver_create_file(&mpi3mr_pci_driver.driver,
+				     &driver_attr_event_counter);
+	if (ret_val)
+		pci_unregister_driver(&mpi3mr_pci_driver);
 
 	return ret_val;
 }
@@ -4590,6 +4630,8 @@ static void __exit mpi3mr_exit(void)
 		pr_info("Unloading %s version %s\n", MPI3MR_DRIVER_NAME,
 		    MPI3MR_DRIVER_VERSION);
 
+	driver_remove_file(&mpi3mr_pci_driver.driver,
+			   &driver_attr_event_counter);
 	pci_unregister_driver(&mpi3mr_pci_driver);
 }
 
-- 
2.27.0


--0000000000004a436b05dd79a96c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEII9N1FsJquYbFHniEu/0nc7WkB0FKre2
KM0Jog3+M9onMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQy
NTEyMjQ0NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDAEOJNwzMzuZgvxaN3vdp0gfMX7Vytc0EZ2Y65zxKZ7mFkTK4M
m56w+W7jj0q6/JpcH6fi7TVeJOthDKOzolucsUxW6f/Na7IjlWGJIDN55nwOS4JReDhfErtfED9A
RQ7/WeSSE1Bq5D012jcuQ3mYj9ueU/4i0ey3Il3oWaJnPvX/kkRJyJkQxrCBGQaGiSRIcnkQeKjx
TAFCTdQQbTc6KOCc5HfegEE2goNwLilvjua1TMN4ryIrhQvrWHm18mAtIgzGLFuGfJmym35J2OOf
sWi0PfebLJDmayCDwTIyZJUg2Gl8qOPT2OMFcaHbYcxMyX94FDHfYQ93nLMqLJBc
--0000000000004a436b05dd79a96c--
