Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3AB3EDACD
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 04:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792039954; cv=none; b=fsYG/fdrAKncfcU+4IKvhg7ztJ4HlDP78y0uMqYaqSNbVemiQmuoPEJjKGM42nDtR+s0jBxM0KSb0Nc5m1OZWYmQnYaI0qUl1s1vm2WJs4X5sxs1YWRxfsdvXxTXvOZEZQ3fSsV63EMnDRPce+3JhxiOlZLjAt1RbMKMxBufH2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792039954; c=relaxed/simple;
	bh=A9dZqNlJD9WYs+GSLH29AUnwq+8L5IzDDOZ0LYgLQg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKprXLLjag9YtQh7Rh0FGN/FN2Sb9/gMPJWb1n7lQJ6QVQgKXoCaTGtMm6+s9mA1GkFht2LJS3w9XhjLH7ae2wY69gMR8vsaEsees4hLnn7u5AiWdSNHfMn+TcP5ql+1apPptIxm0EopFPJNUCl98L8nr9y8InvIjTIBz/aDGIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=ljzYPIoC; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="ljzYPIoC"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e95b3b52f2so1936645ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 21:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792039952; x=1792644752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qB5u2eAth6kclTEDr0WUXrH+pdbrWwKcjOH4XM8d050=;
        b=ljzYPIoClvqjfi/yNUahQ0WG1gz10QoRd5L/gCJ/EDMrbxxj77YRANXxroyOxD2nVB
         QmGPqZYrX2qMLuBQv9SWXuZzo33ObSJ4VPgPmgGivUCnARAmBGImNEJvJYa8svfGDVEz
         PWX5exQxIYXXakInY6ViFHlY4G8NErxIdZearYNjyLcDxMuNguOSupCoi9GgP2jcUYZC
         fCOVnK7YfeQbWFim+4k8cqxOBicXcgcnartcAQ3L23Z9M0/qYLq3oG7pTik2lnVbQQ9m
         8tCZy+LAnRQyib3aO2IJUB4ZI/23ahwUeOQ07z3Y+i23tK9iUDI2clSAJSlQR1jWShSn
         jGog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792039952; x=1792644752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qB5u2eAth6kclTEDr0WUXrH+pdbrWwKcjOH4XM8d050=;
        b=gmVKzoj+UI0B37xezhg0PAr6wjcel1+T6fVd//fUL3x7LTELMHZXTGclW6zYTZ66Eb
         Jvs/YBoi7AqAUWmlo/B2Gmy9CFHjDjo262XHwnkFrBwyThM0hX65EEMlv6IY6O9wt8Uw
         WUmSWHuVDPMAzrOFm64ndq0TBex5dpmJM1rUv/s4J9rpQ2IM0im0JY3d20cgyNzCcWbA
         Q+arxgTy2iDQOqhh61xX6KAsri29/foXp97khvarpsIPVRQJK+ShBkmAGpzar+i7eSnR
         w640jIXPFPW5hlIMVJ0w9nuBhiH16hN7tvXQK4hwW4iJZv93Xtz46Xm74C59VS9k/yiz
         AtxA==
X-Gm-Message-State: AFq9FYJT/+cnqun5hlJzV6zQHvQvmbOTpAXx6KQW5Tk2l4uxNBRSIx83
	TUQDHbYE47QAQ9hWMor+TYHoV8fCEra+pCBiz9Bt2NB4NDczW2ybxql0X9wImtrD+YE=
X-Gm-Gg: AYBFou3mO5HRqfWa/VJfu6tx7KSPlUJt1z0cPtq1G4gzCCUG0lcDFJGMM+X0T5SQVH3
	596BzspDqAHhqryGHqnGz2mLYRMco7vzFe51pcL7dGLlum4LLVkjxtoCDlIFoYGFlyZVMSdc/cP
	7OExOepOdvcimtqYvAPF6qQe5SRvyjNA3lJQGrHF1mw5w/YdLny70dsm2D0IR/Ib84ZAYnkfORh
	VZpnZJE4t7A/8Iqw+pESl1TbqTNkmELjYVrXI4n3QYCdPb8MUkv4Kp7OOeJ9OyI+GjOLljRDH04
	jqqefvyb3FkSurTufUwXxtYZlQqr9n1gJfZLsnlBJy93vvP68I2FzS7Nn9WEKjKQLfzNGAgL3Y3
	nPmofXcul5j0Y+cFtoQVk8CADzytG0O65g4CqflofkWgx5zgldJd/ccagBIa2mJZHvm2UdaGLnu
	rl7TwZ+B6+APGd7upJRTYsb81u17IoVZAa0ABCJ2d8Flm389e18tmLEqDyJtFGhosf0qEY6Qfiz
	LNwuw==
