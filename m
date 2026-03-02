Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790BA3D6CDB;
	Mon,  2 Mar 2026 13:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772456437; cv=none; b=gA3zXO9gHQfgOAbbfP5tJicUUwh25pWMG0oxtO5xbsE3o/MfOjdbPYjRCbNC4NJvhtMEB5h7KTJ6lHrkAZPz5KAonSNHU45xIR3C9CjQP3bRFCRc0kkK9XYB/3Etcp8fOsTkBWdmcYQn/wE8UJRV//vm9arK5U4wmU6LSMTeVcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772456437; c=relaxed/simple;
	bh=fIjVtLv2PApm9p7zByR7Rq2/I5Linm9JuIiBx8Q7GZw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OMTxlTMUJdiE5/TQmSPEvIxAphV/7TYiHPEJUPQu3vleeXgjFTNW7b3+evm2FX4uD/2RYSYt68JbJ3r6UZM81dfU+QNmteJWQh36E0esrOCV+UQJNgfDsVD658ZxW8dNp0Tx2WqBMp1nCJNvt7/FV/coui1mCkF9jZAWMeWcKso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BtmGnuJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BtmGnuJP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49E04C2BCB5;
	Mon,  2 Mar 2026 13:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772456437;
	bh=fIjVtLv2PApm9p7zByR7Rq2/I5Linm9JuIiBx8Q7GZw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BtmGnuJPvKsoT8Dc+8XEAR0CTAEdfFZVaXWeCCzX0lNJWH7aQcW8tGUao1VbuNDj+
	 iaTZgx2+sVSM0yoBixg1lBoPIIdR0X0EMEOHyl5YR446rrL/3mxij7mEG9wkxAECYY
	 M+iAGz4hM8qicLUQdS+sgh2yayzAlliDstv0m0xpk4Yd78oUIa7h4kjfSTdZMe4w7H
	 MFn5zWk2BV9ooScijBvwVuxL8UPI0TOmhOPmZxuIu99WoYyL2N8zuptnFt3YokiZmp
	 X5XdQZYNJ3isnz2N2U+O50ZTRSWzUBUii9kGmPwjKJW1SLIiiKX0BDFeq/DOTrHFHr
	 P7UqbyFpZIs2g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC1CE9B37D;
	Mon,  2 Mar 2026 13:00:37 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Mon, 02 Mar 2026 18:30:21 +0530
Subject: [PATCH v4 4/5] mmc: sdhci-msm: Remove NULL check from
 devm_of_qcom_ice_get()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-qcom-ice-fix-v4-4-0e65740a5dcc@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1276;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=+5SkLtRpHTnkAQ9yZWBecUdG7TMHCu1aRwm2dHYl1LQ=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBppYnyWLul+OebZhtQfx06bRZ+zl5We93nLK/wf
 CvwAmhqp/aJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCaaWJ8gAKCRBVnxHm/pHO
 9UysB/9XzWaOstq7nKp4SviAymNA1oyyZG0PjZpqiPysLvHKxjwtoi53UURPldidL4YeeWItQpr
 RS5kv3omZGPnQvApDm0Vr12fjRqpWcse+qAJgcJYW32wgy1+PUWfkTh6goc1Sh+bU/uDcjK4jZ2
 OfglS8qZH4YGMdVwKZ/XMtsH/eqGPDmPM7cpJ/qOktQYAK5ZxVdrUrJiimQ2Vq5XEzLTz4piFaL
 t8Z9L/dydg5DZM6qaB3fv8imuaqR4Pet23cbTqzRzSl92vXznsFfUr9KeX8LEYkaNIRyc/xvpJi
 omLW2y1pxnjfs97jO5weM0K+yxd7RbYxheFesIKXBxvGExjc
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
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/mmc/host/sdhci-msm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 3b85233131b3..8d862079cf17 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1906,14 +1906,14 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
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
 	if (qcom_ice_get_supported_key_type(ice) != BLK_CRYPTO_KEY_TYPE_RAW) {
 		dev_warn(dev, "Wrapped keys not supported. Disabling inline encryption support.\n");
 		return 0;

-- 
2.51.0


