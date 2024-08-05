Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6EF165EF4;
	Mon,  5 Aug 2024 17:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722880723; cv=none; b=DC6HFZOa3dvyxQM0kco8qNrIBS27QK1feFBD74oLKpWU028ulX1o9QusM3wpMbJJ0Qv3XH8FouAjtRRsQTffpnSDN9VUEwDEE/nrU5do3CS+HNSE0ZhkrCW8fPnnY7ZOLAnDHjEyDEwUvFikWa2iZ8oXtoqkF19459lAL09BpSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722880723; c=relaxed/simple;
	bh=bIZe5Jvq1zs/7HsxziOkORbDxZYEuv1y3vFfSPzIUpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meul2kXfO0MniPeYjizAn1EShlz58F1lESjM6iu39pi8xGyMLvsYkd0mE/0fBiUJVjwYFa7vm2EWO102GoIhnRDG4LlfrkKBJIQduW4C1V8f0FthbHnOn76SxaFcADv5mD/CHjXVyatBs+RCY1YF6Sr2/p1y0yCHGOOR9AmBb5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YHsKDxgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YHsKDxgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CA7C4AF0B;
	Mon,  5 Aug 2024 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722880722;
	bh=bIZe5Jvq1zs/7HsxziOkORbDxZYEuv1y3vFfSPzIUpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHsKDxgqWZhJdABtZ5fNwO23z2dRDO1b/pp94rkJO6l2ZqFHd+FILt+5zmwF+kAcy
	 Ir7vImLmyL/iG7LFSArULYA8wjOYBRxysfmjItk5hiB5+cvf4N0AMM6yBZuxSWo0c4
	 RUt4bdbUnU83XERJyBb0i9bezyRaT9SagW3M4xH/vu0R5NhHVdIWFywGAJliPvnnn2
	 Q0ZXJG9r7HXR9zNkYALQ9jofzrPYUB3WPFg4U9HPN0M1JQ8wq3fRG2+xy4grSkuKAk
	 5F3M7dybcdvvll57R1VuQNlSj5aTk3eGbQvnO1nm5gjn06tDdLwW198FDI0x7Sx0x2
	 x9sc6BGQw3vVg==
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
	ahalaney@redhat.com,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 2/5] scsi: ufs: core: Bypass quick recovery if force reset is needed
Date: Mon,  5 Aug 2024 13:58:25 -0400
Message-ID: <20240805175835.3255397-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240805175835.3255397-1-sashal@kernel.org>
References: <20240805175835.3255397-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.103
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
index 5922cb5a1de0d..aba1f239099c2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6302,7 +6302,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	if (ufshcd_err_handling_should_stop(hba))
 		goto skip_err_handling;
 
-	if (hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
+	if ((hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) &&
+	    !hba->force_reset) {
 		bool ret;
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-- 
2.43.0

