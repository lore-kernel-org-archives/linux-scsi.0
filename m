Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9F83CF1E3
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900162; cv=none; b=nWoI7NKP48cNe3fPOoxBHV3oPPqGaHTglRS/zKBnf18jawp2uxn5JMRqMvVNwlppgVh6iudV6MKhs6ZKTsbKfeL6uwBbSqpRt7LoTkAgN0hd3L0s8ZDbQ6dAcAFfLWqSjd4OkDrYDVfxqvty/3vJQsIosux4+hMYwBli0UgZiY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900162; c=relaxed/simple;
	bh=/mEYgtD7sPEZVYSTwXebZ4dJNlAF4fUdeIQAKaL7y9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UE1Ea1OwewPzWGvqIt77KrMpvTCQ8qmXnRSullFyP11UXAf8cPk64SGqotRnKt0pZ5bwmlLkxO2UvXLpIkt7YfsmOoSLz+K3YU+xnOMa35h56Z6/ac+Lh9qLqAjQGNqn70Vyyg3ma8cRXTZ/HsTI18wg8aHfC74rC0gszzP7p24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=dhRNGbCW; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="dhRNGbCW"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e82462a3f1so16866035ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 07:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791900160; x=1792504960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JIwhV2UA408K2f7C4cB3y92uRUokSrDJADAS6XPBFwc=;
        b=dhRNGbCWtvIjfi6nLMnnC928Ij6k0Or5BOPiijpgLfyHtksIcEvISwo78VBEQSh8iF
         CTqlbyTSUNTlatgdo1lQqxo9Rlm7ZO+MCW3q7KvcNlEY2SM2iyJ79ftBIaxhXk+fJA2X
         OvCrVkONMFOK1xk3dnUbPXGn2vZWOmXPoewFzX93lLBfNj7SAj2jRaBUIdHHHOrGLJIn
         SDEc7PZE6s4t9NPOdXbDPjx0tj50fTq9SLTMGY+4u3GwATPbMSZXv6wHuCkYkHXB07Ms
         g6Ktz9VJ69eambLRpWmkdoH/FtdIzDjhZyhc6+yxYeFmJi3oPlplg3LUWl7Y0lXC5ztb
         Z6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791900160; x=1792504960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JIwhV2UA408K2f7C4cB3y92uRUokSrDJADAS6XPBFwc=;
        b=w/wgMgUvR2bFRPoZMGo7rLGntx3lUSyG4P9QMDPwNPmgXAylG1p8NNesqX2ZcADFHz
         FsF6bTqWI4G1A/lNbMac6Vwy0WwTQihaUFKuUQJV2/IgzIksmS52n6aS7bewk00j6ryU
         /ZFx+/7I/kZCa8nLr3C6vtYc/kzLWJ9P/q58w+2VCtiTZSdbMUyQzRWtyo65LRCx7bF/
         wScbv9FZrnG4zPXdEDuYQFhZZaH8Z2J8Wi4z5pvvX1nfABRrI2WrO+c6Q+eXr2xqnpiy
         a9nhtMPYkSW3vrgGwNi5g7znRuaaeSd4XdPwKmJ1bXop5vWtf/OqzdH6P9BDgyyTWCyb
         9now==
X-Gm-Message-State: AFq9FYLuRMWpUzqMH4twP1R8RnEcQi4tDwUf0RFEBGhBxOFG9t9kXJif
	UcBveGka88AHoHIi0XOYkQ5ZqaVM/oJBJ+olNgRPRdfQGpz66P211+Aj6WPr96YitpY=
X-Gm-Gg: AYBFou0Zph/ZWdg8h/R2l30Xj+DiIWSB8CO898kVa/G0IRgfFnls9hloQ/Kt6TOsS5S
	x4eHuWXfp3HcK8Z/l7m129IXAXBOSOfU0kinxHr/irBEw/eOGQKf3TPdNDt9AN4+CVyVO0e+58v
	wL55ffkxx25ilpTSOB3VPKCjVRrShW9dNcKZrxUrSWYSxqM/fUxwryg93SHn4AXlUxyi9bUd9lI
	25Nm+EMbo/nRq6xF3JmPYEuiK5pb4c7SR5SKwocX04HIYl6UYkpB79Xer0hPdir+fqBB49blMeQ
	nRzbeFAYVKAR26dbRdbk9+yr2/zbzQnKjfarhPbHvVJhmsXy0+T1bQX4LJl9JowT9LVHJWN8In2
	0H9Se0F6L/mCcO0hu7w8sxVv1INo8DaLQJSoRXMf6LcXGPrWjcRaBLjzFMyQUNiAQfoeYPsv5md
	DazWigpyo4BLKBSJ6Uirc7X++sbrTo7cQ6wup68K9mkXXUcisSW3j2acdbf52ruxpf3p0o++MJz
	Dsm2Nj99DQ94XlkdUL3
X-Received: by 2002:a17:902:d2c8:b0:2e6:646:8ee5 with SMTP id d9443c01a7336-2e842cd3e90mr106695435ad.39.1791900158216;
        Tue, 13 Oct 2026 07:02:38 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e841a02f85sm56433065ad.10.2026.10.13.07.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 07:02:37 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 2/2] scsi: aacraid: bound the HBA sense response copy to the source buffer
Date: Tue, 13 Oct 2026 23:02:14 +0900
Message-ID: <20261013140214.3156938-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr>
References: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hba_resp_task_complete() copies the sense data from a native HBA
response into the command's sense buffer, using a length that is only
capped at SCSI_SENSE_BUFFERSIZE (96 bytes).  The source,
err->sense_response_buf, is HBA_SENSE_DATA_LEN_MAX (32 bytes), so an
adapter that reports a larger sense_response_data_len makes the copy
read up to 64 bytes past the array and hand that memory to user space
in the sense buffer.

Cap the copy at the size of the source array.

Fixes: ab5d129f93c9 ("scsi: aacraid: Add task management functionality")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/aacraid/aachba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 89d8e33517584..23512648e389e 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3579,7 +3579,7 @@ static void hba_resp_task_complete(struct aac_dev *dev,
 		int len;
 
 		len = min_t(u8, err->sense_response_data_len,
-			SCSI_SENSE_BUFFERSIZE);
+			sizeof(err->sense_response_buf));
 		if (len)
 			memcpy(scsicmd->sense_buffer,
 				err->sense_response_buf, len);
-- 
2.43.0

