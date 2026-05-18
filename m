Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8142F481226;
	Mon, 18 May 2026 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779112350; cv=none; b=PxS5rmKmM7T2JNhGk0WaFv5+X2rZqRfU8BykKMpONZSI/1szq39+Ga0ot5//MXGQXSqzAaHS1O7+aN6gTrtr+Qa5Z6q1QQEOZ8HBoaTtIJ7a1/eWV8yZR6RqxwUzG8vw5GViSoTCEENxLySwE9kapb1U+RX1D4cIKvl1ZmAsnxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779112350; c=relaxed/simple;
	bh=lWNhLTv5FXzvs3eQd3TLE6Gh2cJpi4D0nd4hOnr2tFA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pFxM2uQ7cxbZM+EhOQd+XMCJwJW/3xOLP9BnsV/8jRBgjAsb0DzrQUsfMS8+u1kJqWIKliA3KyKRX7AwMbWEQogp9/DBsDHUK4R/v37EyAcqLJ1C5maCsk4aJKeRjOQ72kVEI2Dvq3z0OXbScjfvf7Axt9aaSZGcsR5l6EjvQOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PdU3kSc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PdU3kSc0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C237C2BD05;
	Mon, 18 May 2026 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779112350;
	bh=lWNhLTv5FXzvs3eQd3TLE6Gh2cJpi4D0nd4hOnr2tFA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PdU3kSc00Mo0lVjAfiur8q4xeXuLppbXvOc0Chi2jlRQf2tPRG1SWXw1njBEWWfJm
	 KlQO/mEgzt9AGpjNzOe7E3fxDpl9v5gkjwRt9simMyx3gsNln5w9EwIFd+4+PJ8CKs
	 MnmayHjCiHYMI9NN+6R8X1TASbN1YLAa5chNbbQ6Dcnpv8ilqMZ5O14GItPE7y4+s6
	 BDhvwlHE3axfftwDEXg0C0JAOIYtz/NurROjJ3V6JYps0rE4VZDuhHGv9t7XlcUXKZ
	 PK4Tvp5TvFD73MOtPDba73OzUyz8XciQQ2Sv/oSKzxOVIa5+GO3moaCjUYEMYPl5VU
	 eKaRB9sTEwNLQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C92CD4F4A;
	Mon, 18 May 2026 13:52:30 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Mon, 18 May 2026 19:22:20 +0530
Subject: [PATCH v7 4/5] mmc: sdhci-msm: Remove NULL check from
 devm_of_qcom_ice_get()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-qcom-ice-fix-v7-4-2a595382185b@oss.qualcomm.com>
References: <20260518-qcom-ice-fix-v7-0-2a595382185b@oss.qualcomm.com>
In-Reply-To: <20260518-qcom-ice-fix-v7-0-2a595382185b@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
 Sumit Garg <sumit.garg@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1289;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=2TEgOkyvd4r+l0mpS0t2N7pBLvSeAP7e2d285TUvAGA=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBqCxmbFl8JMCvWeUZA1bBL9JGP6YVKVE51lNsQa
 GrjY5i58+mJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCagsZmwAKCRBVnxHm/pHO
 9bYBB/9xnakQ59nUEsBic128rGADmZ+LrKM3pZgMf6CzAY6cRrFIwHtekZF9BC2bLPqGq8bFQe7
 n9/ts8THbKKmZYuNlp/P+6+T47WnvgwvXAQyUw52jKAxb5VhdVSkQ7eUPhGMR7ZgrINp8xUe0OH
 m9FJwCWV8g2iSYKcRF9a3XCPiny/AMo2zBL1UKSMT34ikC6XsAxhyE6WY2nEErte+QoK8rtWDBc
 1ygGoRDiJonOv/td7yJ5h7H9PPJkrpUPMVS86r+idNJGRAfqzmgXH5nr8xzMUpsWvUIh7FxL00i
 X/ekjsKCSK2hzuu6lwgUn5xzhwlt6TNFW5ZzNxmOn76K6wYn
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
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Sumit Garg <sumit.garg@oss.qualcomm.com> # OP-TEE as TZ
Acked-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/mmc/host/sdhci-msm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 633462c0be5f..0882ce74e0c9 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1918,14 +1918,14 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 		return 0;
 
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
 	msm_host->ice = ice;
 
 	/* Initialize the blk_crypto_profile */

-- 
2.48.1


