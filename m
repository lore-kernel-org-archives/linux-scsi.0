Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46732288E8;
	Wed, 11 Dec 2024 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943039; cv=none; b=k1OIK5J3rsn9Jk1aIZTomXKgrC2G7aSJ9/fnw5YiNIZrlJeXjrS+6mi3lExD5xuEVr2pF7gscXsXwr3B4yzigH+xvdZJLMVv1p+e9zOeIPn02Sx6U5gkhK5h6y1MuLRLOvxFNa7KfNOj6Alzunx8EE+7OpFL5GwP2Qo5Ez29CR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943039; c=relaxed/simple;
	bh=vFIvGMNkyrjmZsY+7V1qYfsRWHk0/Dak7gnHWrmo7Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwGyr+hoAnTf8DITriCFkqpdt28mmLjN1SKPjrh3I0HK0UemNdzLEY5awYqKx9zTzF664Pu4WCD4Wj2nHlw5mxtDWs+o/P3PiYC01c8MpvqUH2ngVjrJ41pOwgJtWgmKTXKlMaRD/TWRhKJLAY1RAzFGQF/MEUsnembRmVATk+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COxZQZPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COxZQZPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C99EC4CEDD;
	Wed, 11 Dec 2024 18:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943039;
	bh=vFIvGMNkyrjmZsY+7V1qYfsRWHk0/Dak7gnHWrmo7Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COxZQZPtifUdinnBQg4ih93IcdkwV7ebtXnhTbe0cki++bI8c7hl9MpFI6ZKbEVdh
	 MlEBXjPhOz7Y8c+d1BpCyOvauS3gK6sgECJKh9gajGSVN6sR3/sa2KThZPkZILPmnp
	 TnGOU6B7mXfoOyPjeQ8/IzweB1zfbYmUsdVIufZQy5mfhQHO4KQl0tyA13UhiWxyPq
	 vJj/i0s03r7HNLg8iY1BD4BAc4f2KOv1zaHH6ZUXMVWibVmu/8UnwudBr/ZIaTvqk/
	 HcXB6vnXHLmPsWnirop3jf93JVrpzkjZqiTfyri/Pm79ZrfKJiui67oTUo0z/2rZUv
	 ohQj/4K/UpLSw==
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
Subject: [PATCH AUTOSEL 6.12 06/36] scsi: qla1280: Fix hw revision numbering for ISP1020/1040
Date: Wed, 11 Dec 2024 13:49:22 -0500
Message-ID: <20241211185028.3841047-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185028.3841047-1-sashal@kernel.org>
References: <20241211185028.3841047-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.4
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

