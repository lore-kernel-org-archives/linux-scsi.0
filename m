Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C5076025;
	Mon, 15 Apr 2024 12:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713185358; cv=none; b=raa2QmELP6yAh0VH9cPCyYQ0cDA5HETcAI09iCLtKoRBo86r8sjOc9T/RpohYPZDmqIh+isOszG6kuRWVURyKSbsFuHaeGQYCcPfJct4B5aoe9885ROEu668k+8u2T8LpTmLmmP9m/yeCdHYKRGmlZcjCkqaljbj/MzQkPr9hk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713185358; c=relaxed/simple;
	bh=xeF/Zq3a01ro9m11LFhlH6sAGGaai4u4gzl+O3dH0T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNxLvBwfqvqOP1BgrVdu+4aVD8Fupl3JKPj7t7SqZDFAS4IMbE9JV16CQj4nprS6kvkx7713Lx1zCmjeOVPNhQNtWR3/JIZn9Hp3L1WEuyKjLD+C5Q782fg58z1osExqPfLmRtklZlfQveyiInDgPPUgdqcmXhnC+4tw1hcVs+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfWPQRr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfWPQRr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2351C4AF0F;
	Mon, 15 Apr 2024 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713185357;
	bh=xeF/Zq3a01ro9m11LFhlH6sAGGaai4u4gzl+O3dH0T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfWPQRr2HFI4gDeBmLh7Hqo9jLfYzh8p/wsIMVa7v4qqQuHTePCuSh2fvlTmv6X8l
	 1FYNoxWkbmrX+6SgYCRPOWGvC1VS7JLXLsIsqYBPl6xJsm5wtAnNYtW39IXo3w6h0j
	 DxAuLrou3IrriFUOgajW+3CY5WP2MYHcV+8TAHxB2TKC21t22iNPEs3C+sko8TIFUW
	 519FzRcWhbcaO/HPiW2nulLQHCbrIUBVaMl5GGC/JbsQxoGir8d+hSJa6njhlqJmtH
	 i1WPNexqmIu+GUyFD4e2/bb2ZUmhgqU3h/JrzIE9YqgHw0Gm8Qd3mS5Z8QThQ7CDBY
	 Rhka+qXd+D0rA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jejb@linux.ibm.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	stanley.chu@mediatek.com,
	avri.altman@wdc.com,
	quic_cang@quicinc.com,
	quic_nguyenb@quicinc.com,
	manivannan.sadhasivam@linaro.org,
	beanhuo@micron.com,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.8 05/15] scsi: ufs: core: WLUN suspend dev/link state error recovery
Date: Mon, 15 Apr 2024 06:02:45 -0400
Message-ID: <20240415100311.3126785-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240415100311.3126785-1-sashal@kernel.org>
References: <20240415100311.3126785-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.8.6
Content-Transfer-Encoding: 8bit

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 6bc5e70b1c792b31b497e48b4668a9a2909aca0d ]

When wl suspend error occurs, for example BKOP or SSU timeout, the host
triggers an error handler and returns -EBUSY to break the wl suspend
process.  However, it is possible for the runtime PM to enter wl suspend
again before the error handler has finished, and return -EINVAL because the
device is in an error state. To address this, ensure that the rumtime PM
waits for the error handler to finish, or trigger the error handler in such
cases, because returning -EINVAL can cause the I/O to hang.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20240329015036.15707-1-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3b89c9d4aa404..14a6a100fcdb0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9745,7 +9745,10 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	/* UFS device & link must be active before we enter in this function */
 	if (!ufshcd_is_ufs_dev_active(hba) || !ufshcd_is_link_active(hba)) {
-		ret = -EINVAL;
+		/*  Wait err handler finish or trigger err recovery */
+		if (!ufshcd_eh_in_progress(hba))
+			ufshcd_force_error_recovery(hba);
+		ret = -EBUSY;
 		goto enable_scaling;
 	}
 
-- 
2.43.0

