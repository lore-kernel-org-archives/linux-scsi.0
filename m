Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDB8C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241F16109E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbhHMXBw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 19:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235425AbhHMXBq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 19:01:46 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE56C061756
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:01:19 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d17so13887594plr.12
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W3K6/7PGor0E176ZzywrNUq7xPALmPPlfrZgqNRtEDY=;
        b=MlczA4/Y2Bxg2m++BYx8YuIbru6xfJEakxxd4AcnhgiLVkWiY/SMg0KNGa3N7ezHuZ
         btDr1t/fQ6hwhJcmlJzClPtr+WFxJqUhDJ32HG1dA2L06WyZh4PRNWoS8ifha1YtKv3y
         k/62jUDsEDJNz20ZKA+tmO01RyuzofOajodeFOj7ekcF8Jl5OAJ7mvWufJ/SZGAUUNYZ
         xW48PlU5sZCQJy9FDmh1n2my8S0HcUJgYs+jQonKm5kidRSxVASlNdJaIR1KmmosVqIy
         DE5Kcuj+jgzftf2mOy1O/seQL2XCQPIyYNeqLH2LK9T1Vho4d2wBEWF7HgDb6kodUdd+
         2fTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W3K6/7PGor0E176ZzywrNUq7xPALmPPlfrZgqNRtEDY=;
        b=mGBosx1zAUHrNoT/5rSi7T502KHiI0bSOqGaX7lUGuvy02kaHlHArjcPI47m4PU4Mk
         c7IJzxOsI96lsOFBiSEckzpjnDG5PtyH9j0JowlBMVLTsckdmVoP4X5TWvPsXZjr4N9N
         9bLGFNYJOSQ+aKGCwBQ/HoW7G57K1kKPArpxkcF46Qen5hXSG7fjs6a1SRm+AQbBu6W6
         BWutE6PaJcCc3HTGq1IYvi37stjXcOQKezmzyy3AHx5vjUHoVQMG+CmWSP8UZKYV7s1r
         pFRJZ1UoGB8I8mgD+uMqy4TLf8K24igI+fVycYaFR1L64wilJTfXEJGy1rDuk/iRftRF
         OJnA==
X-Gm-Message-State: AOAM532F6LZUgIoaLqs1XPxnEIn3Y+poqyxCbyqFep7zKz0A1QkkFkUj
        5TLwS2K154rWAf6JZ1bDCPS7IFXmCT0=
X-Google-Smtp-Source: ABdhPJw71bc5LCsfRLzOweb/oTxAEd1GrOJVZI/ZpbwQDE4C3+docy9ftT3sSkWMWYFQxOTRiXjfDA==
X-Received: by 2002:a17:902:8f90:b029:12d:1b48:efd8 with SMTP id z16-20020a1709028f90b029012d1b48efd8mr3773762plo.23.1628895678694;
        Fri, 13 Aug 2021 16:01:18 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e8sm4001997pgg.31.2021.08.13.16.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 16:01:18 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 12/16] lpfc: Add debugfs support for cm framework buffers
