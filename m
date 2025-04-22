Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80606261398;
	Tue, 22 Apr 2025 02:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288285; cv=none; b=KZgY8sxSR1fxW7tcFaDOww3KNpiZ02O6vw4VPvNacT5ldt97EWF1MZiDEO5dVGCXdZXNFYgkpWbgRyjzgitUb8b8WlVl3nKlY6M93N/8gHoKfuAdGy6qFSIougHXwXDhDXUClJlW/ugUkdodU3vm5uFS+l1Yxco0GIx80o+SM5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288285; c=relaxed/simple;
	bh=eDc3CikuCbknB2i/fPX+BXoNfW62U2YEmPuhihkc4IU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tqdp0lpO6GfDStKZAx+rd1kqXkGbBE7SeQaLx+y2izmDpk4OvwlnfExYM0L8LzLzlQAXuLA8BjmI0gxWs3YX1PVXJlFVAi5PCK6xpI2lZFo064KFF0/OvXNOBWRuEZxwqHzvLnNzJF5+NHl8pHflAb33f4y2utnep+qtl/o4Puw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BI0V/w11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BI0V/w11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C9DC4CEED;
	Tue, 22 Apr 2025 02:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288285;
	bh=eDc3CikuCbknB2i/fPX+BXoNfW62U2YEmPuhihkc4IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BI0V/w11wya84dgRYUMBNXZqTejPvcu6JCDasBxxH5Q0snVMAlyBtVoiBPiesz3rt
	 IX1NcWeOFQUuvAM97GJEP24ZMltbkcIfeM2pEdblqYy81DXkxsnhzo6Zzh68E8mwD3
	 +veg7/5+ynwObe8DA6GxAiUXaJRfds4RjOeo9R/nUoBfXCevk+xckaHKpefOwvB6X2
	 +QNo/0JldjlJQm5jeto7QzwSURWLrZt6nKO3524sIBTZaK++Ilo4nAAoeccIz3inJi
	 aiU2cACiwp+OzacZLkbJLHWqhvbpHorNmWtVdv9wL5cjs1F3/Vl1eXI/5XONmpMEMa
	 ILyqqBDT0TFyw==
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
Subject: [PATCH AUTOSEL 6.6 03/15] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Mon, 21 Apr 2025 22:17:47 -0400
Message-Id: <20250422021759.1941570-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021759.1941570-1-sashal@kernel.org>
References: <20250422021759.1941570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.87
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

