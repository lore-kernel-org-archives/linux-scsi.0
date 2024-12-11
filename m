Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB82238E20;
	Wed, 11 Dec 2024 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943200; cv=none; b=MY2Y+xQEATjWl0aZBomoNP3WNEm/th3hgQMyIrGi8F1pZfc6KQdgAhG6XgH/XY6KvaYnJOB9Y3kTI46y0FlILKAuqFXS971171/1IkgOPMv+a+OvPfgoZn/kuXbwN/gonXSmvOpL57krX/OPbcPCiVs3VFGG0TSbmqHHpN2+pOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943200; c=relaxed/simple;
	bh=vFIvGMNkyrjmZsY+7V1qYfsRWHk0/Dak7gnHWrmo7Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxWqKw5bXwT1L0a1Wx4uP8hRRQq/fWf159xCBAqMwRhbPR4gYw+S/4CYO5MCT0qUOOZa34WP8+jy6osC7eNkCxnguN3LVv0eO1G1WQgzvg/piwzH0+yZ9NQYV2t2/hjHzh3ShyMiw/zUrrbfuokWsigMchuF0n5RjdtWOnqmiMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/AGDSpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/AGDSpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B1AC4CED2;
	Wed, 11 Dec 2024 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943200;
	bh=vFIvGMNkyrjmZsY+7V1qYfsRWHk0/Dak7gnHWrmo7Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/AGDSpmOdDEd1HYu+4qG4+SCtZm2LlTdzgSZ1vH1b4e0G1ZPMbGfj35E5N1aadyQ
	 7s3lPGj4xmBrn2M/IY9fQc5HIpHQzki3LKqKZGjszSc87gdu8uK7bvpQW2V4JPIMlE
	 gIa4AZWzDgKeJ1OnQSWrTee0YuoqpRMDgGw3nuUKYj1EtutapPvkJ+hoRYKEDaXZ3X
	 PuDZTtHaUqNOQVahvyrsmV6ddxOLbjUjJ5Pofl+e9m6FGDvUh48AnbdmtpCQlbvDKy
	 BtmgGH3k+OnNV5v67yCUCuflyQlQUa548kkgMaTjQyYc7MoCAbHm8MTDYI9wR7CDIv
	 JzKkrewSQrsCg==
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
Subject: [PATCH AUTOSEL 6.1 02/15] scsi: qla1280: Fix hw revision numbering for ISP1020/1040
Date: Wed, 11 Dec 2024 13:52:54 -0500
Message-ID: <20241211185316.3842543-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185316.3842543-1-sashal@kernel.org>
References: <20241211185316.3842543-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.119
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

