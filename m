Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8450B37B00E
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 04:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792039949; cv=none; b=cMny5QjSgB64rUdvvNnngmXmQZ4SD3I/YqrXRTohSWI75cO392QNYsdKve5AJ82lKiKwKx8pg/GLieReRrl0B6ZRsymOgCvknfrTQoy4vFp8WAuoSr6nPXgbu+osmgejzR9/qDgy511yYpQCat5iLvd/AHbGozTcYMNuJ+kNqQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792039949; c=relaxed/simple;
	bh=/0Th4cc1vO+E41gV5mMuaLCXH78VA1Yl6fBR7oSaQAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpp6xtlmkGel44G8MVuGW4M6+HgF+zQBAYhu8Ds8z1+ny/yCzMgC+utl2E3VRmcSHJ69shg4aeg7thJysPBIIf1NIj2+g49Q64G0kc5Tbljn7T92r6LgsiuVyXglkbiEA2FUrrLezLz8Tv6dk8id7qQBxSvz6VDXbyLlB6AlY/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=mkWE6euz; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="mkWE6euz"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2dd9cbb661bso35256025ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 21:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792039948; x=1792644748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UPVBPUAW/BeX8HkZROCJHuR0r1MMomkKnirbqP6fatU=;
        b=mkWE6euzGyTAdf+lDfZhrNui80qNznid6rev1CV/JaWUj+gCq18LtbNSdxQooXhgEA
         mf6+0Yh3uUjAgOAJwiFxr1N6XtXF/idBt38Rdu8q11cq5AIKq9mBKeA+PjHTdFrdn2Vi
         oyNlBZH6I3/4P5v9jcmYEDuXxEQtmJqVY1LowkGllZqJBu1cW5I9WqCA5woe3jbjprIB
         hvaOxaxhJvwJGU8yO33I7DAzBBQM9VJcTYFjwWUo8p1UuLUNoEXV6Jdaek/Ev+u52pR5
         uVktikOIr0FWHeLlq+ztND2aD/y8QKm9ECi9dlm7/49Y2YFe02KFjOo8+EoAp7plhVoT
         e3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792039948; x=1792644748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UPVBPUAW/BeX8HkZROCJHuR0r1MMomkKnirbqP6fatU=;
        b=l3F/VdfO/ZqKJ4OAXFVBrk3p07NdTacFkqoPlPqGK+8og20SLvx1PlAWR7kOxXVDcx
         e02y4eNMD0i0ENmNVPUD0yLpOs8QTIkA35C9tuhT4Old3bGBr88P0Pa4WOQPUUzOZUdW
         cwne6BXBItfN1+Rp2iVafxjVz1Hol8syPUREX5o15DSNG7iIsCnyUu5zUVH+4ERSNJ7I
         7yMl1HF4WkqNCpS3Dlek4E7ZksALPhtiGTndkkAPgD+vhkpDwZfLA94JkOmwZYpHrKIE
         XIctdWGcxFLwfw8zJunvrLje6q9ITmB9XLvnKs8XY5IMOjnKY0HwYjHtZb72K3rnogjJ
         epnw==
X-Gm-Message-State: AFq9FYKXym478XFOxF9m7kz/bfz/RlpatCaNLoAPGBxBOlVL4YSjeyJY
	u175wudsMD0LPAUclSctqELKVLJ1eI/VzPEWeUyo5m93nXlBpBFz0TUphaOn6LXc+PDwpf6Q0J+
	teJpK
X-Gm-Gg: AYBFou2vNf1lzV71jIyfJGD25KQpszZz5K6m3kSKYWn54S4+ISS2MzxVk/hRXqMR2Gy
	wnAQ7GkQ+j0wrY4DAeh7+jDpCuGDdUBDVFdINsYgi+2nbozQZhouxCPr4mz1bXM/18jc2/WKkYt
	L6E72T45cQLEahSqirfPPcYy47Hy5ddrJYG4ZtFfud+t7GsTrUVkgrnr4s3nSZGghaeQzaU/V2L
	g6pnBYEklArZPzIog4/Y7OUzC5e91wtaTAAVQFLnhkTLpzGcPs/PZHaO5gV89utws2Q+iiAYZGf
	CQMfzQTbS/8wjADc/+mKg4ASKKWZje6MkHjS3X07S0R9Fjp3c9RDlIgFo4Iq9oBhe9jE7bwSaOK
	HgUzyRmNdKTcEZm/AYepeHX4BNgOqH/vuCPqbhtNJ3ubhC6pB2uATG4CKrEhrbqBAl0vOGpE/39
	ib4s6UM+nwJIO3IjAGsfKpIOFuGDh7RN/4U2AkQi+EnuN4Ob03lSYwsUg68VUqWShB7VmrXmj7x
	dh3cA==
X-Received: by 2002:a17:903:22c7:b0:2e9:5eee:e087 with SMTP id d9443c01a7336-2e95eeee1c1mr8289565ad.43.1792039947945;
        Wed, 14 Oct 2026 21:52:27 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e962a4dfbbsm1615915ad.58.2026.10.14.21.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 21:52:27 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v9 2/9] scsi: mvumi: reject an out-of-range handshake frame length
Date: Thu, 15 Oct 2026 13:52:06 +0900
Message-ID: <20261015045213.3975845-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015045213.3975845-1-yhlee@isslab.korea.ac.kr>
References: <20261015045213.3975845-1-yhlee@isslab.korea.ac.kr>
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

