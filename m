Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266BA36214C;
	Mon,  9 Mar 2026 06:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773039521; cv=none; b=ra7j1FI2IaJLE8D9SEoyjT+DIPoGUn7ID25caBBNvCwKyLGkROeJyvFDqbU8rzbmxOK/ZgW1MH6TvxCdN53iUBgGAUH4+ay9Xz/SEnvtZQ26U2SKf9bch2MgyliKQ72gHqkOxC3sD0KqlCz6rrKqY0QCkdrGVhANZt6ycCYfDD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773039521; c=relaxed/simple;
	bh=1eHoa0JSRx58JXoaHKKDpiP/1IcF5/5fTgcvM3Fey2g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eyNHIKVXKtirprKknDzPxU7ZgwWtVT3FdPKAwzHgwT6KaZNZie6QjfNixJtiJAOAujEE4oIfIeQ5CgK8J2m7U2HoBvUoSJSKVjORLDImvuc04+KfiJ4VfwXR9WKx2K4VnQ9JXKo2g2kp17tWAVZB9mh+sLTf1201GrPrVAkj87U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rxLByVD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rxLByVD9"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D50EFC2BCC4;
	Mon,  9 Mar 2026 06:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773039520;
	bh=1eHoa0JSRx58JXoaHKKDpiP/1IcF5/5fTgcvM3Fey2g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rxLByVD9wJAgTWyCvqe0Z4fciIC/XPB8Pv1vPkIgzxBf6l3fyRVKmwOtZ146i5xLP
	 RUODvcfqvlwQyx/wBi3ouXf//pkIxVRk/jAo3YOYTd05WrPMR26uQ1xjKt3kgPQt3S
	 xtVX4+mw1y08EO5rLR8g3BxKfvwmxS9++rizm5z+T7QbLsc8GnseUJumm6OOhP7oYf
	 Cmd3gcsdSZfGpceXMkLqUJoJN23BbqRUKRSbM5WeWGbaWlCe6YkzQX7xDV+1R0PMFq
	 VtMffs6rQqi80YtAV8pMKrv2IXc0K0LYA6YUDKxfbiluqURPjexA7mvFd2pooLOka3
	 VMYczjDAhgvlA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3FDEF36EF;
	Mon,  9 Mar 2026 06:58:40 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Mon, 09 Mar 2026 12:28:35 +0530
Subject: [PATCH v6 5/5] scsi: ufs: ufs-qcom: Remove NULL check from
 devm_of_qcom_ice_get()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-qcom-ice-fix-v6-5-4dd3347df530@oss.qualcomm.com>
References: <20260309-qcom-ice-fix-v6-0-4dd3347df530@oss.qualcomm.com>
In-Reply-To: <20260309-qcom-ice-fix-v6-0-4dd3347df530@oss.qualcomm.com>
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
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBprm+cyzgON8I+0A8+YCwC0lnAx+fVb6xBs8GCZ
 /ipeA1Ope2JATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCaa5vnAAKCRBVnxHm/pHO
 9cjBB/0VpU+HI2L2yhwqP42hjHlO21QGAw6dvYMNGT+s6tcQHvOGxaChFT7fUZacU3wh3qXMlnL
 Vea57yF7ffCZLtmqvrlYPooGq1QoEGjDDhnogQyTsUPu65QEnvhHnTBzglNRIdTYYYsNcGeajiz
 7HazNIUcQI7HUDt+jKZ4T6dQuSO0c8AOxzLlHyh/q+PqPK4wihTRdJvE04yK79RBpT3uIYtmqxb
 tvDaeB23VGek+iK37sSqeCBnvQxAO8GDhQxCj/IDhXlqoW1lvH5zAfXZtR9w4K8c5U2Jj62WVez
 uh68KrTn7q5ywmn0lDKq0AFzmZgVcRlf09aPSamG3uWoqpws
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


