Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F0325EFBF;
	Tue, 11 Feb 2025 01:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237537; cv=none; b=V6s5sqQIZb0InV4FTIz6a5CxhVY9jVLOtvFfkTR9cLtz1R3hXN1b78N1vP3IHEA9d6KGA8cCW2ZrXI86oM6p4TEaItVqpdTbzQVaaSPJ4FP5Us0TUuR32VZQk0SVqJgQkCE9HmxwsB6oaOV0cRlcrjOfQAWpdJPw3dL5PhSDsO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237537; c=relaxed/simple;
	bh=HpILncFWq5M+sNgKQ6VoApqE9zup4jbXv2d50qkWMSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WOSYx+SQd9V7yT0DhKNUcLw31TThFqxwY0Ess6Lji1fmZNNIVy/wUJhKGk6cx4VPZ0lnVB2zciJ4Xz6EOzhaeJw/bkjMWnWxFQ9maapA7fse+wonsz8qeZo2ZM9zMREZIAi1iD2uPdbjHh/dJws3T4MhYxtXqkWOeM0K8s6Rp/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaL6+Kfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaL6+Kfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA79C4CEDF;
	Tue, 11 Feb 2025 01:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237536;
	bh=HpILncFWq5M+sNgKQ6VoApqE9zup4jbXv2d50qkWMSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iaL6+KfodBRKY+2Rm9khUTJJ2usFXWg3UOqqJZEeoGbw2YFCXx8wk7bX6fRgKeos5
	 jCLros7pEcutjQMK/BoxoE9tU+RwbXe41UcZDUHoJXKmvWK8LD+QxfScojnIFu18Le
	 DfSUARWElru7IMCGS/cNNdxWcgvNXAg3yUQ1R/eRiWcd55bSeKGsN5rpbMrxkokCCF
	 2VBnB+jjaZVyoYy3c19lyPPavQEOv7Nxd8ASX1iTcMDPI8Rm4CNGDokHQe6y5TEIi7
	 VqasNGY75Q47vwwHtoGHAFTjOI7G3Z2L1TQCZoKucAxRuItGMUR31VhYQvSh9C/6Fa
	 1jhaNGLWhH8lA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Magnus Lindholm <linmag7@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	mdr@sgi.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/11] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Mon, 10 Feb 2025 20:32:01 -0500
Message-Id: <20250211013206.4098522-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013206.4098522-1-sashal@kernel.org>
References: <20250211013206.4098522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.128
Content-Transfer-Encoding: 8bit

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 5233e3235dec3065ccc632729675575dbe3c6b8a ]

A null dereference or oops exception will eventually occur when qla1280.c
driver is compiled with DEBUG_QLA1280 enabled and ql_debug_level > 2.  I
think its clear from the code that the intention here is sg_dma_len(s) not
length of sg_next(s) when printing the debug info.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20250125095033.26188-1-linmag7@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 1e7f4d138e06c..0bb80d135f560 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2866,7 +2866,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
 				cpu_to_le32(upper_32_bits(dma_handle)),
 				cpu_to_le32(lower_32_bits(dma_handle)),
-				cpu_to_le32(sg_dma_len(sg_next(s))));
+				cpu_to_le32(sg_dma_len(s)));
 			remseg--;
 		}
 		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
-- 
2.39.5

