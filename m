Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C5A2EC083;
	Sun,  1 Mar 2026 01:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330005; cv=none; b=uwY3H7nb/68gCJy4X/a0lGE7Yd4za3PTPptrV7lorPoO4Ywmk8YdvjToQQv48Vx/Kxu3DjNcxrEZQezXuOYKK3AaeK4t6GQ1QdD9Jx5YWnYSEeg7ik1kfQMKDabbaACr7pim0338EJPVkyA/G4yKwMZmNV7C3rmFuYQML7rvpdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330005; c=relaxed/simple;
	bh=y3WWcsnbNdioAhKwkCRTEztl6XRhOrPHSYFxggquwxE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lGym3vU+IgX3gd8DjgsxaBpXZBbkFR44X1dQrWQaYu2g1HTPxzluPq+eJl/NImtvCmjKSMgIER38G0OxRsjWN0eSYpGEWfoyBC81RpFyL7TJ8vtivI0HB8CUaFq5brhQlAv9LkmX407CErzkup3HhTNEJQtuDx0OVZEZrhbFI5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jY883mgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jY883mgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FE8C19421;
	Sun,  1 Mar 2026 01:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330005;
	bh=y3WWcsnbNdioAhKwkCRTEztl6XRhOrPHSYFxggquwxE=;
	h=From:To:Cc:Subject:Date:From;
	b=jY883mgWrRfqr37doa+iVZtDfy0PbcKmzlRIIeXb3y0lF56I7WlAuKZax1P05xr1Q
	 DUSmz+B++RTlwCO0duPvzGXUXn7rx6YMlCuATHivusf40pp/yT/ATTtIzXQ8QTQu/0
	 RLKdxX+Ee6qB+s25J1/oOhu+PFkr6yLFXXfXK/wKPrfjvAeTe4J3aev/37mjx/69f/
	 XW69gEx3CLYiZ3RrP2p2ChvDymRWqxOWF9TlRHatMnLpub4dXJMPObe0/YBV5mZJCW
	 hAcxIb1v7SiJ8Sb+ffDVSVmEEc/QVYt3uurGBJp/gbUMpdCItzGv9F4a26s3d7TMIX
	 cEqcdvTOIK/bA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	thomasyen@google.com
Cc: Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: FAILED: Patch "scsi: ufs: core: Flush exception handling work when RPM level is zero" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:53:23 -0500
Message-ID: <20260301015323.1720142-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From f8ef441811ec413717f188f63d99182f30f0f08e Mon Sep 17 00:00:00 2001
From: Thomas Yen <thomasyen@google.com>
Date: Fri, 30 Jan 2026 00:51:51 +0800
Subject: [PATCH] scsi: ufs: core: Flush exception handling work when RPM level
 is zero

Ensure that the exception event handling work is explicitly flushed during
suspend when the runtime power management level is set to UFS_PM_LVL_0.

When the RPM level is zero, the device power mode and link state both
remain active. Previously, the UFS core driver bypassed flushing exception
event handling jobs in this configuration. This created a race condition
where the driver could attempt to access the host controller to handle an
exception after the system had already entered a deep power-down state,
resulting in a system crash.

Explicitly flush this work and disable auto BKOPs before the suspend
callback proceeds. This guarantees that pending exception tasks complete
and prevents illegal hardware access during the power-down sequence.

Fixes: 57d104c153d3 ("ufs: add UFS power management support")
Signed-off-by: Thomas Yen <thomasyen@google.com>
Cc: Stable Tree <stable@vger.kernel.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260129165156.956601-1-thomasyen@google.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 66223d2908532..8349fe2090db6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9998,6 +9998,8 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
+		ufshcd_disable_auto_bkops(hba);
+		flush_work(&hba->eeh_work);
 		goto vops_suspend;
 	}
 
-- 
2.51.0




