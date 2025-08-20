Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86612D94BA
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 08:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755679663; cv=none; b=E7y2+9k2fprJmdJyxWuiT5R9n7hC7bP+m0zjQ+D0EF+bXETCf7vhr3wnWsGlUPCm2pnhOUfLotvd+g4SlnbQc715CJX4nVRy0BvNM3MmnMZXMDede9TYUh0wbVBk7DsN4bzZK3v7lfHgZeLpoQyo4z6UagRhegyxKhzNseo/tSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755679663; c=relaxed/simple;
	bh=1+y/YNT1GohaTiaydZPin3/P+vTl88MpKE1GrA3lX7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qm1BjlE9Pe+P3GHWYg3gL85PROT1FRTuwldTw6fw9BG/Ft3/aF2aExTIpxqUfDzjk6Kr7/GMGxdGiAf9caI19RFHLYK1p2eWtjYcKuCjy0zrvzSRWyOhXvs1/RLP9zCo4tFmeLacX+l5Zebxc6BrSlWHcmIAFUW90sN047S8C0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Uq7OqeeX; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Uq7OqeeX"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-76e2e89bebaso4595484b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755679661; x=1756284461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sVJn5sdsD9oK9TbPSPWwes61frSKyr49J6+e6eRr9Rk=;
        b=ZDTds1AXtMH3b9nvEI8EHFoGDWywH/qIRFmOFB2lJUlgKVQqFW+ynjyLFYsKUE7E5X
         S73ZJIEvpLzv/u88GpCpvmYLpGXtIUI8sTWw9WZROh57mXzgk2qTFvKDV+4RlEdRzp5X
         xJgzAu50dNJrYOoM2a0VDDrvT+p5fZFrB7ko0a1KuOAGB6VrIGN29Q3FTh/vXUDk+VSA
         2ubUYwHrFZuze9KQFJesmwMftuv0oqv7eYy/Jtg7Jq1MKRd2oC+xfKfAwjp3hKJNGa45
         yM1vKQOghOIGlP0TyJvLpKeFhkysxnWM35RcgbLOg+nkNI7EEssuFWVTZTjjUnmNr7Ag
         6vfw==
X-Gm-Message-State: AOJu0Yw7C7D/2BJkGWsmdAOqQpGz/vK/cgXUS74D0gtYUm+BkPLak/Ci
	ltTtA1aEMlxY4H3FV3MdV1kieHRSaKItXUM3QmVtewoYVrL7//7QEv0Wx39X0NZLw3T2jACWaQm
	unRsjQsDN5NR3DLTgYvHS52TDFiEySLtevFLSeAunWiVMvHzS/ncpohc+DTwjtKu2or7U7I/8eg
	9t4wbx0amoq3qv7sVdfOGHOx8iY7E7w+RES4eAWih4pnRrSMBs7sOyr3eryWO8pzrj8YVXs6VSp
	SZoNiCo0GkXBg4qRYwT6HEG
X-Gm-Gg: ASbGncvidonC/Sx0yMnplvLyioKmnqW4cNMiR44eaQpL0lj0byw6dZK+kkYuRH8PADo
	x0y7RcASQF1R3wl/IAZxI4L2ROJhZvKALZvd6nRujqd8PJgBKQrHhYYeeFO8slp2lEZcjiH5TMr
	zoSiXJUvk5Y9RnHYoi9i0VyQVcVFyVfDG7DY1HSWALLe406KhmKNS5zHvfEuGb0FlybNqhKhANI
	f84m75uKr/iLwKaFNc7lVOu7VvpfpccAXon0OJ2vEpeFyzhFRWgKK5RN562R1XlO7AFxuPjHJii
	0cMOUVZh3Cxv3pqIQiZmOMP+ymYTohjrvQu0f4pHnWW7UHulv3AzKSzUT/7L6+hmfanM9/3JKuY
	5KilXq/oOAHYXlQBpJWlbqK0ZhQ/P+14=
