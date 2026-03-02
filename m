Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564D23D7D65;
	Mon,  2 Mar 2026 13:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772456437; cv=none; b=KL8YS+zfPoVar6LdXjM6qBKh7Qj3t0jM+YaxAP3x6lhAfLZZNu3fIRW5wknj7jdcUqbf+c2VyQ4+U3XYL8VW3a0Cl8IbEJz+65DvO248ukCJ5ayCBo7cU8bD5ZsnvPkKRamy+t6b/tSQ5kJ/PTY8lyfzHZUSjaas68nS6CzmYh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772456437; c=relaxed/simple;
	bh=qO4gAh5r2fusW9ypkr6oNMNi4yq4VGtpzUInmjnoFyQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dI2dr2Yk/mLWoX3/kaNeiTDGyH+qf78iYMhkXJ+6woPTw+nbtsmZKBuB5F8rVyYbQS/SikHoTmWS+gjKnleHzGVTNntZcJnmF7MHszNpQGdN7sjJrtVibqprGHYKf4wmvtQ+ojqp7/TeZcj3bM8yGOq3SHd4Os+R0q0lM3RxGJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQuUbMcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQuUbMcS"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2269DC2BC87;
	Mon,  2 Mar 2026 13:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772456437;
	bh=qO4gAh5r2fusW9ypkr6oNMNi4yq4VGtpzUInmjnoFyQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uQuUbMcSkbMKv4N8q4+Q+RBKg+RwPEU5nWjHUl+QS8mXtaWj3b775FRwv/7Vck6xE
	 M6UqFMxFYR6Nrzi8flXSgB/TMlDEhy35VIYKCZuOs1V+KHDgWmGj/1+ktDLt6CmVc1
	 CC7W4iEkxSyiqsii5HGu3+3jttCCg6s2/KaVTk6Fv6uMiE7oUAL47bdAR7Yb1FBIVA
	 P0yryg2X7DvEnfyT4+fOpPLw0PSVsInHCET4UoGMY9q0UesHxdNgw9eoujk1AFcw14
	 RrXo20M/KL+engfd1cwFiW3PY8PY/8/J7I6WJas4bzCqd3phr5KfGQPmlx2sdbsIoM
	 Y7iuehIyAvTbQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1253FE9B37E;
	Mon,  2 Mar 2026 13:00:37 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Mon, 02 Mar 2026 18:30:19 +0530
Subject: [PATCH v4 2/5] soc: qcom: ice: Return -ENODEV if the ICE platform
 device is not found
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-qcom-ice-fix-v4-2-0e65740a5dcc@oss.qualcomm.com>
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
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=996;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=hWaJRsxgdbS7JVoxpAQk12JWCRBY4hl4BLCSB0VZJ0A=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBppYnyXuyAZt76shPgZ/Z1m/PiwiuWVO+lZKar1
 SOTIGaSwTSJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCaaWJ8gAKCRBVnxHm/pHO
 9dhtCACbsYqlJo9tr8oriZGomZUpdGso3Nn3PFjCdJ9rxibm2kOvnnu45TYiBf2DTj6AdoDwxi8
 c21IC5SVSQXQ6aN1fTCwzKHsI7GuQmgTCtXyUTI8s16dkKhF90o5VfzEgisMjYn5fLORUUIYKt4
 sxXwgRc4Lyi2AV7s1wNM/2ecfsvKh5Wgf+3vOEQzYz6ZjHqF9AcrIiHx7dNv3yc8VVwnenelLrM
 LRtHzF9AnZqZiff0HyF7JM6XxJmm1mSFuepg5BGtu3ddpGuBPEaGCK2U4w4qfTBslrTe9KRapyz
 eJROIDaZR6y2zJHW6B6T5rmlvFsRa3bCUCi3wS19N41M2ehT
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

By the time the consumer driver calls devm_of_qcom_ice_get(), all the
platform devices for ICE nodes would've been created by
of_platform_default_populate().

So for the absence of any platform device, -ENODEV should not returned, not
-EPROBE_DEFER.

Fixes: 2afbf43a4aec ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index a7e7e2251015..833d23dc7b06 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -648,7 +648,7 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
 	pdev = of_find_device_by_node(node);
 	if (!pdev) {
 		dev_err(dev, "Cannot find device node %s\n", node->name);
-		return ERR_PTR(-EPROBE_DEFER);
+		return ERR_PTR(-ENODEV);
 	}
 
 	ice = platform_get_drvdata(pdev);

-- 
2.51.0


