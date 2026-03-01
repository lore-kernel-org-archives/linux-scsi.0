Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DD6274B42;
	Sun,  1 Mar 2026 01:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328347; cv=none; b=bxDUvSIORFAVLSa6ZJHv5ti8PobN5qs64gwCURMUy6JP0bVSLDdrt2JDL1Nawma0S6piK/8ZRDxeVSx4cNxnHK+uzqMaK7FtPYlq6qd/RZJcK3uEpk8AcN7Wgh9JjlWlLHr2yTmyWh25hiJY65ReJO/nxHYra/QdUpAUgZRVhFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328347; c=relaxed/simple;
	bh=jHUj4j0OlZX3qQ+irl9wtqpBEGMbY23kRfObPdjCQiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LHmli4D69T6OXy2jl23nFBWbBBoCZ8Czx/PyPWu3mfJjJuHuDzb9elty98gTJizPd0CsUDQthA+QQ+fJmuTnGXp8A3cTUByRRFL/ah9P2tA6TXhwA3k9eZy9eiKuN2In7IDx/xjJx89fO6o5N8JCYaPGbjCSZ7qfxcrURYJmugo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMuhY1yS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMuhY1yS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F79C19421;
	Sun,  1 Mar 2026 01:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328346;
	bh=jHUj4j0OlZX3qQ+irl9wtqpBEGMbY23kRfObPdjCQiI=;
	h=From:To:Cc:Subject:Date:From;
	b=LMuhY1ySRjCmDIEEH3GXIdzw4QlNqv+31NjwA/SwPlN5JUwMTjsnqgd/W7eXOI5Db
	 lCFhrNzIdGjOSbJu80uupmfSHmhg2qFzbbMfUsxgxGyJ1PiWRRWRV3zWen4McoTu0t
	 P2ANUWluujN7qbC07QXw25pGS/YPwAmH+4KY5WbyIpG0IrJRNYtFoVMS+l6a7t0SJi
	 2epINfZMlBqz0JP4M/B3cVd7v4rn144vBKRO30ay6FqfcvPucQvqV4NWWgig3zLRa/
	 aO82U8OMdEvYTYgN7cM+/leVLO4cV4dFjiarSvgmqcX3Qcwt6HOpzWH2qz0L9izxmK
	 aym1x1cGSHjdQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	thomasyen@google.com
Cc: Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: FAILED: Patch "scsi: ufs: core: Flush exception handling work when RPM level is zero" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:25:44 -0500
Message-ID: <20260301012544.1682971-1-sashal@kernel.org>
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

The patch below does not apply to the 6.12-stable tree.
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




