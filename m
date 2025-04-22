Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A902E1DB125;
	Tue, 22 Apr 2025 02:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288161; cv=none; b=aLAC2aIbW8zDuadVU+3ipvA3+jlzPQUp0Axj/qBhyxgbMbzaZBRKz6BF9tF6y2K21bN8GwYK8dKDBrpt8RKHjDTOMB7/mTAV5+bvM6Blo5x1gXaeA/g1YwwG5J/9Tj7RsuSNGgk3Mfel96dzAqd8SYX0q5ZTVwB/orbcIsVFK5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288161; c=relaxed/simple;
	bh=bQOjSAW7SYIGi/5TTcAq4EqSQ6Pr9z1kYC+TgLuh1dQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aO49xCY+gV7SCMKhRxkh132yrh90UrY27E9AOClGweSM/FyLW5ssnBwGdycTu2b6h40bpSMHHibgzKKMO9V0TO5OPLQ+7MPdZKhUMoeLWjfvl7W3qNeB2iyRPurmM42XbShglezr7PKVUlIsZTbDLIXLAyDamDsMbokJf6wD8W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFgmPgjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFgmPgjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA95C4CEED;
	Tue, 22 Apr 2025 02:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288161;
	bh=bQOjSAW7SYIGi/5TTcAq4EqSQ6Pr9z1kYC+TgLuh1dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFgmPgjBl4COsvNB2jG/lXwzab47rVCkDgH8AagZn5xvd+0fG9WzTVa16KdJmQFhw
	 PEIf6HHXZ28nP/YrlswBv4/e5+Y5fkddeZ/tHQAqY4B/soTAYotjYdudQT2+Ypr9y6
	 dRHDO1W95ZcleD/0RZhFSp9YQKVb6p7kNN8FhafODbVuruFZrObJelPiNDllhX/OC7
	 ArdvxHwNfhL6G/9WelWtcvXxKVP16DsSea2xfrQ+jrXrKQsu3GbVbQZCrtmK8lCzUi
	 CKEXN7jRhSgo6DyPKWA4mYJ+hngjiuzoD4hXIT1nF9+J6Gi+qcnDQidzGhACYwP6VH
	 NmkIX0soOnZ7Q==
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
Subject: [PATCH AUTOSEL 6.14 06/30] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Mon, 21 Apr 2025 22:15:26 -0400
Message-Id: <20250422021550.1940809-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021550.1940809-1-sashal@kernel.org>
References: <20250422021550.1940809-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.3
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
index 183ce00aa671e..f7067878b34f3 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -766,6 +766,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.39.5

