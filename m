Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AC1C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 18:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbjEWSWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 14:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbjEWSWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 14:22:34 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38279119
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:32 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-25377d67da9so3551a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684866151; x=1687458151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dU+ir/gY8wnDfgEBVOVA+2ESwY5PMj+9r095LQ5kwdQ=;
        b=jKLmEmqJFbE+GqKQkzrIpA1NNWbWmBQyqWYj72oE+zrTYIGU9nX8GZDXd2SYUFTtdr
         1RdYIqrVaTQmjxHaL55EH8hq6fAJ25djdoX/NbAPkxS1psxSbImjAp/MIN73vF4cSIQU
         86lxeXsfR98zEZzelwwLwwNIQCDyX90DxPQKRXr3HjKggM62jPIDnfcamOt2WraRB8UD
         7nr9rI+bSh1ciFmf22m8cNtfFQ+z2znnyeTylBiK4r9gDe2XmZzXklO+ibJsCHuk7pE0
         ZipZ2iFY4KrmKyEUiHTk0a0V7lolcQa2DqZXyu5sq0T9itcCEbFICExcaGG+X+DkIMlm
         ylpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684866151; x=1687458151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dU+ir/gY8wnDfgEBVOVA+2ESwY5PMj+9r095LQ5kwdQ=;
        b=jL5g/alj7pBtblQipyHz//5FXlo6yx9/AcbJtcU3953tolMTjiMDQjkH6Fp25i1mmV
         oHaHEp0HEWn/wmye85w0FoIPVlbSi81wNG3ko7MMjMy71QSYeY9+grbHKsnOSxHUQ+I4
         Z6PwXJt1EOjf+dOynUQzRQYxC3n/URc6gCVrkOCAB7HshWzzp2OatBU4j5bRP+B2+F13
         VtxsY+A4ZO5fz6mOraabE7Aha+UZL1OwZrENrYA/6NCorhBM+HvxliqTVt3V0+OtdfFb
         owdiGq1l5jqMlpIWaaVdr1dp8yzcDqOrxbhxlive+GI14lzEC4x5GrZHeCZi8GsWqI2e
         x43w==
X-Gm-Message-State: AC+VfDw3wTWR9bIJbUrUO+jSEcvsvCQ/hINrLKtNVAp/I3/vhHSkU5YH
        NuG9nU80ScszoqOQ8BDbXntnWD8tPSg=
X-Google-Smtp-Source: ACHHUZ5rgMzxp+1ACHSX6hQr3f4PwDwer2ixJfVJ3240pbfMI0urueWqNop+Ro3xy2p5/TZar+lgPw==
X-Received: by 2002:a17:903:41c6:b0:1ae:4567:2737 with SMTP id u6-20020a17090341c600b001ae45672737mr82441ple.2.1684866151094;
        Tue, 23 May 2023 11:22:31 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001a687c505e9sm7070870plg.237.2023.05.23.11.22.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 11:22:30 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 7/9] lpfc: Enhance congestion statistics collection
Date:   Tue, 23 May 2023 11:32:04 -0700
Message-Id: <20230523183206.7728-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Various improvements are made for collecting congestion statistics:

- Pre-existing logic is replaced with use of an hrtimer for increased
  reporting accuracy.
