Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0265C2FD665
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025863; cv=none; b=UuFOySbui4uu0bSOV+77acXUwuwvipXhiiktSBQMZba6w9xYNnaJhavLwQnpSSBaBLvyK0c0bzTNvs/A9ML8I4p9GbTWxCY6fNrzD7vhKFQMdideghT4++sARIDp/odedPVEZKzkC3EZodm8fR1Y+3I1qrO8X44LC/LEq/7c4iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025863; c=relaxed/simple;
	bh=d/UWuIDLttRptXRjgPCr2gHnKIUlkWJphZ/F4/3NVHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPaNFGk528rhXrXuMbMTr0edpigCDfrLjoMpKlguKdT6rNSW4ebwhH6NVRCi6CdhVoOZt5xUC/KXVNAv+6+KoPFbLgUWC7C2SuAkgW99F2l0Wq2TFY3B+FX1xj0yNUKobhHLJxgzhMxsMt27ZkMULHtsEoEw1v/44VHJyazmUwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=QVAw729d; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="QVAw729d"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3a80d1c98f5so670421a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792025861; x=1792630661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=parD2IM7xfaD1K9JnqVrI4SVPT6JMErPe2GlYkxbGxg=;
        b=QVAw729dcca6gKV2kmVL6uFQRZIJNxeiOU6tsLY4zkEuJBU9wVl+hikTwWVHj7eHma
         lR/u0EFP1mML0L5fwy78paRU39IDaWnOWU80IGaRNR5cCFnoKcZgZo8asEyg9k4TDeG6
         jqfi4epWHfvGwpiHLT0/opPyXRtumX2JpYSINPYTThK/iKthkZmCoLW/IJ05AclHhCg/
         A2YWu7UXmN3naxLn2ZsgdZpQGqkUtOOQlEup9JqtouAtHi+GMwLkuPtDbxhh8hK2NagA
         4pLBxuS8U9N577XBW3RZmD6UgPZBKwWPZnBvPxCKaslcJ8LjoEsIWF12pLmEk8tU9X4Z
         qjpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792025861; x=1792630661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=parD2IM7xfaD1K9JnqVrI4SVPT6JMErPe2GlYkxbGxg=;
        b=TU1RUKodnEbC38EomL9jf0/Jtg8HWxnmfGho72iBmw4cO2qKM2ZZcV4qToL5yHXREC
         rNO9BwnpSfQzVsecz9l6zHHo4cc+dXPbACAOPWDtetGJANiqTOpc3aDCjh/71d+/nkB6
         7uqdb6Pzq4S6tn2k+yD/XBJ0MiQi4U4IGjtRKwK4fE0JG69FTfZB0hEQTzWgj3udE55t
         CI1FCtbSk8XIKsd7SqqKfwmhy+xnUyhYHkHp14luJID9IhLDRgXUAv1ofb7690WtbQ0O
         CH225rP2dwu6DxF46MXgEnfBNRrOlIBessTGcBzcMjfyc0h0XzCeJLDpTwyoQB6Fo+Ca
         jiAA==
X-Gm-Message-State: AFq9FYL4Ap10raLridIWvPZVMK/MzaNVIjHjJcE4JA58RVL3TukGSv99
	y+qtA3NPnnZAjBEAcENHeDjo5GlX87YV6YH0IjG2LAamCk6H/07E0hdrH5O4mpR7nEw=
X-Gm-Gg: AYBFou3AyOVxLkrWhbCVKSyCXQiRuKIMQUJgbvI3JUO8F/9WkuiA1DgriDrK5IZ3gf8
	IBK4U8zpt/SYQOnf4U0soiZc6mdiWRZobvdnYd4o69edFUavJuuSQUseSE4j2t/ZzEVFoe2XB2C
	v6M4fip9UYn6gGJZoThwv5irjuxCWhzUzrTq7f4PNEEoLwzu6YRbF3YVIUJmpC4STDrI5Ab5x4k
	J0ptpceRhAkN+cgc7BRU9cFTSrDVKgElBfantJTDmhfj+sOxJnKpW5iGGuwJ83NUtysWMPKzM/j
	UUxmAWyrKZ4MeHvJlX1q5Frq+UIMugdIzS2hEVjfY1PDQDcAgjBsXf2Bz8JmChPAVFGuwRA163/
	q3ocqaHdFg/1IW0qj2G+zC5TkvUaYP3xiaUamio5AoHvo6sK9o0pBZLYlNdA4A+aaaryFqgfw8q
	qpiJ5qi/Xuz8/tvIWFm79LQmJfsuvl0bjCkO8+wFXqpCI03wqQgs7Je8+bgO3k60FgYgAfyOt7T
	Zx1Uw==
X-Received: by 2002:a17:90b:2b4e:b0:3aa:9a32:5054 with SMTP id 98e67ed59e1d1-3ab3ace05e2mr14023296a91.62.1792025861287;
        Wed, 14 Oct 2026 17:57:41 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac92a43d98sm999198a91.0.2026.10.14.17.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 17:57:41 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v7 3/7] scsi: mvumi: bound the hotplug event bitmap
Date: Thu, 15 Oct 2026 09:57:13 +0900
Message-ID: <20261015005717.3719956-4-yhlee@isslab.korea.ac.kr>
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

mvumi_proc_msg() takes size from the hotplug event the firmware DMAs into
the event buffer and uses it twice: as the bit count for two
find_next_zero_bit() scans, and as the byte offset of the second bitmap.
Nothing checks it against the buffer, which mvumi_get_event() allocates at
a fixed 512 bytes, and size is a u16, so a firmware reporting 65535 makes
both scans run roughly 8 KiB past the allocation and places the second
bitmap past it to begin with.

Reject a size whose bitmaps do not fit.  The second bitmap starts size bits
in and find_next_zero_bit() reads a long at a time, so that span is the
furthest either scan reaches.  Compare it against sizeof(struct
mvumi_event_req), the only length the driver ever puts in
data_transfer_length and therefore the most the firmware may write into the
shared buffer, rather than against the buffer itself: dma_alloc_coherent()
hands back zeroed memory, a zero bit in these bitmaps means a device is
present, so scanning past what the firmware wrote would add devices that do
not exist.  Read size once, since it lives in memory the firmware can still
write, and give the buffer size a name while here.

Fixes: bd756ddea18e ("[SCSI] mvumi: Add support for Marvell SAS/SATA RAID-on-Chip(ROC) 88RC9580")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 18 ++++++++++++++++--
 drivers/scsi/mvumi.h |  3 +++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 2378b676a7a78..9a3dde53dea97 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1652,11 +1652,25 @@ static int mvumi_rescan_bus(void *data)
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
+	 * furthest the two scans reach.  Bound it by the length the firmware
+	 * was told it may write, not by the buffer: the bytes past that are
+	 * still zero, and a zero bit here means a device is present.
+	 */
+	if (sizeof(*param) + (size >> 3) + BITS_TO_LONGS(size) * sizeof(long) >
+			sizeof(struct mvumi_event_req)) {
+		dev_err(&mhba->pdev->dev,
+			"invalid hotplug event bitmap size %u\n", size);
+		return;
+	}
+
 	if (mhba->fw_flag & MVUMI_FW_ATTACH) {
 		index = -1;
 		ar_bitmap = (const unsigned long *) param->bitmap;
@@ -1708,7 +1722,7 @@ static int mvumi_get_event(struct mvumi_hba *mhba, unsigned char msg)
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

