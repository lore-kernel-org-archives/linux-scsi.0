Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902B536C5A2;
	Mon,  2 Mar 2026 13:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772456437; cv=none; b=M3Nh4tWj7FZCvWdhUO71sQG+jn3xiZAwvd5cFn3zmsLQeKdKtknGUm29NbI5zQ5Ej+7jL4JAgvINZ3UT51wHjRpxFJWELBa31/hzeicJBAMbsaU+5ZCG4YA9yvamy78Wh3kQQssnWaVtaiMCPrjoQkEUgRB5Ql1RRcMKYLykdl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772456437; c=relaxed/simple;
	bh=1eHoa0JSRx58JXoaHKKDpiP/1IcF5/5fTgcvM3Fey2g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ut/8YGzzrSD6UCPlfwqvnndJp0Qhw4PI4vI2kSQMUAtaz7KYzotndRQqur7+NmSPGKtn/xBdTWzX0YC8gUGs2tMolLpM4Z0O/Cb1r0rpzCGn+v5mg3vUTCapCHIp0EvmV49PhGaRZgovg4ass7S1i7f8y5giwuwMR/gcEXfsBk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UnJzWIkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UnJzWIkM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62FF4C4AF0E;
	Mon,  2 Mar 2026 13:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772456437;
	bh=1eHoa0JSRx58JXoaHKKDpiP/1IcF5/5fTgcvM3Fey2g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UnJzWIkMZtl5K0/JPCVvxb75xeKJ1/SHDvNnzF5upvd2EhPie1clghCAjB+EPIlM4
	 qm+fl0I0gh90/T32LALcYf5aKN1mK7Qj8MKyKhF1PJT7rEeeT8nu1IzD2N3IzzxQMi
	 u+QYLusqlyYjZQ4/iNGDZTNF97mn41NhImL78Va2GzyJ7avgjof9ftPOIy+RPwQc6i
	 zZsttzFgtFHNwLotLqFNnWgOLEWlKe3E7GaEL1kY3E7L99tBLp/XxO68Ciq888YNRZ
	 GD7C6FDodmR18QT8VMlnsRxv4A8QXtLQzpWzPxl6EsoZTDAOPKOoBdCBVoOXB+go2M
	 mtyOOuNAbUb2w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D88E9B37F;
	Mon,  2 Mar 2026 13:00:37 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Mon, 02 Mar 2026 18:30:22 +0530
Subject: [PATCH v4 5/5] scsi: ufs: ufs-qcom: Remove NULL check from
 devm_of_qcom_ice_get()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-qcom-ice-fix-v4-5-0e65740a5dcc@oss.qualcomm.com>
References: <20260302-qcom-ice-fix-v4-0-0e65740a5dcc@oss.qualcomm.com>
In-Reply-To: <20260302-qcom-ice-fix-v4-0-0e65740a5dcc@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Abel Vesa <abelvesa@kernel.org>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 Sumit Garg <sumit.garg@oss.qualcomm.com>, mani@kernel.org, 
 Neeraj Soni <neeraj.soni@oss.qualcomm.com>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1114;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=TzqKhDLr9WN8kubHG4egYv7EvzBCe1kNbA4zOiRN8WE=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBppYny3mM/pjsxxe74LpHcBCBuM6O78WcNJbaJ0
 muUFmU9g2qJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCaaWJ8gAKCRBVnxHm/pHO
 9aQcB/9b0jJ9AdO0vPQV04cG04qKpN+0ub02IqFskXFTaZbgMqRzF0sPxdZY+vzVFMfSBlXUhmB
 cR/mkQvxxxXmnIIQ4hqQyMuW8N61rWMCm/rllIFs/pQ5E9m7z65k3uy317FHTWO+AmNKe1DKOZJ
 H+h9/hKrM3npOcf/Q8R3wVw/t1Q3LKUJT5KQzz0A+GDGAyH1/bYROuvSAD5Eye1iyilHVeAYodU
 yvbSV5tGXNBzS7ZAwtprvt2rzTLcTMiR2/y089tcM96/el2kF++jEwtdlQ3khvtnmxhFjxofcr4
 7vVbUMOtwgxRLodw9hHFGa3mPrFE6HauMAhBJvc/yLkGNwFk
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Now since the devm_of_qcom_ice_get() API never returns NULL, remove the
NULL check and also simplify the error handling.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com> # UFS
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 375fd24ba458..72c24ed65fe1 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -177,14 +177,14 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	int i;
 
 	ice = devm_of_qcom_ice_get(dev);
-	if (ice == ERR_PTR(-EOPNOTSUPP)) {
+	if (IS_ERR(ice)) {
+		if (ice != ERR_PTR(-EOPNOTSUPP))
+			return PTR_ERR(ice);
+
 		dev_warn(dev, "Disabling inline encryption support\n");
-		ice = NULL;
+		return 0;
 	}
 
-	if (IS_ERR_OR_NULL(ice))
-		return PTR_ERR_OR_ZERO(ice);
-
 	host->ice = ice;
 
 	/* Initialize the blk_crypto_profile */

-- 
2.51.0


