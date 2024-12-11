Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB603246B3C;
	Wed, 11 Dec 2024 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943142; cv=none; b=uzZah6RiBzNiFQaNPq8151Uyl/nFLHBsHZ3+4QyRs6XEURsgGRdQGaZXmPXwpAcMd73rGbsvhMqtBDInFq1gJUOdJiRiegFxk8AQeB0Be3nd1bctqX6/tPOzYfuKBnzhGjeIGHA9iXAaguhviT1bM+bGN7wzPVfWkNjcxbkkioQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943142; c=relaxed/simple;
	bh=vFIvGMNkyrjmZsY+7V1qYfsRWHk0/Dak7gnHWrmo7Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQBmyzwggPPYGJLDWe77je2m518qYzoKupR9Hhf+/K54Eyp4XpL3+Gu/L3/lzpvOWebgR1vPEvhwmBOoewi52e+2XMOic5P8RHzYQVZwyt7Kv4q/TnjwUP9Ck1YH4XZ+1KjoNsNeu/suVgDc+QZ7lHILGrUkLl/iiVnDBWJX2eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q9jlkepg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9jlkepg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667FEC4CED2;
	Wed, 11 Dec 2024 18:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943140;
	bh=vFIvGMNkyrjmZsY+7V1qYfsRWHk0/Dak7gnHWrmo7Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9jlkepgWvciDWerdpXRm0XGizHvy+uy5JQUzJ9MsFn99BHmn1XD4xo19Vq4kOyNX
	 Sg1aMafWi9bKSAzjZ6VNSDySb/pUmP4+JiD+tIs9iqzwyivF1f6A7rMIKweNXiUnP7
	 DLaHyej6sDwpp1C1a+RizNAWKmAYydeVc6KRsyDkRP2yzH9dXATCnesw1/YEele4F6
	 UUilD/za11N/LbzervPZXCQw7JfpYMFRnX6f1O3+ODydyTTMy+lNiJ7C7llxKhnmEQ
	 0s7LXu5r8br+e0UMLLGjoLsgBhjfuoDCWRX9PkHEF7xoENADo37Yz3Y3S+r6yRP1n3
	 DjmQmKJ/wWvAg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Magnus Lindholm <linmag7@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	mdr@sgi.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 03/23] scsi: qla1280: Fix hw revision numbering for ISP1020/1040
Date: Wed, 11 Dec 2024 13:51:40 -0500
Message-ID: <20241211185214.3841978-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185214.3841978-1-sashal@kernel.org>
References: <20241211185214.3841978-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.65
Content-Transfer-Encoding: 8bit

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit c064de86d2a3909222d5996c5047f64c7a8f791b ]

Fix the hardware revision numbering for Qlogic ISP1020/1040 boards.  HWMASK
suggests that the revision number only needs four bits, this is consistent
with how NetBSD does things in their ISP driver. Verified on a IPS1040B
which is seen as rev 5 not as BIT_4.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20241113225636.2276-1-linmag7@gmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla1280.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla1280.h b/drivers/scsi/qla1280.h
index d309e2ca14deb..dea2290b37d4d 100644
--- a/drivers/scsi/qla1280.h
+++ b/drivers/scsi/qla1280.h
@@ -116,12 +116,12 @@ struct device_reg {
 	uint16_t id_h;		/* ID high */
 	uint16_t cfg_0;		/* Configuration 0 */
 #define ISP_CFG0_HWMSK   0x000f	/* Hardware revision mask */
-#define ISP_CFG0_1020    BIT_0	/* ISP1020 */
-#define ISP_CFG0_1020A	 BIT_1	/* ISP1020A */
-#define ISP_CFG0_1040	 BIT_2	/* ISP1040 */
-#define ISP_CFG0_1040A	 BIT_3	/* ISP1040A */
-#define ISP_CFG0_1040B	 BIT_4	/* ISP1040B */
-#define ISP_CFG0_1040C	 BIT_5	/* ISP1040C */
+#define ISP_CFG0_1020	 1	/* ISP1020 */
+#define ISP_CFG0_1020A	 2	/* ISP1020A */
+#define ISP_CFG0_1040	 3	/* ISP1040 */
+#define ISP_CFG0_1040A	 4	/* ISP1040A */
+#define ISP_CFG0_1040B	 5	/* ISP1040B */
+#define ISP_CFG0_1040C	 6	/* ISP1040C */
 	uint16_t cfg_1;		/* Configuration 1 */
 #define ISP_CFG1_F128    BIT_6  /* 128-byte FIFO threshold */
 #define ISP_CFG1_F64     BIT_4|BIT_5 /* 128-byte FIFO threshold */
-- 
2.43.0

