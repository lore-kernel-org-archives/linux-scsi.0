Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E45F1487E3;
	Sun, 28 Jul 2024 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722182871; cv=none; b=GxsfOg6cv3Xb+/WEnQeLLSDhdcfFp3qWDBGModGdG4jghZJ0iMzNQgR0q9HWXfJz9u2c3k51R82K7RC4xM4aAalNx/DSvbkFBzCYoflxJHZanWI1X+dYhA1GGTx7QJPnt6JDSUpTkuqUY7EZy1KyZ7tjPc7gQdn/J9VMIQg6vMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722182871; c=relaxed/simple;
	bh=9vciI1GeMRDi0SPmD3oN9I8PJ4t02RNV7SGmTCZ/VIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXaBpE2GM+oFdHyUG3IRxaDCH+DLVFfh6veJoIc77mO2DY7RA1YoXLwYNl0dh9DsMRhJkpY0GEzuyKdUDYlW76OYBTN9cEaq9DFewmeKKyavFRXnfXCHJBPVI58VXCb5/7GMqme5kUugGnBJZGCVPz7RqCnOkhhqNUKGJXTQLRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXcGtptk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXcGtptk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469A2C4AF0F;
	Sun, 28 Jul 2024 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722182870;
	bh=9vciI1GeMRDi0SPmD3oN9I8PJ4t02RNV7SGmTCZ/VIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXcGtptkK7qXnH6TshnXv5nsL7QW5pT/YzR+gb1NSlYP1Ts6bkpTKfIS02QsC6qMd
	 smCCD8yQCXRkQy9nXN6Rhsj7sPROgO2VGuaW/WHmHAygyuF7VrcsO3i7in/h22Jt+K
	 un+bkscKeyi/EdEp2Z8/VQLFmaCKoADwbWknOtne8ggMw2PqMduFkGmKiqsTtKo8CF
	 ydf8bUZzqZfPfw+aQtHjO+BW7cfQchKjHUwJkKW2KRVDbt+Fmmbax7VzkF0K1hy8Cj
	 2TsRjES9/FlJ6AfT+t1gD955gvgBo9VfmRtLeT2QAEbeZIH8WVdIxxO3moHkk1koU0
	 HKIevj9PhRA/A==
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
	manivannan.sadhasivam@linaro.org,
	avri.altman@wdc.com,
	beanhuo@micron.com,
	ahalaney@redhat.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 14/17] scsi: ufs: core: Remove SCSI host only if added
Date: Sun, 28 Jul 2024 12:06:50 -0400
Message-ID: <20240728160709.2052627-14-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728160709.2052627-1-sashal@kernel.org>
References: <20240728160709.2052627-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.43
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
index 808979a093505..df36b141d4431 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10114,7 +10114,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	scsi_remove_host(hba->host);
+	if (hba->scsi_host_added)
+		scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
@@ -10389,6 +10390,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 			dev_err(hba->dev, "scsi_add_host failed\n");
 			goto out_disable;
 		}
+		hba->scsi_host_added = true;
 	}
 
 	hba->tmf_tag_set = (struct blk_mq_tag_set) {
@@ -10470,7 +10472,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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

