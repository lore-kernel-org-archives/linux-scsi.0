Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611F140584E;
	Mon, 18 May 2026 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779112350; cv=none; b=GgZStIi3YSiNKNgSl5mRzHdFctNr+PYC7Qkv9k1h83NnLkrDx8XtR5GeNr0BgXYWEfNPALIeL22OksjC0VpOFsxjWrrDLf1fdvppTXv94VTLWBytv6OrcqpRaLrmzdt97XIm/vvaCnHnspcuCcQyFunbvhvLIEW9Ny86guwyW0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779112350; c=relaxed/simple;
	bh=gvlokpn/TIGlt70y5qlx+ktPw+si3rlEvogvLIf0ls0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZYYycfGX2j5Tn3MKLYQOG0RDub0KvxSZCsld9mtNnjT2w1jaHPsackFYe4SMIGmt6USb99pzIiXHhxrpOGLGCDFG0e6mA9oo11j4x7rwUwWN8LIu16tkTCqfB+7FQkIAcaBQbaz5/tvVOiR2W0y4GLRIELGIQ5cZubLNh9RXwFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rhbhU521; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rhbhU521"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BB52C4AF09;
	Mon, 18 May 2026 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779112350;
	bh=gvlokpn/TIGlt70y5qlx+ktPw+si3rlEvogvLIf0ls0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rhbhU521t4OhDzM3Ku6PiDsynQB7UcKtyTeqqDiWNnO0PzYZHg9CZxJYJ44Zpy/2i
	 iB1+kaAJUgyFMc8RkdYub+q5fYEygeNCnSKf/zHM2Pd4ueXCPaWuRTeoxDfRm+23q4
	 KqBvTSNjE0nWhVwrkSXuPcdtE9Zqsi5+P5Tc0MG10Jf6oLgTnOQlL1/19DfHzogWuS
	 DPi+QavQw6dY66+mwPNtd2GRuBdbTBEIIU1BZ/XlCbPxvodCUKnuDjgGJwg1HZjuRs
	 PqTUpkj/elXFStlkK0eVJ70riZFivpQoNboaIs6EEnfN9Pg0voY0k9tKefp9LvaNY9
	 MTeztAn/hYYew==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A36CD4F3C;
	Mon, 18 May 2026 13:52:30 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Mon, 18 May 2026 19:22:18 +0530
Subject: [PATCH v7 2/5] soc: qcom: ice: Return -ENODEV if the ICE platform
 device is not found
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-qcom-ice-fix-v7-2-2a595382185b@oss.qualcomm.com>
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
 Sumit Garg <sumit.garg@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1139;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=MoJs8ZMibzA5m5D/IfOutYFXC9uF1xpkR8OtPhgJEPI=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBqCxmaUeMfbh+4b+/jA4mgHzfcv0MpzPFd4C19j
 LUUpb2u6R+JATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCagsZmgAKCRBVnxHm/pHO
 9WY5B/9DQCO+hzl7uYIQqMEMJAhFdb8kHdkGqMH88YuqGXbOKoVVQHopxAd+VwqGmIlvoVN+2Mi
 mN7/gqXZgdW0YdPCQgIAC9vYG1ZwqJ+b7rvDcWv+qrZu6CYL5gM7FGRfuX58Tlq7t7jeOBp2E/1
 nn7cUdf3RgsvBT8xKJUTDmkfNOV+yYNPqkfKUiFAqkhPSVqeDoz0IYH066x78Exdhe6BGqvYv/A
 JfeB/zlEpRD9yzqMsY24+TnPh3VVnAzlkAu7Fy6IBDiFcWzfQvHm1mx8vQzy1KveF71sgiqG4La
 DE7p6W7jQwqsydGUPfkpyUaRaIO/ezQ6+E1l+DmFeDNuG4zD
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
Tested-by: Sumit Garg <sumit.garg@oss.qualcomm.com> # OP-TEE as TZ
Acked-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 91991864b4a3..85deb9ea4a68 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -650,7 +650,7 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
 	pdev = of_find_device_by_node(node);
 	if (!pdev) {
 		dev_err(dev, "Cannot find device node %s\n", node->name);
-		return ERR_PTR(-EPROBE_DEFER);
+		return ERR_PTR(-ENODEV);
 	}
 
 	ice = xa_load(&ice_handles, pdev->dev.of_node->phandle);

-- 
2.48.1


