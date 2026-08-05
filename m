Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25366431495
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928462; cv=none; b=mBxplyol35ro3eBKFd85IwoqBJ/9Xkwm8cYe+tRjnM96SaWX/zOfoHS1EjxQryqcalnb8QFwHrEIUdO1iipFwyucCvUSpUo4LHVZG16Tk9TN0dPMxPTwWn4cJxWynWzeqmlyHahkO0SUrVeirNAXe/RU6VMkc0g5B04UkrQr72M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928462; c=relaxed/simple;
	bh=CUaFEBarsONZHGEWugNzumz46WJn9f7Fso9RFSk8+JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKxaRCsTVlHc6ljlvrHssE1qdtWU3+chSGUP7HZvbDLaOWzMhazr2CpXmtzPx+RyuA95YGCAm4SXj9c9ZTmjq4yMQrfRoUnPxDYyOK3E7kobUuSNuKIk5hjl5uIyDzeAR4HDEzSbKz2KE0o+cs0X1SHfpubfgxW/7NQUMy93xa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bcIJP+Ag; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bcIJP+Ag"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-84864086bfeso640727b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928460; x=1786533260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lc8tqu8jijpJ3Ygre1+Rc8PW1msJqWwFg8ycS1GXJrg=;
        b=E/6kJYz0bdD6l/URYKgrhXlZKYQ/2JGnKceBDglbAzyX2YJRG3PyWY/usRx9qPA0HA
         X/45wz1gxLamGJ+KyYxUBzVyJG4r7yvmXOVdgRO5+H0v+xjy8OSdAovvhFnUJ0vFPTHJ
         l19E1omxZ4gLmPaJW1B7Zv8pMcgmkdPr9mvh8F5qqkM7D2ObuJtZQCNYhHfRurH16u50
         75X8MSp5BNGgkT/4bBRbFyAaAUGIm/mWQPMeme83ANeL3J7hm+XYx/XaoPx/azPllyus
         kT5u6x06P+9oQFoLxL7ePlVZQZQk4/DQJ3sJZxWIKYcQftyQWBgfZ+TPJzdEzm21glPh
         S7Ww==
X-Gm-Message-State: AOJu0YzyUPlUwKE433c8bIgqcoJxqn7hsk+FUErXzqqk6FZaR6QTtE0b
	E0ghUQaqg6GZagUXv6iDqa54duAHXqbwoBw/0Lu+8B5m1gkKzLvDEdwZMPYTEG22AskUeWIC63I
	lKE7+a5IhPOZwXQEyZMSd4oBsHIKa2FsQVjr+D9AAl8ZJrfXGnsI5Yx+wnqQHiqiWsZNREVhR3W
	fJGOnvfW0HdqeOGCjFEdcddyIt+nJrLaS6Y5AJHZnXQ3amHkRHhvHcGvlQwCzbv+jRAlrzavhig
	6FKe7iEYA98YVu8
X-Gm-Gg: AR+sD13P/lDbyeg7tRNbrSAZAdTQsbZXfbB2BVjKBJ9sizC1aBF4e4n0q7FZhJKnSNz
	FVKqd3KSuI/IYO+yGntQMwrIy/ICRJXN9rST5vKNim00PtQNQg8mYcsq/zUG/c+PqmnMoR5K/fj
	8C3ca//i+zseHVvqe6Lor3h26hzvrLcAdRPkNpCXH32tge8WgshL2e024+oPQ9KxIHS/1SrqBCW
	wXN+1/3gjSoVrh+CgB8/AcGF+/leLYkPpr4LPiFaPAG0my0PVuBJiNnMF8eyYau3Nz4IN8bgMSu
	ZksyV/ROky2AR3GivVm6Xp00ZJi7XSn59E7oBu4UvJDDrjvlDwS1ZtSwqobCWDTEKEpVAlrG+rO
	WOQqEx3rodsP1m88ytyY9zWfcIKG1ksj44KfrAfEO4PKhNrtNQURUP9TKFjhK3DK92Ht7mWwW1o
	6iNyrESSSdqtRJV6IHoqcqlKTk4fwpjVKZ5hA=
X-Received: by 2002:a05:6a00:450b:b0:84a:2c46:3fdb with SMTP id d2e1a72fcca58-84f2dfd0762mr6650409b3a.5.1785928460337;
        Wed, 05 Aug 2026 04:14:20 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cbe707d60casm679255a12.2.2026.08.05.04.14.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:14:20 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cab041eced3so1310233a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785928458; x=1786533258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lc8tqu8jijpJ3Ygre1+Rc8PW1msJqWwFg8ycS1GXJrg=;
        b=bcIJP+AgdrIIbQNBGsBI6B4MO6PdBx8azh511ulvwQksu3s+8djJiQUpZAul5f4Hzd
         bOhl80g2/2/UxHH3hnFkVm5NV4QBHdGtbLOnlDWtsPVAI+KNYGjDN3kkjzQCrvnxA4GY
         0n4huD38BxKNhcANBgVK9aXMNI5gdtd87bkuk=
X-Received: by 2002:a05:6a21:9f17:b0:3c3:cc3e:a9 with SMTP id adf61e73a8af0-3cb85df09d6mr7519434637.4.1785928458514;
        Wed, 05 Aug 2026 04:14:18 -0700 (PDT)
X-Received: by 2002:a05:6a21:9f17:b0:3c3:cc3e:a9 with SMTP id adf61e73a8af0-3cb85df09d6mr7519368637.4.1785928457985;
        Wed, 05 Aug 2026 04:14:17 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673b7f4sm16740227eec.17.2026.08.05.04.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:14:17 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v4 03/10] mpi3mr: Add early timestamp synchronization after driver load
Date: Wed,  5 Aug 2026 16:36:27 +0530
Message-ID: <20260805110634.346670-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
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