- Congestion timestamp information is reorganized into a single struct.
- Common statistic collection logic is refactored into a helper routine.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  63 +++-------
 drivers/scsi/lpfc/lpfc_init.c | 226 ++++++++++------------------------
 2 files changed, 81 insertions(+), 208 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index dcb87bb5f88b..9a8963684369 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -429,6 +429,15 @@ struct lpfc_cgn_param {
 /* Max number of days of congestion data */
 #define LPFC_MAX_CGN_DAYS 10
 
+struct lpfc_cgn_ts {
+	uint8_t month;
+	uint8_t day;
+	uint8_t year;
+	uint8_t hour;
+	uint8_t minute;
+	uint8_t second;
+};
+
 /* Format of congestion buffer info
  * This structure defines memory thats allocated and registered with
  * the HBA firmware. When adding or removing fields from this structure
@@ -442,6 +451,7 @@ struct lpfc_cgn_info {
 #define LPFC_CGN_INFO_V1	1
 #define LPFC_CGN_INFO_V2	2
 #define LPFC_CGN_INFO_V3	3
+#define LPFC_CGN_INFO_V4	4
 	uint8_t  cgn_info_mode;		/* 0=off 1=managed 2=monitor only */
 	uint8_t  cgn_info_detect;
 	uint8_t  cgn_info_action;
@@ -450,12 +460,7 @@ struct lpfc_cgn_info {
 	uint8_t  cgn_info_level2;
 
 	/* Start Time */
-	uint8_t  cgn_info_month;
-	uint8_t  cgn_info_day;
-	uint8_t  cgn_info_year;
-	uint8_t  cgn_info_hour;
-	uint8_t  cgn_info_minute;
-	uint8_t  cgn_info_second;
+	struct lpfc_cgn_ts base_time;
 
 	/* minute / hours / daily indices */
 	uint8_t  cgn_index_minute;
@@ -496,45 +501,17 @@ struct lpfc_cgn_info {
 		uint8_t  cgn_stat_npm;		/* Notifications per minute */
 
 		/* Start Time */
-		uint8_t  cgn_stat_month;
-		uint8_t  cgn_stat_day;
-		uint8_t  cgn_stat_year;
-		uint8_t  cgn_stat_hour;
-		uint8_t  cgn_stat_minute;
-		uint8_t  cgn_pad2[2];
+		struct lpfc_cgn_ts stat_start;	/* Base time */
+		uint8_t cgn_pad2;
 
 		__le32   cgn_notification;
 		__le32   cgn_peer_notification;
 		__le32   link_integ_notification;
 		__le32   delivery_notification;
-
-		uint8_t  cgn_stat_cgn_month; /* Last congestion notification FPIN */
-		uint8_t  cgn_stat_cgn_day;
-		uint8_t  cgn_stat_cgn_year;
-		uint8_t  cgn_stat_cgn_hour;
-		uint8_t  cgn_stat_cgn_min;
-		uint8_t  cgn_stat_cgn_sec;
-
-		uint8_t  cgn_stat_peer_month; /* Last peer congestion FPIN */
-		uint8_t  cgn_stat_peer_day;
-		uint8_t  cgn_stat_peer_year;
-		uint8_t  cgn_stat_peer_hour;
-		uint8_t  cgn_stat_peer_min;
-		uint8_t  cgn_stat_peer_sec;
-
-		uint8_t  cgn_stat_lnk_month; /* Last link integrity FPIN */
-		uint8_t  cgn_stat_lnk_day;
-		uint8_t  cgn_stat_lnk_year;
-		uint8_t  cgn_stat_lnk_hour;
-		uint8_t  cgn_stat_lnk_min;
-		uint8_t  cgn_stat_lnk_sec;
-
-		uint8_t  cgn_stat_del_month; /* Last delivery notification FPIN */
-		uint8_t  cgn_stat_del_day;
-		uint8_t  cgn_stat_del_year;
-		uint8_t  cgn_stat_del_hour;
-		uint8_t  cgn_stat_del_min;
-		uint8_t  cgn_stat_del_sec;
+		struct lpfc_cgn_ts stat_fpin;	/* Last congestion notification FPIN */
+		struct lpfc_cgn_ts stat_peer;	/* Last peer congestion FPIN */
+		struct lpfc_cgn_ts stat_lnk;	/* Last link integrity FPIN */
+		struct lpfc_cgn_ts stat_delivery;	/* Last delivery notification FPIN */
 	);
 
 	__le32   cgn_info_crc;
@@ -1043,8 +1020,6 @@ struct lpfc_hba {
 					 * capability
 					 */
 #define HBA_FLOGI_ISSUED	0x100000 /* FLOGI was issued */
-#define HBA_SHORT_CMF		0x200000 /* shorter CMF timer routine */
-#define HBA_CGN_DAY_WRAP	0x400000 /* HBA Congestion info day wraps */
 #define HBA_DEFER_FLOGI		0x800000 /* Defer FLOGI till read_sparm cmpl */
 #define HBA_SETUP		0x1000000 /* Signifies HBA setup is completed */
 #define HBA_NEEDS_CFG_PORT	0x2000000 /* SLI3 - needs a CONFIG_PORT mbox */
@@ -1527,6 +1502,7 @@ struct lpfc_hba {
 	uint64_t cmf_last_sync_bw;
 #define  LPFC_CMF_BLK_SIZE 512
 	struct hrtimer cmf_timer;
+	struct hrtimer cmf_stats_timer;	/* 1 minute stats timer  */
 	atomic_t cmf_bw_wait;
 	atomic_t cmf_busy;
 	atomic_t cmf_stop_io;      /* To block request and stop IO's */
@@ -1574,12 +1550,11 @@ struct lpfc_hba {
 	atomic_t cgn_sync_alarm_cnt;    /* Total alarm events for SYNC wqe */
 	atomic_t cgn_driver_evt_cnt;    /* Total driver cgn events for fmw */
 	atomic_t cgn_latency_evt_cnt;
-	struct timespec64 cgn_daily_ts;
 	atomic64_t cgn_latency_evt;     /* Avg latency per minute */
 	unsigned long cgn_evt_timestamp;
 #define LPFC_CGN_TIMER_TO_MIN   60000 /* ms in a minute */
 	uint32_t cgn_evt_minute;
-#define LPFC_SEC_MIN		60
+#define LPFC_SEC_MIN		60UL
 #define LPFC_MIN_HOUR		60
 #define LPFC_HOUR_DAY		24
 #define LPFC_MIN_DAY		(LPFC_MIN_HOUR * LPFC_HOUR_DAY)
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2d9879bf298b..3221a934066b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -101,6 +101,7 @@ static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
 static DEFINE_IDR(lpfc_hba_index);
 #define LPFC_NVMET_BUF_POST 254
 static int lpfc_vmid_res_alloc(struct lpfc_hba *phba, struct lpfc_vport *vport);
+static void lpfc_cgn_update_tstamp(struct lpfc_hba *phba, struct lpfc_cgn_ts *ts);
 
 /**
  * lpfc_config_port_prep - Perform lpfc initialization prior to config port
@@ -3197,6 +3198,7 @@ lpfc_cmf_stop(struct lpfc_hba *phba)
 			"6221 Stop CMF / Cancel Timer\n");
 
 	/* Cancel the CMF timer */
+	hrtimer_cancel(&phba->cmf_stats_timer);
 	hrtimer_cancel(&phba->cmf_timer);
 
 	/* Zero CMF counters */
@@ -3283,7 +3285,10 @@ lpfc_cmf_start(struct lpfc_hba *phba)
 
 	phba->cmf_timer_cnt = 0;
 	hrtimer_start(&phba->cmf_timer,
-		      ktime_set(0, LPFC_CMF_INTERVAL * 1000000),
+		      ktime_set(0, LPFC_CMF_INTERVAL * NSEC_PER_MSEC),
+		      HRTIMER_MODE_REL);
+	hrtimer_start(&phba->cmf_stats_timer,
+		      ktime_set(0, LPFC_SEC_MIN * NSEC_PER_SEC),
 		      HRTIMER_MODE_REL);
 	/* Setup for latency check in IO cmpl routines */
 	ktime_get_real_ts64(&phba->cmf_latency);
@@ -5595,81 +5600,74 @@ void
 lpfc_cgn_update_stat(struct lpfc_hba *phba, uint32_t dtag)
 {
 	struct lpfc_cgn_info *cp;
-	struct tm broken;
-	struct timespec64 cur_time;
-	u32 cnt;
 	u32 value;
 
 	/* Make sure we have a congestion info buffer */
 	if (!phba->cgn_i)
 		return;
 	cp = (struct lpfc_cgn_info *)phba->cgn_i->virt;
-	ktime_get_real_ts64(&cur_time);
-	time64_to_tm(cur_time.tv_sec, 0, &broken);
 
 	/* Update congestion statistics */
 	switch (dtag) {
 	case ELS_DTAG_LNK_INTEGRITY:
-		cnt = le32_to_cpu(cp->link_integ_notification);
-		cnt++;
-		cp->link_integ_notification = cpu_to_le32(cnt);
-
-		cp->cgn_stat_lnk_month = broken.tm_mon + 1;
-		cp->cgn_stat_lnk_day = broken.tm_mday;
-		cp->cgn_stat_lnk_year = broken.tm_year - 100;
-		cp->cgn_stat_lnk_hour = broken.tm_hour;
-		cp->cgn_stat_lnk_min = broken.tm_min;
-		cp->cgn_stat_lnk_sec = broken.tm_sec;
+		le32_add_cpu(&cp->link_integ_notification, 1);
+		lpfc_cgn_update_tstamp(phba, &cp->stat_lnk);
 		break;
 	case ELS_DTAG_DELIVERY:
-		cnt = le32_to_cpu(cp->delivery_notification);
-		cnt++;
-		cp->delivery_notification = cpu_to_le32(cnt);
-
-		cp->cgn_stat_del_month = broken.tm_mon + 1;
-		cp->cgn_stat_del_day = broken.tm_mday;
-		cp->cgn_stat_del_year = broken.tm_year - 100;
-		cp->cgn_stat_del_hour = broken.tm_hour;
-		cp->cgn_stat_del_min = broken.tm_min;
-		cp->cgn_stat_del_sec = broken.tm_sec;
+		le32_add_cpu(&cp->delivery_notification, 1);
+		lpfc_cgn_update_tstamp(phba, &cp->stat_delivery);
 		break;
 	case ELS_DTAG_PEER_CONGEST:
-		cnt = le32_to_cpu(cp->cgn_peer_notification);
-		cnt++;
-		cp->cgn_peer_notification = cpu_to_le32(cnt);
-
-		cp->cgn_stat_peer_month = broken.tm_mon + 1;
-		cp->cgn_stat_peer_day = broken.tm_mday;
-		cp->cgn_stat_peer_year = broken.tm_year - 100;
-		cp->cgn_stat_peer_hour = broken.tm_hour;
-		cp->cgn_stat_peer_min = broken.tm_min;
-		cp->cgn_stat_peer_sec = broken.tm_sec;
+		le32_add_cpu(&cp->cgn_peer_notification, 1);
+		lpfc_cgn_update_tstamp(phba, &cp->stat_peer);
 		break;
 	case ELS_DTAG_CONGESTION:
-		cnt = le32_to_cpu(cp->cgn_notification);
-		cnt++;
-		cp->cgn_notification = cpu_to_le32(cnt);
-
-		cp->cgn_stat_cgn_month = broken.tm_mon + 1;
-		cp->cgn_stat_cgn_day = broken.tm_mday;
-		cp->cgn_stat_cgn_year = broken.tm_year - 100;
-		cp->cgn_stat_cgn_hour = broken.tm_hour;
-		cp->cgn_stat_cgn_min = broken.tm_min;
-		cp->cgn_stat_cgn_sec = broken.tm_sec;
+		le32_add_cpu(&cp->cgn_notification, 1);
+		lpfc_cgn_update_tstamp(phba, &cp->stat_fpin);
 	}
 	if (phba->cgn_fpin_frequency &&
 	    phba->cgn_fpin_frequency != LPFC_FPIN_INIT_FREQ) {
 		value = LPFC_CGN_TIMER_TO_MIN / phba->cgn_fpin_frequency;
 		cp->cgn_stat_npm = value;
 	}
+
 	value = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ,
 				    LPFC_CGN_CRC32_SEED);
 	cp->cgn_info_crc = cpu_to_le32(value);
 }
 
 /**
- * lpfc_cgn_save_evt_cnt - Save data into registered congestion buffer
+ * lpfc_cgn_update_tstamp - Update cmf timestamp
  * @phba: pointer to lpfc hba data structure.
+ * @ts: structure to write the timestamp to.
+ */
+void
+lpfc_cgn_update_tstamp(struct lpfc_hba *phba, struct lpfc_cgn_ts *ts)
+{
+	struct timespec64 cur_time;
+	struct tm tm_val;
+
+	ktime_get_real_ts64(&cur_time);
+	time64_to_tm(cur_time.tv_sec, 0, &tm_val);
+
+	ts->month = tm_val.tm_mon + 1;
+	ts->day	= tm_val.tm_mday;
+	ts->year = tm_val.tm_year - 100;
+	ts->hour = tm_val.tm_hour;
+	ts->minute = tm_val.tm_min;
+	ts->second = tm_val.tm_sec;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+			"2646 Updated CMF timestamp : "
+			"%u/%u/%u %u:%u:%u\n",
+			ts->day, ts->month,
+			ts->year, ts->hour,
+			ts->minute, ts->second);
+}
+
+/**
+ * lpfc_cmf_stats_timer - Save data into registered congestion buffer
+ * @timer: Timer cookie to access lpfc private data
  *
  * Save the congestion event data every minute.
  * On the hour collapse all the minute data into hour data. Every day
@@ -5677,12 +5675,11 @@ lpfc_cgn_update_stat(struct lpfc_hba *phba, uint32_t dtag)
  * and fabrc congestion event counters that will be saved out
  * to the registered congestion buffer every minute.
  */
-static void
-lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
+static enum hrtimer_restart
+lpfc_cmf_stats_timer(struct hrtimer *timer)
 {
+	struct lpfc_hba *phba;
 	struct lpfc_cgn_info *cp;
-	struct tm broken;
-	struct timespec64 cur_time;
 	uint32_t i, index;
 	uint16_t value, mvalue;
 	uint64_t bps;
@@ -5693,21 +5690,18 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 	__le32 *lptr;
 	__le16 *mptr;
 
+	phba = container_of(timer, struct lpfc_hba, cmf_stats_timer);
 	/* Make sure we have a congestion info buffer */
 	if (!phba->cgn_i)
-		return;
+		return HRTIMER_NORESTART;
 	cp = (struct lpfc_cgn_info *)phba->cgn_i->virt;
 
-	if (time_before(jiffies, phba->cgn_evt_timestamp))
-		return;
 	phba->cgn_evt_timestamp = jiffies +
 			msecs_to_jiffies(LPFC_CGN_TIMER_TO_MIN);
 	phba->cgn_evt_minute++;
 
 	/* We should get to this point in the routine on 1 minute intervals */
-
-	ktime_get_real_ts64(&cur_time);
-	time64_to_tm(cur_time.tv_sec, 0, &broken);
+	lpfc_cgn_update_tstamp(phba, &cp->base_time);
 
 	if (phba->cgn_fpin_frequency &&
 	    phba->cgn_fpin_frequency != LPFC_FPIN_INIT_FREQ) {
@@ -5860,31 +5854,6 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 			index = 0;
 		}
 
-		/* Anytime we overwrite daily index 0, after we wrap,
-		 * we will be overwriting the oldest day, so we must
-		 * update the congestion data start time for that day.
-		 * That start time should have previously been saved after
-		 * we wrote the last days worth of data.
-		 */
-		if ((phba->hba_flag & HBA_CGN_DAY_WRAP) && index == 0) {
-			time64_to_tm(phba->cgn_daily_ts.tv_sec, 0, &broken);
-
-			cp->cgn_info_month = broken.tm_mon + 1;
-			cp->cgn_info_day = broken.tm_mday;
-			cp->cgn_info_year = broken.tm_year - 100;
-			cp->cgn_info_hour = broken.tm_hour;
-			cp->cgn_info_minute = broken.tm_min;
-			cp->cgn_info_second = broken.tm_sec;
-
-			lpfc_printf_log
-				(phba, KERN_INFO, LOG_CGN_MGMT,
-				"2646 CGNInfo idx0 Start Time: "
-				"%d/%d/%d %d:%d:%d\n",
-				cp->cgn_info_day, cp->cgn_info_month,
-				cp->cgn_info_year, cp->cgn_info_hour,
-				cp->cgn_info_minute, cp->cgn_info_second);
-		}
-
 		dvalue = 0;
 		wvalue = 0;
 		lvalue = 0;
@@ -5918,15 +5887,6 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 				"2420 Congestion Info - daily (%d): "
 				"%d %d %d %d %d\n",
 				index, dvalue, wvalue, lvalue, mvalue, avalue);
-
-		/* We just wrote LPFC_MAX_CGN_DAYS of data,
-		 * so we are wrapped on any data after this.
-		 * Save this as the start time for the next day.
-		 */
-		if (index == (LPFC_MAX_CGN_DAYS - 1)) {
-			phba->hba_flag |= HBA_CGN_DAY_WRAP;
-			ktime_get_real_ts64(&phba->cgn_daily_ts);
-		}
 	}
 
 	/* Use the frequency found in the last rcv'ed FPIN */
@@ -5937,6 +5897,10 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 	lvalue = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ,
 				     LPFC_CGN_CRC32_SEED);
 	cp->cgn_info_crc = cpu_to_le32(lvalue);
+
+	hrtimer_forward_now(timer, ktime_set(0, LPFC_SEC_MIN * NSEC_PER_SEC));
+
+	return HRTIMER_RESTART;
 }
 
 /**
@@ -6067,13 +6031,6 @@ lpfc_cmf_timer(struct hrtimer *timer)
 		if (ms && ms < LPFC_CMF_INTERVAL) {
 			cnt = div_u64(total, ms); /* bytes per ms */
 			cnt *= LPFC_CMF_INTERVAL; /* what total should be */
