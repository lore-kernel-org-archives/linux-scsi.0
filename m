Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D125E269CE1;
	Tue, 11 Feb 2025 01:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237576; cv=none; b=bT4luOTjtjh+PsUKHb6AV1ojkT7iLzdrvbSB7RzBfaJynr2ILVEzthLNsAj2y/v8cRidcUWf3Co1HilXjOGYhpTdBXxFRL7XaHb2ktQAZOfzgd+HdiTsaW6tCxmjKyy652TgueRHr/Oi3uTaC867hACscCNFehwRasFCiWrzEVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237576; c=relaxed/simple;
	bh=NntETSmMpoqPKXPrmBQsXny2q4hroXsGg9cv8R8jNBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KXH0nejWuhbpKhcbxL2gq9bGKpjMQxHrHGmPiXoL+AskzYefJteX8+SxiGeXk61SQCcO2ZvyVhuAeDeT/xTk4vQDZd2wNiaIvOq/rrJYBGkUyAjOdcREJXoxuQCHQzZqoPiFGMqvifw2g5bj81hStnftjhHtqAKcZQrHaz7lt8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1RVpcJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1RVpcJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB14EC4CEDF;
	Tue, 11 Feb 2025 01:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237576;
	bh=NntETSmMpoqPKXPrmBQsXny2q4hroXsGg9cv8R8jNBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1RVpcJCrg19c9SrLHqSw6w0XLIkImNpFUBLKrzruu9PRjgO8/TnRFiPZxJs2M56K
	 Z3fHbQPeU2/PGCdXaGVC7lHs1Tcwm/4Bz7nI9R3VUeLTZ1Cyf0IeEwLxxsB5fnKwa4
	 6LsdyAu7iDLfVL3jzujCPbMcxJqJ+Tj0yq+BTb5IFWycu7CBpV6As4wJ+JX/+iy9ju
	 uM33ghvpCMzDhcQPKIZGiuTw43K7tsTHcusc6niRPV/cK4ipFn6jvdVdqplJWJYE/M
	 kWHPOsYPtEY+pFCUnH0bFk4W9CUHsNNruP7I5TBrKXs/LFt//QHQYfW2bohbozbJC8
	 /viErzSgQb/aw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Magnus Lindholm <linmag7@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	mdr@sgi.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 5/8] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Mon, 10 Feb 2025 20:32:45 -0500
Message-Id: <20250211013248.4098848-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013248.4098848-1-sashal@kernel.org>
References: <20250211013248.4098848-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.234
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
index 545936cb3980d..8c08a0102e098 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2876,7 +2876,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
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

