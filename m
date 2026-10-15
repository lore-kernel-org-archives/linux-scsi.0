Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D533DA7F3
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031272; cv=none; b=MCHTQKT47gV2ew+G0wttmdYX7XfEWigY6uvv4VeGSV40/4E/dN9GuBoUr03Rbhx8DFC+xpof1SM8HXj4r3McKgzoi8q4u4RRVIyWRq1Au+Rs0g1fF8YApvVWUld2Z+zy+rbFB///TEvtOIkg/Tv3X/crKsxBKqCMWdep1obQ4qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031272; c=relaxed/simple;
	bh=d/UWuIDLttRptXRjgPCr2gHnKIUlkWJphZ/F4/3NVHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8Nuo0VnbtlI7Mx/yKdCTynvsqFydQTexXlt1QQLXimMucxy0zDXjSiHk3I0JTPiImcexNGPnjN7RMU3abBlILEey4W9PDSibbtUvMEFyOhSqFO70VgrShI3aUsR4SEQkYpSwWQHAtvaG6oaR+qQFPqeAiiiXeid8kmYzDjTKMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=WTOgaCM0; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="WTOgaCM0"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so2179192a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 19:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792031269; x=1792636069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=parD2IM7xfaD1K9JnqVrI4SVPT6JMErPe2GlYkxbGxg=;
        b=WTOgaCM0KXikHo8bMsZcVbnNRMP+dv/pzuxJWU2g2f4/oq+3rH6RCkTU35P0Xc6F7T
         MgRemDkf4TepZwy3GlJLiUVLQ8m+PRV/GD+ADfVoHvzWgQH3UnkTQNEXr1LJ+6/b78uw
         VzyoPHAsG8JvvsImU+FS99KJ1urBfG6vfux6ejbMHD8ZVbxpJl1Lze7Oaqz4+/FH9o6f
         Y/IeHrdQdF1UbBXJYhz+jXv+1ERMXj5m8uJSEH1kfbDOOK7Hx7jBr+T2FEnrpUFfICga
         PZn5OZC/b2kBz5n/ilXzA/8rMfZS5M9ZeXauFBES2exfPMbC5P4JdrBf/6h69pdXq+6Q
         Sfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792031269; x=1792636069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=parD2IM7xfaD1K9JnqVrI4SVPT6JMErPe2GlYkxbGxg=;
        b=m9b9wmZ8RCcdnQbyjb/ci7a/ujJB09CdIKgLsY16pDDJ2yczjTFSm3293LeyBsGWBU
         FQTcVUhF6HOeU5cFAmWP5UnHbmdqbuOSD1U32HxdEBLkg0DtG1yKaj8cguKr9x5udwnR
         m+K3oAz4zsy47Kgq7txSd9cBqIMDdmbk1YV1pGZbpwjbM+1C2mMrcvvJhjeu8uhdCup7
         T5aoByXLbSscHld4PKvkQmt5h7LkD4A9WqLKlIYyFqvw9yaO+Y4XnCoRaw+NnIrZqX4U
         9wolrTOF+DxVJti2KSjo/D6vpo6EXHkPu203r99siVsbFvT6nnkC3s7KnJjb2jAufrZ0
         rKMA==
X-Gm-Message-State: AFq9FYLJxHyB5ftMGV7CMlEd3tbceipHq64IOxofkaIBX1W3b2ps8SRr
	fDSltKOKtVTqAkxw4YRr/jyeo+6UIy96kdDABnX6fwgcZ27IVOrwX1091/DHIaln2jA=
X-Gm-Gg: AYBFou1Jhnl9qxHCG8bV9PDSleuP305hxuK4oUwqB6tulYdx77mNz2f80Nrmh8it2RX
	TkJIYi15yAgulYGrbyEu6LRLBpnHURCNUYCNon2cm9lnHCQcJJa4eJkDEUOEUWIoI9I/Ms3RQIq
	sUa+iTku7dVTvwyaZyUZhebJIlB+DlsIQ3unLFfJ9Fvp5lhv1ALArSK8b9cyX+hCPTxN80UVv4j
	K4oYmZm6FrLCuSaFCuZlY31wxJT8cUWmRZaPrZr8sv90PtV5S7Z1VusMbul46MJqlJHCm+X1hdj
	R+vJEUCo4lq3/avwef69UhVNrdOoZJHifFQRb5pEbUGiTP0lbcpbZUQhDq11sJl599kleAZ08xt
	0m0d+fvbDbfs2SdDdP67m3wtgHHloujxftXm0hkl9EKPs/ZKSjqCK6gJud5V6FZpUQ9jvmLeYs1
	Thc9JRMXVC7KIIrT9Pb5Vxlg0dW6ySe/VaTc3xqWsX8O+mEqLyCyGCySI5rXK0HEdQbyw22ES/p
	5tVbQ==
X-Received: by 2002:a17:90a:4ca2:b0:3ab:7031:d962 with SMTP id 98e67ed59e1d1-3ab70412990mr9433766a91.41.1792031268777;
        Wed, 14 Oct 2026 19:27:48 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94375f3fsm1997383a91.4.2026.10.14.19.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:27:48 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v8 3/8] scsi: mvumi: bound the hotplug event bitmap
Date: Thu, 15 Oct 2026 11:27:23 +0900
Message-ID: <20261015022728.3936714-4-yhlee@isslab.korea.ac.kr>
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

