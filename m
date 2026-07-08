Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC0F4CA294
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 18:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536039; cv=none; b=Qdqmu59bmF725/W5QouiRh4EEbPA+G0LzqMi8HtLDfwSBAd158S6MvxmnLK3b/xtfjv7PB2KcIKLGFxkVlD5nL+pvV0w67Kc34hvvRpzwS70lNajFqUtr6VA9GWN2vNY7uE1B0N1kbtAIZ0brFbWyZZb5RI/6aemW+8u4DUnJGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536039; c=relaxed/simple;
	bh=CUaFEBarsONZHGEWugNzumz46WJn9f7Fso9RFSk8+JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1oQhL2rJB73wOlTCXnEOHKhcrV+ww60hET5lj+pSK2irJZYO/C9XBfvDZfNrdNZrgzRo+JVz4NcyUIXa0kKIm+7n4y7hR0t9gN8r7RfQWVi998PodaJirIKRffPQPolDNcUR4INTxesIzbcE1Pecp0fEYGNpSAJe2Tx4ckYYII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Adnh7+SA; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Adnh7+SA"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2cab973140bso13322645ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783536034; x=1784140834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lc8tqu8jijpJ3Ygre1+Rc8PW1msJqWwFg8ycS1GXJrg=;
        b=LsULWLTa1fXiDIEccKWL2/wKkX4Fw7t6I4pa62H6WQz9ZTqazYkbh/u32IeeS2bEWW
         vS7K+fC/x9ciDgs1AIZaLIYkK8FcZN4Jf0HphQJ0on3IhXPd8B+LwIHBfAk4fyMjVFKI
         Tb+c5cQxpcSSZf8lpAxP5eCpu34jd976CE6gEpzTxQrW+CuXkBE2tNgDvNrXidcPulIu
         8qPlNTF6v3nGgmvLMPC/t6tTSUjNyf59zxx99g251hNiuKSSsr5yigXm/FzDmZOxKACL
         MHp/JtM1vnqySq0u8jrG/dT0UL25R39nghfBizLLe/GX8jzua2rOy0YnqUBMDZ6YoDB4
         B2PQ==
X-Gm-Message-State: AOJu0Yy3xTVenRtymRu/cXPFarG9IZf0p3W9RHnUhV9J93Ka6eR7lMDY
	7Va9Dj9ECGrnDoguAOPGpHzmpog3bx1Qdl/Z466YSN534WYZ8jIHiGzbCmLiPsvKKmlvOe146KG
	YAZuYxxR9W+Lcyq8NLospFN/JMG0jXC33cV6J8C6daS+Er+SgbnoEcoK2qJgsB1naFJAeOwvq3+
	A/+fSWZHmbpFBifvYtIBzoat79toL5Uyey3gs4WPHviHFYBTRiVsqx+mqJCnObVYGw0aVql1EbT
	UFQjoypm5MPqiOw
X-Gm-Gg: AfdE7clCcXasswMajBE6JJ5/Uh41g8n4JYHAx+NhK0S2+bJIIIW4W9qIGr2ErzPOzfy
	AJL9tSD+tGVaNj0qRG81H9MOk3lexfks7vaq9vpM4SzWUvkaG/IVRE7MUgcxgO3YshEcxbPzviC
	2JFnGzLLLXA2hwNChosYSSYtSiwZ72O/9hklJBWTfwRK7A76HvP9NcPNHrukWRoEFT9a+7a7YRv
	0enNQX1KQHacBX/PYsoVP9V4f4EUFkZIGlFoQHndL+27laMLwkV1nGOkBcBvyVjU00ZN0ifHCoH
	zYY03gMqtX/L86GyW5AfhVzQj6PJYAkiCI2NTXEzHxsTQapgiQcjmExC7QHnL971aJYP9U+haJm
	dNHveit/WHw6uGlXGo1u4//SXLsmkXgcgCqGrZAhuP+XnO0rXnbUowb19gH4mF3odbzS7iYYOuC
	HICeTXNcHm1WK3/0MjaQQtjVqBkefHT3ip2YCbWq2bzLkkgQ==