X-Received: by 2002:a17:902:f650:b0:2e9:5507:b538 with SMTP id d9443c01a7336-2e95507b924mr18630555ad.3.1792039952157;
        Wed, 14 Oct 2026 21:52:32 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e962a4dfbbsm1615915ad.58.2026.10.14.21.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 21:52:31 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v9 4/9] scsi: mvumi: walk the hotplug event bitmap a byte at a time
Date: Thu, 15 Oct 2026 13:52:08 +0900
Message-ID: <20261015045213.3975845-5-yhlee@isslab.korea.ac.kr>
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

mvumi_proc_msg() casts param->bitmap to unsigned long * and hands it to
find_next_zero_bit().  bitmap sits four bytes into struct
mvumi_hotplug_event, so on a 64-bit host the pointer is four-byte aligned
where the bitmap API expects long alignment.  On an architecture that
traps unaligned loads that faults, and the second bitmap, which starts at
an arbitrary byte offset derived from size, can be misaligned on any host.

Walk the bitmap bytes instead.  The driver reads every other
firmware-supplied field natively, so bit n of the bitmap is already byte
n / 8 bit n % 8 in practice; writing that out keeps the device numbering
this driver has always used, needs no alignment from the buffer, and drops
the long-at-a-time reads the earlier bound had to allow for.  That bound
stays as it is, which is now more conservative than the walk needs.

Fixes: bd756ddea18e ("[SCSI] mvumi: Add support for Marvell SAS/SATA RAID-on-Chip(ROC) 88RC9580")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 9a3dde53dea97..18964e860ac8e 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1653,16 +1653,15 @@ static void mvumi_proc_msg(struct mvumi_hba *mhba,
 					struct mvumi_hotplug_event *param)
 {
 	u16 size = READ_ONCE(param->size);
-	const unsigned long *ar_bitmap;
-	const unsigned long *re_bitmap;
+	const u8 *ar_bitmap;
+	const u8 *re_bitmap;
 	int index;
 
 	/*
-	 * The second bitmap starts size bits into the event buffer and
-	 * find_next_zero_bit() reads it a long at a time, so that is the
-	 * furthest the two scans reach.  Bound it by the length the firmware
-	 * was told it may write, not by the buffer: the bytes past that are
-	 * still zero, and a zero bit here means a device is present.
+	 * The second bitmap starts size bits into the event buffer, so that
+	 * is the furthest the two walks reach.  Bound it by the length the
+	 * firmware was told it may write, not by the buffer: the bytes past
+	 * that are still zero, and a zero bit here means a device is present.
 	 */
 	if (sizeof(*param) + (size >> 3) + BITS_TO_LONGS(size) * sizeof(long) >
 			sizeof(struct mvumi_event_req)) {
@@ -1672,25 +1671,19 @@ static void mvumi_proc_msg(struct mvumi_hba *mhba,
 	}
 
 	if (mhba->fw_flag & MVUMI_FW_ATTACH) {
-		index = -1;
-		ar_bitmap = (const unsigned long *) param->bitmap;
-		re_bitmap = (const unsigned long *) &param->bitmap[size >> 3];
+		ar_bitmap = param->bitmap;
+		re_bitmap = &param->bitmap[size >> 3];
 
 		mutex_lock(&mhba->sas_discovery_mutex);
-		do {
-			index = find_next_zero_bit(ar_bitmap, size, index + 1);
-			if (index >= size)
-				break;
-			mvumi_handle_hotplug(mhba, index, DEVICE_ONLINE);
-		} while (1);
-
-		index = -1;
-		do {
-			index = find_next_zero_bit(re_bitmap, size, index + 1);
-			if (index >= size)
-				break;
-			mvumi_handle_hotplug(mhba, index, DEVICE_OFFLINE);
-		} while (1);
+		for (index = 0; index < size; index++)
+			if (!(ar_bitmap[index >> 3] & (1 << (index & 7))))
+				mvumi_handle_hotplug(mhba, index,
+						     DEVICE_ONLINE);
+
+		for (index = 0; index < size; index++)
+			if (!(re_bitmap[index >> 3] & (1 << (index & 7))))
+				mvumi_handle_hotplug(mhba, index,
+						     DEVICE_OFFLINE);
 		mutex_unlock(&mhba->sas_discovery_mutex);
 	}
 }
-- 
2.43.0

