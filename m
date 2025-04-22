Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C209926F47C;
	Tue, 22 Apr 2025 02:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288330; cv=none; b=BSU9qMiVKdkLMOvGOzgYxPrY7aJ9dgQTQd5php4HLLiBOzTOXVeVC7r2mUvfQZG85cM/ArgihyuPaR+Dn41bLalDO/iwJhZjsJuAkY1kJ8KzNwXJJhN8Z7ZdiwB3GnTMX45mJIuQQdunNi3ETPsfeL1oWw/e2M5pUtykFXSt8+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288330; c=relaxed/simple;
	bh=YpSVatPHDJ1xtkHRasgaGXwyixkvQLsotLwqN5RRxmI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KSXLvkHwFsXglLxHkDmjlU/ue4iB5BEUhZewMEnjTrcpWJ9gMkLTmAlnyIMwdtaSObLeVrOMp8XlQB7NtcOEsiyMVOO+Esz4rO+A/tKz+ZDy0CvBSUZCMp0QmgVyRGWsW345wAnThcJn27ieIQi6dPaUU278G4mqV/BQBiU3oAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqBZyBsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqBZyBsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9792EC4CEEE;
	Tue, 22 Apr 2025 02:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288330;
	bh=YpSVatPHDJ1xtkHRasgaGXwyixkvQLsotLwqN5RRxmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqBZyBsCFIWQ3emo9fBO4L7kGhFkJ03uj3bIzPuGKPwvrSeSKqFc9esbGWWQMUiX9
	 cacj6NrLy6w2jx1vcfKGOmIxT7Vj+p9zG5aaZKqNcVHc8X+2Dcrk6/S4N2Oxo87fBy
	 XCHEr0sEbj/uVcSGPtIwZ3aUklWtFNl8TAh/u7lLLiQO071GJXt+ds4JLsGPEEW9Hk
	 OPzZIDlB7DPyG7r72B42wgN/Jt08ziL9Srgl8nWSxnt6UjANOb3jT/RtxvIs1kini9
	 wBmMcj2Fca7c5MWw58f2o7AMklCAQs50GmqD2SfYTu0coagkVyTDBpB1nMAzs1FD1S
	 KBqIqy0aZQRDQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Igor Pylypiv <ipylypiv@google.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jinpu.wang@cloud.ionos.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 2/6] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Mon, 21 Apr 2025 22:18:42 -0400
Message-Id: <20250422021846.1941972-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021846.1941972-1-sashal@kernel.org>
References: <20250422021846.1941972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.180
Content-Transfer-Encoding: 8bit

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit f7b705c238d1483f0a766e2b20010f176e5c0fb7 ]

When a fatal error occurs, a phy down event may not be received to set
phy->phy_attached to zero.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
Link: https://lore.kernel.org/r/20250319230305.3172920-1-salomondush@google.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 5fb08acbc0e5e..7a02062303a93 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -892,6 +892,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.39.5

