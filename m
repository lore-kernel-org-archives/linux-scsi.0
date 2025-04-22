Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5021F4173;
	Tue, 22 Apr 2025 02:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288312; cv=none; b=OzO+Ugl35MTo+mijkn4CcvT0IiQd9rKVnO2GVo5Q1L56dE7+7OzxFFfDvDf5IHX1G2tBfN9K/ySJJoCUYK5jgXh9naQpkLKe2+685uyjIBkZFrEJqqEk4CLQqnkRFhVTVe/RlU/5CMHiOeqr5EJQPLRozsv1R6uceTDAV9QhxRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288312; c=relaxed/simple;
	bh=KFUKcgaV97DtoJQUvFPRaNuDDH4o7/czpS6aKLyK5qk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mw/oII9yMRgc79hk6J1pYJowitCWuomRO8RPWh6pQ5R9pELnKJIuLfdeNXxkw8rpgb8+ILxnbe2KoSTej90LZJi2bmfXO0pIE5CQKj6PYLjlGhZYH1xXiFt+RmsFgiJZGtU2JDCv6UUOsi0QEJB7lkNhHatoeVt8w6U0ow5KSSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmINarEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmINarEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD97C4CEEE;
	Tue, 22 Apr 2025 02:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288311;
	bh=KFUKcgaV97DtoJQUvFPRaNuDDH4o7/czpS6aKLyK5qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmINarEvpLU4+q78E7OuJWF+N8z0KhXtbAPBmyiuCknWW9+rgVQuidSJbrpFj4mTG
	 arYEdLwX12WMvj+mkJ3zSqE21qANkvE1FbIdCQZxmf7DXsXl/hci9GQUOnJv5opg6j
	 fzA0EkEpHmhZqRJSc/D5dNgW7kEnVaOX63X4BHX2ZVFolnQUdzEc/H+FMyCC1dQiDj
	 bf3jI585caRy90+ru8xDRkjpxeviGaVwEzD0xA2qSRAjYtjWnyeZJEkPz0OZ95EZzq
	 XaOTJ67SIb6t4o/Qt5fhNVXZvIefOq6IXyGjFI57pYrtbmiTSJ8Us//qsbwUcuPB+m
	 e5kgeO/BIH9xQ==
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
Subject: [PATCH AUTOSEL 6.1 03/12] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Mon, 21 Apr 2025 22:18:17 -0400
Message-Id: <20250422021826.1941778-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021826.1941778-1-sashal@kernel.org>
References: <20250422021826.1941778-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.134
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
index 8e3f2f9ddaacd..a87c3d7e3e5ca 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -720,6 +720,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.39.5

