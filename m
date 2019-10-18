Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A22CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D68A2089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cabcoxN8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503028AbfJRVTP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45164 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502466AbfJRVTO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id y72so4598223pfb.12
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vBRUhSKbRvPUMdJRZt7tcEK76G3r/xM6LzBMXROg9M8=;
        b=cabcoxN8kK9yDLKv1rNDWGiDG4Ne8H2a4JrwgXCQyIsZlKQM2kmCrG9laBo25lpECc
         KfSvyVisnzHnROFmsQCBrresOJbNBrr7QloWMz4qB1buhCHPCZY4YtU1mXCZRcOLlbig
         NUftjBLXHB2ixNBnJxUKJYnony8xpi0tjZbG0vkyzCxj1yu/KgtfZqkiNkP+rSf75Pi7
         LQE0x0BZqVq6edfDNl/t46U5rRusvx/WjiiK02uSTeRlqvBnjR+WHNqzh8W2U4JRlZKS
         wiuMRhALePCMxkrAf/rk8gzScjYfEICavBG+W3jwqKIcLAtcG6cl/AojfF6cP0IruERj
         /Phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vBRUhSKbRvPUMdJRZt7tcEK76G3r/xM6LzBMXROg9M8=;
        b=jLeBhAGrIQa32Kr0W374dayfszAg1p2rIGas+peAibrPYdXGAGQ1li+TJFaR/dOZWx
         jU+EUJWL2LfB1IPS6wdhPNmiBKQLJHZ15St6WWMkfxIXvzZZ0totqqlgf5TB3FzUoc4H
         yBn4pQGpfXVJshRt9DOtK4488MUxcAilKWjBEZgtJdJOaOjm7EnJofGHjYPSlckvtFhK
         RBlwHhd1X29yBKUjRRdL32rMlRc2GSw6xGbASXo7klmGx36F4+Tau4NXqVIQjzexGnDv
         bHacuTVEY+nsTx82TRtf59oGiIvjtjdu/Z5O5zug5bRuKqS1xfjOH9p6pQU3NDyY5lp4
         UVBQ==
X-Gm-Message-State: APjAAAVwLvJxiV8M461c1gItf8j8qfeKakG276dqDfnkdl7c7DXzqYs0
        BTsQr0aWxQCsgZJ1LB7Xi6JwKDSu
X-Google-Smtp-Source: APXvYqyV/pr7Rxg+NlO3vUH1EIZeSbjNeODvI6V43EOlX3p0AvAxUvT4QH9npyTFlVdtG1nC5xE9CA==
X-Received: by 2002:a62:60c6:: with SMTP id u189mr9143087pfb.4.1571433553452;
        Fri, 18 Oct 2019 14:19:13 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:13 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 11/16] lpfc: Make FW logging dynamically configurable
Date:   Fri, 18 Oct 2019 14:18:27 -0700
Message-Id: <20191018211832.7917-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, the FW logging facility is a load/boot time parameter
which requires the driver to be unloaded/reloaded or the system
rebooted in order to change it's configuration.

Convert the logging facility to allow dynamic enablement and
configuration. Specifically:
- Convert the feature so that it can be enabled dynamically via an
  attribute.  Additionally, the size of the buffer can be configured
  dynamically.
- Add locks around states that now may be changing.
- Tie the feature into debugfs so that the logs can be read at
  any time.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |   9 ++-
 drivers/scsi/lpfc/lpfc_attr.c    |  48 +++++++++++++++-
 drivers/scsi/lpfc/lpfc_bsg.c     |  18 ++++--
 drivers/scsi/lpfc/lpfc_debugfs.c | 117 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.c     |  22 +++++++-
 5 files changed, 204 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index dabb5eac5fed..884d6076d7aa 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -605,6 +605,12 @@ struct lpfc_epd_pool {
 	spinlock_t lock;	/* lock for expedite pool */
 };
 