Date:   Fri, 13 Aug 2021 16:00:35 -0700
Message-Id: <20210813230039.110546-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813230039.110546-1-jsmart2021@gmail.com>
References: <20210813230039.110546-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds support via debugfs to report the cm statistics, cm
enablement, and rx monitor information.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |   2 +
 drivers/scsi/lpfc/lpfc_debugfs.c | 223 +++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_debugfs.h |   9 ++
 3 files changed, 234 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 640075885540..dd8cb111b199 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1357,6 +1357,8 @@ struct lpfc_hba {
 #ifdef LPFC_HDWQ_LOCK_STAT
 	struct dentry *debug_lockstat;
 #endif
+	struct dentry *debug_cgn_buffer;
+	struct dentry *debug_rx_monitor;
 	struct dentry *debug_ras_log;
 	atomic_t nvmeio_trc_cnt;
 	uint32_t nvmeio_trc_size;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 6ff85ae57e79..bd6d459afce5 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5429,6 +5429,180 @@ lpfc_idiag_extacc_read(struct file *file, char __user *buf, size_t nbytes,
 	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
 }
 
+static int
+lpfc_cgn_buffer_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_debug *debug;
+	int rc = -ENOMEM;
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	debug->buffer = vmalloc(LPFC_CGN_BUF_SIZE);
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->i_private = inode->i_private;
+	file->private_data = debug;
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static ssize_t
+lpfc_cgn_buffer_read(struct file *file, char __user *buf, size_t nbytes,
+		     loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	char *buffer = debug->buffer;
+	uint32_t *ptr;
+	int cnt, len = 0;
+
+	if (!phba->sli4_hba.pc_sli4_params.mi_ver || !phba->cgn_i) {
+		len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
+				 "Congestion Mgmt is not supported\n");
+		goto out;
+	}
+	ptr = (uint32_t *)phba->cgn_i->virt;
+	len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
+			 "Congestion Buffer Header\n");
+	/* Dump the first 32 bytes */
+	cnt = 32;
+	len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
+			 "000: %08x %08x %08x %08x %08x %08x %08x %08x\n",
+			 *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3),
+			 *(ptr + 4), *(ptr + 5), *(ptr + 6), *(ptr + 7));
+	ptr += 8;
+	len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
+			 "Congestion Buffer Data\n");
+	while (cnt < sizeof(struct lpfc_cgn_info)) {
+		if (len > (LPFC_CGN_BUF_SIZE - LPFC_DEBUG_OUT_LINE_SZ)) {
+			len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
+					 "Truncated . . .\n");
+			break;
+		}
+		len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
+				 "%03x: %08x %08x %08x %08x "
+				 "%08x %08x %08x %08x\n",
+				 cnt, *ptr, *(ptr + 1), *(ptr + 2),
+				 *(ptr + 3), *(ptr + 4), *(ptr + 5),
+				 *(ptr + 6), *(ptr + 7));
+		cnt += 32;
+		ptr += 8;
+	}
+out:
+	return simple_read_from_buffer(buf, nbytes, ppos, buffer, len);
+}
+
+static int
+lpfc_cgn_buffer_release(struct inode *inode, struct file *file)
+{
+	struct lpfc_debug *debug = file->private_data;
+
+	vfree(debug->buffer);
+	kfree(debug);
+
+	return 0;
+}
+
+static int
+lpfc_rx_monitor_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_rx_monitor_debug *debug;
+	int rc = -ENOMEM;
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	debug->buffer = vmalloc(MAX_DEBUGFS_RX_TABLE_SIZE);
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->i_private = inode->i_private;
+	file->private_data = debug;
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static ssize_t
+lpfc_rx_monitor_read(struct file *file, char __user *buf, size_t nbytes,
+		     loff_t *ppos)
+{
+	struct lpfc_rx_monitor_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	char *buffer = debug->buffer;
+	struct rxtable_entry *entry;
+	int i, len = 0, head, tail, last, start;
+
+	head = atomic_read(&phba->rxtable_idx_head);
+	while (head == LPFC_RXMONITOR_TABLE_IN_USE) {
+		/* Table is getting updated */
+		msleep(20);
+		head = atomic_read(&phba->rxtable_idx_head);
+	}
+
+	tail = atomic_xchg(&phba->rxtable_idx_tail, head);
+	if (!phba->rxtable || head == tail) {
+		len += scnprintf(buffer + len, MAX_DEBUGFS_RX_TABLE_SIZE - len,
+				"Rxtable is empty\n");
+		goto out;
+	}
+	last = (head > tail) ?  head : LPFC_MAX_RXMONITOR_ENTRY;
+	start = tail;
+
+	len += scnprintf(buffer + len, MAX_DEBUGFS_RX_TABLE_SIZE - len,
+			"        MaxBPI\t Total Data Cmd  Total Data Cmpl "
+			"  Latency(us)    Avg IO Size\tMax IO Size   IO cnt "
+			"Info BWutil(ms)\n");
+get_table:
+	for (i = start; i < last; i++) {
+		entry = &phba->rxtable[i];
+		len += scnprintf(buffer + len, MAX_DEBUGFS_RX_TABLE_SIZE - len,
+				"%3d:%12lld  %12lld\t%12lld\t"
+				"%8lldus\t%8lld\t%10lld "
+				"%8d   %2d %2d(%2d)\n",
+				i, entry->max_bytes_per_interval,
+				entry->total_bytes,
+				entry->rcv_bytes,
+				entry->avg_io_latency,
+				entry->avg_io_size,
+				entry->max_read_cnt,
+				entry->io_cnt,
+				entry->cmf_info,
+				entry->timer_utilization,
+				entry->timer_interval);
+	}
+
+	if (head != last) {
+		start = 0;
+		last = head;
+		goto get_table;
+	}
+out:
+	return simple_read_from_buffer(buf, nbytes, ppos, buffer, len);
+}
+
+static int
+lpfc_rx_monitor_release(struct inode *inode, struct file *file)
+{
+	struct lpfc_rx_monitor_debug *debug = file->private_data;
+
+	vfree(debug->buffer);
+	kfree(debug);
+
+	return 0;
+}
+
 #undef lpfc_debugfs_op_disc_trc
 static const struct file_operations lpfc_debugfs_op_disc_trc = {
 	.owner =        THIS_MODULE,
@@ -5657,6 +5831,23 @@ static const struct file_operations lpfc_idiag_op_extAcc = {
 	.write =        lpfc_idiag_extacc_write,
 	.release =      lpfc_idiag_cmd_release,
 };
+#undef lpfc_cgn_buffer_op
+static const struct file_operations lpfc_cgn_buffer_op = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_cgn_buffer_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_cgn_buffer_read,
+	.release =      lpfc_cgn_buffer_release,
+};
+
+#undef lpfc_rx_monitor_op
+static const struct file_operations lpfc_rx_monitor_op = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_rx_monitor_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_rx_monitor_read,
+	.release =      lpfc_rx_monitor_release,
+};
 #endif
 
 /* lpfc_idiag_mbxacc_dump_bsg_mbox - idiag debugfs dump bsg mailbox command
@@ -5907,6 +6098,32 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			goto debug_failed;
 		}
 
+		/* Congestion Info Buffer */
+		scnprintf(name, sizeof(name), "cgn_buffer");
+		phba->debug_cgn_buffer =
+			debugfs_create_file(name, S_IFREG | 0644,
+					    phba->hba_debugfs_root,
+					    phba, &lpfc_cgn_buffer_op);
+		if (!phba->debug_cgn_buffer) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					 "6527 Cannot create debugfs "
+					 "cgn_buffer\n");
+			goto debug_failed;
+		}
+
+		/* RX Monitor */
+		scnprintf(name, sizeof(name), "rx_monitor");
+		phba->debug_rx_monitor =
+			debugfs_create_file(name, S_IFREG | 0644,
+					    phba->hba_debugfs_root,
+					    phba, &lpfc_rx_monitor_op);
+		if (!phba->debug_rx_monitor) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					 "6528 Cannot create debugfs "
+					 "rx_monitor\n");
+			goto debug_failed;
+		}
+
 		/* RAS log */
 		snprintf(name, sizeof(name), "ras_log");
 		phba->debug_ras_log =
