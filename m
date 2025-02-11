Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FC4267B63;
	Tue, 11 Feb 2025 01:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237559; cv=none; b=RL1NjMOxOWkCyeQLTTkxpg9utuSj3XZg9ssKAYuk0PRewr3Hihc9VB8XTOCSKZ3LEl2v1LwP7EGaVOHRMmC+BB6iI+cJLHMEoFGARw85jOjtiai+RiBknf9gknQtaN553vRDAbpjxYYqhHT261OAy3LexJ9lml6XCpMUYGeTGVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237559; c=relaxed/simple;
	bh=ZdT8FSHziDvTo3lgl4+V4vle+XXXwAJwbZx2uV0vCNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B1x7zjBLYzT7mlIuqQEIutEUSfRXUTYaVFcsb8JCJ1SFiiVB6gHJaRH18jwicc/pUQJcOmFfXtTo1wYuy4ZVImsQ81g1u5CJaDh4XGxsueyrM+/Nn4/n7eWpH2rhqosPnnPVNuxspvqY8+hsnLfD5iHcDDpRXau+EdKmCj2AdT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qpxgNIz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qpxgNIz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A0BC4CEEA;
	Tue, 11 Feb 2025 01:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237559;
	bh=ZdT8FSHziDvTo3lgl4+V4vle+XXXwAJwbZx2uV0vCNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpxgNIz2RfsIKUV1sN4ChV8pSmJCSh9EDdhY+wPXZWZUDSTllT4vjn2fOX8PnPI90
	 9CwDgDzbw0NAHBOGCZlATzOTWLG0Qj2G30mY1CvKagLnB0JSHj6IanJlesk7iHXl1g
	 +x1m1ShmBE3fuwSpSWW96VE+XqaRXj88griMRbDxC3XZ4GHOGB8P0aih6bl6Y9mMdk
	 znskUJ6rrl4A9ANP77HLpYh81ZplkWw1wcX1Yv7vNQ+gKdExgsJAOW+DTOE4Qsw030
	 bxhuA4hJYbEX5Y89h0o0lQfa/N/b97ueYVm3oUQeJiGfkvxkGptvJmJRuOkuOUorzM
	 ZugHN+0SHK3aQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Magnus Lindholm <linmag7@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	mdr@sgi.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 6/9] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Mon, 10 Feb 2025 20:32:27 -0500
Message-Id: <20250211013230.4098681-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013230.4098681-1-sashal@kernel.org>
References: <20250211013230.4098681-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.178
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
index d0b4e063bfe1e..eb8e9c54837e0 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2875,7 +2875,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
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

