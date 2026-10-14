Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C945540B6
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991180; cv=none; b=Xfu8lsu10pUuTkmmg9UrHldNraemo/9e3Zguq9o2JHfNNW8zyRA79Is15mygJcC95yuhl16ak6h69CQ/5v/7F9PX8uAA/TYTymrczAqyCaWq50HILjoyTPHaUq0QjydOdUvwPtlUHSdBiPKruWvk4zAXz67vVKtCehraSlyRLgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991180; c=relaxed/simple;
	bh=ipj4x06xORPFX2v4GgW5SWEG0yhRNVm2l8+JjtLGXcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzfP6oQ9IqDokctN6XFZa9YoBMOFuo27UMDUmyN+VBIu8dZJ+F9EemRTFEcKh/DO1KWz2BcezvRLnv6cckbp6vt/ACmV8XrLPAZ10ooXooxVxDXWn7CryltVfp6lCYPw2We0mvmFYixvT4+Q8Qol32ez9CiJZDG/TqXr6kIiP5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=csxrT/A7; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="csxrT/A7"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-398b3c37877so2156119a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 08:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791991178; x=1792595978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RokP+G7a+HORCP9PKoTQOgxbzp2fwVHaPKd/N4zyJKs=;
        b=csxrT/A738i0+AwwSGxc1dQWuNBFkjixwn+Tqdr/8NX9OQuoEk0NyJbA2Tfw7j+acU
         LvYkJYYPUlzRtwZTLTXqAs5GGXfFxOuURJyctMJH3hO/oZunLT4hwUFxoneoLmWY+b7/
         6+eCpj85zfTOBgFDuS7rKHYG4ENMB6gdeNFZBcHVytwk2EZ3us69dstIke/FKLbFP844
         UzD5wfCHzMIOdgIc8og2c3tdqO/YelF80Hv57fOJF29NLH2tzwl9hyUGoD8rrTuR8vMI
         OfkqhYZEoy8U+jH/GFjfWqrBn0VTRGfuVqGIOw8/msy9sMqvaHL6hOzRsqKg0TgkHMMW
         AX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991178; x=1792595978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RokP+G7a+HORCP9PKoTQOgxbzp2fwVHaPKd/N4zyJKs=;
        b=DS2rx8vp9B8tHXKaXEhsJTEv9JpC8It9rXq4JpoQu+cpnmYy23E3eRY71zfih3iZqK
         csfLcItmzXblrv8jvpgj5VlEG8eVblvXOMl3pkvQpbxR0/uMbIxm+EPzQ77wk3AnuZXF
         OKCiC6bBcYneCrvupy2t3ehEjbRA+r763Lrkgua98jr6UKmnjWQqWAyVU9nNVX/UB6EI
         zscdBeITUZppZAgL2ZfjQyh1O6+H2durKlRctIEgZwPwOcFHKE+/cq+Kw25fqP7a936W
         4tO3l9v/7eOp1jOzue8fytZYvFwX84yb0xRj9atsJNFILLot+dlqHIKJZrKYEkVq224H
         BFDQ==
X-Gm-Message-State: AFq9FYKUgc1iu2euHH7VnVoZB9kgAXQpcgTNFclwLHl6GMHNFH7U9/HN
	7X/ZfHqmx4EjVw1CHPCFHP6biERn0+X2Nt23U8Yh9UBUlMovKseulxKbALOoJo3kgOo=
X-Gm-Gg: AYBFou2pttTSrK8amRsE8CKEU9+yS8jq89kAnC70bZqdQb9Ujl7iTDDLlAV+t7d3rnJ
	R5jkZIdsavCzN0dvs6AsXEKNIzz/xD5N79Lc1fgsxeHYnkQUUTQcy47xktrMRmsiEjAAr81M9gb
	KT2Se4nL/zHMbmr7okmAx2Mfs2MNyiC0q7g8YBhTnGO+BNQkmvu8mv6nZhaDrraIoyRlAeKrDzl
	3DobDW+3PGIyx4ZtLN01uCnywGoyCiC99UXH8rtFeMHqXdYQW3vdJEIrtjUL0c0X/AlcsVOCb9r
	lh82XvADJCuqU20CuN+A2HdRrH3zbznDwe8ZwdPwN87NVKpvlzBRba209ILXDLjfZ/IT0csGbyG
	w4L8p+wVyWmiUqmbJ1NNhk/ob0jV2G5F2sb4z16LpdLMl5boLyMjgma8Hlvt9tNHhLkjFmWyZTw
	o4xj5zdxniCgPTPZjk+kSvB3ou5LdznI/jKol8fJwtAP13K841jaxFl1dw1qgTICmJaX1mDD9Xj
	zA/kqOXExcSswhQ4nVl
