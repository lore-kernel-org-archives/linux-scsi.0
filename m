Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726B4403AE0
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 04:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792039964; cv=none; b=Zp8FGWW6FlfKHzsBuTqwicjk740hf2jc0p9j9hazNF+lh4SPn4dN2xXgo8g3PcJ/gU+hhUogUz3cnsQmVugKm7bfJYpnXpK6CLqXKZvA+Ji5Yd5rpgy+J/poqjvLq6uzgRkb2zO4eE0OKzXSfbQe+3P2sxQvQlwjov79dBLGYvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792039964; c=relaxed/simple;
	bh=rYJvJvnkgZtKchfVvlvx9ACL3kl2ex3CJVfJAmwIQMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GthsTOZr1bdmDT8x1qKP30qTiMUtO24DqBIWJ8DXGAONLuRUDv3eBrRC1t4IAxvHI8IuLZuh7jhNQUBkPGcnTSUycbZMXsvGTET1otSkDf2e/m2Zuy1x1CY3Ry6FWhaq6WEpnWNlxNepy7yHHd45EPAzeUpBcpKFZLT9zYlvLG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Px0ZeuYX; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Px0ZeuYX"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2dd9cbb661bso35256925ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 21:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792039963; x=1792644763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y1CW4E17PsqOiHZDTp/GHdRDHH51grlO5+TKs27nZFQ=;
        b=Px0ZeuYXmH/JvRJMh907f6JqeolLx31GjA4u/2OtO7OcDMGiXIaaHLISZgDjRICpyX
         77FxkEPoHgKMGqKe76ArLqsxBsiEv+4YmpDYblS4rFpysIGFWGZaZ20UVIa+E9GLxrEq
         mT2/On0Am0kfDknsmA3OUNZzwqDqTzZ67Bbdn/FauSt+J/B0Ht63VkOSOdgFMYZqNMP7
         nDnwHhVF66ZM4bJFPR95q1+jygZZ/2n/cU/ws23Krp8V8fCRviFye35BnT6YeglNqcwD
         sSiTTxabyw9XXFX260p7pxM8WQHc9FIjuLLbOS5JjTumxkQ/AgGcpsKYNKXNcQrZE37R
         ZrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792039963; x=1792644763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y1CW4E17PsqOiHZDTp/GHdRDHH51grlO5+TKs27nZFQ=;
        b=ukND0ldJSEYjofl5sH2YicxAiUYTISYpSEkheWdSDxxbr2X/J7k+RHwl3KJcteGARS
         eJdchriPHX/D/HAC2DziHEjiGD+3BkDWjAhDoeMEqSyzEFgb2eawkY8zRQ7gU4kDt9Eq
         bFCewllKYKJKla6tUlDElucQ3CUDHzK5VB06pjoafYZMw/QCvN90tCpvABloBOFlFolR
         mVITBag5v1I3iY848PK5v3pzlztwa40TxGc4EhT8uvayQGU9Etg5hYdxoKMXJ6qWbQ3N
         L5bUZxKmYaklq7HkE6uUGDN7eB8vfvQS0dHFLj7WoOnY2pc9znenwfpWckGL7KbC5uSK
         59TQ==
X-Gm-Message-State: AFq9FYIrVap/hn6HwbMBPSx0hirIAuN4KgV1oNi2wXOTLBxc8DNV5eyN
	1SM50nlXJ8aeMO+bFD5A6hSD2YnlABx0O0eT21tPZiqnsQUf7lPpoD+msR6ovaFhEz0=
X-Gm-Gg: AYBFou2VGEBLrZt9gFgklejQ+X186EC+LP89b+9am4xxE5GWkDc87and+/5gVaRg3S9
	aA/P4HcW6SRtDcrsjhpUtFXykwo3SybvVLAnUXzyXD98B8Z7dErIWAcPjZRGo1opY93elvWJfJG
	84OdphKQqFfJcDo5UhX/fHNcfsU7QpcTXRspgy5bW7MMUYFQdEhyvudMfg7IssvyOaODHjiCPoS
	Govuh+A9OQVPbEz4vGQ76pUP5BN7wuBpJ+y9GD1qXeAzoGk0WsNmzbd1ZCqWK1fK8IatRqjL/vK
	SbKDnFuIOHAR/r2wb1jjHS3d/czxH1PtlwtDQhNmA8TrCBLkvQds8NWFVXNZ1NX7z1PxUKHgm0F
	L+JCIeP7StfwTSQE/c9O1UzPPAbx3XJFHL8Oq7gMWue8WjcgI989//9ykS5nzNDL7G3vJTejSVT
	BEqfdnrAfiaZ+uJJ6ZjCEurjhdOQNjt6uS5EfxM1tlpT/+p5kCPMXT1euZWLix2lYzd1vXbQlNf
	JI/yg==
