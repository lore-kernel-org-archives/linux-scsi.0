Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13CCC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Dec 2021 00:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383726AbhLDAaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 19:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354508AbhLDAaT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 19:30:19 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000EBC061354
        for <linux-scsi@vger.kernel.org>; Fri,  3 Dec 2021 16:26:54 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id m15so4603430pgu.11
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 16:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4+PRV9LosVlZ9ZDh93g4uetT+X/2Sswu6M+7eCceBt4=;
        b=K6ZlelNPqwRYAwnnw73JEOdPZ6LKmSKejZI9Uck1RP4ei8hj/cHuzGFRwWTVv5tDpF
         1OFGULEFB9e7i1UhQu3XxOmPtlthanwlt4XXZRHLR36ew9GRIMVE/osF2x2UtdEdUURq
         Su9U4Dtg+lsmzFowYn62Ibsj6H3Ccyy5G8cokrMH4UfbrvM4q38MBGtj2IKlmZnQv+e2
         O6KlYLs16XqZwdBhJOvM7SRU3Hl+REqaECXdHuJFkz2A7wrQJjMJ12mRPmzE1GviSxQy
         UBVBAGQHUiT4VqaHr2CME9PM91TC2Kuq9Tym+A6yEUg0ZzUepIiKVQ3RiRq2XLPPLG7w
         GNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4+PRV9LosVlZ9ZDh93g4uetT+X/2Sswu6M+7eCceBt4=;
        b=ecTcfpWm8/8gKKjpwgw87+AUPpKFLGXs76y/8B0BxfADh2cGjH8IGQDWm6BhtTxwoX
         LKYYfNdFzfx+zOVe6IhSLVLC7FJqEf/hCULsQ6AnAte4KarXyHrwSyW1C/wsbgIMqKNv
         8+NvXmzMQnRY+7Xz0n2J/6qg5thQ4o+32F8NjIEADVXfJPYBG2WvrdnoLFdl26ZDrpsE
         YqaqRzNOrkJBA+O+MlFQBw8bO1KcDzXJsYRl4y69M6r1rKgzonI01cafabCOYwJ3s7dT
         PKyPmerKhsm11sqZVxhTNaQdQztl/CC0w48HjIIG0sMoJhswYil5d/8UYKxWcRjfqlj1
         XUSA==
X-Gm-Message-State: AOAM532A/irBAsR3sk9e5SM9jXAkK7a8LSO6TlllZaL0Lvp+p32cO8Fg
        6l1teZX9xwOJVIi31VR9jhlbIncaeMI=
X-Google-Smtp-Source: ABdhPJwmvCTAGNbrG6ye+pX6OT4JqR05PdaX8ddmCCEdH0Ge9SzEmMtQ/DF7268+Bzox/vGtY4f09A==
X-Received: by 2002:a05:6a00:2181:b0:4a7:ed1f:c5ba with SMTP id h1-20020a056a00218100b004a7ed1fc5bamr22512931pfi.2.1638577614347;
        Fri, 03 Dec 2021 16:26:54 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q17sm4970707pfu.117.2021.12.03.16.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:26:54 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 6/9] lpfc: Adjust CMF total bytes and rxmonitor
Date:   Fri,  3 Dec 2021 16:26:41 -0800
Message-Id: <20211204002644.116455-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211204002644.116455-1-jsmart2021@gmail.com>
References: <20211204002644.116455-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calculate any extra bytes needed to account for timer accuracy. If we are
less than LPFC_CMF_INTERVAL, then calculate the adjustment needed for total
to reflect a full LPFC_CMF_INTERVAL.

