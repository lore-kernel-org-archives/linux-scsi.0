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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C81C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C59C60FD8
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhHPQaR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 12:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhHPQaI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 12:30:08 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92177C0613C1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:36 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id oa17so27438062pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P8DBHf3l+HDjrxxR333RVI7Kz3VxwX0ifCN9m18i4h8=;
        b=T16Cqm/B3w+kDAdZTH+qeCEYhYvHac4Lm72EFwDUe3asqFADc/nmt8svjIXrmrVzcN
         EHE6UJd1qUngGIXb5EQphZIKfcrMpedchqX5iTt9eAuoYRMSJXVpjxAY2fBGQa3En1jz
         j5I0Lj9JTZdzpF6wHI90d/BT9af+UVIXjrXpPom6ypLd6bSOFOd9EDFZ1oh2zjfXb96e
         dInHR7asWQc1Naco2XiIk8lmLk7lFZcli8rXwSizzzPUeVB7tWsw+wHCSDzGLctxSxJ8
         65k0B/6HigxuHO04C45zd4xsJ9GxHOMZKQZIv4tO7N5CSaGpD7aaEve4KIp7lZtE29Do
         nRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P8DBHf3l+HDjrxxR333RVI7Kz3VxwX0ifCN9m18i4h8=;
        b=lJvd1DQ2rGxszUqe9+dx1UNCGq/D2pzu/1o1LY5UJ5dzcZcmH7uz/nCp2uy2wtC9W0
         ZmEHBmXXolTa+Xt/ktxLf1HnEUupxtTJURdoqHGHz1l9W9mk3wTVFpNzIHKJGbuIrmty
         JIGyXEgDiKcd6srqCOZIJk9ocLRBxQSW+ZnSx+Ya+0O3UXam2XnX9mgdwapyzVJmVxpo
         iz+BiEyOhkcEmKDdtuiXv/r2mlsMrEfpYFL0DSHG7i+xghnc8BY+7EKpwO/QdjEqe3so
         WRMH9Ju3gqJM4wRvTNMVFohiAi49B+HcfVMcTLeUYHqDh1wIfW9NtHu6MTdcXIWFGJ0P
         RfNA==
X-Gm-Message-State: AOAM530d3fbYjKhKr2Boi/C8Ma7fCkOWDr4oY+hHo0IXLxv7Pe/oU3MQ
        sSxx2505Hs+XRTFl81kaIi0dFrE9vZg=
X-Google-Smtp-Source: ABdhPJyQvkBGU1ETS+FxIylDpvMsy6isiwZRAKZC62Pb14z5lGynfi+APfCtr2aRyFlvc+0qkTgafA==
X-Received: by 2002:a17:902:6b02:b029:12c:1278:88 with SMTP id o2-20020a1709026b02b029012c12780088mr13907030plk.64.1629131376040;
        Mon, 16 Aug 2021 09:29:36 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm11257938pfv.131.2021.08.16.09.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:29:35 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v3 10/16] lpfc: Add rx monitoring statistics
Date:   Mon, 16 Aug 2021 09:28:55 -0700
Message-Id: <20210816162901.121235-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210816162901.121235-1-jsmart2021@gmail.com>
References: <20210816162901.121235-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver provides overwatch of the cm behavior by maintaining a set
of rx io statistics. This information is also used in later updating
of the cm statistics buffer.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
  Address krobot cross compile errors: "__aeabi_ldivmod"
    Use div_u64 instead of explicit divide.
