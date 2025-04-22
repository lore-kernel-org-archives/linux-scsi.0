Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C934B25F970;
	Tue, 22 Apr 2025 02:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288282; cv=none; b=LR3tl3FwoPzwp0fa+JMwTG5KmmEG/SDhzm5rmhAiHls5R9U2fOFTLR3PB3Wqo92Y1H9ZNacNHEzP2chbEW3QfuIzOoUG8QQ6c4qS+rZNnQfl2mDKITxgATxHPhUWN82rOoKSnrIQJ/sp/2r3CqOR+3qLfGYaMPA9XCkAvQBfDC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288282; c=relaxed/simple;
	bh=ZCCyIm/fUNr9c1x5le0DTvZgHotQPLwHXcmL7UKeOZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tcCquhVIMMapdCpBUq1/2D/3FwrStuzPSvMjxAniQY93zMA+MlTZ5Sn0GmNO96ar82znsDrjyAiNAXplXDYWu369bVaFpz3PTJxaaP/XOBbgmJSIUUHWSZCZfrWoJDdKQN3TKKl52aWKkZX4fb6UdAyhnBzAFIY7VVMTV4Oqrd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CwzJ282/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CwzJ282/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51040C4CEE4;
	Tue, 22 Apr 2025 02:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288282;
	bh=ZCCyIm/fUNr9c1x5le0DTvZgHotQPLwHXcmL7UKeOZ4=;
	h=From:To:Cc:Subject:Date:From;
	b=CwzJ282/bJpRb/lLegJ6ZHa3cVaCihyQ4LL92mELMK/toZFjx6d7OqTEUrtfLnE0B
	 PIQ82/JZo8HKKdaq2lkwEpX0VIy7cVH6tUOT0XPMS/itGoF8HEj6hbGuK9vU4Zy+o1
	 xctpuwVj5M54dKDDSXdBXvRHk9Fi9CN8XFlWx+soF43eJqN566AwDPRvohOBV2sHde
	 1Bna0bCMBJMorF5RnLtocSxuN+iZOsDxNe06fl61WjReMVZe1gj3ne2zq2+m2IvlSI
	 P9+25djI3ey4pd2eCC6X0SnZ45bTTCHXWLWuNvBXKc9SU6uSaN3iKvUJCSHu/pY6Hf
	 8zlUtQdHOEn4Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Xingui Yang <yangxingui@huawei.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	liyihang9@huawei.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 01/15] scsi: hisi_sas: Fix I/O errors caused by hardware port ID changes
Date: Mon, 21 Apr 2025 22:17:45 -0400
Message-Id: <20250422021759.1941570-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
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
index f78c5f8a49ffa..7e64661d215bd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -911,8 +911,28 @@ static void hisi_sas_phyup_work_common(struct work_struct *work,
 		container_of(work, typeof(*phy), works[event]);
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