+enum ras_state {
+	INACTIVE,
+	REG_INPROGRESS,
+	ACTIVE
+};
+
 struct lpfc_ras_fwlog {
 	uint8_t *fwlog_buff;
 	uint32_t fw_buffcount; /* Buffer size posted to FW */
@@ -621,7 +627,7 @@ struct lpfc_ras_fwlog {
 	bool ras_enabled;   /* Ras Enabled for the function */
 #define LPFC_RAS_DISABLE_LOGGING 0x00
 #define LPFC_RAS_ENABLE_LOGGING 0x01
-	bool ras_active;    /* RAS logging running state */
+	enum ras_state state;    /* RAS logging running state */
 };
 
 struct lpfc_hba {
@@ -1053,6 +1059,7 @@ struct lpfc_hba {
 #ifdef LPFC_HDWQ_LOCK_STAT
 	struct dentry *debug_lockstat;
 #endif
+	struct dentry *debug_ras_log;
 	atomic_t nvmeio_trc_cnt;
 	uint32_t nvmeio_trc_size;
 	uint32_t nvmeio_trc_output_idx;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 266a71b01c47..ba504cc6e8ed 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5932,7 +5932,53 @@ LPFC_ATTR_RW(enable_mds_diags, 0, 0, 1, "Enable MDS Diagnostics");
  *	[1-4] = Multiple of 1/4th Mb of host memory for FW logging
  * Value range [0..4]. Default value is 0
  */
-LPFC_ATTR_RW(ras_fwlog_buffsize, 0, 0, 4, "Host memory for FW logging");
+LPFC_ATTR(ras_fwlog_buffsize, 0, 0, 4, "Host memory for FW logging");
+lpfc_param_show(ras_fwlog_buffsize);
+
+static ssize_t
+lpfc_ras_fwlog_buffsize_set(struct lpfc_hba  *phba, uint val)
+{
+	int ret = 0;
+	enum ras_state state;
+
+	if (!lpfc_rangecheck(val, 0, 4))
+		return -EINVAL;
+
+	if (phba->cfg_ras_fwlog_buffsize == val)
+		return 0;
+
+	if (phba->cfg_ras_fwlog_func == PCI_FUNC(phba->pcidev->devfn))
+		return -EINVAL;
+
+	spin_lock_irq(&phba->hbalock);
+	state = phba->ras_fwlog.state;
+	spin_unlock_irq(&phba->hbalock);
+
+	if (state == REG_INPROGRESS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI, "6147 RAS Logging "
+				"registration is in progress\n");
+		return -EBUSY;
+	}
+
+	/* For disable logging: stop the logs and free the DMA.
+	 * For ras_fwlog_buffsize size change we still need to free and
+	 * reallocate the DMA in lpfc_sli4_ras_fwlog_init.
+	 */
+	phba->cfg_ras_fwlog_buffsize = val;
+	if (state == ACTIVE) {
+		lpfc_ras_stop_fwlog(phba);
+		lpfc_sli4_ras_dma_free(phba);
+	}
+
+	lpfc_sli4_ras_init(phba);
+	if (phba->ras_fwlog.ras_enabled)
+		ret = lpfc_sli4_ras_fwlog_init(phba, phba->cfg_ras_fwlog_level,
+					       LPFC_RAS_ENABLE_LOGGING);
+	return ret;
+}
+
+lpfc_param_store(ras_fwlog_buffsize);
+static DEVICE_ATTR_RW(lpfc_ras_fwlog_buffsize);
 
 /*
  * lpfc_ras_fwlog_level: Firmware logging verbosity level
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 39a736b887b1..d4e1b120cc9e 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5435,10 +5435,12 @@ lpfc_bsg_get_ras_config(struct bsg_job *job)
 		bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
 	/* Current logging state */
-	if (ras_fwlog->ras_active == true)
+	spin_lock_irq(&phba->hbalock);
+	if (ras_fwlog->state == ACTIVE)
 		ras_reply->state = LPFC_RASLOG_STATE_RUNNING;
 	else
 		ras_reply->state = LPFC_RASLOG_STATE_STOPPED;
+	spin_unlock_irq(&phba->hbalock);
 
 	ras_reply->log_level = phba->ras_fwlog.fw_loglevel;
 	ras_reply->log_buff_sz = phba->cfg_ras_fwlog_buffsize;
@@ -5495,10 +5497,13 @@ lpfc_bsg_set_ras_config(struct bsg_job *job)
 
 	if (action == LPFC_RASACTION_STOP_LOGGING) {
 		/* Check if already disabled */
-		if (ras_fwlog->ras_active == false) {
+		spin_lock_irq(&phba->hbalock);
+		if (ras_fwlog->state != ACTIVE) {
+			spin_unlock_irq(&phba->hbalock);
 			rc = -ESRCH;
 			goto ras_job_error;
 		}
+		spin_unlock_irq(&phba->hbalock);
 
 		/* Disable logging */
 		lpfc_ras_stop_fwlog(phba);
@@ -5509,8 +5514,10 @@ lpfc_bsg_set_ras_config(struct bsg_job *job)
 		 * FW-logging with new log-level. Return status
 		 * "Logging already Running" to caller.
 		 **/
-		if (ras_fwlog->ras_active)
+		spin_lock_irq(&phba->hbalock);
+		if (ras_fwlog->state != INACTIVE)
 			action_status = -EINPROGRESS;
+		spin_unlock_irq(&phba->hbalock);
 
 		/* Enable logging */
 		rc = lpfc_sli4_ras_fwlog_init(phba, log_level,
@@ -5626,10 +5633,13 @@ lpfc_bsg_get_ras_fwlog(struct bsg_job *job)
 		goto ras_job_error;
 
 	/* Logging to be stopped before reading */
-	if (ras_fwlog->ras_active == true) {
+	spin_lock_irq(&phba->hbalock);
+	if (ras_fwlog->state == ACTIVE) {
+		spin_unlock_irq(&phba->hbalock);
 		rc = -EINPROGRESS;
 		goto ras_job_error;
 	}
+	spin_unlock_irq(&phba->hbalock);
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) +
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 8d34be60d379..ab124f7d50d6 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2078,6 +2078,96 @@ lpfc_debugfs_lockstat_write(struct file *file, const char __user *buf,
 }
 #endif
 
+int
+lpfc_debugfs_ras_log_data(struct lpfc_hba *phba, char *buffer, int size)
+{
+	int copied = 0;
+	struct lpfc_dmabuf *dmabuf, *next;
+
+	spin_lock_irq(&phba->hbalock);
+	if (phba->ras_fwlog.state != ACTIVE) {
+		spin_unlock_irq(&phba->hbalock);
+		return -EINVAL;
+	}
+	spin_unlock_irq(&phba->hbalock);
+
+	list_for_each_entry_safe(dmabuf, next,
+				 &phba->ras_fwlog.fwlog_buff_list, list) {
+		memcpy(buffer + copied, dmabuf->virt, LPFC_RAS_MAX_ENTRY_SIZE);
+		copied += LPFC_RAS_MAX_ENTRY_SIZE;
+		if (size > copied)
+			break;
+	}
+	return copied;
+}
+
+static int
+lpfc_debugfs_ras_log_release(struct inode *inode, struct file *file)
+{
+	struct lpfc_debug *debug = file->private_data;
+
+	vfree(debug->buffer);
+	kfree(debug);
+
+	return 0;
+}
+
+/**
+ * lpfc_debugfs_ras_log_open - Open the RAS log debugfs buffer
+ * @inode: The inode pointer that contains a vport pointer.
+ * @file: The file pointer to attach the log output.
+ *
+ * Description:
+ * This routine is the entry point for the debugfs open file operation. It gets
+ * the vport from the i_private field in @inode, allocates the necessary buffer
+ * for the log, fills the buffer from the in-memory log for this vport, and then
+ * returns a pointer to that log in the private_data field in @file.
+ *
+ * Returns:
+ * This function returns zero if successful. On error it will return a negative
+ * error value.
+ **/
+static int
+lpfc_debugfs_ras_log_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_hba *phba = inode->i_private;
+	struct lpfc_debug *debug;
+	int size;
+	int rc = -ENOMEM;
+
+	spin_lock_irq(&phba->hbalock);
+	if (phba->ras_fwlog.state != ACTIVE) {
+		spin_unlock_irq(&phba->hbalock);
+		rc = -EINVAL;
+		goto out;
+	}
+	spin_unlock_irq(&phba->hbalock);
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	size = LPFC_RAS_MIN_BUFF_POST_SIZE * phba->cfg_ras_fwlog_buffsize;
+	debug->buffer = vmalloc(size);
+	if (!debug->buffer)
+		goto free_debug;
+
+	debug->len = lpfc_debugfs_ras_log_data(phba, debug->buffer, size);
+	if (debug->len < 0) {
+		rc = -EINVAL;
+		goto free_buffer;
+	}
+	file->private_data = debug;
+
+	return 0;
+
+free_buffer:
+	vfree(debug->buffer);
+free_debug:
+	kfree(debug);
+out:
+	return rc;
+}
+
 /**
  * lpfc_debugfs_dumpHBASlim_open - Open the Dump HBA SLIM debugfs buffer
  * @inode: The inode pointer that contains a vport pointer.
@@ -5286,6 +5376,16 @@ static const struct file_operations lpfc_debugfs_op_lockstat = {
 };
 #endif
 
+#undef lpfc_debugfs_ras_log
+static const struct file_operations lpfc_debugfs_ras_log = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_ras_log_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.release =      lpfc_debugfs_ras_log_release,
+};
+#endif
+
 #undef lpfc_debugfs_op_dumpHBASlim
 static const struct file_operations lpfc_debugfs_op_dumpHBASlim = {
 	.owner =        THIS_MODULE,
@@ -5457,7 +5557,6 @@ static const struct file_operations lpfc_idiag_op_extAcc = {
 	.release =      lpfc_idiag_cmd_release,
 };
 
-#endif
 
 /* lpfc_idiag_mbxacc_dump_bsg_mbox - idiag debugfs dump bsg mailbox command
  * @phba: Pointer to HBA context object.
@@ -5707,6 +5806,19 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			goto debug_failed;
 		}
 
+		/* RAS log */
+		snprintf(name, sizeof(name), "ras_log");
+		phba->debug_ras_log =
+			debugfs_create_file(name, 0644,
+					    phba->hba_debugfs_root,
+					    phba, &lpfc_debugfs_ras_log);
+		if (!phba->debug_ras_log) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					 "6148 Cannot create debugfs"
+					 " ras_log\n");
+			goto debug_failed;
+		}
+
 		/* Setup hbqinfo */
 		snprintf(name, sizeof(name), "hbqinfo");
 		phba->debug_hbqinfo =
@@ -6117,6 +6229,9 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 		debugfs_remove(phba->debug_hbqinfo); /* hbqinfo */
 		phba->debug_hbqinfo = NULL;
 
+		debugfs_remove(phba->debug_ras_log);
+		phba->debug_ras_log = NULL;
+
 #ifdef LPFC_HDWQ_LOCK_STAT
 		debugfs_remove(phba->debug_lockstat); /* lockstat */
 		phba->debug_lockstat = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 0e6674bd15c6..294f041961a8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6219,11 +6219,16 @@ lpfc_ras_stop_fwlog(struct lpfc_hba *phba)
 {
 	struct lpfc_ras_fwlog *ras_fwlog = &phba->ras_fwlog;
 
-	ras_fwlog->ras_active = false;
+	spin_lock_irq(&phba->hbalock);
+	ras_fwlog->state = INACTIVE;
+	spin_unlock_irq(&phba->hbalock);
 
 	/* Disable FW logging to host memory */
 	writel(LPFC_CTL_PDEV_CTL_DDL_RAS,
 	       phba->sli4_hba.conf_regs_memmap_p + LPFC_CTL_PDEV_CTL_OFFSET);
+
+	/* Wait 10ms for firmware to stop using DMA buffer */
+	usleep_range(10 * 1000, 20 * 1000);
 }
 
 /**
@@ -6259,7 +6264,9 @@ lpfc_sli4_ras_dma_free(struct lpfc_hba *phba)
 		ras_fwlog->lwpd.virt = NULL;
 	}
 
-	ras_fwlog->ras_active = false;
+	spin_lock_irq(&phba->hbalock);
+	ras_fwlog->state = INACTIVE;
+	spin_unlock_irq(&phba->hbalock);
 }
 
 /**
@@ -6361,7 +6368,9 @@ lpfc_sli4_ras_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		goto disable_ras;
 	}
 
-	ras_fwlog->ras_active = true;
+	spin_lock_irq(&phba->hbalock);
+	ras_fwlog->state = ACTIVE;
+	spin_unlock_irq(&phba->hbalock);
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	return;
@@ -6393,6 +6402,10 @@ lpfc_sli4_ras_fwlog_init(struct lpfc_hba *phba,
 	uint32_t len = 0, fwlog_buffsize, fwlog_entry_count;
 	int rc = 0;
 
+	spin_lock_irq(&phba->hbalock);
+	ras_fwlog->state = INACTIVE;
+	spin_unlock_irq(&phba->hbalock);
+
 	fwlog_buffsize = (LPFC_RAS_MIN_BUFF_POST_SIZE *
 			  phba->cfg_ras_fwlog_buffsize);
 	fwlog_entry_count = (fwlog_buffsize/LPFC_RAS_MAX_ENTRY_SIZE);
@@ -6452,6 +6465,9 @@ lpfc_sli4_ras_fwlog_init(struct lpfc_hba *phba,
 	mbx_fwlog->u.request.lwpd.addr_lo = putPaddrLow(ras_fwlog->lwpd.phys);
 	mbx_fwlog->u.request.lwpd.addr_hi = putPaddrHigh(ras_fwlog->lwpd.phys);
 
+	spin_lock_irq(&phba->hbalock);
+	ras_fwlog->state = REG_INPROGRESS;
+	spin_unlock_irq(&phba->hbalock);
 	mbox->vport = phba->pport;
 	mbox->mbox_cmpl = lpfc_sli4_ras_mbox_cmpl;
 
-- 
2.13.7

