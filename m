Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94172472F7A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547739; cv=none; b=Bp42NRTS2OqO2/Qzkasttk9924RbXnTyF5DkiGal+cqQ885cL/A64aBRNUuQbxIHZtRH9z6y5eNgfarJC0/WEPUx13QxjnXn8MNEH+cUZROca6LBsw6NJemrfk/uFGgPCMGAmYn5sM5jwfcKn63mLzAQS2OcZiamNoxfU6fMKz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547739; c=relaxed/simple;
	bh=euhRkySjxkn+AZgfiw/hU9u6kqeF9itkRUMlfYKZ9OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiEuGsWRYkgTo26X8zA/4amGPBhKt0qbdt6WHA9fqBLuDpT0VxtredP4PnY7gpDxnpDvGzNZzPe7H2mJ6JkRh7SrA0hOJhFwTpL6IzCilpeTLv9+CIfa/OZCApOzSzTqYnXzGtPmNt5q730mVRyTfBNDt/EsB8/LI+flU+CjYDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Cm1aydHd; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Cm1aydHd"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2dd020a2e44so42664425ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547737; x=1790152537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=huol+FDhAe0340u7Fe+bG5ZYM0nxW8b7y1M+X3YqF8U=;
        b=DNeY0TIkA4z/dLDT+RB8tdj4MQ4pYiAglioz3fMOsdKcDZBH3QKQgoHd3Thkh4UwIa
         PWZkd5jfLMX+5B0bMe9ktpuchjY+cY2lpIScXI6bU+IrTYT2aineMIoK862AR3suqJsm
         gH0ODsYzpjLTM46MGj6XxfxAUpE0wCfC7b6GFjalqNPnb8R5lp1aT7Ax8sP3IaBW2Uzr
         hJLp1p4AeSxfBVQ68dC550q+FbeC/kSoYK1NG5eKWjX7JVoe0sdtetWFv0Z8+iFPuWsA
         I5TYoaBUmOApK2SsSlF9uDWfR4VPw6zQm/pxDbT113/YQ78mXFlQHwW+u6Lp5z9Lu3MK
         De6Q==
X-Gm-Message-State: AFuF++kDQGCkF+/g3Dd3paUJ0XOKMCuMDphfW+V/qUJjDQX8QcjKiuhe
	479yMLIssWTIoTmONYnVEcfhu759KYUtmBp5bGSs+uyWZHjsYK/GXayZTNYZYdZiqICypqtXGrs
	eA/GsdOwmWTeQwkFGYjKWxgE9CRM7bPxMwk+xTmyo2bWS2X4tL+zbky2QojcnCVt2jA5yAYB7Gi
	qF7SP8mxNQRjdkmuucuyG7grRC1x+bsOhK7IVwlrUXqwT3HY5b926n94yYvhITXASEwU2tUuHz+
	svjqq/MsmfbsV9Z
X-Gm-Gg: AYBFou3koGe/fEanhZ9Ul9OvWs0KO+/FDa1Zy2ysqljU6u8YPcVpZkj2jFokZxBuNYy
	H8c8LWlF8d6UoP0v4rduwHTHr+uxO3v3ZqDXFOgD7Kc428KJI4EZWiuyc13Hgo27k+9gAhJRpvG
	f++VCpntimnBD5rEVPBvIoEXMdHS7EgCMkDIyming8Ta3f3+2WvJF9dzTjVii9a2F9vccluwclH
	4JS53V7tTVNE2TAY09dKl+QDOINrLm/L3XAIy32XuC/XYAfdqkjVusqwBv8D689wyiiTzGRdMMM
	TbjwoGqRU9FJuZZeTsswJM1liZf2E+st5HacMIdY3+xiEj3zlEdG2bQ3NLV7c6dqQodWD07MqgK
	TriGDKY0VLvL+BiSU3KeTjJsXSDzXXMxXsenjQVz/pErF1Fx6VbLGCjjE6VYSRmbuoEJdaje3Jv
	TDSJGswPvLCrDAzWuXvUlkdBf6M3krK6ucuP8=
X-Received: by 2002:a05:6a00:3317:b0:848:30c3:45dd with SMTP id d2e1a72fcca58-87237ea6de2mr3664969b3a.11.1789547736731;
        Wed, 16 Sep 2026 01:35:36 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc50a7c1e27sm1055781a12.0.2026.09.16.01.35.35
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:36 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39dfcc20aeaso2858776a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547734; x=1790152534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=huol+FDhAe0340u7Fe+bG5ZYM0nxW8b7y1M+X3YqF8U=;
        b=Cm1aydHdSBowRESUg5JseJ3QXstXgQjJG/IVcoB8JZCnJ2UISL1wSlQ+v7Fqh2s3Cd
         rOv8+Jf0T8KOFx5jL/1vZRY3LCJGOMlhpVex68Swu2YzfUPE1mPLrete2oOUim36Uqg2
         iRrEGr9FVEng8JT0X6j37gG6VkYUJU1/dg9m8=
