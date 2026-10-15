Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1703433F8AD
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031268; cv=none; b=MFI1WZiJkVIM73zULNI7fVbwAX1Lc8oNVWOYmTznPYSf4GCBI4Frsn/1cHiAsxCp04MNUtjJE+h/QNFFXQmCrtY6O1NRzR54NSg++/lPjqiSnrE0hiDnuqLj0CIbjDbYV2142uURsDrK92kj6Y8mJKK/xddw+Dajd54hTg8x3F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031268; c=relaxed/simple;
	bh=/0Th4cc1vO+E41gV5mMuaLCXH78VA1Yl6fBR7oSaQAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tshvI/E6mx8C9rJ7B71GyE/+qu98d3oY+yDTmopAh9OnWNU0DS5+hBDYhWcwvGXOJytbmIEeGSsiM4ay1sjVUFxgzGIMLJNNbj2U6qjqBKOR8FM7elapxuzjuUIroYFj+WxB8P9xw0WXbu5SSjur7EKiCpzdOOSBadeer7029xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=dizI9T/Y; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="dizI9T/Y"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4ca696de6so2614643a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 19:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792031266; x=1792636066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UPVBPUAW/BeX8HkZROCJHuR0r1MMomkKnirbqP6fatU=;
        b=dizI9T/YfTT2XTPWQ9LDHD0oWL72l7L/W2N7b7Ezk95TBsyQMZm8fP7eJ3oyh/uPr5
         1YfB1U3IuAr/lmeU2bT9NQvst0OIcZhm8kLYfCasWB3BsACXZ0Bt1GgSEOHz+185rDHL
         U/ppNCfyBYSd5csa5ocfyc1iDksMcsnNHoZRrhdikvLJscaVYfdZQORVYkNWmGh8zrOg
         lfNharDrCtDpwlbIRonlSs4ZeJtfmsSNZDGNRclRtviu0PrKZZsnkbSxLEol/+5cOj7K
         ix3fHk+QzvuQD3N+qTc1FFuCpCUAXeRXkG83PnO1LrUOsdRbnWEoT+uNHmziTU15IoxT
         E7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792031266; x=1792636066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UPVBPUAW/BeX8HkZROCJHuR0r1MMomkKnirbqP6fatU=;
        b=u1BF/5SdvhNHlpW6I9f7QXHxCeCyMCMegAFK4GeLk4e7JJNZjiJOuWrG4XKxT69hjn
         q+0Dt0B65M8C52ytzVWhyfEk+VTzJtAm8XQuY5V6MXiqSRVNo2cNxHKTDZ0jixRhHkMC
         Kz33a3wj20Xc8ZR4gQ78HM6LO2Erw3h8jSdu2gOcgwI7vntSuL39bgOmob8VI4ivIlpr
         NxdPmdtPzQGEjNA4W1vFCbE8UWV/fZBv/ao6iZ7DEBALBp3brirnwNEWgghnYw7OFAyY
         WqMxlo0Uf2zvUqGxyW799vu1tmtmqYbjMk6/kml+qMj90ZLy3fe1E3xvz4ittYX7borL
         mMtQ==
X-Gm-Message-State: AFq9FYLvQufwssHkiAGftwZ6PhrtJUhulnlq09VulwlJ/O5rEvFzsowm
	BLxU8oGatyBGnka7d+BPyATopk80/RePZLu+Pl+zCDKzBlcQQYB51/tEWISrot85BW4=
X-Gm-Gg: AYBFou2hSI/BprZ2ZQ2vb8f4rmtGTBsqU0uMHva0Yo874TpawcfShcDgKHt+paHwWMC
	WH7I4FB07qMTKDQCdldULXJ4umualGx8K4FCSI5DMfBKFeizlgbccNLgMNpNwcDbj7koJg1DoNk
	qpus0kQFFBTh3wdh4FLqBlVzIpsRE/K7rN3GnktU3ryXPTQQgFc8hx5635DoLlCTg7Gq/p3FaOS
	hiCW5VfSRwehnSNBpyVLfNSRSzmmQKrTbW/k9hL88OM4blklV7gA4DGJIcjmJj5DLUZ6vxOwhuu
	xavId+gn/O4oCNqGR+xJWBUs1MhMIUheeI9Bl2N8O2O2DCrK3+tcEgMogprzqe6w1Cldhok92Rq
	todCWFuH7jYG4h9k/lSktCezYTfPAdYLLsqc7t+5fQbQlLa7UTrvZkDO/FfYGc9FkhNS1thOKje
	zL/Dth4ui2is0lG0eCx+PGnPOq+V1yQdC53/ICCta3ux1U/3Ksn988xIrjOWMsPjtEcJSWzl7Qc
	34Jvw==
X-Received: by 2002:a17:90b:2805:b0:3a4:ad5c:d48a with SMTP id 98e67ed59e1d1-3ab3ae69636mr14696943a91.67.1792031266410;
        Wed, 14 Oct 2026 19:27:46 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94375f3fsm1997383a91.4.2026.10.14.19.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:27:45 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v8 2/8] scsi: mvumi: reject an out-of-range handshake frame length
Date: Thu, 15 Oct 2026 11:27:22 +0900
Message-ID: <20261015022728.3936714-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
References: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
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
between the two, and use READ_ONCE() so the single fetch is guaranteed
rather than left to the compiler.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 38a92f8c25f5b..2378b676a7a78 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1039,9 +1039,15 @@ static int mvumi_hs_process_page(struct mvumi_hba *mhba,
 {
 	struct mvumi_hs_page1 *hs_page1;
 	unsigned char page_checksum;
+	u16 frame_length = READ_ONCE(hs_header->frame_length);
 
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