X-Received: by 2002:a17:903:230a:b0:2c9:ff29:3f91 with SMTP id d9443c01a7336-2ccea36a4a9mr40067165ad.6.1783536034374;
        Wed, 08 Jul 2026 11:40:34 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2ccc9bf8f1bsm5756165ad.23.2026.07.08.11.40.33
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2026 11:40:34 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-37e24235ce1so1902180a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783536032; x=1784140832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lc8tqu8jijpJ3Ygre1+Rc8PW1msJqWwFg8ycS1GXJrg=;
        b=Adnh7+SAqRIqh/o07jcs9TOceEWcQwenNcZ2U8vHSJxcLY63rb7cdzZIWIpwg/gOlq
         vZ+HoaPFa1gZn2uLOM1+Z8mg0OJ/Sl5ZOXzdc5dPK3lyPGtYVG39pLJjJTKhtTpTCoS2
         l97mw/8RXySdITFfcfqFUPXPwgnDIZ1COsTBI=
X-Received: by 2002:a17:90b:2641:b0:36b:a2cc:485b with SMTP id 98e67ed59e1d1-389421ae149mr4103468a91.21.1783536032514;
        Wed, 08 Jul 2026 11:40:32 -0700 (PDT)
X-Received: by 2002:a17:90b:2641:b0:36b:a2cc:485b with SMTP id 98e67ed59e1d1-389421ae149mr4103438a91.21.1783536031942;
        Wed, 08 Jul 2026 11:40:31 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm19820599eec.18.2026.07.08.11.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:40:31 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 03/10] mpi3mr: Add early timestamp synchronization after driver load
Date: Thu,  9 Jul 2026 00:02:58 +0530
Message-ID: <20260708183305.244485-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

When the driver is loaded from initramfs, the controller timestamp may
be initialized before the system clock has been synchronized. As a
result, the controller can operate with a stale timestamp until the
first periodic synchronization occurs.

Currently, the first controller timestamp synchronization occurs only
after the configured ts_update_interval expires (15 minutes by default).
Add an early timestamp synchronization 60 seconds after driver load,
followed by the existing periodic synchronization interval.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 25 +++++++++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 39096004c60a..1f2f0951b560 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -125,6 +125,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_RESETTM_TIMEOUT			60
 #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
 #define MPI3MR_TSUPDATE_INTERVAL		900
+#define MPI3MR_EARLY_TSUPDATE_SECONDS		60
 #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
 #define	MPI3MR_RAID_ERRREC_RESET_TIMEOUT	180
 #define MPI3MR_PREPARE_FOR_RESET_TIMEOUT	180
@@ -1118,6 +1119,7 @@ struct scmd_priv {
  * @evtack_cmds_bitmap: Event Ack bitmap
  * @delayed_evtack_cmds_list: Delayed event acknowledgment list
  * @ts_update_counter: Timestamp update counter
+ * @early_ts_sync_done: Early (1 min) timestamp sync completed after load
  * @ts_update_interval: Timestamp update interval
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
@@ -1318,6 +1320,7 @@ struct mpi3mr_ioc {
 	struct list_head delayed_evtack_cmds_list;
 
 	u16 ts_update_counter;
+	u8 early_ts_sync_done;
 	u16 ts_update_interval;
 	u8 reset_in_progress;
 	u8 unrecoverable;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 59241038f689..434b66f7b502 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2870,8 +2870,9 @@ static int mpi3mr_print_pkg_ver(struct mpi3mr_ioc *mrioc)
  * @work: work struct
  *
  * Watch dog work periodically executed (1 second interval) to
- * monitor firmware fault and to issue periodic timer sync to
- * the firmware.
+ * monitor firmware fault and perform timestamp synchronization
+ * to firmware, with an early sync 1 minute after load followed
+ * by periodic updates at ts_update_interval seconds (default 15 minutes).
  *
  * Return: Nothing.
  */
@@ -2917,11 +2918,23 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	}
 
 	if (!(mrioc->facts.ioc_capabilities &
-		MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_IOC) &&
-		(mrioc->ts_update_counter++ >= mrioc->ts_update_interval)) {
+		MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_IOC)) {
+		if (!mrioc->early_ts_sync_done) {
+			/*
+			 * Send time sync 1 min after load
+			 */
+			if (mrioc->ts_update_counter++ >=
+					MPI3MR_EARLY_TSUPDATE_SECONDS) {
+				mrioc->early_ts_sync_done = 1;
+				mrioc->ts_update_counter = 0;
+				mpi3mr_sync_timestamp(mrioc);
+			}
+		} else if (mrioc->ts_update_counter++ >=
+				mrioc->ts_update_interval) {
+			mrioc->ts_update_counter = 0;
+			mpi3mr_sync_timestamp(mrioc);
+		}
 
-		mrioc->ts_update_counter = 0;
-		mpi3mr_sync_timestamp(mrioc);
 	}
 
 	if ((mrioc->prepare_for_reset) &&
-- 
2.47.3