---
 drivers/scsi/lpfc/lpfc.h      | 21 +++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c | 50 +++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_mem.c  |  4 +++
 drivers/scsi/lpfc/lpfc_scsi.c |  2 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 15 +++++++++++
 5 files changed, 92 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 298b908e9126..640075885540 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1546,6 +1546,12 @@ struct lpfc_hba {
 	u32 cgn_sig_freq;
 	u32 cgn_acqe_cnt;
 
+	/* RX monitor handling for CMF */
+	struct rxtable_entry *rxtable;  /* RX_monitor information */
+	atomic_t rxtable_idx_head;
+#define LPFC_RXMONITOR_TABLE_IN_USE     (LPFC_MAX_RXMONITOR_ENTRY + 73)
+	atomic_t rxtable_idx_tail;
+	atomic_t rx_max_read_cnt;       /* Maximum read bytes */
 	uint64_t rx_block_cnt;
 
 	/* Congestion parameters from flash */
@@ -1591,6 +1597,21 @@ struct lpfc_hba {
 	struct dbg_log_ent dbg_log[DBG_LOG_SZ];
 };
 
+#define LPFC_MAX_RXMONITOR_ENTRY	800
+struct rxtable_entry {
+	uint64_t total_bytes;   /* Total no of read bytes requested */
+	uint64_t rcv_bytes;     /* Total no of read bytes completed */
+	uint64_t avg_io_size;
+	uint64_t avg_io_latency;/* Average io latency in microseconds */
+	uint64_t max_read_cnt;  /* Maximum read bytes */
+	uint64_t max_bytes_per_interval;
+	uint32_t cmf_busy;
+	uint32_t cmf_info;      /* CMF_SYNC_WQE info */
+	uint32_t io_cnt;
+	uint32_t timer_utilization;
+	uint32_t timer_interval;
+};
+
 static inline struct Scsi_Host *
 lpfc_shost_from_vport(struct lpfc_vport *vport)
 {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c0a2a01c1e99..7db2e4858172 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5452,9 +5452,13 @@ lpfc_cmf_timer(struct hrtimer *timer)
 {
 	struct lpfc_hba *phba = container_of(timer, struct lpfc_hba,
 					     cmf_timer);
+	struct rxtable_entry *entry;
 	uint32_t io_cnt;
+	uint32_t head, tail;
+	uint32_t busy, max_read;
 	uint64_t total, rcv, lat, mbpi;
 	int timer_interval = LPFC_CMF_INTERVAL;
+	uint32_t ms;
 	struct lpfc_cgn_stat *cgs;
 	int cpu;
 
@@ -5479,6 +5483,14 @@ lpfc_cmf_timer(struct hrtimer *timer)
 	 */
 	atomic_set(&phba->cmf_stop_io, 1);
 
+	/* First we need to calculate the actual ms between
+	 * the last timer interrupt and this one. We ask for
+	 * LPFC_CMF_INTERVAL, however the actual time may
+	 * vary depending on system overhead.
+	 */
+	ms = lpfc_calc_cmf_latency(phba);
+
+
 	/* Immediately after we calculate the time since the last
 	 * timer interrupt, set the start time for the next
 	 * interrupt
@@ -5525,6 +5537,8 @@ lpfc_cmf_timer(struct hrtimer *timer)
 		atomic_add(io_cnt, &phba->cgn_latency_evt_cnt);
 		atomic64_add(lat, &phba->cgn_latency_evt);
 	}
+	busy = atomic_xchg(&phba->cmf_busy, 0);
+	max_read = atomic_xchg(&phba->rx_max_read_cnt, 0);
 
 	/* Calculate MBPI for the next timer interval */
 	if (mbpi) {
@@ -5539,6 +5553,42 @@ lpfc_cmf_timer(struct hrtimer *timer)
 			phba->cmf_max_bytes_per_interval = mbpi;
 	}
 
+	/* Save rxmonitor information for debug */
+	if (phba->rxtable) {
+		head = atomic_xchg(&phba->rxtable_idx_head,
+				   LPFC_RXMONITOR_TABLE_IN_USE);
+		entry = &phba->rxtable[head];
+		entry->total_bytes = total;
+		entry->rcv_bytes = rcv;
+		entry->cmf_busy = busy;
+		entry->cmf_info = phba->cmf_active_info;
+		if (io_cnt) {
+			entry->avg_io_latency = div_u64(lat, io_cnt);
+			entry->avg_io_size = div_u64(rcv, io_cnt);
+		} else {
+			entry->avg_io_latency = 0;
+			entry->avg_io_size = 0;
+		}
+		entry->max_read_cnt = max_read;
+		entry->io_cnt = io_cnt;
+		entry->max_bytes_per_interval = mbpi;
+		if (phba->cmf_active_mode == LPFC_CFG_MANAGED)
+			entry->timer_utilization = phba->cmf_last_ts;
+		else
+			entry->timer_utilization = ms;
+		entry->timer_interval = ms;
+		phba->cmf_last_ts = 0;
+
+		/* Increment rxtable index */
+		head = (head + 1) % LPFC_MAX_RXMONITOR_ENTRY;
+		tail = atomic_read(&phba->rxtable_idx_tail);
+		if (head == tail) {
+			tail = (tail + 1) % LPFC_MAX_RXMONITOR_ENTRY;
+			atomic_set(&phba->rxtable_idx_tail, tail);
+		}
+		atomic_set(&phba->rxtable_idx_head, head);
+	}
+
 	if (phba->cmf_active_mode == LPFC_CFG_MONITOR) {
 		/* If Monitor mode, check if we are oversubscribed
 		 * against the full line rate.
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index bbb181ab334b..7cb9f4b52b49 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -344,6 +344,10 @@ lpfc_mem_free_all(struct lpfc_hba *phba)
 		phba->cgn_i = NULL;
 	}
 
+	/* Free RX table */
+	kfree(phba->rxtable);
+	phba->rxtable = NULL;
+
 	/* Free the iocb lookup array */
 	kfree(psli->iocbq_lookup);
 	psli->iocbq_lookup = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c5b14d46f998..fa5ee51bf20f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3981,6 +3981,8 @@ lpfc_update_cmf_cmd(struct lpfc_hba *phba, uint32_t size)
 			atomic_inc(&phba->cmf_busy);
 			return -EBUSY;
 		}
+		if (size > atomic_read(&phba->rx_max_read_cnt))
+			atomic_set(&phba->rx_max_read_cnt, size);
 	}
 
 	cgs = this_cpu_ptr(phba->cmf_stat);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a6a8f26eda77..ffd8a140638c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8068,6 +8068,21 @@ lpfc_cmf_setup(struct lpfc_hba *phba)
 	atomic64_set(&phba->cgn_latency_evt, 0);
 
 	phba->cmf_interval_rate = LPFC_CMF_INTERVAL;
+
+	/* Allocate RX Monitor Buffer */
+	if (!phba->rxtable) {
+		phba->rxtable = kmalloc_array(LPFC_MAX_RXMONITOR_ENTRY,
+					      sizeof(struct rxtable_entry),
+					      GFP_KERNEL);
+		if (!phba->rxtable) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2644 Failed to alloc memory "
+					"for RX Monitor Buffer\n");
+			return -ENOMEM;
+		}
+	}
+	atomic_set(&phba->rxtable_idx_head, 0);
+	atomic_set(&phba->rxtable_idx_tail, 0);
 	return 0;
 }
 
-- 
2.26.2

