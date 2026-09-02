Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9022D59E8
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 08:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788337390; cv=none; b=m8QMEanWW8cij4q/Gj216zoNBbyWOLguTMfduoBMAHGOVn8aKHedmVHEVLauB2X0sFM777nmcNU+xlTO2nZ2pi0euUw239yhfzZz0cLHJwQHkyvBgtxtnEg0h9OsqwsN1YEHWOGgR0HtH+IPghzf8oWIjJTXcjIiQu85ICe+wXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788337390; c=relaxed/simple;
	bh=WUIcuXJOyZqQYohNaEb9UxJ2CFI101HXjzuhC6i6Eb8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=a4F8phMzguxxXIYNAS/AL+O5HmrHqR2uAOrp/LXW1XcphR3Pm6sd+/+wX61eG0QDafSWsLOHZ6DNTt5jOL6VF8VhFQROi33QW0CVoYXYV2ML8FxvMBbtAgdyXKmTacfv2UCnTyUr1Ek7YQfZfqaImvVBVyOUR+895HhIkXuVOAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AExVUAv3; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AExVUAv3"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso1122323a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2026 01:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788337388; x=1788942188; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=swx5YF9h3/1MSn74lsdt/yXKjqG7gMOFtYAKP5a23y8=;
        b=AExVUAv3W+4xSetJ6cek8KCo1wKUXy0aL/lg5rCP2BRIJbTmgeSSKORHuQya9rQrAK
         UVD7LUaxjYryrbX9f+tGuO3EXLdTF0bkx0jwDtPZ8SzpGP2xe2e5kxtYjxpHGxf9COvv
         H1+9BbD0yPQ4lq6T+RVImRUYQFJmm6QtyjVrOg94erT+xa9lytGZuDL4wzuCf5/YfbXI
         PC2KWp0pZeV6NwtBXJVlGBh9BOXZVkVG4DKqMTJG7/BmUj+ZVjp0PbTC3M8Ger+bVkMq
         O8T8BXB/7rpukomrhsbwB4LGyp2xfyMVYaRbuIBiPVkulcAYLXWudxx74oqBiWnQwE07
         z5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788337388; x=1788942188;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=swx5YF9h3/1MSn74lsdt/yXKjqG7gMOFtYAKP5a23y8=;
        b=pDhg2pLvC6rulk2yKUy5tP7RMx6U+yoswwZx9G5LwvuNMu251u4Dln4cyS/9+/R9oZ
         HVYz1Y++kFtlnf349jipaUPlfF3P61aesFWEziZMHB0kJw49eF3fFKJPo/SpFxmXqmBS
         GBtNnD3k/ZVU3inqs4fAC81XN5FPIdL66nNIpv29AT/ZQ3usLNp32Z14c5+AXUPpTgGw
         OOPRCLc7Kb0rmOrPiAING+4q/PgIle2ipu5nKC3nfYantWj7oCgFJY30H3UrQzIee5cw
         BO1DGJRcONHkwYqJrGs0N/rXNsnw+faTyhkefiLsWdkxH8T2qd/I7BNirZJlnH4ciKBG
         +/cw==
X-Gm-Message-State: AFuF++mZ077r7/yR8LiZgpW16+ibnGhSC8IbkFccj0oAxIg/eqslj1n3
	uzjH2Juw5PwymGX63PtIWNXn/unWPirQu/DIfBeWnDkxs8uJW7DJI8t1TeGrFhRpCyBDUen0qIc
	slIEoeE7RI9ukwk/5gCBGn4cT4xD2GzP7WZVKiXxbcxyi0O2NiIBHyV5ocOGChIZT0/I0cxC025
	7Ce2WC++KE7Sr4ZgLW7o4UnUIy73ew0U3yMoKwrjHEd76x4BBmrwpeeUbq2E12jG0=
X-Received: from pjlj3.prod.google.com ([2002:a17:90a:7e83:b0:398:c3cf:ab9f])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4fcb:b0:395:f0e8:9e13 with SMTP id 98e67ed59e1d1-39aedf22274mr5088393a91.7.1788337388162;
 Wed, 02 Sep 2026 01:23:08 -0700 (PDT)
Date: Wed,  2 Sep 2026 16:23:06 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902082306.2299159-1-stanleyjhu@google.com>
Subject: [PATCH] scsi: ufs: core: Quiesce SCSI devices instead of host tagset
 during error handling
From: Stanley Jhu <stanleyjhu@google.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Stanley Jhu <stanleyjhu@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Commit 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
switched UFS internal commands to allocate requests on
hba->host->pseudo_sdev->request_queue, which shares the host tagset with
regular LUNs.

During error recovery, ufshcd_err_handling_prepare() calls
blk_mq_quiesce_tagset(&hba->host->tag_set), marking all queues in the
tagset as quiesced, including pseudo_sdev->request_queue. When
ufshcd_verify_dev_init() subsequently issues internal commands (e.g. NOP
OUT UPIU) via blk_execute_rq(), blk_mq_run_hw_queue() skips running the
quiesced queue, resulting in an unrecoverable circular wait deadlock.

Resolve this by quiescing only logical units attached to the host via
shost_for_each_device() during error handling. Because
shost_for_each_device() explicitly skips pseudo SCSI devices (via
scsi_device_is_pseudo_dev() in __scsi_iterate_devices()), regular LUNs
are quiesced to prevent retry storms, while pseudo_sdev remains
unquiesced so internal commands can be dispatched and completed during
error recovery.

Clock scaling and command pause (ufshcd_pause_command_processing) paths
continue to use blk_mq_quiesce_tagset() as they require freezing all
queues including internal commands.

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/alpine.DEB.2.22.394.2609010729350.218556@hyperv.ins.bvanassche.us/
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..11488c5efb47 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6798,6 +6798,23 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
 	}
 }
 
+static void ufshcd_quiesce_all_sdevs(struct ufs_hba *hba)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_quiesce_queue_nowait(sdev->request_queue);
+	blk_mq_wait_quiesce_done(&hba->host->tag_set);
+}
+
+static void ufshcd_unquiesce_all_sdevs(struct ufs_hba *hba)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unquiesce_queue(sdev->request_queue);
+}
+
 static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
 	/*
@@ -6833,7 +6850,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		ufshcd_clk_scaling_allow(hba, false);
 	}
 	/* Wait for ongoing ufshcd_queuecommand() calls to finish. */
-	blk_mq_quiesce_tagset(&hba->host->tag_set);
+	ufshcd_quiesce_all_sdevs(hba);
 	cancel_work_sync(&hba->eeh_work);
 }
 
@@ -6840,7 +6857,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
-	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	ufshcd_unquiesce_all_sdevs(hba);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
-- 
2.43.0
