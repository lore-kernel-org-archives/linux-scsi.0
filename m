Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45F034A76B;
	Mon, 23 Feb 2026 08:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771833776; cv=none; b=O6gRSj2vKId1zeeNP07f5VM358SKKmX1VJREybtPeVCg9ESLeijsuqehuGT7hJXhphI53N/dqFIJBhriu7HwcPSDmOPN+Yag5Jf/RBUIji+6d4R+Nsy85ji6gbbTNiAgM+0Z5VDjwHYQKI5pX/gByRQa57T2JEf2H53dtPyaNHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771833776; c=relaxed/simple;
	bh=fIjVtLv2PApm9p7zByR7Rq2/I5Linm9JuIiBx8Q7GZw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=drYlpJ0GUAqG79YKPLavw3v3arojTtL924Ki2ive2Y7jDfBt28nnap3aTlo1d5JkHOnjka/K8g+2QqLH9C6aqExfsZQ70dHgeSmtQRL2evbzx9bKC1o4WjcipTJDOWpuNlE3sdgb4TSjnxR6OR5oIoS/R5dp7b58Mq//0rc4KvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kk8mLYXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kk8mLYXW"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C789C2BCB0;
	Mon, 23 Feb 2026 08:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771833776;
	bh=fIjVtLv2PApm9p7zByR7Rq2/I5Linm9JuIiBx8Q7GZw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kk8mLYXWt2PfTjRNJuPMS6uTl6gY52vkoWkBU5gONCd4SdIKYDNzUUqOY6u1GkcP7
	 N+uTUiV2mpfzCsqCaEyOGdd0jJqPr3E1XYGeoAvzdrhPCzyTSDVwURFzbSHytZ0m+H
	 /ZrzkhXLpqajKIBBF851wosVgfMPJaxMIWGzQY7RumV0PaJ8fdD8926OyagTncG0Xw
	 ytqIEmhjJkt9fGl2yEq8IeN7wWca+48Kzuuf/UH0623M60/RtOx4IypmVW/Blx7lTz
	 1+tmqGVsHMmalmhAhGKx25l9m15g4wvgSJBWQD4JgV+MjRA6LUYEUNWiIa+JH8Y2po
	 RlnM99RZ45hrQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616DCE98E00;
	Mon, 23 Feb 2026 08:02:56 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Mon, 23 Feb 2026 13:32:54 +0530
Subject: [PATCH v3 3/4] mmc: sdhci-msm: Remove NULL check from
 devm_of_qcom_ice_get()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260223-qcom-ice-fix-v3-3-6ca5846329f7@oss.qualcomm.com>
References: <20260223-qcom-ice-fix-v3-0-6ca5846329f7@oss.qualcomm.com>
In-Reply-To: <20260223-qcom-ice-fix-v3-0-6ca5846329f7@oss.qualcomm.com>
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
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1276;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=+5SkLtRpHTnkAQ9yZWBecUdG7TMHCu1aRwm2dHYl1LQ=;
 b=kA0DAAoBVZ8R5v6RzvUByyZiAGmcCa7ILwc+sMS4UW73gJNjry32Y+Ztk9b3R5XH3c7xWFZzt
 okBMwQAAQoAHRYhBGelQyqBSMvYpFgnl1WfEeb+kc71BQJpnAmuAAoJEFWfEeb+kc710RoH+wUi
 +MI1ja7/D9w+L7CkVCy2ZG6ciwhDyPyGwCmkQd51cwdSoGKbQT9JECy06noV7cCgxAPfMs6jm+j
 nmm+c8dDGXjH/uHDsbqhozWlQO7vpmRCMIl091haPFlScwVa+QYq99RwOnO9MScwLDcJXDxedmg
 kf5USb2jaPaxVgrLU0DuyzLgCs0Dk3gor8LgQNtfS97i7qijUfuXdjXKz83xGdgDdHVXz+jcxIq
 bFk15ijS8A1XCTuAhR4c+Zjxz4stBX0BfiqlRXolljH15VzW9ksD53WZs6JfTfVAEEFeOOa2BBm
 UfXwpSSfXfHaRVITLvoV5A/LnfzcfW87Fe0DRVk=
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


