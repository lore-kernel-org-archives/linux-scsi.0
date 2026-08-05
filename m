Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BD84314BA
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928478; cv=none; b=d1pblI8t0VRtVJO4r6ry1jRfXFIWmnH3yCWPXWtnFxZIelO5MaafOxkLjQ9JQK2vxRlTVxufl4f+DdG/qwff7nbhZN/zvN6Lc9LX3aNWMxnvt1zRyZp7OVhLoW5KjcJBaPBXXW+CgyOc/gICfKrwxDUQwNWRj7gd5hf60e5I1cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928478; c=relaxed/simple;
	bh=z0R0X8zKEgdc7RvkZR2wPQpqsCFXzbnPvbMcsiD65X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6Ai1VB3jUUyc1K81TLMCa838qg8UJYCWpgeqH3Z65mwcdrPFwe0AxTgIreU9GJD5NMJMfP+xhEjGvA8UWKAs8QcZQRzsCemPP+WjJwjmj50lCJxdvLiYsFg4aMeXaSGDf2oB0HeibPXMDz5GiqQoAvl5ofH7W2v20KWf+EzqnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=QfIHfxvO; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QfIHfxvO"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-38e69bdb0fcso833442a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928476; x=1786533276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+GjVeqDouJOYLxkSYiBbdHqtCuIm/QcQGZm/JT5U4II=;
        b=D5jPJkrRCgyXDQbuoICEP0BzY7a6+hmccDgKtYkmYX26ECkHM/KDdxm6YbqL2tIhYI
         rI40xslWUZtmWBiG0oUwWdYir43sUrWSLN4HusrWJ0g51od/FOcZIRTFxGPBVTs4+oZK
         PvWJ4Pa8jWOqXMPUZOycfBnYhw9TQeVvl135AfiWOjgl4DkB/dkFJF/u+WPe9vUtesrD
         bmcY+bWE9rH9eLcB/4HpT0NfLB+l+I3W9hVc94m+elPa2lGj7+pkUIFOSaxSb0kAMG85
         scAzuCTMzI8Bx4TJ2BpTrdRbGTxjKkrfsysZW9AzVF+5Vw55Gx+SJsrxYsRssWzSNmpu
         hpRg==
X-Gm-Message-State: AOJu0Yy2bVMxjLtgOzfbMmQ4rxesnF/K11U8i8aB/pb/Sth4jBLGK35w
	n5hHp+JC7zZY9XxN1DQV5yDfuFDhRfTXJVwcVEkGO9vOBw42XmJBkMbqRgI063MGwmoF09V4Vlp
	cvvTNOFLMumuzAKuxnVWiAqETRXr5xCCGHlmH7iSG/LsCCpZQvdjFcpbABVdwYOeRr22SqpIdBj
	4UXplHYdM4rSMnJkwbtMqaKHwJ1q3iR8sn5Br6gu+09IpGEHdKwkDAaFiVANr3hfpTa1JdIHZBL
	aVERPGcBSb7Zd+y
X-Gm-Gg: AR+sD12vmi9W5q9SX6L2A+pzp+K7eSqgj4Fa6W2Jv7NI3p3LOgcgsAoifdP9ZRt6gsP
	1GuFgcJ8u+JmjSqeKZ42ei0U2RbOAF0iH4YrE7XLSOMywJGi3cy2S+z5Nw4gmIBWOXZV8Cnk4fZ
	wVqa7WY4pgb6rDOJIDXaZPofjF+XTWrGIWkv8h8eUA2yF/RA486oP0aMYNWDb1uxk4/yE/pkEIS
	kBDQfjIVqHm/VRaCb2PG9kO9C3B5xlUKuBfvTzO5InS0dSCZTHwBsSLrItBBDxHAVzQ35ORl12l
	tHwytosaPpRisDr+ZvYxWVYD6HPUBwZlDmErFP40unYY0eRntVg3dYJH+NYwCmvmVNnYuwEMq72
	gVUJjLLu7m7x0za66GIwMtuWcPhVddPiO3bU7fzmwYgy4v4c3gD7DXxzcAWk7B32sczGQFusYjy
	AiojRApVuIUKyNA5SVA5wV9Rhqecv5sNExQMo=