@@ -6335,6 +6552,12 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 		debugfs_remove(phba->debug_hbqinfo); /* hbqinfo */
 		phba->debug_hbqinfo = NULL;
 
+		debugfs_remove(phba->debug_cgn_buffer);
+		phba->debug_cgn_buffer = NULL;
+
+		debugfs_remove(phba->debug_rx_monitor);
+		phba->debug_rx_monitor = NULL;
+
 		debugfs_remove(phba->debug_ras_log);
 		phba->debug_ras_log = NULL;
 
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 7ab6d3b08698..dd4cdd8563eb 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -52,6 +52,9 @@
 /* scsistat output buffer size */
 #define LPFC_SCSISTAT_SIZE 8192
 
+/* Congestion Info Buffer size */
+#define LPFC_CGN_BUF_SIZE 8192
+
 #define LPFC_DEBUG_OUT_LINE_SZ	80
 
 /*
@@ -279,6 +282,12 @@ struct lpfc_idiag {
 	void *ptr_private;
 };
 
+#define MAX_DEBUGFS_RX_TABLE_SIZE	(100 * LPFC_MAX_RXMONITOR_ENTRY)
+struct lpfc_rx_monitor_debug {
+	char *i_private;
+	char *buffer;
+};
+
 #else
 
 #define lpfc_nvmeio_data(phba, fmt, arg...) \
-- 
2.26.2

