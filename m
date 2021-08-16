Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DDDC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47B6460FD8
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhHPQaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 12:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhHPQaN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 12:30:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E121C061764
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:41 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q2so21283358plr.11
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W3K6/7PGor0E176ZzywrNUq7xPALmPPlfrZgqNRtEDY=;
        b=vJYpQYufB0IkgvYCzGSJo+fn/K3tLBJ+SLRBJ9TA/6fQC2zc30N45OhFALNhxYCGAM
         s/HHuUZAAMTrc2DmcRlo/CW4xm4SBzTyex4EFduQdd7NXWOu0W60Z+T4e4yRTsnLB2Tx
         xUDLzPUWSNFwNw/xTMF24JCzW+h/WEtCo9b/3zesW7PvmwlKAgSoGylhjeCIJJHy0w+k
         a0c0W/CDrw3rf7BxspSbmX0iblnyhGeMRsUOPsI6RSsO5xlnDYW/oauUJm00VC5eCUhz
         k83j06rkbJVgZusyUNIdB2YO1kPM/odlLIwoxdSOr4vNNPg+nmzwY7ngi8Lf+SQqvHYH
         SXbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W3K6/7PGor0E176ZzywrNUq7xPALmPPlfrZgqNRtEDY=;
        b=n1YWUo1HqIVHoEqOIG26Dja2IAlsR9wpcC5KpG29Um4Zpif6zGxvaY28rDQy2pKhQU
         jFstIwQVeTXYVDBWskUM1TQhA/UMYWZTAcqUKiU5tSjq9VwkQ48p6R5ydXgx7r04R2bi
         NmNZ+dI3vamNWCJI/0pHKlkCwnUPzmMtALUf7//iKhX764h/TiOy+wzi3eZnP7UZ5I2R
         62JPY3PiFxapZ+mc3DoCMn+TGz2le8H8FWDtuxQ8q0lbnl0dtYHmeYWQuvt8MJHKBRvg
         dkgmeJYuAHgsMs5dT+zvLJ3sRymX36GqM3/BXsL9sJ+SVx09QznUPZvFAPcymi683NGl
         nFOg==
X-Gm-Message-State: AOAM530ymmprZVCol3SklvVb05ErteBEc3xkUxSfXFYPQNuan9QjJgfF
        dZh2dDdO9mNLSSvMZjDs5jwP5dWJ3HU=
X-Google-Smtp-Source: ABdhPJylLHwos4NukMqx95T2Pt3+OjcnShhCjVehv1kt/Tjx32sCbBFGk6SYtMpOFH0Pg6ieS55sww==
X-Received: by 2002:a17:902:b188:b029:11b:1549:da31 with SMTP id s8-20020a170902b188b029011b1549da31mr13653707plr.7.1629131381027;
        Mon, 16 Aug 2021 09:29:41 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm11257938pfv.131.2021.08.16.09.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:29:40 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v3 12/16] lpfc: Add debugfs support for cm framework buffers
Date:   Mon, 16 Aug 2021 09:28:57 -0700
Message-Id: <20210816162901.121235-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210816162901.121235-1-jsmart2021@gmail.com>
References: <20210816162901.121235-1-jsmart2021@gmail.com>
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

