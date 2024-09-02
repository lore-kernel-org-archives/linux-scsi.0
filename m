Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C987619F12A;
	Mon,  2 Sep 2024 14:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725286542; cv=none; b=orru6cLv6Lhz0RvRpbbF8bBSFu6zO8lfgNTo+cZM8wCDDc3NHGnLZ05QQFovXKXQpfgJM3q/aLaClcYKZ5dmgz2rrPRhc5Ci+AwIYnHTi9LL0TQhlVjacqxfB5GUxFaxfr0/JXczKKh8XrF7odeTVVxvAuUp1eEtuvVPTOkcmqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725286542; c=relaxed/simple;
	bh=VH/Vx5rdSKJYQxJ996AxvxGom1DGT4TVPWEVrF9jU04=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=QKygIYLetvwPGWC4bhpl6UAe8RM50DkoQRpMGghsvcIw1W5f5J57aU+VxIQen9LRejbAt0gZbhElIvNJn6UQE3ihyDhgpib4WGrMb3clsGAfHN3HCa00vXgIa5f9joWg9zYu0YkuElxjB4wO5Ez+PlGCn8ZgA/smByQ4a38au8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hsoYZCKu; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hsoYZCKu"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53346132348so5294597e87.2;
        Mon, 02 Sep 2024 07:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725286539; x=1725891339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0bG9lyeZyatxy1jR3IjmXpWEdkF/UNv1TCoaGvgG/e4=;
        b=hsoYZCKu1D1TsXFf0llDVNpe907uFdyy0WyjNABJxhg/8rh0DYWfM4VzIHG46fgXWD
         2Y7scRj6bsd/KuCd+UXOW11aUm2z65ciHvKm8RW3PwEFetLPhQw1L2FtAvSl0kg4wgm6
         5GgX6IB7m0UnXPfv+dP6b4p4Q3OVbjSIhRi4k44iwIeRH2HsmfOB8d4LHSF4ZSJQNOB8
         l6KZk5au8yw87iDdXH1tx0yXvQXUa1a4ZqBJuouF2wuosS81iSNmEkLMgeTFiQhuwycB
         16d+uEdF3aQ+KQNC9k6BStUgASAyTQzpL2LnanHSyedWfX+gKkOfxd/4nAR+yyt+bmML
         mI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725286539; x=1725891339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0bG9lyeZyatxy1jR3IjmXpWEdkF/UNv1TCoaGvgG/e4=;
        b=mLqYvrvEMS1gzJL9pWErduac1BbfBA15X4MbsAqdTIgn5xBDzcBOdqLn8X8Xvehere
         a9ezvFX6c2SfHht846X6zzKD1MjtKUsPI9TgMGf/KyauHSqppJGtO2JfTDyNn3tBGb15
         Z5HZuuZEoIJ98jRL6Ztgjy6V/MHSXyVoohIw6wMSedvZlF5vzmR4gqyNQedzIQngHO31
         kVltXRREgpD2gYgdHjksiPpxwhnPcJZoU6z9dvtg9CSp/nC4VwgU27UAVvTkEh4olnIG
         PZQzyj8eXyPBxB/VYbcQPit0CJgLN8j5hwCmeAAOI5co/W/V/h1kiTxjASZGisletUX6
         ptgw==
X-Forwarded-Encrypted: i=1; AJvYcCW5HP6sPjKnh38R9bKmNq/U94FfnifKeEGi9Yllfc2Vxbo7XIg/ZBeEhAFuF14aKFHTHdKWx1w+Y2wAdxI=@vger.kernel.org, AJvYcCWIQS1krq7/7ZgkecAJhYrs1IecdPRftqp4jutvjvh1exPbwIlK9e3NUtNwjSDHjfYdMoejoZU2Mtg3sQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YziVVYQCqnYtXga5c4TLxGgPhHCI8jLltM+avkW+KPCMotflg//
	/gwkeGzviIvme482pNKQlaZ4l6LhM1v8ELeYprmgo+Pt1uBJaE2B
X-Google-Smtp-Source: AGHT+IHFlYMqox8BRCs891kq3eAJOFZFSGXM/BJv8oKnJNCgWBtTTwm11XZ9pbAoXkEGctO0ABkShw==
X-Received: by 2002:a05:6512:3190:b0:530:e323:b1ca with SMTP id 2adb3069b0e04-53546b27398mr7575326e87.25.1725286538304;
        Mon, 02 Sep 2024 07:15:38 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8988fef4c3sm560473566b.32.2024.09.02.07.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 07:15:37 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: pm8001: Remove trailing space after \n newline
Date: Mon,  2 Sep 2024 15:15:37 +0100
Message-Id: <20240902141537.308914-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a extraneous space after a newline in a pm8001_dbg message.
Remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8fe886dc5e47..a9869cd8c4c0 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2037,7 +2037,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	}
-	pm8001_dbg(pm8001_ha, IO, "scsi_status = 0x%x\n ",
+	pm8001_dbg(pm8001_ha, IO, "scsi_status = 0x%x\n",
 		   psspPayload->ssp_resp_iu.status);
 	spin_lock_irqsave(&t->task_state_lock, flags);
 	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
-- 
2.39.2

