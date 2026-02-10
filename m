Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4B732E750;
	Tue, 10 Feb 2026 06:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770706619; cv=none; b=tVEHBRGhzGyRuIUmhQnh1TDf7i/3AQv2n3dfrfWVFygj8exse2whj5qJiWqiYBnSHiq7ZV2eIQSl6nw33QFQ6vm3D342BUJLt29dAz98xf8utmzbQGQeXdYv53heGOXiefsHuAb2rpLWdQ3mLJBSkddJJTQFp2JILum5qoNhUCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770706619; c=relaxed/simple;
	bh=BqHZGQIeCQ45SHzcHrF0Fr/DAKVMrwgf/SUEWdoIFb0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=csyFe/Uom5cH49FAhH8FNWR57GbbGV+Mam0h79VSGsCrkkVT20GALPZ+/d3gu3WgVsQs/yyWq7MyRcbDBBNm8HouQNYEOq9Jt9O84Xh/ZG7JzqF/wkNx8XM7W7ojbD9jxMzRfK+AtI4InJa5fAEe46U251MJUHR8YGuxMsQwNVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pi7wZMB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pi7wZMB4"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8ADCC4AF0D;
	Tue, 10 Feb 2026 06:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770706618;
	bh=BqHZGQIeCQ45SHzcHrF0Fr/DAKVMrwgf/SUEWdoIFb0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pi7wZMB4OyDrcCpDoqfQdeZ6mbBCKxYR3hG/5x0+Vmr6DrP3p4ybynWxeVtj9IX9j
	 +hyHd9AoVtBYa45lYUKHTX6SFdl4JLPEkWJzkEXNuNIEg227d3xHEBu1mnnGBvQEJ+
	 8C+x02pGjckz7KjdhdAJasoLt1NfV5Xru5/iA9eUWIeu8N5LtF0JvzmuAxaf0lkyLp
	 DIPdTu5o3QstdFHxQ7su/1CWdSZdG1AkgC9nnqkFK3Wv+gEZe5TJOgju28VB3H0geF
	 PDuow52fo/WkqcGHhL7H1LrcRtlALC/cCUbWvjcSHSxUeU2Me1mimLlLhzx0X1fOZo
	 Zq1QvqSmHHYjg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6E9EA3F12;
	Tue, 10 Feb 2026 06:56:58 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Tue, 10 Feb 2026 12:26:53 +0530
Subject: [PATCH v2 4/4] scsi: ufs: ufs-qcom: Remove NULL check from
 devm_of_qcom_ice_get()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260210-qcom-ice-fix-v2-4-9c1ab5d6502c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=988;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=FiX0U3Dm1c+1x6b4FdICdmWPYMgaPZ7RllOZdWKy2K8=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBpita42yOVZvNIs7XIN83MKt1HqaVNv0rUcGwMj
 6V1ximH0EqJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCaYrWuAAKCRBVnxHm/pHO
 9fx+B/4gycPlxXLFgpHn+yVLSbelGWv8BKp29Oc7vTQvS5fmWt73d9YPbmyfTZdS8oyUixibIyB
 kEyYLxKTqDBjV3Xq7GHx0bCc5xIzKWwchVW3NvP9qB3AzNYy3QkEmTj/8YOmAh6OrhxFL4cw3wd
 I3Ag5/FxcdSd/ND04ug4B+P6dW97zvT+0DimBimsGGDX3QJvmwcW3xqEn2IJ6A7rkIpFgl5kXmH
 j63Rj5wJFbkYT1xlpiZBYWtJMhJS9aOhm5elMwC6f5YsPncwIGULfaioRb0R3Q5Lh66+NG7u+Wa
 MjQd/jeTErP7lOn9qp1F1Zr3knyHdvU8hZWWs+G1OjBi3juG
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
 drivers/ufs/host/ufs-qcom.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8ebee0cc5313..6ab08565413b 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -176,14 +176,14 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
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


