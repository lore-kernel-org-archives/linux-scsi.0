Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D9B1990B7
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 08:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755679674; cv=none; b=VmHsEiOkiPz7cL0A2ZclJHXC5jKF0yhN1NU80RtuCOw2x9ivJYyWzhFe7a4jruQyguaVHUoPe7K97cfE0Cuhk1RT/kzhS8ebtM/3oHU0Ks4qKtQTgxtQiDNdhQeBwW01kEYswhIa3Af3UjiJYX2GRRlgRFplOSWLP7cPHho+1tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755679674; c=relaxed/simple;
	bh=W9hD1VSAZOQKhGBDm5O0C3zbcXoC3atqIxUI0bZz4v4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mDiVfk2tJ4uy1PzvAk1gMvP3Kzo1xuvLRfQrAjKr3fhkVPfIJ04jPsphZWKVmhACTQPHxMnt8CYObof3U/ienBSuyT3zGPEBJRW/WC5RFBgSYOQ4iSWIhfKnl0BSwIKr7LCpd2OPo4BH0ZkmMeO/J5f8n6WZT5r/VhjWkwZ0hqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=U53M1iq5; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="U53M1iq5"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-24457fe9704so48033205ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755679673; x=1756284473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cH5AIvQaAYpSjBR1I0JCbMmXc8KRAHvmGTfdccBmkfI=;
        b=CCwJrt9+oBjlLJVarZyD0Zkdev4wlpvlfcxnz4r/tgx7DACkATkZlGsa3czAWUS2uM
         onHXy4GGtqJEhmL1zN6+ifkP+2U5e8GAc2RIM8dri+elxgf2je0aEcLSGyXeX4OcyheU
         6nj4CnvBkYFktMig7WAT98W3/nlqbwFNSAdSX7RUPs9QYUgjA2a2FGQZfDhuJJw2CnZj
         qxP2PnY5SYBQuof/wkJnk15Q14P5tG+mPDb/0NV2tu+B6AFUGwp+BYtlvlJuIoPhx9n2
         tWl0Yec9K1AOHj62yNh9phW35PKA/cLbAWrdCR1bRxLk43tp+cxcuyh3Ihe5CUmeoC3C
         OAvA==
X-Gm-Message-State: AOJu0YwP4oAFklqwMetQz/zA+lXPKiQN1vVgMrpcWI/F0TFYy4xoMZJI
	rIFQ3bUTM5PGlkYjvd55n7OYWCT6ytrB95CT1MLUnqvY+coAbv4fk6c2t4mp3lhuxeexvYti3ii
	6NSbG8Q6MhgzF6GUawA8OUMSZQY4d3DxGwKWpXPTNXuTcY46LQcKvA4qPvcXT1sn64o1lc+SUwX
	wMdY0cm8lH5iizrAYkT+u7vr3l7PRCJXThSnMqqE6860SKRbVHbkgjnLPQ94JxBUkxtySBhf9MP
	IBXZE4NI1uZjlRsWuOxD2R1
X-Gm-Gg: ASbGncuHsRfW1uRNDAglLu2RgEQ4uqneMuygy7tDXa9OjDQiwHNyvWbuhQ45ibPqaJH
	A/RAI5DTafcmpdqSEiMv820/fY6UsD+gRKz2apfe88/dj59ot7lah4ocDThnGL90jnEE6cFBtWb
	UeV2M3Qan8v9ysQq5RGzvHSndkkfBoVb4+VSxdGHGXv4MGb3p/UrRj1+2t8UrEl1H92YIR9PjXZ
	agWwGe4PF5usvpdF3qfjJlTWiLSmo7kbm/sr3/+xDqEX7MmgiEHoFUFTQKFHvdyV+z62GRHpYzx
	QRF5uyl96qMGEyo7H+rJIKktcdY1eNZuc0au7tkUf9H7RJSGaIJq55B6dS6LeOJu58MC66lW4Zg
	u14HBfnC6DwqN0wuSrAAjG2POuneZxl+5kdzXAVdt0wlI/BmZWFgH4KniIPNHkCQVtoKfx6au0U
	q+bJyv
