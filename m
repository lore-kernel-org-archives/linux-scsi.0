Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D247556BB0
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991190; cv=none; b=geVoEPVkUf9KaqhdkEhX7GOr6wYoKvOQSG2bkJCvDH1yJr/Wonkc3SmQ9bjdL62vRea1cPGXZPOXbTxWSpwRupGXwDpJV7SZmqBzPAJ8pjhdpDjJkOGLMG06ITZV3mfVDpn2pGTQb87fLvp2YqwA8tq2+6hxbspNYvurwISXvDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991190; c=relaxed/simple;
	bh=zZ4wrRNrUSlbAIRtWsrlzRF+70WmEZHyaWAMWVXvwfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LT62phCIRh2II8RrdYfJ5/AwvjRQjXzLrT5fyJYFohrvARLKCIUffQAO8XwWLFwoPFSqtfBLT253j5psFduGn39VNpjCuwJ2161Od/KTywfzSSVbD6fJLIBlHpjP5csGit0sDx2EmDpc7IcAGbSkyJ5gIYG2M2RNRPN2/tLsQwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=MyGrqvJa; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="MyGrqvJa"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ac7842c17dso388973a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 08:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791991188; x=1792595988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yt2lnf8MDVtM059brPwM3fIP69zsoLXWM8Qr1rtqseg=;
        b=MyGrqvJa/9a17O/A9tbOIwlbPkWZSgRyWttuxUOmkfG6+Mn2Akqjk/W0RwVPw74357
         hfbFfwC9n7+F9dIbmExFAv0h+q8FuGtZXmPqxd5d0o08rgArVfyOMF07xVOYv69pfY9X
         YEXI02+nLyfg0qVcRnOb6sk5VPp5OrsLa2bkD6I8sZUNhwU9mWplOBSKEnUhllbSARPy
         v8YpYIMZQwc9lU8V1LqwhTooutKrePp+dDbvDg77YEQenOXsdgnjJUNtevhcQJg6U28a
         uCS78Sw+h4bUEFAgAaNrSFJYMTptA39HnyLm66vD4kcOTbzMH8NBEmrcwj83euTk3KsJ
         KhVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991188; x=1792595988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yt2lnf8MDVtM059brPwM3fIP69zsoLXWM8Qr1rtqseg=;
        b=gDGwP38eavum96mSNoORXjvsDldOZpmdLoB9LrWT+gDQ1VtekP5f9xC5SxIdP1U+f+
         MDTzo/CxZqfHS9Icc8nG2MyhB7wiafEbnccHA6HtnwOX9x4aH0qSpjYb4EPKCzqmY67K
         bblve9fgr04QO+ci5fFzZUGwFanuINYK/5i32KwZ+V8BaDZLwlSG/73SoyOrsT1SYnaP
         9KtLfZLgC8jteJy4u7+QfUQQwQIL25TF6qJrciBg1m81H9oT7kYrreg3j8tiQCg1N41G
         doVhdDxPjrkQBDzVTFyT62iOFH5+zpNflOyLqsnGwV/VhzeIeN14ltViES2H2ctC+pZ+
         +84w==
X-Gm-Message-State: AFq9FYK6Nn7RWV5hm/yPdfenvL2QRpc4Llr/z/LBrABE1SbVVH+osUD9
	GWUvSK1zJm5oRye1VNCRI38KoKnVsysdn/iw0uUm2t7lkKhBv9OrcjpGBgX+jeM4PV4=
X-Gm-Gg: AYBFou177SjAs6MKSHuVc0J5E4PDsuxTZEjP9ZyC66aD//3Ib/4umjf6gv6C1lBQj5K
	o1p1lyqrC5d6DyATseWtWVvMNSM0STqL3yJRctX+SBe47m7GpUtCvotUa1cd0sRnTEHET76nObj
	DlTw7Vikwmgz+ZkIWO+KTMwvKtjEgB5nnBcdnVItneTzciHRZUzwd0wAI37S9W+UMkYxLaqipnj
	4KquGUvBKcG9357LRtkT/krkdPHX8Iv9nym7B7VmTDv3enN4IW6jQMlzQSmE6FF8f7xqQ11eEaW
	NH64SYCIgYdkyQI+4k/Hu4lOUNyQbSDFA5qqB2HtcIQwHrPUf/Hvniug8V7LKH2XY3sBjnkPCke
	Xg8fHGmXBAt3hpnxJSxI4OMJWR3FP3rsNDW/CXOa3xNmYgKjuYHQaSNs43JO1cdj4/+AofuyUXu
	gfzKJeF85a3kaAVppu3+Z/GCi5vjmaJAXvWwhCrdOIJggJPWsznD1Hy7i/NemGA8I9fdRC9lW3c
	+5ZSrtaHQYUqD0+hvLjY07bCwiFoWEI
X-Received: by 2002:a17:90b:574c:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3ac83c10467mr1056621a91.64.1791991186183;
        Wed, 14 Oct 2026 08:19:46 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac8d40e7f3sm622450a91.5.2026.10.14.08.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:19:45 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 6/6] scsi: mvumi: widen the flush cache loop counter
Date: Thu, 15 Oct 2026 00:19:14 +0900
Message-ID: <20261014151914.3632701-7-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
References: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_flush_cache() walks the targets with an unsigned char counter while
the bound it compares against, mhba->max_target_id, comes from the u16
max_devices_support field of the firmware handshake page.  A controller
reporting 256 or more devices makes the counter wrap back to zero before
it ever reaches the bound, so the loop never ends.  mvumi_flush_cache()
runs from the shutdown, suspend and remove paths, so the firmware can
wedge any of them.

Give the counter the type of the bound.  It is assigned to
frame->device_id, a u16, so nothing truncates it again, and target_map
holds round_up(max_target_id, 8) / 8 bytes, which covers every index the
wider counter produces.  That last part needs the earlier patch in this
series: without the reset check it adds, max_target_id can grow past the
bitmap it was allocated for, and the wider counter would then walk further
past it than the narrow one could.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 07cfac9276e7b..090ae79ec8c3a 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -769,8 +769,9 @@ static unsigned char mvumi_flush_cache(struct mvumi_hba *mhba)
 {
 	struct mvumi_cmd *cmd;
 	struct mvumi_msg_frame *frame;
-	unsigned char device_id, retry = 0;
+	unsigned char retry = 0;
 	unsigned char bitcount = sizeof(unsigned char) * 8;
+	unsigned short device_id;
 
 	for (device_id = 0; device_id < mhba->max_target_id; device_id++) {
 		if (!(mhba->target_map[device_id / bitcount] &
-- 
2.43.0