X-Received: by 2002:a17:90b:48c9:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-3903c58f06fmr5982659a91.13.1785928475569;
        Wed, 05 Aug 2026 04:14:35 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39038ffd111sm824962a91.0.2026.08.05.04.14.35
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:14:35 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so761419a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785928474; x=1786533274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+GjVeqDouJOYLxkSYiBbdHqtCuIm/QcQGZm/JT5U4II=;
        b=QfIHfxvO3EboxdfRYMLQFtJc28X+n8tw/dCCiS+hsl/982tiRZYE7W+RnldM/60v2T
         634Bt7xAZ5Obio4i+uc5+DBz8TJDXWJrSLzEu5SEIy5uC+OOdWRFSWtzDKCMLIctqcdQ
         azkC8QleLwnp01rZPETfoEG6vBsZ9JgTWx3NE=
X-Received: by 2002:a05:6a20:ce4d:b0:3c6:3c5b:f2e3 with SMTP id adf61e73a8af0-3cb8607680fmr7283236637.33.1785928473502;
        Wed, 05 Aug 2026 04:14:33 -0700 (PDT)
X-Received: by 2002:a05:6a20:ce4d:b0:3c6:3c5b:f2e3 with SMTP id adf61e73a8af0-3cb8607680fmr7283139637.33.1785928472825;
        Wed, 05 Aug 2026 04:14:32 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673b7f4sm16740227eec.17.2026.08.05.04.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:14:32 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 07/10] mpi3mr: Fix firmware event reference leak during cleanup
Date: Wed,  5 Aug 2026 16:36:31 +0530
Message-ID: <20260805110634.346670-8-ranjan.kumar@broadcom.com>
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
index 23a6a5e3df5f..a34ea7e05690 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -282,32 +282,6 @@ void mpi3mr_hdb_trigger_data_event(struct mpi3mr_ioc *mrioc,
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
@@ -327,11 +301,7 @@ static struct mpi3mr_fwevt *mpi3mr_dequeue_fwevt(
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
 
@@ -365,6 +335,11 @@ static void mpi3mr_cancel_work(struct mpi3mr_fwevt *fwevt)
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
@@ -379,17 +354,44 @@ static void mpi3mr_cancel_work(struct mpi3mr_fwevt *fwevt)
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
@@ -397,8 +399,13 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
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
 
@@ -912,6 +919,8 @@ void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_tgt_dev *tgtdev)
 {
 	struct mpi3mr_stgt_priv_data *tgt_priv;
+	unsigned long flags;
+	bool discard = false;
 
 	ioc_info(mrioc, "%s :Removing handle(0x%04x), wwid(0x%016llx)\n",
 	    __func__, tgtdev->dev_handle, (unsigned long long)tgtdev->wwid);
@@ -924,17 +933,27 @@ void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
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
@@ -962,6 +981,8 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 {
 	int retval = 0;
 	struct mpi3mr_tgt_dev *tgtdev;
+	unsigned long flags;
+	bool discard = false;
 
 	if (mrioc->reset_in_progress || mrioc->pci_err_recovery)
 		return -1;
@@ -978,19 +999,29 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
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
@@ -2133,9 +2164,19 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
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
 
 	if (mrioc->stop_drv_processing) {
 		dprint_event_bh(mrioc, "ignoring event(0x%02x) in the bottom half handler\n"
@@ -2268,9 +2309,12 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
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
@@ -5811,6 +5855,9 @@ mpi3mr_suspend(struct device *dev)
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
index 240f67a8e2e3..b309cfdf6687 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1330,6 +1330,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_phy *mr_sas_phy, *next;
 	struct mpi3mr_sas_port *mr_sas_port;
 	unsigned long flags;
+	bool discard = false;
 	struct mpi3mr_sas_node *mr_sas_node;
 	struct sas_rphy *rphy;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
@@ -1457,8 +1458,10 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 	rphy->identify = mr_sas_port->remote_identify;
 
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
 	if (mrioc->current_event)
 		mrioc->current_event->pending_at_sml = 1;
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 
 	if ((sas_rphy_add(rphy))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
@@ -1480,11 +1483,14 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
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
@@ -1522,6 +1528,7 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 {
 	int i;
 	unsigned long flags;
+	bool discard = false;
 	struct mpi3mr_sas_port *mr_sas_port, *next;
 	struct mpi3mr_sas_node *mr_sas_node;
 	u8 found = 0;
@@ -1578,8 +1585,10 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
 
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
 	if (mrioc->current_event)
 		mrioc->current_event->pending_at_sml = 1;
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 
 	list_for_each_entry_safe(mr_sas_phy, next_phy,
 	    &mr_sas_port->phy_list, port_siblings) {
@@ -1601,11 +1610,14 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
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

