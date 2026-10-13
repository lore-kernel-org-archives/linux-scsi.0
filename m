Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A660F489892
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912723; cv=none; b=ApeWSapIKJqrKn+SRZaOIQ/hwsa5MtE3VFx9bvkKuUgAVbE/2hyECQkOONDDmk5xUmF6VFpwKEMMltLBAogxN5SNZW1EoFP4YqWJL1t2fqM1eO9PLsukFLBNiUv7szOnvtzT8czvQ4ImjiwzPPZiFSDXGmQ2oiScEBMWsD5auxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912723; c=relaxed/simple;
	bh=mZ+27cf/ial1Kmh8g9YuKRqBc89avEfQ355XOYWXwMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZQt0ppMjNvDBoDBVvx/OK/wFvXU3soWlopMOGdlk5RF1XKA3w8MfA+2I4IzdHXVZHObcKFjovsaJptKYqXeV8jUu7EIteapTcKIeCBrX2dPwYOl3l80kEU3lMFrqx+K+7/Qzamd/SvuPzibqJ6FoHAxxHIIaf5owmufBcPrDHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Thp24BMc; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Thp24BMc"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-88b5f43cb8aso1041010b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791912721; x=1792517521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6gF7titqAQOhWgf/cID4J3N6cuUz4241e7eJ9tfRVLQ=;
        b=Thp24BMc++oldWYY5fJ7dvx+TdCjnRPA4JnxFYP9mLFe2Yt5QA1V4bkIt29GoVaFAH
         yX2JegtgW4zGXUBgD9KTzqhGSczjsDkvmra5VVMYGV5trlrTQou7NbmiBOIlpiKJ9ARb
         3Q9RTwS1376Hzf7gyxY6VX4u4iwQm/r5yYYa/FpgRAOrw/cnMiGuSWzUwquh09vdYt3d
         K5o65iluAV+5+gRAMYSLF/sdSo8/pVCmfXcuB/SZ776bmArJ4ffEw7XYh4vjqEI0NJiW
         taYkdd+e7Nibxm00WEsg1XGqCQgHMMVSRiwQViulwzdLqSzJPP3FjZXB2SkPXowdFXdK
         b5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791912721; x=1792517521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6gF7titqAQOhWgf/cID4J3N6cuUz4241e7eJ9tfRVLQ=;
        b=Ujz2zogj3UcM7lzdBJVV8ogvtVnIkbI/74WPEdrmW/KeCKgAl8hQqWNjLneEgn3Yrp
         D8iA9huoINeSd1DH5yw9eaWSOwxQuLcmPHsyRwTQYbu+yFSVl/2m4OODZBMvFj3IqET9
         FDKqpa6Ga7+vVE6BXSPUX2LCm20Wk/Q4gLWmPAzkuK5uTWLt2e3L0YEXKpaIMD5intNi
         YBbkd+bt60NzHSEiqIDeRyrltOafsbAa15nvufC+558EFihNyJYjd8epR/FvCZ/OOh8/
         p0fW1gcRFW3vXTku7GM8ERkPIm7pYU9Gfng+Tu1MW6WqqXmmoHqFbxzBLnDUiAmTi4Nu
         nzNg==
X-Gm-Message-State: AFq9FYLaozHvT8XTWW7mkE3T5EBl+drwb5LWN8m2AYlPVm0sp9yFA+k9
	qNXplXLYDne89G9ZLYoQUZGslk8OXEvYvc9W9pBwkjC1b3UBj9U+7uJW/1kXYWqJv/DoMXgU9VH
	03rbbgAs=
X-Gm-Gg: AYBFou2qW8yZQ2Ssj8rUikBxl/OdEW2rYpZyzaayBX5mmqbNmwSrpp6fX/umPoUK+jR
	pnNCknmPGhC8TkVoSKgrvvR+LliJ9c+r7hYQvYZtJ4ommaWdhHmOBBmarBZM3SEDIAAPUXSoVfz
	9jvUQUaooBJnF0Xcn5b9djKu8dX6qn4sA/Yg30l7GDlQ5x2slU43z0sbyaWQnURq1HedGmyQszb
	S7LI4CgUkF8yEbZ6+rtPKX06GxH9YZ+lHocR2vJ9f5jtVLY9z/a/LeZBGT7fzyraLEjKjAZy6dt
	uc5W7BBVrJTZSXqWlHhGMR8yYJZnR8of9BAa7bfbd/1u4oEYcTiXBmCdr+qS65DpGHJAwMQY9pr
	dWBzCooqy+g7JDTjYBrYTfVgKN6yqH1sQBbLsz9Y1YoHR9UcxuvyOs2Br48eOiI7kT3RTg5VNEb
	cz6n/zJmBQKdDo0BiXHpFe9wnU0c6R00Eyh8BL5ZZuBjTPDtLMgw7iWiLSIY4outROx5QxnKkDK
	asbRVW8VZmItGggeR3+0BnHh/+QOTM=
X-Received: by 2002:a17:90a:d006:b0:3a8:6a04:80ef with SMTP id 98e67ed59e1d1-3ab3a2901c2mr9313055a91.6.1791912721027;
        Tue, 13 Oct 2026 10:32:01 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac6019ca59sm607396a91.9.2026.10.13.10.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 10:32:00 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 2/2] scsi: mvumi: reject an out-of-range handshake frame length
Date: Wed, 14 Oct 2026 02:31:45 +0900
Message-ID: <20261013173145.3412863-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013173145.3412863-1-yhlee@isslab.korea.ac.kr>
References: <20261013173145.3412863-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_hs_process_page() checksums and parses a handshake page using
frame_length from the page header, a u16 the firmware fills in, without
checking it against the HSP_MAX_SIZE buffer the page lives in.
mvumi_calculate_checksum() then walks frame_length bytes of frame_content
with an unsigned char loop counter, so a frame_length of 256 or more never
terminates and the probe path hangs; values between the buffer size and
255 read past the page.

Reject a frame_length that does not fit the handshake buffer before using
it.

Read frame_length once into a local and use it for both the bound check
and the checksum, so the device cannot change the value in the DMA page
between the two.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 38a92f8c25f5b..910505ef4f3ee 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1039,9 +1039,15 @@ static int mvumi_hs_process_page(struct mvumi_hba *mhba,
 {
 	struct mvumi_hs_page1 *hs_page1;
 	unsigned char page_checksum;
+	u16 frame_length = hs_header->frame_length;
 
-	page_checksum = mvumi_calculate_checksum(hs_header,
-						hs_header->frame_length);
+	if (frame_length > HSP_MAX_SIZE - sizeof(struct mvumi_hs_header)) {
+		dev_err(&mhba->pdev->dev, "invalid handshake frame length %d\n",
+			frame_length);
+		return -1;
+	}
+
+	page_checksum = mvumi_calculate_checksum(hs_header, frame_length);
 	if (page_checksum != hs_header->checksum) {
 		dev_err(&mhba->pdev->dev, "checksum error\n");
 		return -1;
-- 
2.43.0

