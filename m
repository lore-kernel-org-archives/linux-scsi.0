Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CCD13A25B
	for <linux-scsi@vger.kernel.org>; Mon, 14 Oct 2024 05:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728884225; cv=none; b=EKzdtcMPdERMRWRIdbfaTHY+TQl+3ceAmef/mJmYywH1v3dLr546T7h9Jo5kRyGbS+PsJb5M43DWQ3Wb6tLuiHbhie44c2pmzrdme4SSBpma60iugEP6JvFNx3xgnjNWehOK1/9SYS2S3hirORrHLcNoteq7IUo00NmuuQL+270=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728884225; c=relaxed/simple;
	bh=vowF12unhwaqH2Uhzh4TMLo1NmToPN+zrLa6q4Tvye4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MpDFNbmIAyU8wvtsrxvdgsxqgWVeONT6BF31d3Nc8YrgYUIvUikecinOsxl5VkHZfvGpulq4atJq3CLWJoRwIMIc5aOTPrehFIrINycVcO3NBu2mi+gfi4KJzfd+VauBhSsVp0sZ9YKQKs5pGndG8yUj3uzBjJLCvCD+869Aboc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jLUzhemW; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jLUzhemW"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71e4c2e36daso990724b3a.0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Oct 2024 22:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728884223; x=1729489023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BF37USWtm+h5np031/ok68lrYUFohiyeM1z19S1LTYQ=;
        b=jLUzhemWsVUCikWr6BsipSLuzeaIXI7KwIIva1L0c+0ia2FzEG1gZxXDG6CCT3NY0Y
         O5jPDH695zgRvhMVUUNyKnip+fq5fE6aU77lO7qTmNG9j6/PJ39aZGyTEH7kG4RIlYfJ
         Uuxc/5h5tmltThUdwPV2x1/Q0cKrCGsMzTwXeKM7CYbr/tfz0teUKuwThDB9pzFRlun7
         uZ1M8t3rKP3uZdWOLMSIDEzRWCdeBLlHcMdrf72Ucb2N0rtFdldw60ZzmsEiwtNUTseb
         2zWjHNMe5JyOMdsr3TVIsho4QzGnNd66b/pF+b/86p+6zjeSAiYKh3pH0ldtrP/Xblg7
         wbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728884223; x=1729489023;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BF37USWtm+h5np031/ok68lrYUFohiyeM1z19S1LTYQ=;
        b=DcYohW/P5H8MfDdP1mL9N+10Oh8JyQ0B/bCb+LqDbi7r85d+hs/o3EqQ/ztUVvzAJy
         +fETAll9i6tLwXhxbAP1sTh/10hgZhF8CxA3lQImvknuVqWQjcE+wIUrhWZvI81ToW3Q
         6XW9Gn259hYO/8ziq5tSVvUE0sl4Km1r//TA4pe6v5bhYIDXH5xzvZl5FhE3gN/sXoTH
         0l/08KslFlCWBYZuUJ3slHcs0BT+v+Is7hsZQKRVwJL1uoYJ3sRUP5RiFepdKmzjMHbJ
         Yqt+FvaD197xjy5ZO4w/GQvu73iOGr3hvKRm74N6dMVmFiBXsz660U8WW/mQRVQTPpVn
         c+Tg==
X-Forwarded-Encrypted: i=1; AJvYcCXk5LdFqurIezLmDIDwgoZ7sHAH+WjaWKALl2NNfwozuyeZZmjwkfu7daSOY67iNiVDz+y24j3Ewqxs@vger.kernel.org
X-Gm-Message-State: AOJu0YwDTErFCMqbZnaGz96iqQaMU+Jec6ci0pUtG9sSoNQAJuGYz7oG
	MHi4pLa8CDJ04VTb/emJNvaXJ5Qu1KPJSUkTakwQcMWNkZsrJ69p
X-Google-Smtp-Source: AGHT+IGoDJaXSiQrpIspY+1y57QSzV/xHgIeH/LIMAVee40rvm+VbMb7WBWMxWmnYYLP3UN+jsZ8yA==
X-Received: by 2002:a05:6a21:e86:b0:1d7:e62:ea94 with SMTP id adf61e73a8af0-1d8bc85d4e3mr14450196637.14.1728884223502;
        Sun, 13 Oct 2024 22:37:03 -0700 (PDT)
Received: from localhost.localdomain ([103.150.184.35])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e52f62b26sm3222104b3a.204.2024.10.13.22.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 22:37:03 -0700 (PDT)
From: Xiang Zhang <hawkxiang.cpp@gmail.com>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	ames.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	Xiang Zhang <hawkxiang.cpp@gmail.com>
Subject: [PATCH v2] scsi: libiscsi: Set expecting_cc_ua flag when stop_conn
Date: Mon, 14 Oct 2024 13:36:45 +0800
Message-ID: <20241014053645.17619-1-hawkxiang.cpp@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initiator need to recover session and reconnect to target, after calling stop_conn. And target will rebuild new session info, and mark ASC_POWERON_RESET ua sense for scsi devices belong to the target(device reset). After recovery, first scsi command(scmd) request to target will get ASC_POWERON_RESET(ua sense) + SAM_STAT_CHECK_CONDITION(status) in response.
For command's response coming, according to scsi function calling: "scsi_done --> scsi_complete --> scsi_decide_disposition --> scsi_check_sense", if expecting_cc_ua = 0, scmd response with ASC_POWERON_RESET(ua sense) will make scsi_complete ignore "cmd->retries <= cmd->allowed", fail directly. It will cause SCSI return io_error to upper layer without retry.
If we set expecting_cc_ua=1 in fail_scsi_tasks, scsi_complete will retry scmd which is response with ASC_POWERON_RESET. The scmd second request to target can successful, because target will clear ASC_POWERON_RESET in device pending ua_sense_list after first scmd request.

Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
---
V1 -> V2: Fix build variable 'sc' is uninitialized warning(Reported-by: kernel test robot <lkp@intel.com>).
---
 drivers/scsi/libiscsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0fda8905eabd..f6bfe0c4f8a4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -621,6 +621,7 @@ static void __fail_scsi_task(struct iscsi_task *task, int err)
 	if (cleanup_queued_task(task))
 		return;
 
+	sc = task->sc;
 	if (task->state == ISCSI_TASK_PENDING) {
 		/*
 		 * cmd never made it to the xmit thread, so we should not count
@@ -629,12 +630,12 @@ static void __fail_scsi_task(struct iscsi_task *task, int err)
 		conn->session->queued_cmdsn--;
 		/* it was never sent so just complete like normal */
 		state = ISCSI_TASK_COMPLETED;
-	} else if (err == DID_TRANSPORT_DISRUPTED)
+	} else if (err == DID_TRANSPORT_DISRUPTED) {
 		state = ISCSI_TASK_ABRT_SESS_RECOV;
-	else
+		sc->device->expecting_cc_ua = 1;
+	} else
 		state = ISCSI_TASK_ABRT_TMF;
 
-	sc = task->sc;
 	sc->result = err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
 	iscsi_complete_task(task, state);
-- 
2.44.0