-
-			/* If the timeout is scheduled to be shorter,
-			 * this value may skew the data, so cap it at mbpi.
-			 */
-			if ((phba->hba_flag & HBA_SHORT_CMF) && cnt > mbpi)
-				cnt = mbpi;
-
 			extra = cnt - total;
 		}
 		lpfc_issue_cmf_sync_wqe(phba, LPFC_CMF_INTERVAL, total + extra);
@@ -6143,34 +6100,6 @@ lpfc_cmf_timer(struct hrtimer *timer)
 	}
 	phba->rx_block_cnt += div_u64(rcv, 512);  /* save 512 byte block cnt */
 
-	/* Each minute save Fabric and Driver congestion information */
-	lpfc_cgn_save_evt_cnt(phba);
-
-	phba->hba_flag &= ~HBA_SHORT_CMF;
-
-	/* Since we need to call lpfc_cgn_save_evt_cnt every minute, on the
-	 * minute, adjust our next timer interval, if needed, to ensure a
-	 * 1 minute granularity when we get the next timer interrupt.
-	 */
-	if (time_after(jiffies + msecs_to_jiffies(LPFC_CMF_INTERVAL),
-		       phba->cgn_evt_timestamp)) {
-		timer_interval = jiffies_to_msecs(phba->cgn_evt_timestamp -
-						  jiffies);
-		if (timer_interval <= 0)
-			timer_interval = LPFC_CMF_INTERVAL;
-		else
-			phba->hba_flag |= HBA_SHORT_CMF;
-
-		/* If we adjust timer_interval, max_bytes_per_interval
-		 * needs to be adjusted as well.
-		 */
-		phba->cmf_link_byte_count = div_u64(phba->cmf_max_line_rate *
-						    timer_interval, 1000);
-		if (phba->cmf_active_mode == LPFC_CFG_MONITOR)
-			phba->cmf_max_bytes_per_interval =
-				phba->cmf_link_byte_count;
-	}
-
 	/* Since total_bytes has already been zero'ed, its okay to unblock
 	 * after max_bytes_per_interval is setup.
 	 */
