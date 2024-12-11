Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9E2253D37;
	Wed, 11 Dec 2024 18:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943239; cv=none; b=PMh76sUn+h8Bab7khZbtGw+SQ5byhp8zJ+CiTEp1lmr190WJeo3KJdKsIr+ghurDT86M9QEva6uTy4sk0mggmMR5Oy/ZdR6t5sb5SZDNFexzkWKONwlVUm6GMUe1ayMvEqjMU0aNwXjNuzD7Y/FQHsM/vB3+xg3LDNtq1nkaPFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943239; c=relaxed/simple;
	bh=hE7o4tTWZINIJU8nthSiHxq0NPPs3Ub6Bz6t/xJ16Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1xmkFpDzVNP6MTC3uvojfqD1JoLCqlmwfkN+jFoKg/LrZj4hCz78jLYtPYrqJhwSsP3XqJ6Ccz3rRJW2FG8QXeNP++T4vqNWHoEJTea1Rgqzl8CDwBtG3sNOknhSepgaEdPABZYqJTnZeyNssQ7qQn4+AHFecNPHwjcJ3PSwJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G3n4rofN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G3n4rofN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E581AC4CED4;
	Wed, 11 Dec 2024 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943239;
	bh=hE7o4tTWZINIJU8nthSiHxq0NPPs3Ub6Bz6t/xJ16Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3n4rofNBtQXj0NP+14FM60+KLoK2iDzPZsb2Y620slfSojdWrJ7Nlq146Qeqph53
	 bSjBsLVcPZdW0x7+23sU10uTd+9RBh5tuv/JmEwcO9pPkxW0lAhg5hQIZg2bZCjuYG
	 lOk5poVv1QnPP1J7JHNtF9//xRsA3CGCGm4HbohdgZ1epEZlO1bxvzx2YIaAJlpxq2
	 2IpT9xHiT9EWcfcOgsHwTzn6B5jWuNgjH/YmoQ/YAxOsvzqUJp3NpiVvdVi/FHAzSL
	 l9izW2yDqnbGKZl8apWUxommIifs+hRQShuvTR4OWiEiENhutkfLyVlJpjMYyexjDJ
	 te5XMH1sz96+w==
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
Subject: [PATCH AUTOSEL 5.15 02/10] scsi: qla1280: Fix hw revision numbering for ISP1020/1040
Date: Wed, 11 Dec 2024 13:53:43 -0500
Message-ID: <20241211185355.3842902-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185355.3842902-1-sashal@kernel.org>
References: <20241211185355.3842902-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.173
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
index e7820b5bca38c..c0a9251b2bed2 100644
--- a/drivers/scsi/qla1280.h
+++ b/drivers/scsi/qla1280.h
@@ -117,12 +117,12 @@ struct device_reg {
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

