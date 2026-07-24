Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0AA420497
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889177; cv=none; b=KsrzlGurCVTCFsHWOhjRQvo+vKLzw9Ji3fe+pujtCtuarBhqGjg+CRC+7+oW4H1xE0U6o2JhpABX4zc2i4wfIYWuyNa+4awhSdb5sq71JATegZNjEzCH8dlbxzEEVz06yWpw0A+FjeC1XG5QakYr9IUHD3QTQkGEbei3eXvNLk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889177; c=relaxed/simple;
	bh=N7M/pO9czLM43IOKtpnzT6PmoHuiixGP7GyoNKlvPn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svZnEt4ohgXs+ZIOlyt0bwTvrSou3GObKYXpjOJZoH4QaAHHmy2VZlshLmEdE2VV+ZfjJ9Drnp/EUhzzUnh3Wq4aLT3sY4hIJs8TF+vX+Se2cyLYyHZo4FENZgq+Le6Iz8FdXiSzEPvrPnDRLPLsAUbIxC1lz+LVuppjFpnmF1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Y7nJAapk; arc=none smtp.client-ip=74.125.224.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Y7nJAapk"
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-664b05d408bso175408d50.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784889175; x=1785493975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TtZ7CUtOPujMWrugvWV6ht61yJ+DtAprRFs3gzJqxqI=;
        b=CJUG+VbS2kvv99Jo+QbMvKnbH1SLWZ1TqpVXu0nGR8aDi+50otyJsle9zCI6mpKTJv
         ovzPTSXeERsFR04ZniDRG3PZ6wOEJwuyV6AO1iXkfbssJQ2VrGf+vyrjOfvyE4oZj5kk
         v4f9rpU3tfyC/DRZ0Ksb97d+d1eL9cjjBtbH6yABwGWhF0U+Qcvh5fT72A9XYbWsAeD3
         ol/a79xYVaE7S8wHI886r9TyqQCx62VTxazIoewXZnxmqiYrWRj9gOZyaSMtMzCawMoY
         wkEJR0iJvOIvcfP7x8nJyBXcExklYHx4fJwgkDrbp3DnJpaBzTmX+i9ZNR/VjDMYy20y
         v6fA==
X-Gm-Message-State: AOJu0Yybx86axOAVWOyT+cb0b0pFkg8DbWNkJITBe8Y7W4Ewz9Kr7gK7
	hjcMxfk3iluQv+AL/Vx2dfq1gs+3HayLbfaZwWrlZKN9lw64JpYFE1LNm3M56Hx1XShwHQB3RbW
	ow+UV7UhQq/82tUUunw6e5aLLHLZW0PgTCWlzgGpzy2SFPRoWGVMqoqVCy6S8fQQ+vKOajSpEhV
	r7g6vHfOYBreGwkE294k6jU5tLLO97yQTYfnyqxVxbF1w+biasJqYBbEB5V8jjh0PAFrAPXztYc
	zJU8eNmwrqfvobr
X-Gm-Gg: AR+sD114AUbQQwmxAn+oojElVFKQc6DNfFhuBsopOCcGbhOawrasKSg0Fe7AqSbotSV
	v2+HXMVtzOl2VAXJHEEgnLgpaaxxOhmr5z1X/42L1e32FLsxKUCx9ABbKl8MNCS04ROTpwIj65J
	PwHeITBRVqTXFBIuOikofCvBVncEBcCTmaxSTZJV1pkOXvvUTx5GNC3dWI8YHERlG8KpLIKsOh0
	8GJLwwYh1c/0yCJkvGJXVy1MnZ53dMsOm9jVN5AJWPBlwVjOuJzX7+WqUjY9uN7t2P0oPPb09Op
	wknkg5ZOb4FFXCqtL1C8LSw8O5FBl0B2NIy3troRO2m00G/pX3G3ipSqYNI8ISwqdxe2E1pSFve
	XrvZrrkq8cbb6rlUP3wdYb8ruvT+StrTY9gKfQzuHT6aLkigdjr/h2mjioxz2tEDZNqkB9wR1SF
	DQOikfMLfwmVPT9f9LGLwCA8mWE7aJLrQCDMU=
X-Received: by 2002:a53:acd3:0:10b0:668:437b:5478 with SMTP id 956f58d0204a3-668a4c9845dmr1497655d50.41.1784889175070;
        Fri, 24 Jul 2026 03:32:55 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-66890547313sm534712d50.10.2026.07.24.03.32.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:32:55 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c860544c077so642944a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784889174; x=1785493974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TtZ7CUtOPujMWrugvWV6ht61yJ+DtAprRFs3gzJqxqI=;
        b=Y7nJAapkHi7iKJ1Xz8UB67Ao2W6YhXFUFZOv3FWwZQEnJOSoSXm93nOn0SKkZw6iA0
         rwrGT8Uvj/pZIv+mlcPw5sEUriVuW4oFIJzpNr26UIlrimsW3bTWpFdkmkCnTZtOL8My
         wBrCR7xhvUtfvWrvhr/qKyI6YQs+Ic2N+VEP4=
X-Received: by 2002:a05:6a21:a393:b0:3c3:7427:5ed8 with SMTP id adf61e73a8af0-3c44afb4fffmr7910583637.8.1784889173727;
        Fri, 24 Jul 2026 03:32:53 -0700 (PDT)
X-Received: by 2002:a05:6a21:a393:b0:3c3:7427:5ed8 with SMTP id adf61e73a8af0-3c44afb4fffmr7910534637.8.1784889173082;
        Fri, 24 Jul 2026 03:32:53 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm30233211eec.31.2026.07.24.03.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:32:52 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 07/10] mpi3mr: Fix firmware event reference leak during cleanup
Date: Fri, 24 Jul 2026 15:55:02 +0530
Message-ID: <20260724102505.115136-8-ranjan.kumar@broadcom.com>
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

During firmware event cleanup, when an event is currently executing or
pending at the SCSI mid-layer, the driver sets a discard flag and exits
the cleanup routine early. This early exit skips the normal cancel path,
resulting in the firmware event reference count not being decremented,
leading to a reference leak.

Further analysis of the firmware event handling revealed and fixed
additional concurrency issues:

1. TOCTOU Race: mpi3mr_cleanup_fwevt_list() read current_event
   locklessly, allowing the worker thread to free it concurrently.
   Fix this by safely acquiring the reference under fwevt_lock.

2. Use-After-Free: mpi3mr_dequeue_fwevt() dropped the event reference
   before returning it to the caller. Remove this drop and add a
   balancing put to the end of mpi3mr_cancel_work() so the caller
   retains the reference during cancellation.

3. Soft Lockup/Deadlock: mpi3mr_fwevt_bh() temporarily dropped
   fwevt_lock while moving an event from the list to current_event.
   This race window allowed driver unload (rmmod) to intervene and
   deadlock. Fix this by inlining the list deletion so the lock is
   held continuously.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=7
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=7
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 84 +++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 39624fae9131..545570d490fa 100644
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
@@ -379,16 +354,39 @@ static void mpi3mr_cancel_work(struct mpi3mr_fwevt *fwevt)
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
 		/*
 		 * Don't call cancel_work_sync() API for the
 		 * fwevt work if the controller reset is
@@ -399,6 +397,7 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
 		 */
 		if (current_work() == &fwevt->work || fwevt->pending_at_sml) {
 			fwevt->discard = 1;
+			mpi3mr_fwevt_put(fwevt);
 			return;
 		}
 
@@ -2129,9 +2128,19 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
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
@@ -2264,9 +2273,12 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
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
-- 
2.47.3

