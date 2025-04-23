Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0866D221544
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 09:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745400395; cv=none; b=i6If93+WAlOV0Qk5ne7x9ecNKKFLTF2y1OKdL16W+7yBVCfB0A+KXhpFTj/S38iaQt8DQBriDLMUaLAujralAGl3sXzbq1XsB9HZnF0fIoIxiGBTejEG6MB0T0d92+sq9t1JU0pVOAL5i8e5n37twNERhcknSb86aM2AwKj9lio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745400395; c=relaxed/simple;
	bh=Zt85IUojNv29QXX6TBNPBOibxwAfhcBZueNz1bTkvv8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Hh6W2jIopW7QLouV2T2BVNUgKvxw60K5Z+2SxHKFSdoZJn6RxUGYACcsXOep/f03JSnLObLR6q2wJeZiktPOafUIqnkSGWMORuROSsHeZGwlG+F4USgtuY+COQFCrJyQTnsA/eo+pMGlPp/tlPknQS+wXOzX8ZMgrVYWkaExSw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=RUQNm9U/; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RUQNm9U/"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-736a72220edso6307769b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 02:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745400392; x=1746005192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RYCjDMpy7r6NsAezWYp5ZKkj4cLt+F9Y8BHsyfKapiw=;
        b=RUQNm9U/LZEKyQ2gsZ60BlRgYI0AciqOVFLG6okucp0UPOVmSuH70TLhf0GTnc5MZ9
         31AU2csosp4SAMXyvjOMG5cvgv40/CESc2IIofUS49gu6xUbPBQXhNYhbpeOr1zVPAsz
         da5fp5XkxvyKHjCv/mknLt6qGJpIgUOo+/fPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745400392; x=1746005192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RYCjDMpy7r6NsAezWYp5ZKkj4cLt+F9Y8BHsyfKapiw=;
        b=JbwgU+Vt5CaA37A8OZM1hbviWJePx19MWG6ps0jCjlUhd7/bY6RfBhAZwslOeo6tsm
         8mUtZNNpMAqe7T6nZnm0+a78JhtJCA4cqzkNSgZ6ILZwp8IJyOf2pa2OY29UP09S08rF
         kt+afxfAYcxsoQ4nhGuxA4abYsjyC8+yvWThxXD6q0netFKfJccPTTnCdMbX5nQ/MTVl
         8d6Mnwl7h5d3NRbvtTPEXDXquiHUoGIhu/yRKT3yOoapvcqQmQfufsqik24qm8WrSLTP
         PR+I7xFAblu8ioYboVDmO6z7XKoLB0du1MWvGLmBcXe46oJNZ/bVd0hGVC+jys11mkZs
         8+6g==
X-Gm-Message-State: AOJu0Ywp8cZ0SXtVB0RXSepzRLqMjvzX02uMKgV/sTZb4hSiRwkMiZvQ
	TmGdIVTRGG8bSOIneqyFPFrpo6BsKyUsPSMgCP8XUoNB2R98WTEU8JB8IEy9J5XVV2KZ+ViC1SC
	39R2PBF97CGFOwkzfbqBR972IqsiJL611Z3yp7VnaKx9VZOhlWo9JIXgfM14NLT2ZnrkQiMQlli
	uQQtxjVuvY+VF1U44a1ehVGyXgmBL9hU8McAo5grsi+W6W2Q==
X-Gm-Gg: ASbGncvtBF4k0Tt//wW8lxSnpILmjdogKp5iOwWjnmm9bON6AnPOI8cyufQp87zLAI2
	PNLtagOoDhN6zu+slD8BZXlwBqXCmCN/+3YjwWdEvna6KuBMU9cmZryUZTY+A2415eFGNkhg8pc
	RbUQTYjW3Jl8i8s/8HfS6gIlBlGEZ1lMGh5LpETxNUEC1iz0emHl1x5+OAzEeReeiCN6JFjjx4U
	ufSwmmxfZTA3vE87IsH3zBpVkN7or/FJggoeslkeVVc5hHN2KR0Y1TkpoIyrDdZtGpULsI0VNtE
	vDKCmiwjfJxur7T/+B2y+R9KneedVdcVkEHNT4rW9H5TNoe+3GHCOORAr0/4mRwJ2/BHcMrpf/M
	G9lqLtijo
