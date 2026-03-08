Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EF02E5B2D;
	Sun,  8 Mar 2026 06:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772951267; cv=none; b=Un0PAGYBLj+RzMh2ojtOHiKTovzJyu0s+FuS7MCIrIxpOXZQffgwPq0e6QX27jXvGe0B62FAwodTxVGYn4tDTvko/AwP4rsgsk/1so/u8sz6QeHrCbIhKDcTNNH6c6HHnyeVavBPTTtm5Ydhml2Rxb9t0ZGaB/UoVf5ecpHG13M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772951267; c=relaxed/simple;
	bh=1eHoa0JSRx58JXoaHKKDpiP/1IcF5/5fTgcvM3Fey2g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aNRwSCEC+dISqz5qDrj7E2Og9WHBgT9XjAmZua+of2qGCnXuM4orP83IKOaMUvbAWQIJsDDUKj7kKHIR2BPdG5ZOwjK9Go7A9AGCwk66Zs4hKMnNgVB3TtirOdG/V9OSl8O7nlLhwYYj8aEAEqzvGjIgplv3LEOuZOiu1JPvyII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHrTQ+Hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHrTQ+Hg"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F8AFC2BCC7;
	Sun,  8 Mar 2026 06:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772951267;
	bh=1eHoa0JSRx58JXoaHKKDpiP/1IcF5/5fTgcvM3Fey2g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZHrTQ+Hg/cGtPDsOfuu819bYycup4rhABpjztxHAcX/2dOXYx7LGWbHFXeki2xs+K
	 Ri8lfdppXHO+nSUX8rl1EwQHChcRlm5BeduS+w2o7E3UbKCz6zp3yjiu/17XAbMcAb
	 wHfyUfWEnp1Wvdw+CGVmQUFJYNvTorvt/vcfRF5mf5L8+8s35Vt+b402DohXZOpHS3
	 GE/aKLK1/pKAa7o+B38/H1Tb3Bm8nFnim2I+hLCR5/OiV3ncKM7a5RDLpcHdUBRG26
	 FFWoDFBWnL0hOiyJYUMXc7dMV/9Xa54RahlhmZUPDOf+NmFag+FcWcuhBbeMpazUZ6
	 HqBEMckckozjw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5290BF55139;
	Sun,  8 Mar 2026 06:27:47 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Sun, 08 Mar 2026 11:57:31 +0530
Subject: [PATCH v5 5/5] scsi: ufs: ufs-qcom: Remove NULL check from
 devm_of_qcom_ice_get()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260308-qcom-ice-fix-v5-5-e47e8a44b6c4@oss.qualcomm.com>
References: <20260308-qcom-ice-fix-v5-0-e47e8a44b6c4@oss.qualcomm.com>
In-Reply-To: <20260308-qcom-ice-fix-v5-0-e47e8a44b6c4@oss.qualcomm.com>
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
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBprRbgLn3T61wt6ZIws4U8+iZm85mLQbn2L0LkB
 jdNzTJQG/eJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCaa0W4AAKCRBVnxHm/pHO
 9Sq9CACAtzJB/b5B7KU1tuGKHbiIGzaq0+XkeDdRyZbJO+T0RjlwkPKJZNd3fDUK4VS98edK5is
 O3MkCT7wwlUQzuveyx7fOf2Wh9FbHMV5ZC296eI/T0rWOmNjkohqQhj2Pwbxy9HQSTl2O8cskqK
 eIEp6ldnBqfI+X0DeDs+u0zUut9t//dQWd9tDiCUfcr1aDLLFTTem77Hg88osY2F+iv8Iz3N5xb
 DI8H7jE6cTJxa9LvLNrmbIB4kQlF+bYEZtHjH4CW0SCH8joAeVOQGyO1aeL9RDwRkygjjRVuxZ0
 Cp9T13UpXDJXDhPyNKLCjXCFyPRcepiDqkqM7J/vpDmKZ82w
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


