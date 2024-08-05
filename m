Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB701741C8;
	Mon,  5 Aug 2024 17:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722880673; cv=none; b=ShSVXCR8Z4Fpz1jTgTs/v2uq7tIaX0osDeRuUqcpHKh0CPQmTAZytQrUtdPkugwJZmP0fIX8WOxYX9GNy+Naqd8Dd2AbPE0A2y56eIc/HVpShs/9wn4bvoMkfYY29zw5YtgSLIMgnaz4HgFSjkfUgRXB/zb74wznf+b9bGBlTms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722880673; c=relaxed/simple;
	bh=DoUPlimrFRhtNclCWd1YfRboQeEO3xCq0hHqgXrZ2yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qp0PtVKF5Pya1VMkd5IW/BHH01rU3+hBQ7qPobbdkabhXq2jmJVNVtRp9g3X0NQtOyL9ISDQ+iL55jYY9/RHz/JUel/UOibAp48MdcCjUTzZ0sgMX0lxG0779o8gtP/hgNhmUDtI0EIGzp3JmmWyhjFXh6NXmm9xnl/P+6nHkdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiLaIusu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiLaIusu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BC5C32782;
	Mon,  5 Aug 2024 17:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722880673;
	bh=DoUPlimrFRhtNclCWd1YfRboQeEO3xCq0hHqgXrZ2yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiLaIusuASrzdUB9k22E4l/CahycTPsKEVlSQLXGOrU307UKrg60ekcFWFgOV9HCb
	 gLHi4GqlVzUYtp+ihD87B6pHKrKGBMlT3txvaskrxOXlnSWsvlJiEjgaeHosV/yI0L
	 /lH12fSNLHSKA66VEhs//ny2lsKZt+Jx5rJg9+zWPKOsIWEeG88Lq6XD7F2z5f4bkA
	 +BytcDe0fmW8rB0DIO2+RiOpkUvp7XKLiprU4V6q/6kXR88IuaSi3oyG1qkdzVSlZ2
	 USOENz6DQ/7e07qZ0593L1TdTlKFdMhXsjnJ6KAhz+Vabczmfy8HPCbg+GxIF0haFA
	 gbKkhIRwL+/WA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	manivannan.sadhasivam@linaro.org,
	avri.altman@wdc.com,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.6 04/15] scsi: ufs: core: Bypass quick recovery if force reset is needed
Date: Mon,  5 Aug 2024 13:57:01 -0400
Message-ID: <20240805175736.3252615-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240805175736.3252615-1-sashal@kernel.org>
References: <20240805175736.3252615-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.44
Content-Transfer-Encoding: 8bit

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 022587d8aec3da1d1698ddae9fb8cfe35f3ad49c ]

If force_reset is true, bypass quick recovery.  This will shorten error
recovery time.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20240712094506.11284-1-peter.wang@mediatek.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d8e323fbcf21a..3a2e19ecf785f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6462,7 +6462,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	if (ufshcd_err_handling_should_stop(hba))
 		goto skip_err_handling;
 
-	if (hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
+	if ((hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) &&
+	    !hba->force_reset) {
 		bool ret;
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-- 
2.43.0