X-Received: by 2002:a17:903:32c2:b0:2e8:30dd:523d with SMTP id d9443c01a7336-2e8429a739emr170899815ad.13.1792039962771;
        Wed, 14 Oct 2026 21:52:42 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e962a4dfbbsm1615915ad.58.2026.10.14.21.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 21:52:42 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v9 9/9] scsi: mvumi: bound the firmware handshake retry loop
Date: Thu, 15 Oct 2026 13:52:13 +0900
Message-ID: <20261015045213.3975845-10-yhlee@isslab.korea.ac.kr>
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

mvumi_check_handshake() drives the handshake by calling
mvumi_handshake_event() until mhba->fw_state reaches FW_STATE_STARTED,
with nothing bounding how many times that can happen:

	do {
		if (mvumi_handshake_event(mhba)) {
			...
			return -1;
		}
	} while (mhba->fw_state != FW_STATE_STARTED);

Each call advances the state machine by one step and has its own
FW_MAX_DELAY timeout, but that timeout is sampled on entry to
mvumi_handshake_event(), so it only bounds one step.  A firmware that
keeps asserting DRBL_HANDSHAKE_ISR, or that reports the same handshake
state every round, is answered every round and the loop does not end.

The firmware does not have to be hostile to keep the loop going.  The
page walk advances hs_header->page_code, which lives in the coherent DMA
handshake page, so a controller that writes that field back can keep the
walk at the same page.  The restart that mvumi_handshake() takes when the
firmware reports a status other than HS_STATUS_OK also returns to
HS_S_START without ending the loop.

Count the steps and give up after MVUMI_HS_MAX_STEPS.  A handshake that
completes needs four fixed steps plus one per page the firmware asks for
in the u8 total_pages, so 259 at most, and a restart adds two; 1024
leaves room for both and still terminates.

This does not change what the driver writes to the firmware.  In
particular, the HS_S_ABORT that mvumi_handshake() stores into its local
hs_fun before returning -1 is still never written to the doorbell, so the
FW_STATE_STARTING restart continues to work as before.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 9 ++++++++-
 drivers/scsi/mvumi.h | 9 +++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 994c04902fa12..a2759dbeedf75 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1334,7 +1334,7 @@ static unsigned char mvumi_handshake_event(struct mvumi_hba *mhba)
 
 static unsigned char mvumi_check_handshake(struct mvumi_hba *mhba)
 {
-	unsigned int tmp;
+	unsigned int tmp, steps;
 	unsigned long before;
 
 	before = jiffies;
@@ -1355,6 +1355,7 @@ static unsigned char mvumi_check_handshake(struct mvumi_hba *mhba)
 
 	mhba->fw_state = FW_STATE_STARTING;
 	dev_dbg(&mhba->pdev->dev, "start firmware handshake...\n");
+	steps = 0;
 	do {
 		if (mvumi_handshake_event(mhba)) {
 			dev_err(&mhba->pdev->dev,
@@ -1362,6 +1363,12 @@ static unsigned char mvumi_check_handshake(struct mvumi_hba *mhba)
 						mhba->fw_state);
 			return -1;
 		}
+		if (++steps > MVUMI_HS_MAX_STEPS) {
+			dev_err(&mhba->pdev->dev,
+				"handshake did not finish in %u steps, state 0x%x.\n",
+				MVUMI_HS_MAX_STEPS, mhba->fw_state);
+			return -1;
+		}
 	} while (mhba->fw_state != FW_STATE_STARTED);
 
 	dev_dbg(&mhba->pdev->dev, "firmware handshake done\n");
diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
index d998c65c26472..9597e87a08167 100644
--- a/drivers/scsi/mvumi.h
+++ b/drivers/scsi/mvumi.h
@@ -399,6 +399,15 @@ struct mvumi_hs_header {
 #define HS_PAGE_CL_INFO		0x4
 #define HS_PAGE_TOTAL		0x5
 
+/*
+ * Each mvumi_handshake() call advances the state machine by one step: four
+ * fixed steps, plus one per page the firmware asks for in the u8 total_pages,
+ * plus a restart if it ever reports a status other than HS_STATUS_OK.  This
+ * caps how many steps the driver will take before giving up, so that a
+ * firmware that keeps the handshake going cannot keep it going forever.
+ */
+#define MVUMI_HS_MAX_STEPS	1024
+
 #define HSP_SIZE(i)	sizeof(struct mvumi_hs_page##i)
 
 #define HSP_MAX_SIZE ({					\
-- 
2.43.0

