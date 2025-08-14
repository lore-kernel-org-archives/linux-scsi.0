Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11AB28642D
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192778; cv=none; b=N3OXK5vUi9U8F+GSSJ7Uh4r/XXCWi58lJxx1hkKAHdVri5xnKx+t5BK7ryMNamj42le3doWSKcGXpugINeBoIQ9rhLoHa5DJBXM3b766m1tM/PxPbn1gywu7Hwdik99q3PoDhTm3jutM47/e1Rh/7W59UYFp9+fTK/7WztnYcrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192778; c=relaxed/simple;
	bh=GUr7viIYP6VHLsxTY/cYpdlc6AFuetHD8JkVFK8hvi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eyio2dTG1F++mMLWfL/5+49vJVRW4QEfnxao4ccYK9pmlB9MEW8xtE1D38DWlPJlARhhGLh2tqRm3+MAQglrdZ4+ir3ojb6Pr2SB6n4/t2dSXZLvXPcOC6LyOEwfdc0FEyjPXmGgjyMY1+Jku3I4o31RxmCdveXkS/W3rEB8yC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aETytHjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aETytHjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E09DC4CEEF;
	Thu, 14 Aug 2025 17:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192778;
	bh=GUr7viIYP6VHLsxTY/cYpdlc6AFuetHD8JkVFK8hvi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aETytHjZ6OAvWxduTxprykJzv+V3eWxeq0O8oglzKXkaxw7gHzu7UHBE+zam2xFqH
	 qKEOgmk5RQ37EAuXCZYNFLoj2xo+qVkSxDFFulCFCWDD+kMfQNS4nPjXfxoYfS7Pbn
	 zDuBAlEYGdJfuemLP9sZUTUMB4cX6U20sTBwQwvHLhYRGffZnrFjUfz43QNWlR5jy5
	 1t7mXmKU1SOUFTkHpb79Vr5eNtoNqNHRGBgV/00DvakOwyDSX8HHrJoEAJJ6/jxrZs
	 82dhw3OsSu0ORkB1T1byDYv1ftxtMnUmbxyNC+/z+lHZMWqovFTXBM1sK+TbHTLQ1H
	 k9IfIWOl4fRBQ==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 10/10] scsi: pm80xx: Use pm80xx_get_local_phy_id() to access phy array
Date: Thu, 14 Aug 2025 19:32:25 +0200
Message-ID: <20250814173215.1765055-22-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1679; i=cassel@kernel.org; h=from:subject; bh=GUr7viIYP6VHLsxTY/cYpdlc6AFuetHD8JkVFK8hvi4=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmya5gMuzRC/x/YtOC6t1B2890PX20m0PB88HnJTL3L j7umCv3oqOUhUGMi0FWTJHF94fL/uJu9ynHFe/YwMxhZQIZwsDFKQATafVmZDjDXGD8avfk3hmf bpr1N8xxnfBv2dc7K+Y2PfzO0Jp+LLiNkeHIz0dKxpZe5W2+sh2v0zV5ZX7HlOzZpXL3sGWu7r9 1LFwA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

While the current code is perfectly fine (because we verify that the
device is directly attached before using attached_phy to index the
pm8001_ha->phy array), let's use the pm80xx_get_local_phy_id() helper
anyway, to reduce the chance that someone will copy paste this pattern to
other parts of the driver.

Note that in this specific case, we still need to keep the check that the
device is not behind an expander, because we do not want to clear
attached_phy of the expander if a device behind the expander disappears
(as that would disable all the other devices behind the expander).

However, if it is the expander itself that disappears, attached_phy will
be cleared, just like it would for any other directly attached device.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index c5354263b45e..6a8d35aea93a 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -780,8 +780,11 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 		 * The phy array only contains local phys. Thus, we cannot clear
 		 * phy_attached for a device behind an expander.
 		 */
-		if (!dev_parent_is_expander(dev))
-			pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
+		if (!dev_parent_is_expander(dev)) {
+			u32 phy_id = pm80xx_get_local_phy_id(dev);
+
+			pm8001_ha->phy[phy_id].phy_attached = 0;
+		}
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.50.1

