Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6B01DB154;
	Tue, 22 Apr 2025 02:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288234; cv=none; b=Oc6Z1MJk3XRm6yRtdOb1KntoszDZrPZI/l3jbenjiSqJ+8y/Fo/KU6O2NL/oAoC6w2xngYkXBJn5nXfFmudVJuKGPXaW2/I8BDt+rvTGpOGAQbs87HNeLWVBvZg6Up3TuHXqPM7Vy0vkZF+wwfoEY7FGJ7U3kiRP1JR2WKcJr8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288234; c=relaxed/simple;
	bh=eDc3CikuCbknB2i/fPX+BXoNfW62U2YEmPuhihkc4IU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E2SlPtrNvPkWAEhcoXKrB3bNKM3XBhIYHQ/FajExds0E/rE5yaeUrhET2h84I/jueOOQKcEshXrFMjHgdc2+duXT2+M7hTCAgtN37xTZ7lCj4BQJ9dJ51MTWKDBmHXvj7TyJn8Qj32dO90CWYlaDihsh4ldU/7DomfrVXU2RgfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTdhPnfF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTdhPnfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163F2C4CEE4;
	Tue, 22 Apr 2025 02:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288234;
	bh=eDc3CikuCbknB2i/fPX+BXoNfW62U2YEmPuhihkc4IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTdhPnfFRLJfo9nkFMIqauJDfPGo/D3qtsjt24ziLJbHqTIN52cn20nTzLpHULWBJ
	 RPYUQRu9HtWFzKQAMdf8NCy2fnN7LIt4B3LhdebnITRgtjuWDAhudympZKWelGccoX
	 pWjbPRUIf0xGrSNNNlIxXBR/3+iL/+yNgkD829AEs8I0bEDUD5w5rnRr8zBCvEDbL3
	 hai9pRnt958I7JvL+Wq6fanLaJrzR1Y2lJAq2iH1xFFpbhstq6r7CA626Q2GulEsVQ
	 RX21mHbPq4LwM1U3axYetuE43JRZsz7gRknNClBCkvgMWyX5/dk2ilfW6Uji8FUB0d
	 6aQBmQKCJi0Xw==
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
Subject: [PATCH AUTOSEL 6.12 06/23] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Mon, 21 Apr 2025 22:16:46 -0400
Message-Id: <20250422021703.1941244-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021703.1941244-1-sashal@kernel.org>
References: <20250422021703.1941244-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.24
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
index ee2da8e49d4cf..a9d6dac413346 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -719,6 +719,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.39.5

