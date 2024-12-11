Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40A6257D7C;
	Wed, 11 Dec 2024 18:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943284; cv=none; b=ie/3JdWvv0swQIytiSyZZcnvhmJvt7ZdYrop5VQSOTIQWlF+IVXwG1rMq/d8NU2+oMEZKuMuoASgy96MMSy3khzdwADfx1zfxc1EYuEzFNjepdoPtCqqi2JKiwTZDLXH3pzVrXTNJdKtVr9NPvufC5hQxfCdNdF3pBBR+CHlKSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943284; c=relaxed/simple;
	bh=7LcGdzwt9e8nd6IwVVrgkhxiGCKe4iPAALLEj/hdlYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fLyQ/ns9vAgIuvwd89qSwdxCYlFVA40f8+WYkcWUTeXFTpoE1pZec+qQMEPLMNZjTNFgkDQ7bgH/UW1ZSDecS+0/o4GNyIvwFhTx242KqWPm2qtuv2oqDKVDmoteT+YathQLzmjoHt28oEbBJKdXhSOhLhrSRM69R4+HQsap/tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsz6MD/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsz6MD/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9392AC4CED2;
	Wed, 11 Dec 2024 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943284;
	bh=7LcGdzwt9e8nd6IwVVrgkhxiGCKe4iPAALLEj/hdlYc=;
	h=From:To:Cc:Subject:Date:From;
	b=bsz6MD/tgbT/7aMjDOfwlACp0V8sR56crIQ78s2Pr4p0BPghvlUzqtLU5eA2hEU/b
	 vzWJ4SuWAnCuSAyfmgP2JhnWE50hojA3ZQHx/smA2s7cFOLjz9FSbP9OJUlrPcLJci
	 nTBZ/oMO3Tb5/cdQ4RdIBpv8VvKqXbqcDDwT2STlANjdLOVMpbWW0Wbc7qMn2gWBE0
	 zqZHMQkluTWqsG19Boa7si5tD7nOgS5qsasz2EMMbqv+iFoSOutu7hu4Dk++f/xhqw
	 pr5v/x5o8uYSG1MJrodWN5Z8tvfENOx4xfNSWtUKfxDgmVYtuTQLIyj/HapdLmqfR8
	 L5yiaBgvyDjBQ==
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
Subject: [PATCH AUTOSEL 5.4 1/7] scsi: qla1280: Fix hw revision numbering for ISP1020/1040
Date: Wed, 11 Dec 2024 13:54:34 -0500
Message-ID: <20241211185442.3843374-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.286
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
index a1a8aefc7cc39..9d4c997c3c820 100644
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

