Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E3D13D262;
	Sun, 28 Jul 2024 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722182802; cv=none; b=Au1NeJh7g6DrKaqcsJ7CVoW6tZOJ63H+Yey+C476obTEu8qqiXnK83XI/kCFGRSfj3FIeQYFviMB8BS+cYeFUaz1m+9gqhqTrEt8CoV3Gw8mPdmjg3H3xK8Pb9A3Gpi9ER4I/IGurNpvJwiGcpfupxKmxyA9NsOXp7F3+lUdAxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722182802; c=relaxed/simple;
	bh=Z6jMe1juRTMCqezG0PeD7rbTkneFJqKVSq2c6rpgzRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKv6oS+2YuuyPCCB6mdBUm3gYRHph/MwCHx/ju4dMYRBlFaniIB6xZoW7brUmp6svg2Zz7oO+Y61oGUHG5rzf48iPjvC5ThXmaoo6ShTmyzCKIkz7PiGbWU2h4GD4/X5zc5IhWY0Zy1OWi7OPIHvAnRaE9Wm+WaH9mu/TinZ7YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KeA0hpsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KeA0hpsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AF3C116B1;
	Sun, 28 Jul 2024 16:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722182802;
	bh=Z6jMe1juRTMCqezG0PeD7rbTkneFJqKVSq2c6rpgzRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KeA0hpsxEPWqgsCIJN/o+U8wIW5cQPYWGJeViFls6dNBoBwuJiliZU3Vgez061hwR
	 gn4OqKo0Ea7OTz7acvBangTXq44w1FVm+ff1lWbk/eAPQU22n4CS2rysKVFi3i3wm8
	 q+vuF0gUkJRidQDapgx7e7P15lD+2xzJBVDe/NuKRrN8pbthmXTXaTojjRjc5WAgjU
	 UsWNxL83Kgq4qhou3zwEeun1dswYmC4yMMJ/2XufFPsBp8tJE7lK8v6t9tChTWZaNx
	 Bl5bvvQ5sdgkBU8IjhvbMsVaiigjgeL1GGc9FnJ+EdDKmnr/gX3HVC6xdb0yB/9EAX
	 xVP/qC3AWn77A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Kyoungrul Kim <k831.kim@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	peter.wang@mediatek.com,
	avri.altman@wdc.com,
	manivannan.sadhasivam@linaro.org,
	ahalaney@redhat.com,
	beanhuo@micron.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 19/23] scsi: ufs: core: Remove SCSI host only if added
Date: Sun, 28 Jul 2024 12:05:00 -0400
Message-ID: <20240728160538.2051879-19-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728160538.2051879-1-sashal@kernel.org>
References: <20240728160538.2051879-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.2
Content-Transfer-Encoding: 8bit

From: Kyoungrul Kim <k831.kim@samsung.com>

[ Upstream commit 7cbff570dbe8907e23bba06f6414899a0fbb2fcc ]

If host tries to remove ufshcd driver from a UFS device it would cause a
kernel panic if ufshcd_async_scan fails during ufshcd_probe_hba before
adding a SCSI host with scsi_add_host and MCQ is enabled since SCSI host
has been defered after MCQ configuration introduced by commit 0cab4023ec7b
("scsi: ufs: core: Defer adding host to SCSI if MCQ is supported").

To guarantee that SCSI host is removed only if it has been added, set the
scsi_host_added flag to true after adding a SCSI host and check whether it
is set or not before removing it.

Signed-off-by: Kyoungrul Kim <k831.kim@samsung.com>
Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
Link: https://lore.kernel.org/r/20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 46433ecf0c4dc..b68a440bc6b9e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10177,7 +10177,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	scsi_remove_host(hba->host);
+	if (hba->scsi_host_added)
+		scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
@@ -10456,6 +10457,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 			dev_err(hba->dev, "scsi_add_host failed\n");
 			goto out_disable;
 		}
+		hba->scsi_host_added = true;
 	}
 
 	hba->tmf_tag_set = (struct blk_mq_tag_set) {
@@ -10538,7 +10540,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 free_tmf_tag_set:
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
 out_remove_scsi_host:
-	scsi_remove_host(hba->host);
+	if (hba->scsi_host_added)
+		scsi_remove_host(hba->host);
 out_disable:
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
-- 
2.43.0

