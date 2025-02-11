Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C22E26B680;
	Tue, 11 Feb 2025 01:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237593; cv=none; b=Aa4IG3Zav1RiEp7D3KQRyTRow788Uqcm6oEFbz9QkLSMcOAgiFlOwriqzP6c0jS26aOpaDERqa027jTEIie3btLI81HAQEmKKidpZcCGhttFpg3rIS3+GRbSmmRww63UhrnH9d6tOtyM/aWTprgRoCKIhavcWBIn/5JEmlkytTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237593; c=relaxed/simple;
	bh=sVpWVyVIi/UBNokcUGfr0YLYO3PC27CRMpOSlEF7m64=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lIhuNzdXdBfG+0L1CR6B88FWeZVKocsXCMS45aoqnTeVRyjL0fFr+yDPSveRs5Num0TTCvqjUmf0Voi51y6PdpXF2NGzlVduBCQql31UOHPpq0ot4NYAD5j7nXwsHsBdytZfxbUAn6J84b9/jflLrUfqhpNT4pSEUXBIK6Hq5D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p9uDfetU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p9uDfetU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5B6C4CED1;
	Tue, 11 Feb 2025 01:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237593;
	bh=sVpWVyVIi/UBNokcUGfr0YLYO3PC27CRMpOSlEF7m64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9uDfetUpCIWeBIRtMg2dHIoS5NgzDzsjf+zDNHdllHafjyZQsaDBlfR1KA+2KfxA
	 DWkeNzAvdsAvSlapsOJ4OnNya1Fs6Pa03kca1D/KyEf2/HwEDIUnRMAuywQGRJpc4m
	 UruFJTW8KsLrTOtnDQJYGldi8M3ANcAyhxX8FemON69OwY7R/DAUYuQ5x0p1757rNF
	 d0b84dCawZgKN6zVoQmqhlAMw7geusviIuAFm8pnVCAbPd24b9PYiI0A0Z/d1RxSVM
	 yqMra5addcqhkjg++iYOldqqqwSSlQUcB70hA6if4auz3hrXiyc+/mN9OzLDwF2CN1
	 vfG06KxwRTP6Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Magnus Lindholm <linmag7@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	mdr@sgi.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 5/6] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Mon, 10 Feb 2025 20:33:04 -0500
Message-Id: <20250211013305.4099014-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013305.4099014-1-sashal@kernel.org>
References: <20250211013305.4099014-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.290
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
index 832af42130467..a13db27b04ede 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2871,7 +2871,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
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

