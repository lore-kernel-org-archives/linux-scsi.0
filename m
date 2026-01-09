Received: from mail-ot1-f100.google.com (mail-ot1-f100.google.com [209.85.210.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709873382E5
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 10:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767954849; cv=none; b=SVSfaWBTYyUWYmAqTlrU5sRtod4C9gmHuKbJdn5PKKwNgH7hAg59BHnDbWeHr98m1PVT8UcAODVho6oqw+Q0zhsy7MKbWq6YlxffQGdHCcFmir0hxDFmjXALViVZCO5EM7dvednS0fIUUwOXkQeuduHv5LZXySsBsG6qxxc+k/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767954849; c=relaxed/simple;
	bh=qyAIaazdwIw49PPuAk/0GEIkpgkeLChWeD2e081LVRc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ee5KfOAOWi3G8iL61pYUOYk6rAkeHEJb2gpYd1lzsmhKi4Fw6GoHpHbbg06AhokUohFOe+k/GW2BVLPEp1wLlqaMCpa7mEbUX0v5Y020/RPzwDyRt/rOvh49RJbqc/yR3Ovv/AdeTkUZ2NjdYgMXF0C3orFaaCZLlj80AaNpnjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=YonAn+K/; arc=none smtp.client-ip=209.85.210.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YonAn+K/"
Received: by mail-ot1-f100.google.com with SMTP id 46e09a7af769-7c75a5cb752so3027755a34.2
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jan 2026 02:34:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767954846; x=1768559646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kCeTL5DyL4OpVceWW2dtJZK2fvnfNct2KD6UucHZ0lo=;
        b=qpCG8gxOxJUh0QRfDKfMG9vUbCrTJYZ1GWi/CViWWT6ylWTN+QazSV5b7dQuTeCsX8
         +yiGqMO4XKHwjct7j5hgNgyeF4lQQuY48N6Yvr2CavZANsMlF7QOyPGh1l5Am/bjayZ0
         tNxTaqobG9O4eVLJWk72HWm1eUSa/L3hmygQHUEDdTdiMgktaefUiHe3En8dl8//eTpO
         yZjTrs/xeXlG/UMMIJk9yq46HeA0gbMWK+YOQyrxauHqRhwSXfkQyHsCTtICxfFiro2H
         SwVsZgOre+4xCjCbe9h4kZJ8Y3pJjqWtWewvDRru4u+8P7I/BVsQLedxofmN89SxSwvW
         4bAw==
X-Forwarded-Encrypted: i=1; AJvYcCWGkJxa2K+v6329nOCkyayU4N1dJKb+eJinXaqUCKv4ZeoWoB47bTsOkTwGTzJoGxY+l6AFXLOgqST5@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3zmZ8Mq/AsLfjq90GxmC70NHDcpFByZ1IxfO2SeSJOk44tCZA
	WW1Ptze58gHEgHtmTHKa5vQRhi9ATw7qJ8VzqjT3waxWJ25KpckqGx3kq4wsvTTXcph2aM6mAra
	ZnLzafbq3WJWCO3Rr1P8EaUYtYP1gQja5uH4x1UTUhwlQM6HIyC3vn2xrdwd35dhc0byrcTC6Bi
	KXZ/OTiih+fsTbaP+0dy2iM0RYaRvyvyAzIkewboVh7qjjnFe8V7UbwONOlcXmk8ItL8LiGtjO0
	Sw3ShhOLiWGjTwcPNNkYoo=
X-Gm-Gg: AY/fxX5s51CZEB3kC0/MwkN+5x8bTPUjRwXcPfsY6mtg7Tox9JW2Ohnzby/H9f3aVT8
	tAVPmBRj+3y9CKlanfU9hqhBookalTJCHZi+FBv5fcmctvHWF+gyBsYV7P+zZAA1ma2TVakEETs
	g3q18kk4nSxxux48FO1ES/OWj7/f/VTKH+POi4L/iHmnfQgBdVj3YqfjXw3jUawEtHy5rsd4Cre
	wII+pjE1r2UafRYCPGLjyxtJ/brr/7Tv0NvbvlWqPW82gxkFQM+BvzqYfzcCFbZAU6hv29zVyDS
	Z/lbY6TTfIrobkwk5v5WGtwE1s70Mq59mxfl7wgN4+du7/MI9o/sG+XqmDsx0O0HXLsoVp9vpKm
	rfcnNaL5jmqknuWQNemcQk67yTIU86qTLI8MFBgaU1UeEhidHBT5pOrXR10ex9j6R4WuxsLtHDm
	MJvf9uruXp9HFwudiyWi0N7Tu63nsvJ8AGrlT5d/bxlRxLQ/suZ98=
X-Google-Smtp-Source: AGHT+IGku9PF/tQ4VrWI8YEAaL/1mGoE62dSre0jPrvg8mTb3ev49EmKEMetkS/lqifFrxWcvFYiL7XSCBaW
X-Received: by 2002:a05:6830:304e:b0:7ca:e8bf:8c4c with SMTP id 46e09a7af769-7ce508ced45mr5864636a34.12.1767954846385;
        Fri, 09 Jan 2026 02:34:06 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7ce47803ad5sm1617322a34.1.2026.01.09.02.34.06
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jan 2026 02:34:06 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8c38129a433so1019660185a.2
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jan 2026 02:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1767954845; x=1768559645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kCeTL5DyL4OpVceWW2dtJZK2fvnfNct2KD6UucHZ0lo=;
        b=YonAn+K/hNeju/vfUTGrTh4VewE3Le5mRf0/z+xVZYuUcI2+VHhAH4xuI8bGn+rVSx
         N6zrdIQV/JSoWHX+gq7/EZOSqgzccg3IjtjC6XvULRNQc8/stHqj0ZGHyBPuzTdPB6jH
         UL/fKQ6SQE2i96pdu/35JNpo98Ebux2mzjh/o=
X-Forwarded-Encrypted: i=1; AJvYcCWnkcQZMHYwxL4RFYl6aHo8Bw0Fxe/5cATWEhYIBJM7SD4GKxbYb6/aDvVneWprCWuWoGdwbB+Ikvjc@vger.kernel.org
X-Received: by 2002:a05:620a:7088:b0:8c3:87eb:f with SMTP id af79cd13be357-8c3893ef6d0mr1155257485a.53.1767954845213;
        Fri, 09 Jan 2026 02:34:05 -0800 (PST)
X-Received: by 2002:a05:620a:7088:b0:8c3:87eb:f with SMTP id af79cd13be357-8c3893ef6d0mr1155254585a.53.1767954844715;
        Fri, 09 Jan 2026 02:34:04 -0800 (PST)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770cc73dsm73691156d6.7.2026.01.09.02.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 02:34:04 -0800 (PST)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	sthumma@codeaurora.org,
	JBottomley@Parallels.com,
	santoshsy@gmail.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Sanjeev Yadav <sanjeev.y@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH v5.10] scsi: core: ufs: Fix a hang in the error handler
Date: Fri,  9 Jan 2026 02:13:02 -0800
Message-Id: <20260109101302.676694-1-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Sanjeev Yadav <sanjeev.y@mediatek.com>

[ Upstream commit 8a3514d348de87a9d5e2ac00fbac4faae0b97996 ]

ufshcd_err_handling_prepare() calls ufshcd_rpm_get_sync(). The latter
function can only succeed if UFSHCD_EH_IN_PROGRESS is not set because
resuming involves submitting a SCSI command and ufshcd_queuecommand()
returns SCSI_MLQUEUE_HOST_BUSY if UFSHCD_EH_IN_PROGRESS is set. Fix this
hang by setting UFSHCD_EH_IN_PROGRESS after ufshcd_rpm_get_sync() has
been called instead of before.

Backtrace:
__switch_to+0x174/0x338
__schedule+0x600/0x9e4
schedule+0x7c/0xe8
schedule_timeout+0xa4/0x1c8
io_schedule_timeout+0x48/0x70
wait_for_common_io+0xa8/0x160 //waiting on START_STOP
wait_for_completion_io_timeout+0x10/0x20
blk_execute_rq+0xe4/0x1e4
scsi_execute_cmd+0x108/0x244
ufshcd_set_dev_pwr_mode+0xe8/0x250
__ufshcd_wl_resume+0x94/0x354
ufshcd_wl_runtime_resume+0x3c/0x174
scsi_runtime_resume+0x64/0xa4
rpm_resume+0x15c/0xa1c
__pm_runtime_resume+0x4c/0x90 // Runtime resume ongoing
ufshcd_err_handler+0x1a0/0xd08
process_one_work+0x174/0x808
worker_thread+0x15c/0x490
kthread+0xf4/0x1ec
ret_from_fork+0x10/0x20

Signed-off-by: Sanjeev Yadav <sanjeev.y@mediatek.com>
[ bvanassche: rewrote patch description ]
Fixes: 62694735ca95 ("[SCSI] ufs: Add runtime PM support for UFS host controller driver")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250523201409.1676055-1-bvanassche@acm.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 54e7d96bf..c1f232472 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5766,10 +5766,12 @@ static void ufshcd_err_handler(struct work_struct *work)
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		return;
 	}
-	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	ufshcd_err_handling_prepare(hba);
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_set_eh_in_progress(hba);
 	ufshcd_scsi_block_requests(hba);
 	/*
 	 * A full reset and restore might have happened after preparation
-- 
2.40.4

