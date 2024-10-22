Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D541CB508
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 19:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729625530; cv=none; b=QL6MQdtOK4RCypFc2+OChf5wXz2FK0N+I2LLN6GPjKUZOPDfrwhmZxK/W7Q85Ev1pYbF3u3mBj+i1oFN0L6HRyBYnmYSkZPsm1bOxlHwWAXG9K+kRPw8RVCMxErAtEnXKnDUJG++lmPAjJtZCN6T5depG89095gvMiVJKivK/Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729625530; c=relaxed/simple;
	bh=crnUGiEWcx5uU38Fy62Oq3WY+EcZCObSxilBVC6WdY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjra73diECxeeNe8vOTiF6RxCom2tvxQu2AKlD4l4nZW3BdKrUArgpbLr5CjTt4jSFGd7YrKTv5gK4TmIFxIhJxXWzKk8Jx7MdmP0V4u+HcUjzeRnIT9N/9+6vauA2R+bvbBXHXgPi+Oo36NQhR4A5o5TICW4my4VplYeP9dHdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bdt3w7XP; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bdt3w7XP"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XY2PN0zR7zlgMVW;
	Tue, 22 Oct 2024 19:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729625522; x=1732217523; bh=UPUSe
	dRFjdNT8ZAkw0yfEAemxlV/+z4DQYjD3T9LrTM=; b=bdt3w7XPpnI7P/Gl0l+VX
	eWlifwHZRIuWfNpc2SBDNDVuWIP3KdqALAqyrXzGS996hP85JGidQQ0kSHhwS/H5
	Z9LzLcRFpc7fwTttLBZbMLeJQJXFpkD6aO/fLPpGRzppVIPmIaKd5bGdIbWf3bDG
	xie7ieOz0Sq+OSCEPSIq3KGdU6i5X9tIGcCaAS0XqkMdzhQIO8Jh4vZaTXxrxKkW
	4SBEJAa8cBGmL74OIQlzKykT3ZBJbQ1uT25hVoryH3ESxmHYppwRKV7FIcLDN/7Y
	ToXTq0aeqapWwhicaLN8zjs3nOh5M+MJuSgIiqphjgo0/WkeVRqThhpp9hEaJ2GY
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yugf9VIyL1Cl; Tue, 22 Oct 2024 19:32:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XY2P828CxzlgTWP;
	Tue, 22 Oct 2024 19:31:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Minwoo Im <minwoo.im@samsung.com>,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	Rohit Ner <rohitner@google.com>,
	Avri Altman <avri.altman@wdc.com>,
	Eric Biggers <ebiggers@google.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v2 1/6] scsi: ufs: core: Move the ufshcd_mcq_enable_esi() definition
Date: Tue, 22 Oct 2024 12:30:57 -0700
Message-ID: <20241022193130.2733293-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
In-Reply-To: <20241022193130.2733293-1-bvanassche@acm.org>
References: <20241022193130.2733293-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the ufshcd_mcq_enable_esi() definition such that it occurs
immediately before the ufshcd_mcq_config_esi() definition.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 14 +++++++-------
 include/ufs/ufshcd.h       |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 5891cdacd0b3..57ced1729b73 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -417,13 +417,6 @@ void ufshcd_mcq_make_queues_operational(struct ufs_h=
ba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_make_queues_operational);
=20
-void ufshcd_mcq_enable_esi(struct ufs_hba *hba)
-{
-	ufshcd_writel(hba, ufshcd_readl(hba, REG_UFS_MEM_CFG) | 0x2,
-		      REG_UFS_MEM_CFG);
-}
-EXPORT_SYMBOL_GPL(ufshcd_mcq_enable_esi);
-
 void ufshcd_mcq_enable(struct ufs_hba *hba)
 {
 	ufshcd_rmwl(hba, MCQ_MODE_SELECT, MCQ_MODE_SELECT, REG_UFS_MEM_CFG);
@@ -437,6 +430,13 @@ void ufshcd_mcq_disable(struct ufs_hba *hba)
 	hba->mcq_enabled =3D false;
 }
=20
+void ufshcd_mcq_enable_esi(struct ufs_hba *hba)
+{
+	ufshcd_writel(hba, ufshcd_readl(hba, REG_UFS_MEM_CFG) | 0x2,
+		      REG_UFS_MEM_CFG);
+}
+EXPORT_SYMBOL_GPL(ufshcd_mcq_enable_esi);
+
 void ufshcd_mcq_config_esi(struct ufs_hba *hba, struct msi_msg *msg)
 {
 	ufshcd_writel(hba, msg->address_lo, REG_UFS_ESILBA);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a95282b9f743..a0b325a32aca 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1321,8 +1321,8 @@ void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32=
 val, int i);
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
 					 struct ufs_hw_queue *hwq);
 void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba);
-void ufshcd_mcq_enable_esi(struct ufs_hba *hba);
 void ufshcd_mcq_enable(struct ufs_hba *hba);
+void ufshcd_mcq_enable_esi(struct ufs_hba *hba);
 void ufshcd_mcq_config_esi(struct ufs_hba *hba, struct msi_msg *msg);
=20
 int ufshcd_opp_config_clks(struct device *dev, struct opp_table *opp_tab=
le,
