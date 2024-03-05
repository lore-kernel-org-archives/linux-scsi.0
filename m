Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC3279953
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668154; cv=none; b=ZSqo8k1jVYn6St516Wz9Sst8oLCAnFuwPSmLt2ADSf+s9UBcpCsP2m4dvQD1iHuWDbIaoC7J36B+kfZgX1/08bjVZ07vunQ5JRsnRzYf1NT8FxtGaaDO3E+QHk2ZBB8ds2bbryf37D4HyZATH4XMb26idhr4YIV5n/XpSnDPhDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668154; c=relaxed/simple;
	bh=IIbhw+SwZRPcdlyiLWdehPC5LHjqM0Vs4SAlPferXR8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EXsla4qZniHX35yop2P8uApNjn8V5m29x4jyx5IvLoGzv8waR3b/P1bJ/XYZaT/ZNcaR2lWO1xSC9o84EXy/tHvESVlLQn/Hecg/t9Fu1lG+qDrqquVe9DwCksux/jOVDkgxCP3w71mr6mbEKciXOd60k5bt6cIZ5bnIbOQw40g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VudB6H5+; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VudB6H5+"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-21f10aae252so559657fac.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668152; x=1710272952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMYL4XINwiJyrxByVkAt03WJ0yc5MhT9bqgD56m9lEU=;
        b=VudB6H5+5Y0vzJaYwY8Zx9AeJPn0wRJqz0wkdN/QcSUwRgmAUlywwtp2NT1fkFWcKK
         Md20fEpMozWf2WIjxGOlws+wh9CN+UfkAK4r/F7C8m5RuLwwr7kAsmUWVMtybX7Tz+1y
         Q5AA9UNtkkhMZ8y2p3G4hsvGzN4iug1kmhIId5PY6hrgr0zKCVuYkMyWGJx2X8qOYkiM
         QswmXtKpJP7LVQ2ZNgF6/wY9lzLWRNThFdtRWhwujSD9OW5QbiA/sktjGGvm+myklHQE
         BLuy5wybP0gBg500NitSsgp7BV5pCAF9qkBGBwXti0vsBJ5+MOBlZxsOlbIKu+2OzVZw
         qBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668152; x=1710272952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WMYL4XINwiJyrxByVkAt03WJ0yc5MhT9bqgD56m9lEU=;
        b=pwTJdRwqrAvuNX4DK031NsiAFJM6mp5NzYqWMfhW2XEeShOXOohyqdl57z/V2wCX5L
         x7f0QRb+NpGmPyWJzdBHZvMZAfAnViCK0ZPYznocdUr/dnkBlPFC6LmDaprXEhvSboo6
         vTxVEmci+MLXrxxkwvVNc2VqEw3vXX8mX9tM2DFF8K7bwZLtXFcKbUjT7D9D8VYja8CV
         z3kLNMd9vH1r3+A6tihBqrpb48HtYZSICC9UDj8UyxuElM7kiV8GGeScyOrAJ2o+uatN
         od/V/mFQEgViEZuemcFiQ/tNVHhCDVmauQ/F0Hfs29edC5hGNv5zH5IYc3PgTCnpXgYw
         sSEw==
X-Gm-Message-State: AOJu0YwYrOwkalUxgiLubqroYmQEXIFcZxd0YC+6764P9n46CbogrpjS
	YTYenSqCdyuRqZVe2fREqyrVKf+YuwQfdJVpJcuuPKsFSvAH1Kl0NSrIKqFo
X-Google-Smtp-Source: AGHT+IE2wHHc32ovQMn8vK1JLDPdhcHCjFrLvZnRFutCqOC5lCAYcQpd3PaOTreP3mOrTOcB3ODjTQ==
X-Received: by 2002:a05:6870:5e53:b0:220:c30d:75d7 with SMTP id ne19-20020a0568705e5300b00220c30d75d7mr1501373oac.2.1709668152195;
        Tue, 05 Mar 2024 11:49:12 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:11 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/12] lpfc: Update lpfc_ramp_down_queue_handler logic
Date: Tue,  5 Mar 2024 12:04:55 -0800
Message-Id: <20240305200503.57317-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240305200503.57317-1-justintee8345@gmail.com>
References: <20240305200503.57317-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Typically when an out of resource CQE status is detected, the
lpfc_ramp_down_queue_handler logic is called to help reduce I/O load by
reducing an sdev's queue_depth.

However, the current lpfc_rampdown_queue_depth logic does not help reduce
queue_depth.  num_cmd_success is never updated and is always zero, which
means new_queue_depth will always be set to sdev->queue_depth.  So,
new_queue_depth = sdev->queue_depth - new_queue_depth always sets
new_queue_depth to zero.  And, scsi_change_queue_depth(sdev, 0) is
essentially a no-op.

Change the lpfc_ramp_down_queue_handler logic to set new_queue_depth equal
to sdev->queue_depth subtracted from number of times num_rsrc_err was
incremented.  If num_rsrc_err is >= sdev->queue_depth, then set
new_queue_depth equal to 1.  Eventually, the frequency of Good_Status
frames will signal SCSI upper layer to auto increase the queue_depth back
to the driver default of 64 via scsi_handle_queue_ramp_up.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 -
 drivers/scsi/lpfc/lpfc_scsi.c | 13 ++++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 30d20d37554f..18cbfd371ccc 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1333,7 +1333,6 @@ struct lpfc_hba {
 	struct timer_list fabric_block_timer;
 	unsigned long bit_flags;
 	atomic_t num_rsrc_err;
-	atomic_t num_cmd_success;
 	unsigned long last_rsrc_error_time;
 	unsigned long last_ramp_down_time;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index e7bfaa0eb811..fc77f19547de 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -167,11 +167,10 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 	struct Scsi_Host  *shost;
 	struct scsi_device *sdev;
 	unsigned long new_queue_depth;
-	unsigned long num_rsrc_err, num_cmd_success;
+	unsigned long num_rsrc_err;
 	int i;
 
 	num_rsrc_err = atomic_read(&phba->num_rsrc_err);
-	num_cmd_success = atomic_read(&phba->num_cmd_success);
 
 	/*
 	 * The error and success command counters are global per
@@ -186,20 +185,16 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
 			shost_for_each_device(sdev, shost) {
-				new_queue_depth =
-					sdev->queue_depth * num_rsrc_err /
-					(num_rsrc_err + num_cmd_success);
-				if (!new_queue_depth)
-					new_queue_depth = sdev->queue_depth - 1;
+				if (num_rsrc_err >= sdev->queue_depth)
+					new_queue_depth = 1;
 				else
 					new_queue_depth = sdev->queue_depth -
-								new_queue_depth;
+						num_rsrc_err;
 				scsi_change_queue_depth(sdev, new_queue_depth);
 			}
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 	atomic_set(&phba->num_rsrc_err, 0);
-	atomic_set(&phba->num_cmd_success, 0);
 }
 
 /**
-- 
2.38.0