X-Google-Smtp-Source: AGHT+IG9+FiD7HiywLkTj7yf4CXhmMI4ay9ZK7HeKsol2zEBDuxyn72I1TOPpLfUaaRAUqYX2Q49JQ==
X-Received: by 2002:a05:6a21:9987:b0:1ee:efa5:6573 with SMTP id adf61e73a8af0-203cbbee8a9mr28597896637.8.1745400392282;
        Wed, 23 Apr 2025 02:26:32 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b0db127447bsm8680559a12.2.2025.04.23.02.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 02:26:31 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1] mpi3mr: Event processing debug improvement
Date: Wed, 23 Apr 2025 14:51:39 +0530
Message-Id: <20250423092139.110206-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Improvising event process debugging.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 67 ++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index c186b892150f..1c139cca9099 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -985,6 +985,10 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 				goto out;
 			}
 		}
+		dprint_event_bh(mrioc,
+		    "exposed target device with handle(0x%04x), perst_id(%d)\n",
+		    tgtdev->dev_handle, perst_id);
+		goto out;
 	} else
 		mpi3mr_report_tgtdev_to_sas_transport(mrioc, tgtdev);
 out:
@@ -1344,9 +1348,9 @@ static void mpi3mr_devstatuschg_evt_bh(struct mpi3mr_ioc *mrioc,
 	    (struct mpi3_event_data_device_status_change *)fwevt->event_data;
 
 	dev_handle = le16_to_cpu(evtdata->dev_handle);
-	ioc_info(mrioc,
-	    "%s :device status change: handle(0x%04x): reason code(0x%x)\n",
-	    __func__, dev_handle, evtdata->reason_code);
+	dprint_event_bh(mrioc,
+	    "processing device status change event bottom half for handle(0x%04x), rc(0x%02x)\n",
+	    dev_handle, evtdata->reason_code);
 	switch (evtdata->reason_code) {
 	case MPI3_EVENT_DEV_STAT_RC_HIDDEN:
 		delete = 1;
@@ -1365,8 +1369,13 @@ static void mpi3mr_devstatuschg_evt_bh(struct mpi3mr_ioc *mrioc,
 	}
 
 	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
-	if (!tgtdev)
+	if (!tgtdev) {
+		dprint_event_bh(mrioc,
+		    "processing device status change event bottom half,\n"
+		    "cannot identify target device for handle(0x%04x), rc(0x%02x)\n",
+		    dev_handle, evtdata->reason_code);
 		goto out;
+	}
 	if (uhide) {
 		tgtdev->is_hidden = 0;
 		if (!tgtdev->host_exposed)
@@ -1406,12 +1415,17 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 
 	perst_id = le16_to_cpu(dev_pg0->persistent_id);
 	dev_handle = le16_to_cpu(dev_pg0->dev_handle);
-	ioc_info(mrioc,
-	    "%s :Device info change: handle(0x%04x): persist_id(0x%x)\n",
-	    __func__, dev_handle, perst_id);
+	dprint_event_bh(mrioc,
+	    "processing device info change event bottom half for handle(0x%04x), perst_id(%d)\n",
+	    dev_handle, perst_id);
 	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
-	if (!tgtdev)
+	if (!tgtdev) {
+		dprint_event_bh(mrioc,
+		    "cannot identify target device for  device info\n"
+		    "change event handle(0x%04x), perst_id(%d)\n",
+		    dev_handle, perst_id);
 		goto out;
+	}
 	mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0, false);
 	if (!tgtdev->is_hidden && !tgtdev->host_exposed)
 		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
@@ -2012,8 +2026,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
 	mrioc->current_event = fwevt;
 
-	if (mrioc->stop_drv_processing)
+	if (mrioc->stop_drv_processing) {
+		dprint_event_bh(mrioc, "ignoring event(0x%02x) in the bottom half handler\n"
+				"due to stop_drv_processing\n", fwevt->event_id);
 		goto out;
+	}
 
 	if (mrioc->unrecoverable) {
 		dprint_event_bh(mrioc,
@@ -2025,6 +2042,9 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	if (!fwevt->process_evt)
 		goto evt_ack;
 
+	dprint_event_bh(mrioc, "processing event(0x%02x) in the bottom half handler\n",
+	    fwevt->event_id);
+
 	switch (fwevt->event_id) {
 	case MPI3_EVENT_DEVICE_ADDED:
 	{
@@ -2763,6 +2783,9 @@ static void mpi3mr_devstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
 		goto out;
 
 	dev_handle = le16_to_cpu(evtdata->dev_handle);
+	dprint_event_th(mrioc,
+	    "device status change event top half with rc(0x%02x) for handle(0x%04x)\n",
+	    evtdata->reason_code, dev_handle);
 
 	switch (evtdata->reason_code) {
 	case MPI3_EVENT_DEV_STAT_RC_INT_DEVICE_RESET_STRT:
@@ -2786,8 +2809,12 @@ static void mpi3mr_devstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
 	}
 
 	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
-	if (!tgtdev)
+	if (!tgtdev) {
+		dprint_event_th(mrioc,
+		    "processing device status change event could not identify device for handle(0x%04x)\n",
+		    dev_handle);
 		goto out;
+	}
 	if (hide)
 		tgtdev->is_hidden = hide;
 	if (tgtdev->starget && tgtdev->starget->hostdata) {
@@ -2863,13 +2890,13 @@ static void mpi3mr_energypackchg_evt_th(struct mpi3mr_ioc *mrioc,
 	u16 shutdown_timeout = le16_to_cpu(evtdata->shutdown_timeout);
 
 	if (shutdown_timeout <= 0) {
-		ioc_warn(mrioc,
+		dprint_event_th(mrioc,
 		    "%s :Invalid Shutdown Timeout received = %d\n",
 		    __func__, shutdown_timeout);
 		return;
 	}
 
-	ioc_info(mrioc,
+	dprint_event_th(mrioc,
 	    "%s :Previous Shutdown Timeout Value = %d New Shutdown Timeout Value = %d\n",
 	    __func__, mrioc->facts.shutdown_timeout, shutdown_timeout);
 	mrioc->facts.shutdown_timeout = shutdown_timeout;
@@ -2974,9 +3001,11 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		struct mpi3_device_page0 *dev_pg0 =
 		    (struct mpi3_device_page0 *)event_reply->event_data;
 		if (mpi3mr_create_tgtdev(mrioc, dev_pg0))
-			ioc_err(mrioc,
-			    "%s :Failed to add device in the device add event\n",
-			    __func__);
+			dprint_event_th(mrioc,
+				"failed to process device added event for handle(0x%04x),\n"
+				"perst_id(%d) in the event top half handler\n",
+				le16_to_cpu(dev_pg0->dev_handle),
+				le16_to_cpu(dev_pg0->persistent_id));
 		else
 			process_evt_bh = 1;
 		break;
@@ -3039,11 +3068,15 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		break;
 	}
 	if (process_evt_bh || ack_req) {
+		dprint_event_th(mrioc,
+			"scheduling bottom half handler for event(0x%02x),ack_required=%d\n",
+			evt_type, ack_req);
 		sz = event_reply->event_data_length * 4;
 		fwevt = mpi3mr_alloc_fwevt(sz);
 		if (!fwevt) {
-			ioc_info(mrioc, "%s :failure at %s:%d/%s()!\n",
-			    __func__, __FILE__, __LINE__, __func__);
+			dprint_event_th(mrioc,
+				"failed to schedule bottom half handler for\n"
+				"event(0x%02x), ack_required=%d\n", evt_type, ack_req);
 			return;
 		}
 
-- 
2.31.1