X-Google-Smtp-Source: AGHT+IHCO6D8oulf+ql4VBPfabK5xqar4qymBOOO70fUJrmurZKHAe5MODUV5eXG6/vp2REO1iYXRsQrzFwB
X-Received: by 2002:a17:902:ec8c:b0:245:f7b9:3895 with SMTP id d9443c01a7336-245f7b93a8fmr2503795ad.12.1755679660820;
        Wed, 20 Aug 2025 01:47:40 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-245ed32cf65sm1768095ad.7.2025.08.20.01.47.40
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Aug 2025 01:47:40 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-32326779c67so5996189a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1755679658; x=1756284458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVJn5sdsD9oK9TbPSPWwes61frSKyr49J6+e6eRr9Rk=;
        b=Uq7OqeeXJnQE1UrCgj3FjyX7g4LGAsjHFfMJc0pNjKnIR9MFh75dLel5b0SOyU7qR9
         ABJSZJU5RJbotc02MrwXS2SDrg3XTZyY3+A4P6pfxvPvucFr9nlhQnqXIPbMsJh6dIEL
         9oM13lTkyBg9SLHXr/UIce+LFgOhkhFUMPrK0=
X-Received: by 2002:a17:90a:e7cf:b0:321:c81b:29cd with SMTP id 98e67ed59e1d1-324e12e819dmr2554887a91.1.1755679658513;
        Wed, 20 Aug 2025 01:47:38 -0700 (PDT)
X-Received: by 2002:a17:90a:e7cf:b0:321:c81b:29cd with SMTP id 98e67ed59e1d1-324e12e819dmr2554863a91.1.1755679657867;
        Wed, 20 Aug 2025 01:47:37 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e2643bafsm1604034a91.23.2025.08.20.01.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 01:47:37 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 3/6] mpi3mr: Fix I/O failures during controller reset
Date: Wed, 20 Aug 2025 14:11:35 +0530
Message-Id: <20250820084138.228471-4-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
References: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

I/Os can race with controller reset and fail.

Block requests at the mid layer when reset starts using
scsi_host_block(), and resume with scsi_host_unblock() after reset
completes.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 124a0aa0ed9e..8fe6e0bf342e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -5430,6 +5430,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	    mpi3mr_reset_rc_name(reset_reason));
 
 	mrioc->device_refresh_on = 0;
+	scsi_block_requests(mrioc->shost);
 	mrioc->reset_in_progress = 1;
 	mrioc->stop_bsgs = 1;
 	mrioc->prev_reset_result = -1;
@@ -5538,6 +5539,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	if (!retval) {
 		mrioc->diagsave_timeout = 0;
 		mrioc->reset_in_progress = 0;
+		scsi_unblock_requests(mrioc->shost);
 		mrioc->pel_abort_requested = 0;
 		if (mrioc->pel_enabled) {
 			mrioc->pel_cmds.retry_count = 0;
@@ -5562,6 +5564,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		mrioc->device_refresh_on = 0;
 		mrioc->unrecoverable = 1;
 		mrioc->reset_in_progress = 0;
+		scsi_unblock_requests(mrioc->shost);
 		mrioc->stop_bsgs = 0;
 		retval = -1;
 		mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 1582cdbc6630..5516ac62a506 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2866,12 +2866,14 @@ static void mpi3mr_preparereset_evt_th(struct mpi3mr_ioc *mrioc,
 		    "prepare for reset event top half with rc=start\n");
 		if (mrioc->prepare_for_reset)
 			return;
+		scsi_block_requests(mrioc->shost);
 		mrioc->prepare_for_reset = 1;
 		mrioc->prepare_for_reset_timeout_counter = 0;
 	} else if (evtdata->reason_code == MPI3_EVENT_PREPARE_RESET_RC_ABORT) {
 		dprint_event_th(mrioc,
 		    "prepare for reset top half with rc=abort\n");
 		mrioc->prepare_for_reset = 0;
+		scsi_unblock_requests(mrioc->shost);
 		mrioc->prepare_for_reset_timeout_counter = 0;
 	}
 	if ((event_reply->msg_flags & MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_MASK)
-- 
2.43.5

