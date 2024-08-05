Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A60A48CCD;
	Mon,  5 Aug 2024 17:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722880596; cv=none; b=jJYb/dnZOncD1s2NxHLNLhuT6+JMpvwA9/DzaFZr/1PAdk3BZuDE+dEybvCrvAMavt7epUPmTvyr0ynLPLkWYcGXTZM0a4q7DNiy3bKL0Gxf9mG0uJvVDeVnqDcYtqXCy0LVf/Eo+FeLWN+JevVu3XicnQVzZAHjO3Fn8xePPyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722880596; c=relaxed/simple;
	bh=FWXRir7NdsfpCQeLqcWhIT+hGlGvOxV0pY5ePjzURQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkAfZXNHejjneLRQbY7+JtKVII65di47e6jvWP20X75xGWAcE2Lk5QgEK9Bsu9rnTSIn4dHQMzQ+UwHHurUT1Km9AtM+Np6lbTnnYq0yxK74SjaueJl3ErexfP4kVyAX9751N13QUQGfVHtMz3Wwj37qnvLQq0HE74cHS/YycFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JvmicJlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JvmicJlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08C9C4AF0B;
	Mon,  5 Aug 2024 17:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722880595;
	bh=FWXRir7NdsfpCQeLqcWhIT+hGlGvOxV0pY5ePjzURQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvmicJlhcb9ra3ANDoPREMWtUItBsDGq2aUK1Q31n6KD8C7UQW36fKqoKqdJvloFW
	 y9tvU7ZFhCa/yRSD+RI5lo0p0GSKqVNpReAVIz6gT/FHiVUIQ7iBdgFJcsiETc1Zqx
	 MO+AZ1vQ2gcLVAybrsX1BnKgisi61TtQIaKONV90USB9dAXmJC1XjFhy5AiyPbc/7L
	 wPK5Twk5roHNEh/4c2WCbSCDamxIP+2ZaM8zBO0uV8OH9nvY0Dk5iVzUJT9duDQjuV
	 4PbBXXx+ZdJwBoGUcTATsZTTkH/ycCKqHpV67oEW7biXJ6A0IH+xZz3XZrQ7TpxiDz
	 ubu4GnUnT0kTw==
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
Subject: [PATCH AUTOSEL 6.10 04/16] scsi: ufs: core: Bypass quick recovery if force reset is needed
Date: Mon,  5 Aug 2024 13:55:36 -0400
Message-ID: <20240805175618.3249561-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240805175618.3249561-1-sashal@kernel.org>
References: <20240805175618.3249561-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.3
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
index 3678b66d3849a..27cce03be375e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6555,7 +6555,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	if (ufshcd_err_handling_should_stop(hba))
 		goto skip_err_handling;
 
-	if (hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
+	if ((hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) &&
+	    !hba->force_reset) {
 		bool ret;
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-- 
2.43.0

