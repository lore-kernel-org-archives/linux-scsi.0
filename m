Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B218626F462;
	Tue, 22 Apr 2025 02:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288329; cv=none; b=hPzWp2HQlcvuwLRv28Pyrd2tLHmhkFLCp5ftvQnoqsP1xZwQywZBZRfB2mJNHWrkAyMhh6knXF3Z+Ady4i28s7yfjoghF6m1aDlWHDaZX2cLJkXaf6igxqOrpLDjY6SqK64SurMDtGsoxe/LNynoH6sgVy+iB81F7j0Hr9FFsEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288329; c=relaxed/simple;
	bh=KNCCxNknB46EvhaCtLTyPyI4/qY/w4Md9FL0egBeNh0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Vo+gcqJ6sNtBXvXtIKo0v++X9MZKsedh9fLBa7SUeCyZKZZ5Xt0mRGl24FJ5Hu2YLx7QmV95YiAN2VKhTIU2kLtC+yYcdZumamu1B9aACsn7Y64eFzrPkmVEZaKJ7ODyTSB6eU13amQ4YOnZ5N60t6bBkB8qKqtWucejO5AwZfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oO5E9EE4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oO5E9EE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465D4C4CEE4;
	Tue, 22 Apr 2025 02:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288329;
	bh=KNCCxNknB46EvhaCtLTyPyI4/qY/w4Md9FL0egBeNh0=;
	h=From:To:Cc:Subject:Date:From;
	b=oO5E9EE4akBbdnUIBEy8Ztm8nsu02p2kalWcCynRaUvrXJEYbwG2VnNrhX5NBiCNl
	 9KzKxoSbvpE2Mp6O91LTq8U3jtVxNVnWcv7ek9Xqez0Zz6Ojjp12AM11lgvbFl1hQc
	 GgjtJQSBB0YlFh8YxAnquYf68f3f0O0fKZHpslGLhOc806um4idI+ORZGt4mkqGlMB
	 PG3HxQZJ2fgPJxc6PSpba/VhrRmw/x9EKDYIXVTta1dKdz5NP7p1F6mrQiUkGhNV7j
	 4TSTVSYT/lYMO6ixMyb9MJuHb97R9RypmOOcKXQXZ8VfFrTRfv5G8Qa0oAkQe4+c+5
	 g7UF7A+pnIZ+Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Xingui Yang <yangxingui@huawei.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	liyihang9@huawei.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 1/6] scsi: hisi_sas: Fix I/O errors caused by hardware port ID changes
Date: Mon, 21 Apr 2025 22:18:41 -0400
Message-Id: <20250422021846.1941972-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
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

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit daff37f00c7506ca322ccfce95d342022f06ec58 ]

The hw port ID of phy may change when inserting disks in batches, causing
the port ID in hisi_sas_port and itct to be inconsistent with the hardware,
resulting in I/O errors. The solution is to set the device state to gone to
intercept I/O sent to the device, and then execute linkreset to discard and
find the disk to re-update its information.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20250312095135.3048379-3-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 530f61df109a3..52255663ca168 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -855,8 +855,28 @@ static void hisi_sas_phyup_work(struct work_struct *work)
 		container_of(work, typeof(*phy), works[HISI_PHYE_PHY_UP]);
 	struct hisi_hba *hisi_hba = phy->hisi_hba;
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct asd_sas_port *sas_port = sas_phy->port;
+	struct hisi_sas_port *port = phy->port;
+	struct device *dev = hisi_hba->dev;
+	struct domain_device *port_dev;
 	int phy_no = sas_phy->id;
 
+	if (!test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags) &&
+	    sas_port && port && (port->id != phy->port_id)) {
+		dev_info(dev, "phy%d's hw port id changed from %d to %llu\n",
+				phy_no, port->id, phy->port_id);
+		port_dev = sas_port->port_dev;
+		if (port_dev && !dev_is_expander(port_dev->dev_type)) {
+			/*
+			 * Set the device state to gone to block
+			 * sending IO to the device.
+			 */
+			set_bit(SAS_DEV_GONE, &port_dev->state);
+			hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
+			return;
+		}
+	}
+
 	phy->wait_phyup_cnt = 0;
 	if (phy->identify.target_port_protocols == SAS_PROTOCOL_SSP)
 		hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
-- 
2.39.5

