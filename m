Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA02B517BB9
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908199; cv=none; b=Z1o1T2a6kqOhS9do4Mztlrjld7Rd6pQdavIiMsJS3kBbc0RfCJV5k24viXpKpLfZ3lWO/ovqQfgxlZrVeOUQxcf5DB+7lLRcasOQv4VmZL80/EDqsIt56NeeNJrTO5VjdIPs4IeIhonFAYGKd5tznpRFx3rl8g1k4mlf/ve/DrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908199; c=relaxed/simple;
	bh=6BMwdsi3ofoz+bipxdz7wykMCA0g4jyIQITHzdnkJnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbvMIBzzfZp0PuwoNxiUU15gs62Cbhnz8KKdDVaW0i4ALLbq3PbubbdawvNXb28fPeOzoLQKJZT484BdquxtH/JlxQQga9n2UFogkdrhqYFEUy946asR3aim9C3UUk+V2jTd88x0/y4xizOq6HgVtbOvd1/a9+9/UR+NWTs2L5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=0sRYIJZa; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="0sRYIJZa"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3a4b9732d5aso2402489a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 09:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791908197; x=1792512997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K9zJQoLv8Tql7NoNqNEI0i7VSFA1eBmo00WB94NShbc=;
        b=0sRYIJZatomYPwE/grE+dLyVKAxYVoaUDKB99Xu146rYXicczXjFNmuX6PHlTkYiFj
         e76t29qmsuxGqoht8KVk1tl8DoW8JN5lzqSQ/hyySH2V2dFN+XTa/uxgvt/zOfFRbbli
         Y+c9GDB4j0h4Ew+5/4ot/Wf6tB2R0A25Xy5AFjQ1RnVDH31wt0YDuAuH4O5+jFrYndra
         XWjjWDFJp6FRwihmBOtIUTX0anWoxssB4aVaMOKDFbiXL2q30M67KbGgScQk+a9ZkBl5
         duL0f8Ba3n54ZZ5zt/tEPubzCtYJ02MRwjpRIRGw3BoRkuuZ3cRtwVWpdU1PfU8RGWsn
         HyRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908197; x=1792512997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K9zJQoLv8Tql7NoNqNEI0i7VSFA1eBmo00WB94NShbc=;
        b=SBytbAj2bqeFbUJN1jP4xBAHBkHGtTi1+miB7c94oRKioTToXWOHTyE223Y8BaY/sD
         3hVeVdZ+3KfrLUx0CL7zV7BUMGuUpCckx19Dc8uoT3F+7ZgyGqpKDCi6P0Kr+b8gBsih
         Uz8ePwWsBJBmaJG10uyHnMD1Qf6EAhZKme3yMIr1fiW9HGeDy4gdYsy/oKX9yRgH/K7k
         2tIxPDvxsGXGFUqJcrI00kkMagUk68uMm8O00HbbnEMbp9Pj9lxs2HPbluPBUMnJOiYt
         UVKY6+sC20Za4jDb4pZ99Sjn9fAuDXGONhN3LUL0a5s3+Gp3ixkYwA6UEJ2sJA2j4uqf
         /z+g==
X-Gm-Message-State: AFq9FYLA8QpiW/vhKiaK2lsIx2xIqO2aALI5XAfE6l1Nb5E+PADlQ8r+
	BS/PBlt9HD4+v7FEOf2mmSebgue7Qls3QAdeUGaaHzRKKhhTM/UCva5LsLLmKIUY9Ds=
X-Gm-Gg: AYBFou2YXzVOLrRdqk1eEZF59iyAQjy7NXTWa6mV63TO9IKbZvv/q4bu5wtOM2L+SL9
	hgQwNAYteVgmLDxDpsjsS60gjqGnZ2rFhcPh5Q/TSxXhO8uNCAuxI5Yhg+vNJwxWA2x0jxKdyNY
	iMfVjkspQY7vPxIOkxdg2/iXkOy5n76ETb8xCMNg9EZ12jj6pxslSdBpdmbyaXhWgYBVccPhnq7
	eKYbsoYkcUcme/kT4XzbqkRGhRL2VphJeyuOaXOdNP5F/DtfUwwYhVgsnrGvlpzfV3jSskQV63z
	FCuJjvJiEk19rH9Dj9Urxq62/mB7PKtACfUkxwyvARzMmi/I/wXxPra9nGeQO1GOfIYoQEbtMSk
	0fU0outTz0SgSnyEFTWIoIKIRO58Wyl0aOS4TOLTAvqfIC3qVZG0daJEhdgmiCTnX23IH+1Pi6O
	L9kKbU/Y/fvC+qLmBwrImdfOR3Ldwotd6BZCVenDxmHAEaup0wdCe5UuaoaBGXENQ2h20+0qbn3
	x2zpwPgljLETpB8qlVGfVm8gl2JoIs=
X-Received: by 2002:a17:90a:d446:b0:3a0:5413:49b4 with SMTP id 98e67ed59e1d1-3ab3a9fa33fmr9197790a91.39.1791908197099;
        Tue, 13 Oct 2026 09:16:37 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac600642c5sm202607a91.5.2026.10.13.09.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 09:16:36 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 2/2] scsi: mvumi: reject an out-of-range handshake frame length
Date: Wed, 14 Oct 2026 01:16:20 +0900
Message-ID: <20261013161620.3210533-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013161620.3210533-1-yhlee@isslab.korea.ac.kr>
References: <20261013161620.3210533-1-yhlee@isslab.korea.ac.kr>
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

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 38a92f8c25f5b..e85400291a141 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1040,6 +1040,13 @@ static int mvumi_hs_process_page(struct mvumi_hba *mhba,
 	struct mvumi_hs_page1 *hs_page1;
 	unsigned char page_checksum;
 
+	if (hs_header->frame_length >
+	    HSP_MAX_SIZE - sizeof(struct mvumi_hs_header)) {
+		dev_err(&mhba->pdev->dev, "invalid handshake frame length %d\n",
+			hs_header->frame_length);
+		return -1;
+	}
+
 	page_checksum = mvumi_calculate_checksum(hs_header,
 						hs_header->frame_length);
 	if (page_checksum != hs_header->checksum) {
-- 
2.43.0