Add additional info to rxmonitor, and adjust some log formatting.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_debugfs.c | 14 ++++++++------
 drivers/scsi/lpfc/lpfc_debugfs.h |  2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 20 ++++++++++++--------
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index e652926fb47a..49abbf132bee 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1602,6 +1602,7 @@ struct lpfc_hba {
 #define LPFC_MAX_RXMONITOR_ENTRY	800
 #define LPFC_MAX_RXMONITOR_DUMP		32
 struct rxtable_entry {
+	uint64_t cmf_bytes;	/* Total no of read bytes for CMF_SYNC_WQE */
 	uint64_t total_bytes;   /* Total no of read bytes requested */
 	uint64_t rcv_bytes;     /* Total no of read bytes completed */
 	uint64_t avg_io_size;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index bd6d459afce5..ab2550ad0597 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5561,22 +5561,24 @@ lpfc_rx_monitor_read(struct file *file, char __user *buf, size_t nbytes,
 	start = tail;
 
 	len += scnprintf(buffer + len, MAX_DEBUGFS_RX_TABLE_SIZE - len,
-			"        MaxBPI\t Total Data Cmd  Total Data Cmpl "
-			"  Latency(us)    Avg IO Size\tMax IO Size   IO cnt "
-			"Info BWutil(ms)\n");
+			"        MaxBPI    Tot_Data_CMF Tot_Data_Cmd "
+			"Tot_Data_Cmpl  Lat(us)  Avg_IO  Max_IO "
+			"Bsy IO_cnt Info BWutil(ms)\n");
 get_table:
 	for (i = start; i < last; i++) {
 		entry = &phba->rxtable[i];
 		len += scnprintf(buffer + len, MAX_DEBUGFS_RX_TABLE_SIZE - len,
-				"%3d:%12lld  %12lld\t%12lld\t"
-				"%8lldus\t%8lld\t%10lld "
-				"%8d   %2d %2d(%2d)\n",
+				"%3d:%12lld %12lld %12lld %12lld "
+				"%7lldus %8lld %7lld "
+				"%2d   %4d   %2d   %2d(%2d)\n",
 				i, entry->max_bytes_per_interval,
+				entry->cmf_bytes,
 				entry->total_bytes,
 				entry->rcv_bytes,
 				entry->avg_io_latency,
 				entry->avg_io_size,
 				entry->max_read_cnt,
+				entry->cmf_busy,
 				entry->io_cnt,
 				entry->cmf_info,
 				entry->timer_utilization,
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index a5bf71b34972..6dd361c1fd31 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -282,7 +282,7 @@ struct lpfc_idiag {
 	void *ptr_private;
 };
 
-#define MAX_DEBUGFS_RX_TABLE_SIZE	(100 * LPFC_MAX_RXMONITOR_ENTRY)
+#define MAX_DEBUGFS_RX_TABLE_SIZE	(128 * LPFC_MAX_RXMONITOR_ENTRY)
 struct lpfc_rx_monitor_debug {
 	char *i_private;
 	char *buffer;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7628b0634c57..132f2e60bdb4 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5927,7 +5927,7 @@ lpfc_cmf_timer(struct hrtimer *timer)
 	uint32_t io_cnt;
 	uint32_t head, tail;
 	uint32_t busy, max_read;
-	uint64_t total, rcv, lat, mbpi, extra;
+	uint64_t total, rcv, lat, mbpi, extra, cnt;
 	int timer_interval = LPFC_CMF_INTERVAL;
 	uint32_t ms;
 	struct lpfc_cgn_stat *cgs;
@@ -5998,20 +5998,23 @@ lpfc_cmf_timer(struct hrtimer *timer)
 
 		/* Calculate any extra bytes needed to account for the
 		 * timer accuracy. If we are less than LPFC_CMF_INTERVAL
-		 * add an extra 3% slop factor, equal to LPFC_CMF_INTERVAL
-		 * add an extra 2%. The goal is to equalize total with a
-		 * time > LPFC_CMF_INTERVAL or <= LPFC_CMF_INTERVAL + 1
+		 * calculate the adjustment needed for total to reflect
+		 * a full LPFC_CMF_INTERVAL.
 		 */
-		if (ms == LPFC_CMF_INTERVAL)
-			extra = div_u64(total, 50);
-		else if (ms < LPFC_CMF_INTERVAL)
-			extra = div_u64(total, 33);
+		if (ms && ms < LPFC_CMF_INTERVAL) {
+			cnt = div_u64(total, ms); /* bytes per ms */
+			cnt *= LPFC_CMF_INTERVAL; /* what total should be */
+			if (cnt > mbpi)
+				cnt = mbpi;
+			extra = cnt - total;
+		}
 		lpfc_issue_cmf_sync_wqe(phba, LPFC_CMF_INTERVAL, total + extra);
 	} else {
 		/* For Monitor mode or link down we want mbpi
 		 * to be the full link speed
 		 */
 		mbpi = phba->cmf_link_byte_count;
+		extra = 0;
 	}
 	phba->cmf_timer_cnt++;
 
@@ -6042,6 +6045,7 @@ lpfc_cmf_timer(struct hrtimer *timer)
 				   LPFC_RXMONITOR_TABLE_IN_USE);
 		entry = &phba->rxtable[head];
 		entry->total_bytes = total;
+		entry->cmf_bytes = total + extra;
 		entry->rcv_bytes = rcv;
 		entry->cmf_busy = busy;
 		entry->cmf_info = phba->cmf_active_info;
-- 
2.26.2

