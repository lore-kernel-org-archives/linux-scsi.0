Received: from mail-oa1-f98.google.com (mail-oa1-f98.google.com [209.85.160.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DFE421229
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889166; cv=none; b=X69xHcM2LgRz1Gqnf/1swwhvrk1ELRDvX4+hDwy8xgT5NVui8T16c3b8kBx+Y4D9HEW7VTgnohFjiu10PhGl7N1UW/xiG6wEknk6NWl9V64moYs5/nzC8mGE1z5+Na9AAsJs5JtWO9iYROO7xkgqyPn6eLYA28m3VoKrVP9FSGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889166; c=relaxed/simple;
	bh=CUaFEBarsONZHGEWugNzumz46WJn9f7Fso9RFSk8+JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7o3mvCUYRJmo3nTK0MzEb+iKKmBR0tPu7Q5mGpCXZPJqlmbgGIpVPYuJl/MdMHWaiAwOQ0KKm2zW3ceZ0qR1m4Th07+Q8mHytsJuhzElSpnBKgbUL3gi5ujAliJCEtDa6rgO23R2DI35pBRcAI8qQmWa7t4tNuN4yHy2+M7fjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=L7XxOkyX; arc=none smtp.client-ip=209.85.160.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="L7XxOkyX"
Received: by mail-oa1-f98.google.com with SMTP id 586e51a60fabf-456395f4e7bso134519fac.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784889163; x=1785493963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lc8tqu8jijpJ3Ygre1+Rc8PW1msJqWwFg8ycS1GXJrg=;
        b=owIVQfbs+tj3+OeJksSkEn3NUM4kve56E8SsZqxPsqdMMc2/2UBi3Fj/ofNdY9UNrc
         UhrZtElg+lE0kwT0LkpGC8ImY4rdJusw4nNt4HhZbdNNXlAUuL+IBYFqusdcGByoRSYE
         8x4xRSl1vhkRz9XsYdEQJBs1es15JLTHyYi6hL4zhOm3wNVkKUrcheiIdqgvNakinqqo
         OWmor3FNp0KDbFDT4FA9ypZJGLHFkVh2yRw+jwRr1efdrG7lxEbLVbJx0HVu/pwxvoP9
         +g9F3AGPz506R3cvOB0dF3vQNgL2DhGVDqTT2uRVYx+0bY3JSDtcyggo8Ay+EVV12B2z
         EwSw==
X-Gm-Message-State: AOJu0YzzllUUelgskCO96F+7357unyb75H7Gldk5yyED1J/UW8hDZFuu
	TEWLujkplm0W3mgfXF8r9ToZNKS06KQVF3LZR0bQUvpaJ8bPBGIgA5jIDj+9XEzZTWoMMAQwAq5
	Qjdi1EPSnVVsWg+XdAOZQhKIuLxA/ZSk8c0BHGQmbTixIR8zwBQvVBAfYX7UjcdurjjpYe14Lv9
	RCp5p5/f4zkbVjzC1bEy3j0SnnllHa/LdLTZUIn7l4fMaqGlqRSFLWYOnbotc+fQojIFtbNlaqq
	nwoicy9+xIRnstg
X-Gm-Gg: AR+sD12ivD1FPGvCa6akL6eZcKicryvFj089zrV3/iAneOdE4RLU1cGN7GMiApCQArA
	WuAVdmWa3XVik8SH8kuarmMlo+uxbeU5igvKvdlIr4I/k0paeHS8euHFde8ACvUPuAi1fUrB9p9
	Lqw/sbYOSRhsQuBC/F0FVAK1GXRnbO8RIYCmXK/V2pahEbH1V5PERkLcznadh9gUWGGQdk3bTj3
	7wsgP4ODZQvMTrn3JTNfqU3X90QdOEZo5PAm7s0BtdPCNwFtd8mytlwjPBF2ClSA5GebuN/evDb
	VOL1y5GbPiLWkOalfqFZeT7fVTTUUtQwFOXTYNa8ROrAGDWTrzNFPPFqm2GQpnmSAu0piCylZ4D
	qH5FtAjYiTx+oZMLXXUk+6Uja85naI9IhIQDORUbt98Py4AFSFlVVRoe22uUKpSYdicXCDtuJE8
	nQYVE+HacjPy1xO6UzGiD0fQlkatqHwUBmkag=
X-Received: by 2002:a05:6871:c909:b0:456:5842:f33e with SMTP id 586e51a60fabf-457a103e0a1mr3916569fac.25.1784889163409;
        Fri, 24 Jul 2026 03:32:43 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-45767465a64sm582952fac.13.2026.07.24.03.32.42
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:32:43 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb6cf425e86so399469a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784889161; x=1785493961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lc8tqu8jijpJ3Ygre1+Rc8PW1msJqWwFg8ycS1GXJrg=;
        b=L7XxOkyXSQp7x0+FYjYArelb5BASuWhgFhaCMNbw6eVTdOcZWJnOOF7gO0/bhgz8ST
         YLWrcHQY6Dvige0vmjpAJRH1vWsplMEJGgDaX02ax3YPlX/AJpUqaSifTKD1/Lf9B/Yn
         HIrs1eGlf0zN8fL2fK8rmHiqIhxxgl4QpLsPw=
X-Received: by 2002:a05:6a20:a11a:b0:3c0:9c19:65b3 with SMTP id adf61e73a8af0-3c44b2ae24bmr7636601637.75.1784889161104;
        Fri, 24 Jul 2026 03:32:41 -0700 (PDT)
X-Received: by 2002:a05:6a20:a11a:b0:3c0:9c19:65b3 with SMTP id adf61e73a8af0-3c44b2ae24bmr7636564637.75.1784889160588;
        Fri, 24 Jul 2026 03:32:40 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm30233211eec.31.2026.07.24.03.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:32:40 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v3 03/10] mpi3mr: Add early timestamp synchronization after driver load
Date: Fri, 24 Jul 2026 15:54:58 +0530
Message-ID: <20260724102505.115136-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
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

