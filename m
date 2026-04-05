Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB1830BBB6
	for <linux-scsi@vger.kernel.org>; Sun,  5 Apr 2026 15:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775404040; cv=none; b=RikVSnr4AOi18zBV3YNTUy1jS9l35osVmfqvHyViSwFtGqb3POrlBBDfQ0ny+2iDwC9NTvVgDHxdvWUdjstCjdXGSbG3MBxcF+T3ba5n4jcQGSCk9e/vUo2xUAPLTG9msfO6zWylw0BG88N5L80c0O5o/5aKgDDLWXH5Z90p11Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775404040; c=relaxed/simple;
	bh=KWjggx/Mo8aB0ehD/VPw1reu36vBVKSRmD0eNEQxans=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l41XqMaRsQMJmv5FWXOe25OgAE8dO9GFpqoo+zUMCtDfMoam6xvtP/6jS6vYKEQ6wk2xtBdNNV36nzJzE3EOUp4VdjFkuG1J2vVjuJer8nKadKk4vcOAHacNlHPickVmKzW4/T1wX5/SNFv9UT8t0f8ejB6ehEk2yQkxtgVhIJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zd4S+xCk; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zd4S+xCk"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43cfa33a983so1983196f8f.1
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2026 08:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775404037; x=1776008837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XH7TDXoqdU7pa9wJu9hwxRZR79gQhjpwL8M/TgWuJUE=;
        b=Zd4S+xCkv2+2r48Oop1q1sasntl4tbOG1hiUUapIgrMmTYNCJOfCsmZ6Ncu2M8dwUg
         6vgM4QSK/GYVBUCbJTEAPvueC8HtpFz2jkhmKXxLGwpZP7/FoVnJw9LgVDVUCM702Qbi
         5bS445jbT+3GzqyfgNgnEqN9SjmuD2rp3LtH0C3vBT9IyW7DisLwhdzJHEsU8kZIsH7a
         IRZPz0jDiXW4v2GXsimIVKySO3SIFVXvMiQKlSzAi5I9wyis2r8lp6hovKA/B8WSqeDp
         aaoCstI7gsUxxtSJo8QoTx+HgQRCKr34Ft6eHyn9TUOCdx+WLmgRLiZJfV+6pZss/apB
         T6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775404037; x=1776008837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XH7TDXoqdU7pa9wJu9hwxRZR79gQhjpwL8M/TgWuJUE=;
        b=sl/fcIIVR7ymAsswjM5xpF16us+oOoAjNghJxTqsM6f4TKFKffPLIy54Ce26rR7B/4
         a2C+zvYqMC7hrln0MwUKlHam3Mf4cp+CEqJvQTLUpegdANPGZTDZnXbz2jy0RTtH+X+x
         djV5CI8rWMcg8RNYob0+D9kX4Mnn9NiAF0u8HLq0HSloW/h9AKSZlUzReGyi+I2hna15
         zmcclgNMV7xvMB8wpwfkJsrob6m25z4019PLzi8uKcZ26rQg4pXFhNRqZskiITvggM96
         zR9nmwTPz4IZlVWpEVBlfSoRGpXJH/zpExektj8oRiKn3pP+JHvq7Gan2kXMzVn6jfjZ
         qKxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxAV9b9g2vMUv2eWy/9+jFLA6xdfN02/4kbT6q3VHjg4AGV8FtyMuDa+JfeGO+R1mF+jopdHSn+o08@vger.kernel.org
X-Gm-Message-State: AOJu0YwzSvvyVS55kznUtFaS0SPqnzSgX8+mYkJo98UlHuk/FxaiisFX
	pRzFMoJSlx5YmtSmXcLGuKHURMrWdFTvgAfIsFx+uL6LfrPWr/tL38bI
X-Gm-Gg: AeBDieviivqdl15JWOPn0GiJtZnuBe3AEryny9jVtPjMxCcPXheOXp4fvFyb0MsK7Al
	wTcPlXVx3vMGNjb6eLKwe3I9E1egmg7ePvuTIdiByps/wS6rRAuFj9kuUR1CbxGGLqPrEYFohOs
	5YxOXXy7yx+r6dYXrfeetZY7FB7umdjrY9mfqRAIWhYwl445x+Um/GbDH87zgau/PcXUj6LrMJJ
	Wls7sufpv+BZATtrpQ6AFZjZKPbmUkM0Sr511OU3d3NPChP98VXR7uO/7B8jIOcaYCzibHa7PI5
	SvaGxUVWTZ25xTv1UDVecL1a9OkHZOCbQUQi3MS/pk/4qHvsIz6yuiBm4J2Fj11y1d3TXHl7Gln
	zia3JxNWOeoiKcZeOdPZcjP6by7frU7KLebNm2FZ8PLnIkRD7BUzLRhA0csq5b5VQamI+rgHO2v
	Nm1bW8Hmh6Grqok4Ag/9b7oiFyi1ojkfSb78Gx2+RN5+0Rt6V5+3z4lu0QLaQtjvB7LQxLOzv7k
	MpNEkGSfz4MuZQb+CXdRJw=
X-Received: by 2002:a05:6000:2389:b0:43c:fa77:f71a with SMTP id ffacd0b85a97d-43d2929d761mr15340536f8f.15.1775404037129;
        Sun, 05 Apr 2026 08:47:17 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e2c50a7sm34399150f8f.15.2026.04.05.08.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 08:47:16 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Kees Cook <kees@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v3] target/iscsi: use get_random_u32() where appropriate
Date: Sun,  5 Apr 2026 16:47:15 +0100
Message-ID: <20260405154715.4683-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the typed random integer helpers instead of
get_random_bytes() when filling a single integer variable.
The helpers return the value directly, require no pointer
or size argument, and better express intent.

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index 75c37c8866c8..81e28e567a01 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -102,7 +102,7 @@ static void iscsit_create_random_array(u32 *array, u32 count)
 
 	for (i = 0; i < count; i++) {
 redo:
-		get_random_bytes(&j, sizeof(u32));
+		j = get_random_u32();
 		j = (1 + (int) (9999 + 1) - j) % count;
 		for (k = 0; k < i + 1; k++) {
 			j |= 0x80000000;
-- 
2.53.0

