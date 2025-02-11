Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A571F2364;
	Tue, 11 Feb 2025 01:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237478; cv=none; b=Bqi6I/mueE1ZsJ7dKEhksB4MLPjcJel9MHCuBnfXq5cjOog8D1t0SCJl2bR5ge+EiA8u7yjMdecc528eJ8BV0nkQNXCP8GjDCAeeTQRR7RnXZEmvSPkpvjWdNR4CyV2TAkwOvWiG/2v1wEOv1TUTstmkmm1RxHjULS6EQFp05TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237478; c=relaxed/simple;
	bh=2p3d9rcWhiRUyaYYBIzZpSMMGDD62ma37zHkTzTzjz0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZKZ93xJX5ed9idJLilwYZrXXZA5GqbFZXfQYySotaed7egMwrh53wJTQqW5Tm0ZF5eNsW98JQQNURXamOSnm2XaP97+6lrff9W2FyVo8xyRSXSANQpGn46dgsK4PEpt6Bo8ncI6dvxR8f6+nqtwd2FWeaJGdIMPZ8ihfGOApIRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONS/ZjAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ONS/ZjAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF8BC4CED1;
	Tue, 11 Feb 2025 01:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237478;
	bh=2p3d9rcWhiRUyaYYBIzZpSMMGDD62ma37zHkTzTzjz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONS/ZjARYgCIjTEkse16nVGFqBmXXHAGz4krgkrpvp8wU5DKckBqUafJwLH/aNQg0
	 uaK5CpirCtQ9Teccx5vbqV70ZJNf4/0z8TPrglOJ8wUO6SFouPajfbGzwX6NACh04T
	 cOZ4tOF8NLvDlyG9Dc18QRrcxiaSvGgDW3WZFGw5HN/kF7jCloB+b/ALR2eyqJ/QWo
	 qxSfvaFVrYzq/JmB7EK9QKDE8dbsjUavE7AXnahDLzr6IXr2e8ATlJfgReLvDZq8KG
	 6UZS1ae/Lh56XQxcu495AfDXNXeuk7O4BdsETJJB0X78tlgrtckSs3dWUNaFr53ZVH
	 YbAVm2Tw/iVKQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Magnus Lindholm <linmag7@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	mdr@sgi.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 13/19] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Mon, 10 Feb 2025 20:30:41 -0500
Message-Id: <20250211013047.4096767-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013047.4096767-1-sashal@kernel.org>
References: <20250211013047.4096767-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.13
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
index 8958547ac111a..fed07b1460702 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2867,7 +2867,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
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

