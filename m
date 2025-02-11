Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC571D63FA;
	Tue, 11 Feb 2025 01:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237477; cv=none; b=WaRFBqMPhTSXlW2AmEz4P97opPf9ObNP7KmOj2unmhZ6PUUsxIApoDJnBRVDUtzXyGW4aNcepHB+l1yNpLgBI8L4FTrj/8cVw6w4JrFi0Q2bfyxWphF5CC+ej9XUT47S4kac1OQw2G8oRyA45kJQ5rQGjoobCA+h78Snjv3nqWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237477; c=relaxed/simple;
	bh=MlDIsyeX9Kx86FPPIPQstoTJGgVq4qcyxFsqs8KhqKU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bFQlADgTUxrEuD8ijgihxuCRnFwLShZj0BE5312zKG94NC5k1NsBUqFzxRyhdHU2rn/9HUINwLEPIo6Tg2fBeHXtmZbNfMNbzqQXSEY56rPveFLL5G5CO5Yp+piAYLFRjT44nWaCAjKa+NtP/URrBs9rHYmw6x3wpTQJv2m6Q5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pe5CI4sK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pe5CI4sK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0444C4CED1;
	Tue, 11 Feb 2025 01:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237477;
	bh=MlDIsyeX9Kx86FPPIPQstoTJGgVq4qcyxFsqs8KhqKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pe5CI4sKcBBDjXtkfzY9HaFfti5IW4OpDGu+bQ0bvRojUhs3gkyIJAs17BNhQ4BKz
	 7IAPGKAdJm6yin5rC5LDRZDpdGztggV+eKERmtqKCvVB1Dh4abY/SbFr4LIiZfPVqA
	 Bhf2U/maO9t6PeVResn+0+u9e3MJilRzL+UXdnOo89yuRrZp05oy+zUci1kWucOTAl
	 YKN3ihU6wJLaqVGuJlObxMosoEoWSHLZkqy1Nb+k9Z9/+4ZV+NGoeluhTkdI3d9I5m
	 KgowM/mdA4dWXUBFQoCy9tAVGVVkt1/roTooCn6bf923TVrVUPaEcb1FDDRg64eDZ8
	 rUY665P4NJ+1g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Seunghui Lee <sh043.lee@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	avri.altman@wdc.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	ahalaney@redhat.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 12/19] scsi: ufs: core: Fix error return with query response
Date: Mon, 10 Feb 2025 20:30:40 -0500
Message-Id: <20250211013047.4096767-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013047.4096767-1-sashal@kernel.org>
References: <20250211013047.4096767-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.13
Content-Transfer-Encoding: 8bit

From: Seunghui Lee <sh043.lee@samsung.com>

[ Upstream commit 1a78a56ea65252bb089e0daace989167227f2d31 ]

There is currently no mechanism to return error from query responses.
Return the error and print the corresponding error message with it.

Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
Link: https://lore.kernel.org/r/20250118023808.24726-1-sh043.lee@samsung.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6cc9e61cca07d..b0c37b9060106 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3137,8 +3137,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case UPIU_TRANSACTION_QUERY_RSP: {
 		u8 response = lrbp->ucd_rsp_ptr->header.response;
 
-		if (response == 0)
+		if (response == 0) {
 			err = ufshcd_copy_query_response(hba, lrbp);
+		} else {
+			err = -EINVAL;
+			dev_err(hba->dev, "%s: unexpected response in Query RSP: %x\n",
+					__func__, response);
+		}
 		break;
 	}
 	case UPIU_TRANSACTION_REJECT_UPIU:
-- 
2.39.5

