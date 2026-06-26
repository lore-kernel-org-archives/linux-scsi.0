Received: from mail-dy1-f225.google.com (mail-dy1-f225.google.com [74.125.82.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED192EDD6C
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 11:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474521; cv=none; b=palUezwEFsyuqaCHPrzivtX1YVxZpFlctmnlcsntp+GzvFEBmJt/2DyEQ0eFcgOI+xJm0VlhlHj6bDTtWO6c8dTUcr4vDV1+RrnZUYJ1T/+3BJu05zkWWnYJb9K/kykWsIOTAeV2Nqn0SuTV6Nit8fiL8uuntrcGX7G+sJstWBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474521; c=relaxed/simple;
	bh=MeIxt2Xr9cs+bvsbdfxd7UvaCsBHRWqjvyB8FBSg+q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txn4qGyBphyKx9Q9SS+uj0GfNP54ZlM1mwrkKygQ3Bqyu+a3NqenFmv6TH39i1Z8P1UMJCOWo+3I7xvH6e6wzn3Xk7RQyHfvEXB/VXzJHIsu/2VPKSfOGd454BIiT60jGUDGRcBboEwL8jzANxoXoA5wZ9tmkbf6iC+m2afTj88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=MxdfAbUg; arc=none smtp.client-ip=74.125.82.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MxdfAbUg"
Received: by mail-dy1-f225.google.com with SMTP id 5a478bee46e88-30bc806fcf8so1140684eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782474519; x=1783079319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73Scx3KJFlBJzXL7C2Ua+DoHEEk4jHQgekXemWM5KIU=;
        b=ojTt0IHpNGAyxUsgN0foFyNErMWwGsfMzgGuXezQ4R63KnIoL3LqtDuEA2NpC8DpNT
         d7pIPrUnRd03QNI1BXb5tFKTEhMAmp8egrHWtLLstO/Ip3Q/XutTKCAsFS4M3vXpVOPc
         sn7TTT8Ikffpg2n15R0SfInYPrFcsLu5LMfYnbDeieoNt6b9MvvkpxecOyWnE6OcCz6i
         mbOWqdjZ96xCl/FpQGlKppbE1Ih1dtwl1UTzRV2QZGkwaGuH3L7tI7Iye0aa1IGytQNc
         ld4/WYbpBfyrRpnyPpTsh4e0CmFVQL3TbZ9tWg9JX1KW7Ta/NxeSIJ/ncQ27+a+zhD3Q
         Ccpw==
X-Gm-Message-State: AOJu0YyDiC4T0CXI4pAKrCvVxmb5+Bk6N8JRoD6ObvbQMwU53Yu6mwcX
	+i5DtEPsqWUAex7aTdN9uWqgfuFKY3/iuRRiyvZY94NVNkqjlXt7d2yLIPHdTgKpX/5ocQLn607
	xm/opMsPv9otDp2nTRsn1Xwmw+AcGhOKM4+55X1QMT7MTnshlcHGqzurNHw8gSM5t7zEIu4yVAd
	IUrBmu5nWY7a009bYud7Z9w0KakH3WAXI4iOvR2KflAnefliIhOZF7/S/nKYw7S6km879Z8I1qx
	loBNIsAIriNz07L
X-Gm-Gg: AfdE7cnMmPdKOcny8kNXrkKkqGdWlEGuCfONWLLRCGEM0AV1Tb68SuebEV2nXT4lsAc
	yR4p1EEX29kDakucw24c+u6TZnRe/K2Bh1Eo2JivH/Sw7dZnE9g3kme/siTjdzh8u6PuTxmClVd
	1SVqEKVgZgoLqZKNWVqQDHqbO7Su1nnnmcva9WsQOgymFx8dOoddE8EtESgIZl21FxzNBfiPrHM
	0kll6fal2ZKCvx6CJaaegLaEPNDf/s8rRPwODbrjtwo9vfphcq00laPzaYWwu9/pMA231N9v7pj
	on8LnDeZ4UXoIl4VCc9mJuzxAbSi0wa3wPwyamHfPF5wJCOeppwNkc5dctfENpb6ob6R9B9BDhJ
	V1EuvHUQ91G4OfPlZKYWaDOmOOkTp4aea4CyK0/usb5auD/tboEkmbiKSKJv/hwE1ITOSqXajxn
	UBIqx0ipWs92EWnwkKZtbC2bEAoCSilRU1UWZk14puQzAi8lB4
X-Received: by 2002:a05:7300:5346:b0:30c:5176:8edc with SMTP id 5a478bee46e88-30c84d90d38mr6975256eec.32.1782474519001;
        Fri, 26 Jun 2026 04:48:39 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-101.dlp.protect.broadcom.com. [144.49.247.101])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-30c7c7da01asm459689eec.19.2026.06.26.04.48.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:48:38 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c50cd6cbcso1101772eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782474517; x=1783079317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73Scx3KJFlBJzXL7C2Ua+DoHEEk4jHQgekXemWM5KIU=;
        b=MxdfAbUg/VgRxCOCgX4rVrOxRqPlxrdThbJpvaljn5hRFY7gi5SU6zR3w7uzEDLj6T
         YPvBuRppl64D3vWN+nkp2cvwFyUV3L3rp+9Z+OWSikZOjze8FmpuWi5t+BE0nmsBi9Ng
         swOFtfXwwyZ4EB2F4pwjkrzdEnFWG3FENwF+c=
X-Received: by 2002:a05:693c:37c4:b0:30c:1865:d9f6 with SMTP id 5a478bee46e88-30c84b2b6dbmr6550986eec.6.1782474517229;
        Fri, 26 Jun 2026 04:48:37 -0700 (PDT)
X-Received: by 2002:a05:693c:37c4:b0:30c:1865:d9f6 with SMTP id 5a478bee46e88-30c84b2b6dbmr6550935eec.6.1782474516008;
        Fri, 26 Jun 2026 04:48:36 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm18844838eec.13.2026.06.26.04.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 04:48:35 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 03/10] mpi3mr: Add early timestamp synchronization after driver load
Date: Fri, 26 Jun 2026 17:11:02 +0530
Message-ID: <20260626114109.43685-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
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
index eb730318db47..496d7ca3ab37 100644
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

