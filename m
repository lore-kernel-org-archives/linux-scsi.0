Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066281D54F4;
	Tue, 11 Feb 2025 01:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237427; cv=none; b=qMSVN4sDqULXZMtHNVQeRQa3/q9n2CJvvFZw/c/Y8zqL2eLFuBGj2HzzD6TCdLgcjWilgIDqb00iLWUU4k33yjHEcQgE8Z84MzFeaZheY8/jp46A5HtWQAuEpkjWigHE7x4GpRCM5wkdW8iKq88oHQ8ekajQH4XpPqnlSupzM2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237427; c=relaxed/simple;
	bh=CT1iK6n+FJN9evEq+NQKRxRia2cbAoO0FXrHR8bLfKs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e6eCpPqydj2WBsZtMpBPwHekCwhl8dkqtM6FqkgZC6dUgGRFJPF3luUAnamPteWcot7vEkGSaMeNQKy6+kccT7Ze060KYOiyHoh7fYO1uq4LyP3Z6uwZ3kjJUfhit2Z7pWEWpzPBLeCGjYRZqwvtR71ZeVOkdyqyPI8rj3ntSgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LcBdHo8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LcBdHo8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B45AC4CEDF;
	Tue, 11 Feb 2025 01:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237426;
	bh=CT1iK6n+FJN9evEq+NQKRxRia2cbAoO0FXrHR8bLfKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LcBdHo8x1HdhyKtNTokI92ccCaBvHRM+H+NPRPVeafPWHlNTtNCOKEKllrktWcQM7
	 TWvr60M7+gRQt392lcK45h5pw/i0HkL+sLSPbRdDFmdRS1pjtEFqYsemgKknt+VFLV
	 8khgdjzv8Il+2sWgPRzJurZq1HjAb+alA+PKNolcQzfxLvNY2py9deCAHCRW6O9ZZ+
	 bz6hNPx30gHWbx45jdPz3phEoDUazZX12hGyon2W3RJ+G7Lio96e9BolRsZI4cO6VB
	 1YTwKxgZc5oaswYVouAlfkpbhF10UrjK703iv0ZXO7Lbei4va638osXh7U3nayc2Ja
	 yVlyI+wJJZHUg==
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
Subject: [PATCH AUTOSEL 6.13 13/21] scsi: ufs: core: Fix error return with query response
Date: Mon, 10 Feb 2025 20:29:46 -0500
Message-Id: <20250211012954.4096433-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211012954.4096433-1-sashal@kernel.org>
References: <20250211012954.4096433-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.2
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
index 9c26e8767515b..97e50bccb95ce 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3118,8 +3118,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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

