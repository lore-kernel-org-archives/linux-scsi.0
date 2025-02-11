Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BF61FA165;
	Tue, 11 Feb 2025 01:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237515; cv=none; b=cMjycNF1Y41x/+jKFc6ysbG+lWCGtZbDn+M1Wa8YwIQyjDz10U+ImYz2UdabLvB28eg1tfy9fEJoqimEEAYLplmdee29Zl2xZiULYP0PUDvqzvQXyqVI3DLG1IeQEogpy1MeMApC3l1QPXDiaVoNC1XkzGTFldw6uy6Qz9kJFI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237515; c=relaxed/simple;
	bh=v1S3vnQNZOSk1x0SkWdreDmoV9lGTWHxxS+h7Gfo/jE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uYzhDKmrsCErMmNSL+pF+4q0wk136V3wfYpSkyxu4bWMcSQHpV89/sptYX6ruIEVwCvKsIPtcNYl+gFHUd1bH0mTwRSap3IO9z6rO1hSVi7DugS5gHzpAlD4ZpT2t3UPRAKy4sB8TS+DWfFyTJ4KGKbao2tyC6o8WbU/gCCuZ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRTSx226; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRTSx226"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0F9C4CEE5;
	Tue, 11 Feb 2025 01:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237513;
	bh=v1S3vnQNZOSk1x0SkWdreDmoV9lGTWHxxS+h7Gfo/jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRTSx226Wksvie4nzgv9sRDhoIwhll+kP/US2lPhNhBJ55yzXVR0SqBNsH5FBFoky
	 YeIdXJVvJ/lcwp9L8yOY5i4Je8QTHP8/vNaN5gLLj8PWY4JiDA0nT9pPw6bZf7IOqS
	 KKUPxX5XFKyRV4FsM5mj0uXPi7NPkI2Hi3ee7036Hmol3ZrrHQwsh8uXTXn4/KOR/N
	 mPna6x4QPgTRB1X+Q+5xE0PA6oiU2BncIp+7qSx+xr/GhBpTS3f/JxNUVe9YiLeuRe
	 9ILMFDRLYmbyo0xQWDpvGSatGCdSH+sswdMNPkL9pPYtVHVq/YLoEr7kDxpofOl+DR
	 sCnoQPhumXOgg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Magnus Lindholm <linmag7@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	mdr@sgi.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 10/15] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Mon, 10 Feb 2025 20:31:30 -0500
Message-Id: <20250211013136.4098219-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013136.4098219-1-sashal@kernel.org>
References: <20250211013136.4098219-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.76
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
index 6e5e89aaa283b..74b23c43af3ea 100644
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

