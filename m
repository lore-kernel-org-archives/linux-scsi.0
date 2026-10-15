Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6332F745C
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025860; cv=none; b=hvGHXOiYHyccHiajciffhz2ijPEbaQ9EXG01kdDaoXW0m6p40KLdIWdXLNuhhfTFa+ma9LWsxS5w/t0RdJcLJiJJ4Nc9l4OyAZX55/6kti8nv1i8ZpJdCyvi7Eo+XUfxIAzuvwCKC3AL3wzqEUob1mvHcQL/PgIVNOmYQlUshFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025860; c=relaxed/simple;
	bh=/0Th4cc1vO+E41gV5mMuaLCXH78VA1Yl6fBR7oSaQAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsrXwsR1pJtdDeSw+qIoIu8manhz7gvwvJqhj1AVSST6o1u3nAoAJBuGfwjKaXxJy5qHhzq9I9L50uwz7JFNEbP5ZudscAZcO+or6LVkR6RBdF0u/39TM/6E/fFttutmioCcXSD4vsXxLRR1Y3vxPEeHnkQzCEH8ClTL/mOo4s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=b3y2O3NY; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="b3y2O3NY"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso725148a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792025858; x=1792630658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UPVBPUAW/BeX8HkZROCJHuR0r1MMomkKnirbqP6fatU=;
        b=b3y2O3NYh4fc6e454A6HE64TJwOyI2zRi8iFlPIN4exMBDQDfp0fU6ZXA+JwnAWpSv
         td6ssSiA4y0d2ETX5GHkhsJo198SDCebX3VU13pciaqTuROHT4je1ytRL3sinHgaFhxz
         OCFxix0ZdjBDmoMEpywvjs5fzwrce4AqDml1yJhgJMcMP2QxECxSRWa+E0xppL5GeS1L
         djw+5Xwbp1CPC08I8HURptXFSKrsFmdOZA+ZURiZWt3tEMaCqmJqKxWTI6NoWy9jKfMk
         LFU3zhuKH6nMBb1aVl8jyQcUccpfywJ2UIF4Pf5hbRDVzkBCmI9GTMCmkQvlmbAFVuRi
         KE8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792025858; x=1792630658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UPVBPUAW/BeX8HkZROCJHuR0r1MMomkKnirbqP6fatU=;
        b=gG4pWfZLxGiXfJTGxna+Dekbkbv5JbjGUk5J8fgR/YcePzm9rHFV0sSiT1N5Vuo0mO
         dJDtYUtdWRgwObLVY20EH4gRWeBWc7H3uPXvN2RCRCf2PXNrcPDVr09fyXu7RaZmj0qc
         tMcJL9i6vOyIdoaPI8u1ElHDwNNLF2Sc8trLBtWftGk8+fJtYNBM9B069kygx3n7zj3U
         gLT3cWCLTiJ8LHRKTEcZfOm3C+TCjWcu96ypHy6RNvL9SS3SWSBL4g4Fr06u0d1lrbM2
         ytB5pW3NXYTBMHUgNKsDokO9R5BdKBW3JbMbufiUgX9uzR25K1c0EOxZ9HmdrhgYv0na
         52Lg==
X-Gm-Message-State: AFq9FYKUQAgXDkvpcV6TDoUEoM7SZFptMuf0i2OLEpfNHEvXf97Wn26Q
	/BT/wvFserNwo9/6UgbVGqWCcRu0U+UwAVyxQthwU4fkNKmdeRWEa7dPBQvCXTU+Ueo=
X-Gm-Gg: AYBFou0jMNK2dr8uPkg3AuQMvSQvBJqdTPi9q4aEcCOVpupc8oOFKs++v2TcUmGlw+S
	vl084HJBEsY6YvJDjw55k6yHiohTOMUBWbJg6PQBvz/7o//Ckc80zRI/rRexRiz8G5hGtCEq6aT
	45u8wBRovbhpBX0o4ngKamNXFCUImzXgHyMyjIZwf4B4UCiJUul5Diiv/Tg3jwnCE7Ox4wZQwLT
	B59Lcc+ABt2I0TKCY0pcRLVwZ6/JF7UEZNfMIo3AN0a8sMA4qB3oTm1zXoMlFE21jvGrir5MZPB
	f6+WS/i2mgtVzM16uteLgpIpLjoYEeP5/fExYugIAApfVmAq6t9OBc4Pkeo5umqOxWYQDjep4It
	VS4Wsir7KKF/qGum7EZdGDFaNPxFLDM9eT1aMh9zH62hHfS3ZXVTONLmNCgLtGweCCMWz37w33T
	gTy44KU9LKJmmR9t+d/4wwyLIt7REk7V5kkE/G7F1hKREUp+vZ+8W9KAKfDxw/ZqEhyhjsnVMms
	BLWiA==
X-Received: by 2002:a17:90b:4a8f:b0:3a0:becb:914a with SMTP id 98e67ed59e1d1-3ab3a359f4bmr15112664a91.3.1792025858605;
        Wed, 14 Oct 2026 17:57:38 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac92a43d98sm999198a91.0.2026.10.14.17.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 17:57:38 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v7 2/7] scsi: mvumi: reject an out-of-range handshake frame length
Date: Thu, 15 Oct 2026 09:57:12 +0900
Message-ID: <20261015005717.3719956-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
References: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
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

