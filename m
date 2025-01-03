Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91FC1EE7B3;
	Fri,  3 Jan 2025 11:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735902690; cv=none; b=rDyuEdKVZFZJ13e8rr9t+o1Oki/jXGsq0G+j6A9ilv8IPjYfq3LnQVySuIafxMxOYcUacdHhOLr1ezeY6zNIo/Zih6bol4raHKTqzgWy/qGsZZwu9s6VhaYzFxYOSzL0degxKKyyRgsOalXMcNKt5jL/1w9bTAigyQixxce0//E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735902690; c=relaxed/simple;
	bh=6o1Wagd0uUVsHIpGzUJpqU/Rw+/J5VBWI+It9NIq3S8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=la4nuK2N7pfpQYMp6vWYfCoCJ56k6vAbo12p4VJ5aV/3dj/+Zgo+krgimqVZ0Dnqe2Jht9fh2HtAGwcIoWUgBdkpoMB38khZ9PmrPtW757tfoPhkGBfEPs6r2BXWoKg2bI9cHq0rlm7wTKYja/Y0VLe4jJTvRvRESe58U3lFpYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KjTMaJJs; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KjTMaJJs"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-216401de828so157907715ad.3;
        Fri, 03 Jan 2025 03:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735902688; x=1736507488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VBWbka6tcunvnkswMnINMIR9eUmPBlJrKkb4tiWy/N4=;
        b=KjTMaJJsnpwpCLIshDRBSzhGlmYLol9/XR7PBPZ99FDg3KW9vYpk66Fph6RsqwRAny
         qrKvgaIMoTaVkzQC+pj71QPtwWxXOwsp/zDCpeYlXDY6RM3hBtj76zHyogM1wbg2BrPv
         J+ZVi/WDiS+sNIuxZJlKIaVqHOpOaMHajqxO1SAsHvhGcWzlafa02u2zW1OmlPmVZTB6
         O7zB7A+icGnd0qVsTHWxcUbyEL5vg/uZ0J7DScOH1fzta5NQc8T/PLHaLSmo3cb2zuKc
         uatSOf/DF74K2crNWo5wEadVMxvkFNz4hbDzyvTvM0q/At1PrvDAjwYGk4s8HWXRhSpp
         1qSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735902688; x=1736507488;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VBWbka6tcunvnkswMnINMIR9eUmPBlJrKkb4tiWy/N4=;
        b=jA5Nev656ENNL3J32QXgKhce+boLesgSMbm0cN6rVM8CvzVOLL6L7ubUWCKkbnuqhk
         4lYdqXkq4GSug0LluTsfvVL8wo+X1kbD5rBLbUSd24JAwXZWttGbbvpEyJscBik5yUZT
         TbYutKhFJwViKYykdbMW9YJKH5zakASBDpb0CB25hV7do/0s/1swbny+DHOZoskUNBMa
         NLXGsDHYt/EJswhS1IRCR798LAc6gE6iGpeaVX9NjTqBW/XvLt36Cu0RxC0rUGhsMbGA
         9Rgsa8AaUDxpi7a3VfTR3KUvUAiZUFCZ15MWFKeXq3IR2lldNqmZ967wk0lF62mtXfS+
         uP4g==
X-Forwarded-Encrypted: i=1; AJvYcCWRnNw0q6rvKK4CadFw2aNimt8tFHrCfojmn8etYgjtBIHZSckWVd1/+9z/GeTJHczPkE5BLO6Q2Db4SOA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOBiQT6AV+T/Xhji/eEpNpZ5O0Oj8wsJjTHAV9/sIYlcXpVNib
	bUoulorQGfInYKOze9qgOmT3At9C91gjEn85A6fBbsG5PAkTDQ0S
X-Gm-Gg: ASbGncvdSMs0kmnTwTf/MsMeoj4NhBH4ovybEZDADYCJipGdAFqByfwErj4FLCcMj0A
	KCeM6BaHN7PQt3L8vqey0DnmPfgnyw9FTDaunK8HcFxoA9o7xiC0XXAcDfGkXI/BlC0TqrN/lpj
	ZzISmn1ZQ4UEFRhLq1oGioybkz751B89RayrNUpIi2DJRKQ9ELyI16xiI8SNoG2hm1HXKTnDEwi
	7DCtMAn0gFcJB1/LZs8NFFMYf2YYWu9e0IkUpAZmCyqBSkuVXdAfXfO28qzwHdxCkHfbw8qiCnq
	qajvlS2Zbg==
X-Google-Smtp-Source: AGHT+IE/BYgNRvINRX7OgscnNTUkQp50Zau6Yfbmq7OIjPNIeChro/Q+SD/SMrCmQc92D0N0Yxs1ag==
X-Received: by 2002:a17:902:e88b:b0:216:3436:b87e with SMTP id d9443c01a7336-219e6f14504mr666524385ad.44.1735902687874;
        Fri, 03 Jan 2025 03:11:27 -0800 (PST)
Received: from localhost.localdomain ([103.150.184.35])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-903f22c073fsm8825270a12.53.2025.01.03.03.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 03:11:27 -0800 (PST)
From: Xiang Zhang <hawkxiang.cpp@gmail.com>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Zhang <hawkxiang.cpp@gmail.com>
Subject: [PATCH] scsi: iscsi: special case for GET_HOST_STATS
Date: Fri,  3 Jan 2025 19:11:09 +0800
Message-ID: <20250103111109.21609-1-hawkxiang.cpp@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Special case for ISCSI_UEVENT_GET_HOST_STATS:
- On success: send reply and stats from iscsi_get_host_stats()
  within if_recv_msg().
- On error: fall through.

Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fde7de3b1e55..ad4186da1cb4 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4113,6 +4113,8 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
 				break;
+			if (ev->type == ISCSI_UEVENT_GET_HOST_STATS && !err)
+				break;
 			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
 						  ev, sizeof(*ev));
 			if (err == -EAGAIN && --retries < 0) {
-- 
2.44.0

