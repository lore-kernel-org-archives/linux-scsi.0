Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89083D952F
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031287; cv=none; b=fc+RZuW3YxSJqyLqrXufzpRmRCk6Nsjc0NJJgENOPSRYbOQ+80Bu3nTfe/vpXHaPhD4u/1EMkBele+qkzl0rJXFWOAX2cVd0a61ZsPdp/QcDr3ASCZzsi/SgC+qR/MoIwq4t1d/LrsrEPLsD1k6VELIvZB9w5EiIckB+RN8e/0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031287; c=relaxed/simple;
	bh=DvmUcdBGk9Ip3K6aMNLyTsmPzHjEV1WQkSgWvFOcyz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tctvdeDVjHUEAo55DFhY3EqULp0rls9TUTXZwXi5fGNAZolTEo1IuQyonITCInGyHasAQdKxSwnIwUA+SSZ8wnmalBiyIp8qnlf+Mj7WUi9+5h9VnJNj9WO8fhMq1uTIim31ruFg/mfgK79x1BbvJ8ZD4nqDuRs85brPAMAmrZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=kLawuoei; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="kLawuoei"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ac5b090d16so1109870a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 19:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792031281; x=1792636081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2vTCBryNCZePgMXjmqfRG2WB7QhMRd9mrUtZ7pw310o=;
        b=kLawuoeinR4ABznzjO0d0pclVNPlXik1S0VbFxyOJXF6c+k2JanZU078D0O5v3l8k6
         zEioVKftzO++gWuBtJQKMw2/YPbeevTfAlNqvLr4NH3hlhBoTxDFpzyxjEYewLsrB87I
         z9m0BU9gm1hluEHYTuc50lut0Dkp0ng2jMaSN6dRMl+M+2DsCljhmuZx9fK7aR7ZWW1m
         dESuFrObeRdMoOEdUR3PlzDMliOmZtdCfXaG+d4BnIzsI5cRyD6EVJ8ci2f27TQzZ6OG
         YX9+GRW8pbKiLIXag2bIguVKOMWAIbULA7+kMTsu8QFx02kTOX8aTmHTQBSCPRWmOHmP
         TLxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792031281; x=1792636081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2vTCBryNCZePgMXjmqfRG2WB7QhMRd9mrUtZ7pw310o=;
        b=IG71HqrXyHBrlm3Wy8DliJMkvqtendvDJS/ie3Wr8jzDgqJmlSG4TIHz3tB2Km9aE/
         FQVmxTDQ+Vw9uW19QFtc5VuqQ91d4Jzu/ye0mv2IzM/cEYHX16X7y7jbidCT+z/6yPx1
         xqyKAlctrRfld6HplwFHMi7J1/oUe89LU4bR9RF8b+2qFFqcGBW2GisoGJwnIRO6sZpZ
         TygoENGCEc3l28j6amX0OBNwE/wO0UyRRdczBDu8UVQQjKdxJE0QS3Oc7ugMUHWr+dDj
         8EGjpqTpODczBgBfQuht6DemkjeBf/6bAlh0wOO8b5P0SOcjyqOUyRrudVumIKelvjNJ
         SnPA==
X-Gm-Message-State: AFq9FYJuol8cKWZytx3jsdGv5BC16WNEw+MAuK/o+DiOvt3c+xHbqET9
	g05zDq2PwlfVjwUj1XjsohMWZ42gqeQmu8bk6LMvxvE5c6ADqDkTnYRsPtS5wD8ZcGE=