X-Received: by 2002:a17:90b:258f:b0:39d:b1bd:b384 with SMTP id 98e67ed59e1d1-39e1e4da87emr4383541a91.17.1789547733198;
        Wed, 16 Sep 2026 01:35:33 -0700 (PDT)
X-Received: by 2002:a17:90b:258f:b0:39d:b1bd:b384 with SMTP id 98e67ed59e1d1-39e1e4da87emr4383458a91.17.1789547732534;
        Wed, 16 Sep 2026 01:35:32 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:32 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 07/10] mpi3mr: Fix firmware event reference leak during cleanup
Date: Wed, 16 Sep 2026 13:57:02 +0530
Message-ID: <20260916082705.44712-8-ranjan.kumar@broadcom.com>
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

During firmware event cleanup, when an event is currently executing or
pending at the SCSI mid-layer, the driver sets a discard flag and exits
the cleanup routine early. This early exit skips the normal cancel path,
resulting in the firmware event reference count not being decremented,
leading to a reference leak.

Additionally, resolve the following concurrency issues in the firmware
event handling paths:

1. mpi3mr_cleanup_fwevt_list() read current_event locklessly. It is
   now acquired under fwevt_lock.
2. mpi3mr_dequeue_fwevt() dropped the reference before returning it,
   risking a use-after-free. The drop is now moved into
   mpi3mr_cancel_work().
3. mpi3mr_fwevt_bh() dropped fwevt_lock mid-move, racing with unload.
   The move is now inlined under one continuous lock hold.
4. pending_at_sml was read/written without a lock, risking an ABBA
   deadlock. It is now protected by fwevt_lock throughout.
5. mpi3mr_suspend() could unmap PCI resources before the event
   worker finished. It now flushes the workqueue first.
6. mpi3mr_report_tgtdev_to_host() and mpi3mr_remove_tgtdev_from_host()
   could still set pending_at_sml and block in the SCSI mid-layer
   after a stop or reset had already begun, deadlocking against the
   thread waiting on that flag. Both now bail out beforehand once
   stop_drv_processing or reset_in_progress is set.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=7
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=7
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar@broadcom.com?part=7
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 139 +++++++++++++++++--------
 drivers/scsi/mpi3mr/mpi3mr_transport.c |  20 +++-
 2 files changed, 109 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 3412e1e0e8ce..dd11b13f9d0b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -283,32 +283,6 @@ void mpi3mr_hdb_trigger_data_event(struct mpi3mr_ioc *mrioc,
 	mpi3mr_fwevt_add_to_list(mrioc, fwevt);
 }
 
-/**
- * mpi3mr_fwevt_del_from_list - Delete firmware event from list
- * @mrioc: Adapter instance reference
- * @fwevt: Firmware event reference
- *
- * Delete the given firmware event from the firmware event list.
- *
- * Return: Nothing.
- */
-static void mpi3mr_fwevt_del_from_list(struct mpi3mr_ioc *mrioc,
-	struct mpi3mr_fwevt *fwevt)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
-	if (!list_empty(&fwevt->list)) {
-		list_del_init(&fwevt->list);
-		/*
-		 * Put fwevt reference count after
-		 * removing it from fwevt_list
-		 */
-		mpi3mr_fwevt_put(fwevt);
-	}
-	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
-}
-
 /**
  * mpi3mr_dequeue_fwevt - Dequeue firmware event from the list
  * @mrioc: Adapter instance reference
@@ -328,11 +302,7 @@ static struct mpi3mr_fwevt *mpi3mr_dequeue_fwevt(
 		fwevt = list_first_entry(&mrioc->fwevt_list,
 		    struct mpi3mr_fwevt, list);
 		list_del_init(&fwevt->list);
-		/*
-		 * Put fwevt reference count after
-		 * removing it from fwevt_list
-		 */
-		mpi3mr_fwevt_put(fwevt);
+
 	}
 	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 
@@ -366,6 +336,11 @@ static void mpi3mr_cancel_work(struct mpi3mr_fwevt *fwevt)
 		 */
 		mpi3mr_fwevt_put(fwevt);
 	}
