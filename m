Received: from mail-ot1-f100.google.com (mail-ot1-f100.google.com [209.85.210.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BC4472F7A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547722; cv=none; b=AZyb2PZ9pYD6H3HJMAGEG9mG8bUdJX1fxovT6UCwTPLsKc634qinECzQuJLf8kD819mxX5znhYjS5AXZmHNrQQ7rEw6RrIu8/YRZUbeg5tE4AmsRSNzN3Z6kZ9mQNytKHC4x7vGdHCQMynr2vWnFNSt8yh2YJOrvHJFIXtU0kgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547722; c=relaxed/simple;
	bh=YSqe5N7h2IfoK6sJaRZUbTK4avla2uii9i8uO5aZCmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezFCquXL/a6q9rFLwfqyZ7AGjcFikb8DPrEcweW8PH9u60vISn3rFPfjv4l3e6DuxCWy7CNKzEqt/T7Q8jow1nbTugLODST4j6eX0CPyMRm4QdJSUf4O+LD0pic/B9ApKQjqpotQBSnMiv0mYtHvO6M4PqlejqBlamotylbqjlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Klbc0D4E; arc=none smtp.client-ip=209.85.210.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Klbc0D4E"
Received: by mail-ot1-f100.google.com with SMTP id 46e09a7af769-801a52aa540so1280112a34.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547720; x=1790152520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nfDH3V+GWsZITiBA078voH7xbgnPWdvbiN71gsDLtEU=;
        b=TITlGAFLfmGYOshobqUnqeR7xj+CDOKQiRjVKfHmNUmTPfzvVez/RYZCpko1HClKZk
         02SB6D7pOzHlxexgC57s84QNlyjsfrNDEhH2/o6BxR4MDB4I2eG67dFcSRQqxC+qQ60M
         bDTYEgVy5bpczUqVj/USZjKECnDxbidtGBJn1eqTA26dklcgqjnHmSxkGg/LuzreM95C
         vvup6ar1iO19iZJxN10pswQn42YpPKN8WeQc4fnbQxjpn2vfu5xfDpoFopKEqSwl+8iq
         Du5mbZiMiDRU8ROhVXDi/8oEZv0V1Dt3kWypsnt0TauoUDZoawARlpBoXmr+Lq+SMUC7
         asjw==
X-Gm-Message-State: AFuF++m1GClLqZqf0o0is4v+BglZl2gMtsBgiTcBqk50Ot0SBr5GXZiL
	G6Fn7pOdxRWT3a7O+oCawO03ZhSfSo/WT0ky/wy9xCNJPyyXlGAJQFdWXd/QMDgt7wmp7obgqK+
	TVc/l1T7h+I2pnQm7n2hA+nFMe2ZD5SSI5Wh/K1scOlSr/S+vKw2ux5Li3E9C+UzpYR1y3xNSWc
	X43dzVgOQkltUFMKX2zSPEcIT1shbfEGBDFg5FZkthVuygA3D6J5r+Nzx5QquTewno8rwVSsPU5
	7p/Z6MC5BAGBWZi
X-Gm-Gg: AYBFou1nR53A1mTw66K/U8/cQ0hBeMANmbaf8ZPubUBUhjWs7FSUbc0WgUcExpirnky
	lopsEaT+whG9oc/KbfXBBI5AY63MyYgI93Sn5B9atE6fK/K5Nx+JpqNG5m7+raR11w4kzDj6QBj
	mgfNiH+co2In4O+K+IyQ/LxBVUTujur8h3lPHq8P59VAOBOKT1TXujcMW6ZeuziUIqxrR9femR/
	zqNqr3IZS8KHqF0VfMogmPoGFzFvvwXq/5z1f98HzZIeafBKJed6z4VSruTA1MMeQE4D99g78Le
	Fvpj6+DFqLjQpXVmg5ttJ/e4TkY/kDISc11X+KFxQNjJwpndltn1asBknLw5mrgakZyTNwL/KXb
	gYh0wD5WdmS++n7S7KSBeXl0DsYtCfXYyA1xVojiVr/i8DA1Br6r2DZOri6+X5dRev6shkn8E3w
	GGRz9zw4SYXwaObONCYSyYzsZNuUbGwhWLEgs=
X-Received: by 2002:a05:6830:81f9:b0:7fb:eade:d302 with SMTP id 46e09a7af769-80b2d416d2bmr1920680a34.10.1789547719708;
        Wed, 16 Sep 2026 01:35:19 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-80b06cafc58sm1025335a34.3.2026.09.16.01.35.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:19 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6b1abf73d1fso3741208eaf.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547719; x=1790152519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nfDH3V+GWsZITiBA078voH7xbgnPWdvbiN71gsDLtEU=;
        b=Klbc0D4EcKFOERvMUWXpwArsKRb65VfUE7zbllzXd9GTG51D2l/eWgmXoEyF7Rmkre
         UU4Pbm1I2MuNkZHcXFEwodp6+i2ADYYkZYT/QMlrUrCLcK+wJDDvFhlTcPRIJZxhBcoA
         +1RkeLpN3ntwVfwm9pxKCD/hsqBZ+3pgsVEbo=
X-Received: by 2002:a05:6820:198f:b0:6c0:7620:fccf with SMTP id 006d021491bc7-6c7d45e15e2mr1599476eaf.57.1789547718604;
        Wed, 16 Sep 2026 01:35:18 -0700 (PDT)
X-Received: by 2002:a05:6820:198f:b0:6c0:7620:fccf with SMTP id 006d021491bc7-6c7d45e15e2mr1599442eaf.57.1789547718021;
        Wed, 16 Sep 2026 01:35:18 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:17 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v5 03/10] mpi3mr: Add early timestamp synchronization after driver load
Date: Wed, 16 Sep 2026 13:56:58 +0530
Message-ID: <20260916082705.44712-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
References: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
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
index d122e95c9081..d8a68d7fdf19 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2890,8 +2890,9 @@ static int mpi3mr_print_pkg_ver(struct mpi3mr_ioc *mrioc)
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
@@ -2937,11 +2938,23 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
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