@@ -8016,6 +7945,9 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	/* CMF congestion timer */
 	hrtimer_init(&phba->cmf_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	phba->cmf_timer.function = lpfc_cmf_timer;
+	/* CMF 1 minute stats collection timer */
+	hrtimer_init(&phba->cmf_stats_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	phba->cmf_stats_timer.function = lpfc_cmf_stats_timer;
 
 	/*
 	 * Control structure for handling external multi-buffer mailbox
@@ -13525,6 +13457,7 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	struct pci_dev *pdev = phba->pcidev;
 
 	lpfc_stop_hba_timers(phba);
+	hrtimer_cancel(&phba->cmf_stats_timer);
 	hrtimer_cancel(&phba->cmf_timer);
 
 	if (phba->pport)
@@ -13649,8 +13582,6 @@ void
 lpfc_init_congestion_buf(struct lpfc_hba *phba)
 {
 	struct lpfc_cgn_info *cp;
-	struct timespec64 cmpl_time;
-	struct tm broken;
 	uint16_t size;
 	uint32_t crc;
 
@@ -13670,11 +13601,10 @@ lpfc_init_congestion_buf(struct lpfc_hba *phba)
 	atomic_set(&phba->cgn_latency_evt_cnt, 0);
 	atomic64_set(&phba->cgn_latency_evt, 0);
 	phba->cgn_evt_minute = 0;
-	phba->hba_flag &= ~HBA_CGN_DAY_WRAP;
 
 	memset(cp, 0xff, offsetof(struct lpfc_cgn_info, cgn_stat));
 	cp->cgn_info_size = cpu_to_le16(LPFC_CGN_INFO_SZ);
-	cp->cgn_info_version = LPFC_CGN_INFO_V3;
+	cp->cgn_info_version = LPFC_CGN_INFO_V4;
 
 	/* cgn parameters */
 	cp->cgn_info_mode = phba->cgn_p.cgn_param_mode;
@@ -13682,22 +13612,7 @@ lpfc_init_congestion_buf(struct lpfc_hba *phba)
 	cp->cgn_info_level1 = phba->cgn_p.cgn_param_level1;
 	cp->cgn_info_level2 = phba->cgn_p.cgn_param_level2;
 
-	ktime_get_real_ts64(&cmpl_time);
-	time64_to_tm(cmpl_time.tv_sec, 0, &broken);
-
-	cp->cgn_info_month = broken.tm_mon + 1;
-	cp->cgn_info_day = broken.tm_mday;
-	cp->cgn_info_year = broken.tm_year - 100; /* relative to 2000 */
-	cp->cgn_info_hour = broken.tm_hour;
-	cp->cgn_info_minute = broken.tm_min;
-	cp->cgn_info_second = broken.tm_sec;
-
-	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT | LOG_INIT,
-			"2643 CGNInfo Init: Start Time "
-			"%d/%d/%d %d:%d:%d\n",
-			cp->cgn_info_day, cp->cgn_info_month,
-			cp->cgn_info_year, cp->cgn_info_hour,
-			cp->cgn_info_minute, cp->cgn_info_second);
+	lpfc_cgn_update_tstamp(phba, &cp->base_time);
 
 	/* Fill in default LUN qdepth */
 	if (phba->pport) {
@@ -13720,8 +13635,6 @@ void
 lpfc_init_congestion_stat(struct lpfc_hba *phba)
 {
 	struct lpfc_cgn_info *cp;
-	struct timespec64 cmpl_time;
-	struct tm broken;
 	uint32_t crc;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
@@ -13733,22 +13646,7 @@ lpfc_init_congestion_stat(struct lpfc_hba *phba)
 	cp = (struct lpfc_cgn_info *)phba->cgn_i->virt;
 	memset(&cp->cgn_stat, 0, sizeof(cp->cgn_stat));
 
-	ktime_get_real_ts64(&cmpl_time);
-	time64_to_tm(cmpl_time.tv_sec, 0, &broken);
-
-	cp->cgn_stat_month = broken.tm_mon + 1;
-	cp->cgn_stat_day = broken.tm_mday;
-	cp->cgn_stat_year = broken.tm_year - 100; /* relative to 2000 */
-	cp->cgn_stat_hour = broken.tm_hour;
-	cp->cgn_stat_minute = broken.tm_min;
-
-	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT | LOG_INIT,
-			"2647 CGNstat Init: Start Time "
-			"%d/%d/%d %d:%d\n",
-			cp->cgn_stat_day, cp->cgn_stat_month,
-			cp->cgn_stat_year, cp->cgn_stat_hour,
-			cp->cgn_stat_minute);
-
+	lpfc_cgn_update_tstamp(phba, &cp->stat_start);
 	crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ, LPFC_CGN_CRC32_SEED);
 	cp->cgn_info_crc = cpu_to_le32(crc);
 }
-- 
2.38.0