+
+	/*
+	 * Drop the reference count that was acquired by the caller.
+	 */
+	mpi3mr_fwevt_put(fwevt);
 }
 
 /**
@@ -380,17 +355,44 @@ static void mpi3mr_cancel_work(struct mpi3mr_fwevt *fwevt)
 void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
 {
 	struct mpi3mr_fwevt *fwevt = NULL;
+	unsigned long flags;
 
+	/*
+	 * Safely read current_event under lock to prevent TOCTOU race
+	 * with the firmware event worker thread.
+	 */
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
 	if ((list_empty(&mrioc->fwevt_list) && !mrioc->current_event) ||
-	    !mrioc->fwevt_worker_thread)
+	    !mrioc->fwevt_worker_thread) {
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 		return;
+	}
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 
 	while ((fwevt = mpi3mr_dequeue_fwevt(mrioc)))
 		mpi3mr_cancel_work(fwevt);
 
-	if (mrioc->current_event) {
-		fwevt = mrioc->current_event;
+	/*
+	 * Safely read current_event under lock to prevent TOCTOU race
+	 * with the firmware event worker thread.
+	 */
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	fwevt = mrioc->current_event;
+	if (fwevt) {
+		/*
+		 * Take a reference to ensure the event is not freed by the
+		 * worker thread while we are evaluating or cancelling it.
+		 */
+		mpi3mr_fwevt_get(fwevt);
+	}
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+
+	if (fwevt) {
+		bool pending_at_sml;
+
 		/*
+		 * Read pending_at_sml under lock to avoid a stale value.
+		 *
 		 * Don't call cancel_work_sync() API for the
 		 * fwevt work if the controller reset is
 		 * get called as part of processing the
@@ -398,8 +400,13 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
 		 * waiting for device add/remove APIs to complete.
 		 * Otherwise we will see deadlock.
 		 */
-		if (current_work() == &fwevt->work || fwevt->pending_at_sml) {
+		spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+		pending_at_sml = fwevt->pending_at_sml;
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+
+		if (current_work() == &fwevt->work || pending_at_sml) {
 			fwevt->discard = 1;
+			mpi3mr_fwevt_put(fwevt);
 			return;
 		}
 
@@ -913,6 +920,8 @@ void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_tgt_dev *tgtdev)
 {
 	struct mpi3mr_stgt_priv_data *tgt_priv;
+	unsigned long flags;
+	bool discard = false;
 
 	ioc_info(mrioc, "%s :Removing handle(0x%04x), wwid(0x%016llx)\n",
 	    __func__, tgtdev->dev_handle, (unsigned long long)tgtdev->wwid);
@@ -925,17 +934,27 @@ void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 	if (!mrioc->sas_transport_enabled || (tgtdev->dev_type !=
 	    MPI3_DEVICE_DEVFORM_SAS_SATA) || tgtdev->non_stl) {
 		if (tgtdev->starget) {
+			spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+			if (mrioc->stop_drv_processing ||
+			    mrioc->reset_in_progress) {
+				spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+				return;
+			}
 			if (mrioc->current_event)
 				mrioc->current_event->pending_at_sml = 1;
+			spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 			scsi_remove_target(&tgtdev->starget->dev);
 			tgtdev->host_exposed = 0;
+			spin_lock_irqsave(&mrioc->fwevt_lock, flags);
 			if (mrioc->current_event) {
 				mrioc->current_event->pending_at_sml = 0;
-				if (mrioc->current_event->discard) {
-					mpi3mr_print_device_event_notice(mrioc,
-					    false);
-					return;
-				}
+				discard = mrioc->current_event->discard;
+			}
+			spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+			if (discard) {
+				mpi3mr_print_device_event_notice(mrioc,
+				    false);
+				return;
 			}
 		}
 	} else
@@ -963,6 +982,8 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 {
 	int retval = 0;
 	struct mpi3mr_tgt_dev *tgtdev;
+	unsigned long flags;
+	bool discard = false;
 
 	if (mrioc->reset_in_progress || mrioc->pci_err_recovery)
 		return -1;
@@ -979,19 +1000,29 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 	if (!mrioc->sas_transport_enabled || (tgtdev->dev_type !=
 	    MPI3_DEVICE_DEVFORM_SAS_SATA) || tgtdev->non_stl){
 		tgtdev->host_exposed = 1;
+		spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+		if (mrioc->stop_drv_processing || mrioc->reset_in_progress) {
+			spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+			tgtdev->host_exposed = 0;
+			goto out;
+		}
 		if (mrioc->current_event)
 			mrioc->current_event->pending_at_sml = 1;
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 		scsi_scan_target(&mrioc->shost->shost_gendev,
 		    mrioc->scsi_device_channel, tgtdev->perst_id,
 		    SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
 		if (!tgtdev->starget)
 			tgtdev->host_exposed = 0;
+		spin_lock_irqsave(&mrioc->fwevt_lock, flags);
 		if (mrioc->current_event) {
 			mrioc->current_event->pending_at_sml = 0;
-			if (mrioc->current_event->discard) {
-				mpi3mr_print_device_event_notice(mrioc, true);
-				goto out;
-			}
+			discard = mrioc->current_event->discard;
+		}
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+		if (discard) {
+			mpi3mr_print_device_event_notice(mrioc, true);
+			goto out;
 		}
 		dprint_event_bh(mrioc,
 		    "exposed target device with handle(0x%04x), perst_id(%d)\n",
@@ -2134,9 +2165,19 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	u16 perst_id, handle, dev_info;
 	struct mpi3_device0_sas_sata_format *sasinf = NULL;
 	unsigned int timeout;
+	unsigned long flags;
 
-	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	if (!list_empty(&fwevt->list)) {
+		list_del_init(&fwevt->list);
+		/*
+		 * Put fwevt reference count after
+		 * removing it from fwevt_list
+		 */
+		mpi3mr_fwevt_put(fwevt);
+	}
 	mrioc->current_event = fwevt;
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 
 	if (mrioc->stop_drv_processing || mrioc->pci_err_recovery) {
 		dprint_event_bh(mrioc,
@@ -2271,9 +2312,12 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 		mpi3mr_process_event_ack(mrioc, fwevt->event_id,
 		    fwevt->evt_ctx);
 out:
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	mrioc->current_event = NULL;
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+
 	/* Put fwevt reference count to neutralize kref_init increment */
 	mpi3mr_fwevt_put(fwevt);
-	mrioc->current_event = NULL;
 }
 
 /**
@@ -5874,6 +5918,9 @@ mpi3mr_suspend(struct device *dev)
 		ssleep(1);
 	mrioc->stop_drv_processing = 1;
 	mpi3mr_cleanup_fwevt_list(mrioc);
+	/* Flush any pending discarded event before unmapping PCI resources below. */
+	if (mrioc->fwevt_worker_thread)
+		flush_workqueue(mrioc->fwevt_worker_thread);
 	scsi_block_requests(shost);
 	mpi3mr_stop_watchdog(mrioc);
 	mpi3mr_cleanup_ioc(mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 2afff1a002ed..be794fe8eb7d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1337,6 +1337,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_phy *mr_sas_phy, *next;
 	struct mpi3mr_sas_port *mr_sas_port;
 	unsigned long flags;
+	bool discard = false;
 	struct mpi3mr_sas_node *mr_sas_node;
 	struct sas_rphy *rphy;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
@@ -1464,8 +1465,10 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 	rphy->identify = mr_sas_port->remote_identify;
 
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
 	if (mrioc->current_event)
 		mrioc->current_event->pending_at_sml = 1;
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 
 	if ((sas_rphy_add(rphy))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
@@ -1487,11 +1490,14 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	list_add_tail(&mr_sas_port->port_list, &mr_sas_node->sas_port_list);
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
 
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
 	if (mrioc->current_event) {
 		mrioc->current_event->pending_at_sml = 0;
-		if (mrioc->current_event->discard)
-			mpi3mr_print_device_event_notice(mrioc, true);
+		discard = mrioc->current_event->discard;
 	}
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+	if (discard)
+		mpi3mr_print_device_event_notice(mrioc, true);
 
 	/* fill in report manufacture */
 	if (mr_sas_port->remote_identify.device_type ==
@@ -1529,6 +1535,7 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 {
 	int i;
 	unsigned long flags;
+	bool discard = false;
 	struct mpi3mr_sas_port *mr_sas_port, *next;
 	struct mpi3mr_sas_node *mr_sas_node;
 	u8 found = 0;
@@ -1585,8 +1592,10 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
 
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
 	if (mrioc->current_event)
 		mrioc->current_event->pending_at_sml = 1;
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 
 	list_for_each_entry_safe(mr_sas_phy, next_phy,
 	    &mr_sas_port->phy_list, port_siblings) {
@@ -1608,11 +1617,14 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 	ioc_info(mrioc, "%s: removed sas_address(0x%016llx)\n",
 	    __func__, (unsigned long long)sas_address);
 
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
 	if (mrioc->current_event) {
 		mrioc->current_event->pending_at_sml = 0;
-		if (mrioc->current_event->discard)
-			mpi3mr_print_device_event_notice(mrioc, false);
+		discard = mrioc->current_event->discard;
 	}
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+	if (discard)
+		mpi3mr_print_device_event_notice(mrioc, false);
 
 	kfree(mr_sas_port);
 }
-- 
2.47.3

