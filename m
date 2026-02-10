Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CAE32692D;
	Tue, 10 Feb 2026 06:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770706618; cv=none; b=VV4QXAeRYMlt2Yg6cl3uPOjW9HcAlr9DMg93/Qufk/iSQRsxdquwTrWTiCSi57z2LvEnBLfCD1tghMnJkg+j9FtQF2mtzN9EvceuADSuq/aPf+4hPWpO8l6kZvla/kiKz0s/3KYD77Ae4b8GzXQIFbgCPSEZfTw5k1YQKKi6ASE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770706618; c=relaxed/simple;
	bh=lh1qd96ymZJU5LO53UJtp+J/py70ywlqsW41wm3yqkU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uDbLDI5Np8VeJe/tayp1cS4YJNetc1gGotovDEYo/AIqvKbGrhEkrjwO21VOj1+HHbvmleSnrnql8IoO3ZbE1Zs9keD9EiOyWKEmdTR/78u7baJr3kyRlSV8rpHfnTIBfDrlHhyw1U7RrFwHNPeABVexl9oHR9lt9rSIC8+3fzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBvy++WK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBvy++WK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABA93C2BC87;
	Tue, 10 Feb 2026 06:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770706618;
	bh=lh1qd96ymZJU5LO53UJtp+J/py70ywlqsW41wm3yqkU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YBvy++WKVloTrkXiDN/9KMtYIc/rOiR3sDJwLYsyyAMc1MYeajtWExhIphO1Jop1e
	 TuhH3EvgnO/H3/s0C/9hH+YBpGzsUozAZcQFunVRPdNzF2v6NOFPXIDZL4HfdKLvFz
	 eMYZxv5np1exqkQto7q6xxbJMBPLtxwhIi4dI/p4ezy755bRmAPG5h/yxJucvba7P/
	 9s0iCY26T5sLLl0DaK7xTNXR4xECwtS7vYohUhZ70BujEUg19CvzKNzqvP5/SoApB7
	 opOEeLiyIBScgKCFG3j90yw4cxByQA+0APjKVMEDVEsHl5zjVnNCOxQLZrKR9raEe4
	 ls6HR4EKpMDmA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5F8EA3F11;
	Tue, 10 Feb 2026 06:56:58 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Tue, 10 Feb 2026 12:26:52 +0530
Subject: [PATCH v2 3/4] mmc: sdhci-msm: Remove NULL check from
 devm_of_qcom_ice_get()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260210-qcom-ice-fix-v2-3-9c1ab5d6502c@oss.qualcomm.com>
References: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
In-Reply-To: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abel.vesa@linaro.org>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 Sumit Garg <sumit.garg@oss.qualcomm.com>, mani@kernel.org, 
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1116;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=RFJ6aiBL+C6phcTa/pja7cXNj5Ir3ve7IHMAT5QAUyo=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBpita427DMd6zsyCIBZSsjTuQycO9zekmH/+DrW
 8VN5F5v10CJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCaYrWuAAKCRBVnxHm/pHO
 9ZovCACIifNUXJ1AaJ5ODxc+RIq7EDZczAPEnS4OIlHkN9A2YTpab8UMmsh2hcJ+PwLUJTCVZ/t
 M+xqfmbQwnLDbpXT1fosJrSnKjeZnf3g0SRVAVdEMLq2DFVspQiU8buTpckUN5GEjukPW2JPqew
 fpuSSFnEmDifQJUSIXTK738VHuh7Eu/PzqiGMre4aOfPI7JGUp/rydbXTUe5GQl+uT/t8+Jjapi
 rJJ7NO5s4ugh5GTAaOsv/FRTMvxw8GcmzWVfRoJGcZkz89+jqpfHqSMKbMLMGcztXXxkZhcdOIa
 6bbAPn7wh46plBz/laXuXp2m/07kf0cP/VqSal2oO/6OB0g9
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Now since the devm_of_qcom_ice_get() API never returns NULL, remove the
NULL check and also simplify the error handling.

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


