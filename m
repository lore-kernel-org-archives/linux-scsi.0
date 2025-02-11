Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407431E47AD;
	Tue, 11 Feb 2025 01:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237512; cv=none; b=eatXORTCqFhJTe4z/6HuqEwfTbWyAStIbgXLG7zeRQK0SelzFwNftM+yo+G5BLyreu+ImP8F7/15VyZ6vUiaB/QqojzPYEy3XxOFvZOvM58fzpNXLgT+WmtukCSRK170ACxhu9RqXXxm9MujcENCXGPjN+tknGLtizpGViIx26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237512; c=relaxed/simple;
	bh=0eBvUKEK82giojtNxyzYI+1xhTf4jVlRIIp8RtZsvl0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OJMvd9lPQ+FkDTOaPxX1jxBGUblPPQzWuWFIkFx1CG8DnjQKwcClGG3SLugAh8OJb6HQ4wKzWnt5kgFeKBHp2LPERJXqchh36b+I56jk24PgAzZLkBgaayZWuTcYkDoQv2d4mzwD0nHEtR6M2zWuvPwPucgBAZGhZHZ+M8aPG6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTXvQUE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTXvQUE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10F0C4CEE9;
	Tue, 11 Feb 2025 01:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237512;
	bh=0eBvUKEK82giojtNxyzYI+1xhTf4jVlRIIp8RtZsvl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTXvQUE/378ZfDFc/+aJh/ajgPCMq727k7yi1hSdMsnY79V5Dh5ZVfM09ieLune00
	 VWV2Zoc0U26Xj470Nzs2dzynzEM+uk6Vo2R5s6Yz5nBUsd+ckhtds0UA00ZpZUrzLd
	 5stAIMaJ8BnWLT2asgAS8OTyfHR6GkyLdw9vM1k5wtaNrkb3XuyppW3YpUa6SQmQis
	 JgKmd2SxhSlbXTcRQLCvTnTzZO6/TlQj2UDnBxc+1qoan36YvbK2YPQM4f34AIfCF8
	 JMeXX99JqSsEiO0zBUb0u9aDGjH1Tl0XHeP93xtiEY5E8eTG8oYH9zO0HY2/WY2lor
	 zqn81Q/5g7uBw==
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
Subject: [PATCH AUTOSEL 6.6 09/15] scsi: ufs: core: Fix error return with query response
Date: Mon, 10 Feb 2025 20:31:29 -0500
Message-Id: <20250211013136.4098219-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013136.4098219-1-sashal@kernel.org>
References: <20250211013136.4098219-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.76
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
index 0ac0b6aaf9c62..e843f69b8d3a0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3013,8 +3013,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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