X-Google-Smtp-Source: AGHT+IGnFAgBVrUSfC+xIP0b8i6hGBoUhN4/3Fp46fdpwSE/SSJMKcElq+MLHogWuVbvSidda3uWVW2PQf0H
X-Received: by 2002:a17:902:e888:b0:242:ffca:acd6 with SMTP id d9443c01a7336-245ef20cab1mr24752215ad.35.1755679672575;
        Wed, 20 Aug 2025 01:47:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-6.dlp.protect.broadcom.com. [144.49.247.6])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-245ed4b1db0sm1855125ad.79.2025.08.20.01.47.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Aug 2025 01:47:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-323267c0292so5953607a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1755679670; x=1756284470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cH5AIvQaAYpSjBR1I0JCbMmXc8KRAHvmGTfdccBmkfI=;
        b=U53M1iq5zFOoaalmCI+vKj6WiYoi0gtD9BPaNzhWw201TObZGWUIKb15KiJWw+zOH+
         GpMQ+nHWxJmc0U1S4I5jIVybDxbf2wk7tdm0eCUatyMOwcldE+5sooueuW1dMkQRxvAA
         aWKhSWXOtABGFO5jt0zNqpf72XdRLidJy+cf8=
X-Received: by 2002:a17:90b:35c8:b0:312:f0d0:bc4 with SMTP id 98e67ed59e1d1-324e12e5009mr2909944a91.5.1755679670274;
        Wed, 20 Aug 2025 01:47:50 -0700 (PDT)
X-Received: by 2002:a17:90b:35c8:b0:312:f0d0:bc4 with SMTP id 98e67ed59e1d1-324e12e5009mr2909919a91.5.1755679669643;
        Wed, 20 Aug 2025 01:47:49 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e2643bafsm1604034a91.23.2025.08.20.01.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 01:47:49 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 5/6] mpi3mr: Fix premature TM timeouts on virtual drives
Date: Wed, 20 Aug 2025 14:11:37 +0530
Message-Id: <20250820084138.228471-6-chandrakanth.patil@broadcom.com>
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

Task Management to virtual drives may timeout prematurely when using a
static default timeout.

Read Abort and Reset timeouts from Device Page 0 and apply the maximum
of the firmware value and the default.

This fixes premature TM failures on virtual drives.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  4 ++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 18 +++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8d4ef49e04d1..6024b5b760c5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -697,6 +697,8 @@ struct tgt_dev_vd {
 	u16 tg_id;
 	u32 tg_high;
 	u32 tg_low;
+	u8 abort_to;
+	u8 reset_to;
 	struct mpi3mr_throttle_group_info *tg;
 };
 
@@ -738,6 +740,8 @@ enum mpi3mr_dev_state {
  * @wwid: World wide ID
  * @enclosure_logical_id: Enclosure logical identifier
  * @dev_spec: Device type specific information
+ * @abort_to: Timeout for abort TM
+ * @reset_to: Timeout for Target/LUN reset TM
  * @ref_count: Reference count
  * @state: device state
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5516ac62a506..43507dfdbdcc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1308,6 +1308,12 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		if (vdinf->vd_state == MPI3_DEVICE0_VD_STATE_OFFLINE)
 			tgtdev->is_hidden = 1;
 		tgtdev->non_stl = 1;
+		tgtdev->dev_spec.vd_inf.reset_to =
+			max_t(u8, vdinf->vd_reset_to,
+			      MPI3MR_INTADMCMD_TIMEOUT);
+		tgtdev->dev_spec.vd_inf.abort_to =
+			max_t(u8, vdinf->vd_abort_to,
+			      MPI3MR_INTADMCMD_TIMEOUT);
 		tgtdev->dev_spec.vd_inf.tg_id = vdinf_io_throttle_group;
 		tgtdev->dev_spec.vd_inf.tg_high =
 		    le16_to_cpu(vdinf->io_throttle_group_high) * 2048;
@@ -3917,11 +3923,13 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	if (scsi_tgt_priv_data)
 		atomic_inc(&scsi_tgt_priv_data->block_io);
 
-	if (tgtdev && (tgtdev->dev_type == MPI3_DEVICE_DEVFORM_PCIE)) {
-		if (cmd_priv && tgtdev->dev_spec.pcie_inf.abort_to)
-			timeout = tgtdev->dev_spec.pcie_inf.abort_to;
-		else if (!cmd_priv && tgtdev->dev_spec.pcie_inf.reset_to)
-			timeout = tgtdev->dev_spec.pcie_inf.reset_to;
+	if (tgtdev) {
+		if (tgtdev->dev_type == MPI3_DEVICE_DEVFORM_PCIE)
+			timeout = cmd_priv ? tgtdev->dev_spec.pcie_inf.abort_to
+					   : tgtdev->dev_spec.pcie_inf.reset_to;
+		else if (tgtdev->dev_type == MPI3_DEVICE_DEVFORM_VD)
+			timeout = cmd_priv ? tgtdev->dev_spec.vd_inf.abort_to
+					   : tgtdev->dev_spec.vd_inf.reset_to;
 	}
 
 	init_completion(&drv_cmd->done);
-- 
2.43.5

