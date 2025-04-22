Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E40D277035;
	Tue, 22 Apr 2025 02:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288345; cv=none; b=WpmBtDg7WoDfdxwY25dlqxOcwBPe0Q5/wEpyZWFSm7N+UXpFdZdns+5IIEQtxl+sCyL87kWE1K/K9UhLKkYod11ZO+fQ9rnrt74bPEbOdgG96aapMzPbhJrRIePVLDxjJKuqtNjwSL9SSEl/ZU40RnxUzjWZJQdBLsbZIJligCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288345; c=relaxed/simple;
	bh=Qi7PabfiLaCYRd+It5pzaESZMIsKHvkjX21NhKvn4Yk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QFg1/7hbe5SPNHopZylNMbNxEwtZhxuGJ0I9xLFhnF8FZEeioVX28T2aQQ0AnCFuhf2oaqRu51ZIyuEYiny3uxV2saJ1im7q8SidSQLbwHo/nX1J79ZJQ8HT0FiqrV5Gi9TcQvU0b5hdac8cr/8NU78HG5TUufzWdjFIGzGbuZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=abx3sgTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="abx3sgTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDCFC4CEE4;
	Tue, 22 Apr 2025 02:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288345;
	bh=Qi7PabfiLaCYRd+It5pzaESZMIsKHvkjX21NhKvn4Yk=;
	h=From:To:Cc:Subject:Date:From;
	b=abx3sgTJMkQllGVuo35/7bUNO6hIHh4vIK/wI5fzVdktqHasw6+RnWQzPsO5IIJmu
	 idTrZ+c8tniapLPjrPduYr1FH5A1onYrZCRMaYPTV8Anr64r3Zh1F8NYw1IlaeelEO
	 53taNKcEuPGGS2aYFyZ+Y0N+DeObNAV/BqPv+OmHJCJT7rRJ6zpqGcr7aVS+HRA07P
	 ThoOuhG96TeToP6p+zobNI9/KkZhek6iWfAI4ojnz5SPx1H4uxM5scY9UlbZsNOQE4
	 DU+oYzFimP8cL53IBtn4mjHZTPZzmzbry7Y1RIoHgI1Cc31DIst+zsv1gm3ymXPxXU
	 6TeSUMniezUAQ==
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
Subject: [PATCH AUTOSEL 5.4 1/3] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Mon, 21 Apr 2025 22:19:00 -0400
Message-Id: <20250422021903.1942115-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.292
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
index 36f5bab09f73e..1215fc36862da 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -893,6 +893,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		PM8001_DISC_DBG(pm8001_ha,
-- 
2.39.5