X-Received: by 2002:a17:90b:2d0b:b0:3a4:945e:bc33 with SMTP id 98e67ed59e1d1-3ab3af7177amr12815120a91.47.1791991178309;
        Wed, 14 Oct 2026 08:19:38 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac8d40e7f3sm622450a91.5.2026.10.14.08.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:19:37 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 3/6] scsi: mvumi: bound the hotplug event bitmap
Date: Thu, 15 Oct 2026 00:19:11 +0900
Message-ID: <20261014151914.3632701-4-yhlee@isslab.korea.ac.kr>
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

mvumi_proc_msg() takes size from the hotplug event the firmware DMAs into
the event buffer and uses it twice: as the bit count for two
find_next_zero_bit() scans, and as the byte offset of the second bitmap.
Nothing checks it against the buffer, which mvumi_get_event() allocates at
a fixed 512 bytes, and size is a u16, so a firmware reporting 65535 makes
both scans run roughly 8 KiB past the allocation and places the second
bitmap past it to begin with.

Reject a size whose bitmaps do not fit the buffer.  The second bitmap
starts size bits in and find_next_zero_bit() reads a long at a time, so
that span is the furthest either scan reaches; compare it against the
buffer and give the buffer size a name so the bound and the allocation
cannot drift apart.  Read size once, since it lives in memory the
firmware can still write.

Fixes: bd756ddea18e ("[SCSI] mvumi: Add support for Marvell SAS/SATA RAID-on-Chip(ROC) 88RC9580")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 16 ++++++++++++++--
 drivers/scsi/mvumi.h |  3 +++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 2378b676a7a78..9e342db4b8383 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1652,11 +1652,23 @@ static int mvumi_rescan_bus(void *data)
 static void mvumi_proc_msg(struct mvumi_hba *mhba,
 					struct mvumi_hotplug_event *param)
 {
-	u16 size = param->size;
+	u16 size = READ_ONCE(param->size);
 	const unsigned long *ar_bitmap;
 	const unsigned long *re_bitmap;
 	int index;
 
+	/*
+	 * The second bitmap starts size bits into the event buffer and
+	 * find_next_zero_bit() reads it a long at a time, so that is the
+	 * furthest the two scans reach.
+	 */
+	if (sizeof(*param) + (size >> 3) + BITS_TO_LONGS(size) * sizeof(long) >
+			MVUMI_EVENT_BUF_SIZE) {
+		dev_err(&mhba->pdev->dev,
+			"invalid hotplug event bitmap size %u\n", size);
+		return;
+	}
+
 	if (mhba->fw_flag & MVUMI_FW_ATTACH) {
 		index = -1;
 		ar_bitmap = (const unsigned long *) param->bitmap;
@@ -1708,7 +1720,7 @@ static int mvumi_get_event(struct mvumi_hba *mhba, unsigned char msg)
 	struct mvumi_cmd *cmd;
 	struct mvumi_msg_frame *frame;
 
-	cmd = mvumi_create_internal_cmd(mhba, 512);
+	cmd = mvumi_create_internal_cmd(mhba, MVUMI_EVENT_BUF_SIZE);
 	if (!cmd)
 		return -1;
 	cmd->scmd = NULL;
diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
index 1306a4abf19ad..5d45f0d99e639 100644
--- a/drivers/scsi/mvumi.h
+++ b/drivers/scsi/mvumi.h
@@ -124,6 +124,9 @@ enum {
 #define APICDB1_HOST_GETEVENT		1
 #define MAX_EVENTS_RETURNED		6
 
+/* size of the buffer the driver hands the firmware for event replies */
+#define MVUMI_EVENT_BUF_SIZE		512
+
 #define DEVICE_OFFLINE	0
 #define DEVICE_ONLINE	1
 
-- 
2.43.0