X-Gm-Gg: AYBFou2t0cZk0nyh2zNaVCaQFKbtHo/5gStLXXzxDvWAMpvt3Jv3UOjNi8u4RyKYeAg
	87o3BTHh/j0NFMNGTctq/hzA/t7ukeQYz7ZApmfQwojZWrI6ajEyEQRo/5psdeH9VK2GMg79nFa
	MKTMN4JxuqiXONnOS6y+gPsTwBgI0/w7jzHHht3OPkW1rjnxVa/qx+B600vOMB/J3qaQiF1RB38
	ebiyhg1UZS2cwvmhqhrhjGYfWZwYu/Mjak7o3/Q8YQhnoDa8cMyAtId4G6PHVTnXB+7w+7gfAdW
	sYzXSoB+Tzm4M2JRVkoyqthXNjAfGSAvcxijB2Tq34XiPb/uSyb0ED0Y2iOgOCmLRcrhBv2lpp9
	TSLQs5PGVNcOMT8U9tJ4mJhJMLFX7U3n3QTDKZWGB4q9cBwCD3dgcNcgABJ57Rr6HueTGez/5Fa
	sTgIO6BSWiRuK9+JNhLuDAv4rhU7dYJhb3iYDP3gzgwCd72gHqAqHJ9k1+sQLqQQGE3acNcsZG/
	zlgqw==
X-Received: by 2002:a17:90b:4e8b:b0:3ab:be66:ddd3 with SMTP id 98e67ed59e1d1-3abbe66dfa9mr7610333a91.32.1792031281033;
        Wed, 14 Oct 2026 19:28:01 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94375f3fsm1997383a91.4.2026.10.14.19.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:28:00 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v8 8/8] scsi: mvumi: stamp a consumed outbound list entry out of range
Date: Thu, 15 Oct 2026 11:27:28 +0900
Message-ID: <20261015022728.3936714-9-yhlee@isslab.korea.ac.kr>
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

mvumi_receive_ob_list_entry() copies a completion out of the outbound
list and then writes 0xff over the tag, so that the entry is rejected if
the firmware's copy pointer brings the driver back to it.  The comment
right above the checks says why that can happen: "Copy pointer may point
to entry in outbound list before entry has valid data".

Nothing ever compares a tag against 0xff.  The only test for a usable
entry is

	tag >= mhba->tag_pool.size

and tag_pool.size is mhba->max_io, which the firmware supplies in the u16
max_io_support.  As soon as the firmware asks for more than 255 commands,
0xff is a tag in range and tag_cmd[255] can hold a live command, so a
stale consumed entry is no longer turned away by its tag.

What happens next depends on the controller.  Where request_id_enabled is
set, mvumi_check_ob_frame() still compares the request_id left in the
entry and rejects the frame.  Where it is not set, and the MV9580 case in
mvumi_init_fw() never sets it, that comparison is skipped, so the entry
passes, is copied, and completes whichever command owns tag 255 with the
bytes of an older completion.

The tag field is a u16 and tag_pool.size is an unsigned short, so 0xffff
is >= every value the bound can take and is never a valid tag.  Stamp
that instead.  The store is the same width it was.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 2 +-
 drivers/scsi/mvumi.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index bd1a8c1d54aeb..67a6bb6536950 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -571,7 +571,7 @@ static void mvumi_receive_ob_list_entry(struct mvumi_hba *mhba)
 		}
 
 		memcpy(ob_data->data, p_outb_frame, mhba->ob_max_size);
-		p_outb_frame->tag = 0xff;
+		p_outb_frame->tag = MVUMI_TAG_CONSUMED;
 
 		list_add_tail(&ob_data->list, &mhba->free_ob_list);
 	}
diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
index d20eea2b61a31..f69a0807100c3 100644
--- a/drivers/scsi/mvumi.h
+++ b/drivers/scsi/mvumi.h
@@ -133,6 +133,12 @@ enum {
  */
 #define MVUMI_MAX_TARGET_ID		255
 
+/*
+ * Stamped into a consumed outbound list entry.  A valid tag is below
+ * tag_pool.size, which is a u16, so the largest u16 is never one.
+ */
+#define MVUMI_TAG_CONSUMED		0xffff
+
 #define DEVICE_OFFLINE	0
 #define DEVICE_ONLINE	1
 
-- 
2.43.0

