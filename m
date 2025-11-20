Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641A6304BC6
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 07:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763623555; cv=none; b=HA+mnddCylj/LXfqhBhuMpNxUXnxiQeRvVb41Xy4vx4EICYo0MXzDJfa0Ffz+kzOMHx3s2WFa/F7PYXWAzVuUJfwjXzYz0TuZUKqlL+j15sqdU6KvfhJ8LElAK38ZGax6+SGUaqts8CZERAMiXTMbz/FoOGu2k5wYbWbunp217M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763623555; c=relaxed/simple;
	bh=x7zoQKjejtTwgqWLbZyHhyC/P+er2/F2lcU4gQbyGGM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IWPGjdsxMcThBvtaQyqZsPM9PuHR4cBospoq4HvgcTBLm2CpYSAdwyMyjd/SjEy3cwEtQqXMHH8zeH8dlz+V4L5+LwiHlrFriKF28U4L+AgtHSKtkbSjM9j176tFAc3A8OxNekGmhvjWD1i2x8+3eLhRH0pZQBpJlEvGOT3zKg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=WuPXchqJ; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WuPXchqJ"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-29812589890so7302475ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 23:25:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763623553; x=1764228353;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vNBg3K0OSAln8eZOSUOn8UtbJ+SShwdvZTkyuXu3RMs=;
        b=OBojT4TdP7dAgdD6ggzIkWJgHFfT+IttZfn+JeXHsTZwGn3c9VPCBOd/13Km3LwVm3
         mCz3eZkFQUd+Iz6pYZY5bqRrGqUFQIgfEpI3PQ93OaOIMEvXTV/ZAtGGZaBKnvCl84s9
         J1uOXakhOGwVIkl+nNKnLakf/VQ4MYuJUwm1MGnUaS9g3bBIeDzm/SS9s+CiitPa0cWB
         XlsgnRr26mo0zdUtlaoQCMLzg24ALc0zUIx1E6BJwuWvmNrYC+Tb8Ql4btJmR++IGUMO
         YMhmg2bBatopSB9SEKp7ookOMFb7kbU1hb+/TzlshMcj2v8KoQQC5CZ33Ilyrbf0ceuS
         jRvA==
X-Gm-Message-State: AOJu0YzIjad25K+PpmfMzQ/cXJnb74gaR96aL8cx7KSW1YOA0nffO79f
	1iFrCUH9MFGHz8nmiXjMVGizm19EKeeZTmOaXFEfzwr2LoSFhg1+b97EChEcnpd1HHQaZT+7ztV
	KXe4cfEIiLg8W0RxY3USshI5nK+o4Ugcvcck+d1XwZ+0b2BQoLntqrwqoWGoN3FNceVqxS/5809
	qMPE+QVXY4dpj76o98lJQDOAD5tjxwGePYxrS1XWC1WrMx+/dbvHB6AM8goVObSS3hkiGktocoD
	88Q+bH3wP4issYhx+J/1WeDly8NOgip
X-Gm-Gg: ASbGncsaxFogYtKY3QCwLHqd61e4SctHlqv1YvWIf3T9a39SmRGxAdPWTsXsfI+8E9a
	SSYoiWLhYkGjxz9NfKtVZ145Fl9T1ofytqXj/Ug9Qe/6363rzDG+pugmp+tHDGeil7C6spIHJjK
	t+S9KW70YPHw/SwEcE0D31zc45dP832LrvvVIcjMhVx5GFR5tG3h/DWRY/n17j6h0MVKJPd+J3W
	rHlT2Ptz3eeWYilutZZmVhBTNJUrbIqqprrsHSYdiVh579yRXjcLGkXDc+8+jTFFqwt4zkJwDLZ
	KhHlp+QabngUiKOFDbb8mrGsZ+Z7e7DH9Pla7IU2myTuNyE3+OSU7cmo6tLARjkBl4+veQSb6oS
	MKPVXMY9g8qCE0glZLwuIe+DSdALN8koEJFMFJQ7yWcTtmGP8OP5fSLamC/C4gL/blYqxemM8YF
	1P+/otLM9chK0+j0dsFg/KK1l/v+f5UlkLtRgJIlwe59n1H/+oA28g12JvAw==
X-Google-Smtp-Source: AGHT+IFF3LScyphD4zL0U3HLB4ppOmSDQkJ6n5mwmCkTVdhaYgfqwm+nCL7Z0n/FfQczkII1nZLuYMCOVuTa
X-Received: by 2002:a17:902:f60f:b0:29a:5fe:4f33 with SMTP id d9443c01a7336-29b5ebc028amr17298965ad.20.1763623553500;
        Wed, 19 Nov 2025 23:25:53 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-1.dlp.protect.broadcom.com. [144.49.247.1])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-29b5b1075f3sm2137785ad.12.2025.11.19.23.25.53
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Nov 2025 23:25:53 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7b80de683efso1118757b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 23:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1763623551; x=1764228351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vNBg3K0OSAln8eZOSUOn8UtbJ+SShwdvZTkyuXu3RMs=;
        b=WuPXchqJaobE03xTjoPuq/LF0lfe9jyNUVAWj3AHc2MBZ5iHDAXkLbWq9W3QVDbAvp
         5S1IjtsKxNUCwIJXfDU1TAwivCiPxD70MtFHgsyLJFFF9MlU5eSK6RsPGe3LBHG1eS6X
         NQTnMmtkDigajDOQ2Hv05pHdhqZZ2SHEKGvYc=
X-Received: by 2002:a05:6a20:12c7:b0:334:a784:3046 with SMTP id adf61e73a8af0-36140be339fmr1347337637.38.1763623551492;
        Wed, 19 Nov 2025 23:25:51 -0800 (PST)
X-Received: by 2002:a05:6a20:12c7:b0:334:a784:3046 with SMTP id adf61e73a8af0-36140be339fmr1347305637.38.1763623550943;
        Wed, 19 Nov 2025 23:25:50 -0800 (PST)
Received: from dhcp-10-123-98-239.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75dfed8f6sm1593796a12.2.2025.11.19.23.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 23:25:50 -0800 (PST)
From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	stable@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH]  mpi3mr: Prevent duplicate SAS/SATA device entries in channel 1
Date: Thu, 20 Nov 2025 12:49:55 +0530
Message-Id: <20251120071955.463475-1-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

 This fix avoids scanning of SAS/SATA devices in channel 1
 when SAS transport is enabled as the SAS/SATA devices are
 exposed through channel 0 when SAS transport is enabled.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 4 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6742684..31d68c1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.15.0.5.50"
-#define MPI3MR_DRIVER_RELDATE	"12-August-2025"
+#define MPI3MR_DRIVER_VERSION	"8.15.0.5.51"
+#define MPI3MR_DRIVER_RELDATE	"18-November-2025"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index b88633e..bca3671 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1184,6 +1184,8 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 	if (is_added == true)
 		tgtdev->io_throttle_enabled =
 		    (flags & MPI3_DEVICE0_FLAGS_IO_THROTTLING_REQUIRED) ? 1 : 0;
+	if(!mrioc->sas_transport_enabled)
+		tgtdev->non_stl = 1;
 
 	switch (flags & MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_MASK) {
 	case MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_256_LB:
@@ -4844,7 +4846,7 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	if (starget->channel == mrioc->scsi_device_channel) {
 		tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
-		if (tgt_dev && !tgt_dev->is_hidden) {
+		if (tgt_dev && !tgt_dev->is_hidden && tgt_dev->non_stl) {
 			scsi_tgt_priv_data->starget = starget;
 			scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
 			scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
-- 
2.47.3

