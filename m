Received: from mail-il1-f227.google.com (mail-il1-f227.google.com [209.85.166.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4603E1EBA0D
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 08:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755679649; cv=none; b=fHSsQBgUci5KEx4ww0ZBgJotDpgxzKgtS3LhCbovODko3adB71ISpJf8qMX4+gHMvJakF8j30lP4y8crik8del4+GKLcoYkettADqDn8TspEkIw0bT6TruHEKTauxMzj2j4Pw8VtOhfpk89ot72ZtXP0RGtqRmPvKE5KZ+4RmSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755679649; c=relaxed/simple;
	bh=evrgWFQHTqUjHUipcSDGMidTr4uWVIns4a2kbqZrxVA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iBCLO3U+3ip/JD4ihqdgCQrEpiRiH4f/CioBOZ/ePZUxpbBR3ska+KCpNCFOlOp6UXo4oAwch0xw6ImFFcyECpbTExX35gM4wDeeAsjUVctVyGbVrn7pMbKoqWED8ublVU68+aigPEOxMZPbntWfEveOzYZjhzQ2G3JooAViHZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=athPiiJG; arc=none smtp.client-ip=209.85.166.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="athPiiJG"
Received: by mail-il1-f227.google.com with SMTP id e9e14a558f8ab-3e570045e05so53505465ab.2
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755679647; x=1756284447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sSeb7Z5Var7LnP6jF5ldv6kzbEeqeahVSNtorw9zTxU=;
        b=tKSeycGwzhtvpYPL1N6dfsPh0wE+3XN1AjiU5Hi8eOETAe2GZkWbiVLKpaCklWDerJ
         hJCg2muR+t64hEaqyQNRLlnRfQqy94nKKoDBwnQUE0q7liDFw7CPMrUwZlFHcs0w1WIC
         VpwCoiPiYFG+aFFskDsOt7SN/IotM5Jsptg2FU5vpWkrGuwQnTCrDq2VVmoz4o9dUcHA
         g6vwNHH6liqhQk/hBkUKgG9vAfPjtodwhKD3EMrGFkOPEAkCPy/kGfeH7CQpMgTn1siG
         Rm/bDYGBmM1pJo5+MJow6S8I7lMiKiasntcPnU1YpU6VqStaeXmZzLgpZOJ/dPf+US6o
         G8gA==
X-Gm-Message-State: AOJu0Yw/cggUSSyZG3a+lC0/pKArRGkvMxuVm0qyIxMwsN3hVW78LGI/
	8ZZcCzE/yQ/M8rEFTGM2IcXrS2RXX82ygIiAYFLaIdJ/G62TTTuD2NRFgI+wVAZXldjKPsy8zcL
	vrRm6utg2oiBvBJ39cQzlhdZpZansdcBAZnkX9vJ3FO5b3pT7URNQxx58E2U5/FIUK5559XCAa8
	3na8mi16Ieb1RzbbnH92d8PuYXYRSDq5QL50WLQgxFanlpBdJffJaNYtGG6Iay4bEcjG8FagYLv
	FrAXWuMSMNOeU6gaf+xTYj6
X-Gm-Gg: ASbGnctR/aKU6I17LAERSjLijwNWNo+ExRWWrdandPcczSgdUMDb7B/WZzbq41gVoar
	/fQEZYtZ/xx42pXV5W/85UNUjZuLuyTgXHxUTyNV3bamQuxO8lUt/AwMzx9TJStNqiN4UQNQ54y
	orMOAX4lc+IdqLE7G8DAuQpFpW3A+BhllD8lYln8yF9VAHEt8ooncZWFN6FUnkmdxhGUiHo/5Xw
	r129U+KcxoyuKuIUdpprTaaVLHI1HjQYQN9Fvp/QNFIJOsZ7st+9y1vnaLxRMunZT5bTzK7xiOb
	hya5C6OdybOVyBBAmTzptWT5gNDMvDaPM6hbFmIrBZtbCgcJNC2EtUYd18klo7ZcYF7DWxADnXe
	Grh0fg57E6Ykc6lh6q4ajo2r5/u1LQmYnRPtA2vJ16qwKg6Uzgm6JLVrPI7TVC6bPUt/O50Y8PT
	6+aW3rrdKszA==
X-Google-Smtp-Source: AGHT+IFG/kBZqwMaFnJISFjFxD6JDDJv7CjQ5DOBPyQVlYabJsnsH2z9BiHhLCmFF/VnFKblN0kGHrAxICh9
X-Received: by 2002:a05:6e02:2591:b0:3e6:7c38:f4d6 with SMTP id e9e14a558f8ab-3e67ca22dcdmr39843675ab.14.1755679647337;
        Wed, 20 Aug 2025 01:47:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3e57e775d2bsm9879255ab.49.2025.08.20.01.47.26
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Aug 2025 01:47:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-32326779c67so5996064a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1755679645; x=1756284445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sSeb7Z5Var7LnP6jF5ldv6kzbEeqeahVSNtorw9zTxU=;
        b=athPiiJGA6+RNDA53os7y+fcU54dyrNmETXKgBqYAC5lSaA0WTc9PYmKM83fjDzDuM
         u05VjE7rv3JPccX3/sZSY/U4QSUGnOn1b8VkaDmwvjOM51fguV4WTaN2V6Jz8pzN7EFp
         vdPwjMKNEUEpeVzY4RJrrHtAL6MKiyzmyCpNs=
X-Received: by 2002:a17:90b:5284:b0:324:e298:3eba with SMTP id 98e67ed59e1d1-324e29842b5mr2255038a91.7.1755679645289;
        Wed, 20 Aug 2025 01:47:25 -0700 (PDT)
X-Received: by 2002:a17:90b:5284:b0:324:e298:3eba with SMTP id 98e67ed59e1d1-324e29842b5mr2255005a91.7.1755679644685;
        Wed, 20 Aug 2025 01:47:24 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e2643bafsm1604034a91.23.2025.08.20.01.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 01:47:24 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 1/6] mpi3mr: Fix device loss during enclosure reboot due to zero link speed
Date: Wed, 20 Aug 2025 14:11:33 +0530
Message-Id: <20250820084138.228471-2-chandrakanth.patil@broadcom.com>
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

During enclosure reboot or expander reset, firmware may report a link
speed of 0 in "Device Add" events while the link is still coming up.
The driver drops such devices, leaving them missing even after the link
recovers.

Fix this by treating link speed 0 as 1.5 Gbps during device addition so
the device is exposed to the OS. The actual link speed will be updated
later when link-up events arrive.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  8 ++++----
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 11 +++++++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e467b56949e9..1582cdbc6630 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2049,8 +2049,8 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	if (!fwevt->process_evt)
 		goto evt_ack;
 
-	dprint_event_bh(mrioc, "processing event(0x%02x) in the bottom half handler\n",
-	    fwevt->event_id);
+	dprint_event_bh(mrioc, "processing event(0x%02x) -(0x%08x) in the bottom half handler\n",
+			fwevt->event_id, fwevt->evt_ctx);
 
 	switch (fwevt->event_id) {
 	case MPI3_EVENT_DEVICE_ADDED:
@@ -3076,8 +3076,8 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	}
 	if (process_evt_bh || ack_req) {
 		dprint_event_th(mrioc,
-			"scheduling bottom half handler for event(0x%02x),ack_required=%d\n",
-			evt_type, ack_req);
+		    "scheduling bottom half handler for event(0x%02x) - (0x%08x), ack_required=%d\n",
+		    evt_type, le32_to_cpu(event_reply->event_context), ack_req);
 		sz = event_reply->event_data_length * 4;
 		fwevt = mpi3mr_alloc_fwevt(sz);
 		if (!fwevt) {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index c8d6ced5640e..d70f002d6487 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -413,9 +413,11 @@ static void mpi3mr_remove_device_by_sas_address(struct mpi3mr_ioc *mrioc,
 			 sas_address, hba_port);
 	if (tgtdev) {
 		if (!list_empty(&tgtdev->list)) {
-			list_del_init(&tgtdev->list);
 			was_on_tgtdev_list = 1;
-			mpi3mr_tgtdev_put(tgtdev);
+			if (tgtdev->state == MPI3MR_DEV_REMOVE_HS_STARTED) {
+				list_del_init(&tgtdev->list);
+				mpi3mr_tgtdev_put(tgtdev);
+			}
 		}
 	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
@@ -2079,6 +2081,8 @@ int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
 				link_rate = (expander_pg1.negotiated_link_rate &
 				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
 				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
+				if (link_rate < MPI3_SAS_NEG_LINK_RATE_1_5)
+					link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
 				mpi3mr_update_links(mrioc, sas_address_parent,
 				    handle, i, link_rate, hba_port);
 			}
@@ -2388,6 +2392,9 @@ int mpi3mr_report_tgtdev_to_sas_transport(struct mpi3mr_ioc *mrioc,
 
 	link_rate = mpi3mr_get_sas_negotiated_logical_linkrate(mrioc, tgtdev);
 
+	if (link_rate < MPI3_SAS_NEG_LINK_RATE_1_5)
+		link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
+
 	mpi3mr_update_links(mrioc, sas_address_parent, tgtdev->dev_handle,
 	    parent_phy_number, link_rate, hba_port);
 
-- 
2.43.5

