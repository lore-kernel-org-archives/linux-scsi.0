Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2BD2676DF;
	Tue, 22 Apr 2025 02:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288309; cv=none; b=ExHYMGOURX6SsekZrOi0ojpjWf631ihE3xk2UnxyEuqobNpIQ72qmxPHtCDIBlZtH405RDZ+dbxCxj7UqGE7rftsMDETyMATTOFh/h4V6S8lEQqn62u3S8WJGH2+9X6oX72uYJnyijfsKwFq7k4v3g9rqWb1ebWhI0NjdNDZa/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288309; c=relaxed/simple;
	bh=D2yxn4KR1gHoEPSTjHakNtiGLP2BJCK2pMbVvRcSjjo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d7qOxoetO7DMrwxhOZS2qUmEEZRGn76EgCiZFwmBc/drK9TAmxvPt/gXuVvn+IuAc2piYEUTQ6DWo5V9ZKMK2W0fjPK1yD7xPwJ0BtJHT9hpjCpw2VTuyuBKG/xT1FO6ArziU5rufYTvHxY+AWBBdVGi2x64xvmxKJngOFNBatg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R9cqkBNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R9cqkBNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1781C4CEE4;
	Tue, 22 Apr 2025 02:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288308;
	bh=D2yxn4KR1gHoEPSTjHakNtiGLP2BJCK2pMbVvRcSjjo=;
	h=From:To:Cc:Subject:Date:From;
	b=R9cqkBNW/OrGl17CN6asI+1ELEqaqdBe05UEIFVpkog99lxcWf48ZHyHDKfBJ5Upb
	 5WEKlKyfQzhXZR2oKjCfRv8Z5dE3An7CUnJeYugD7/OsO/tBPY674NoPZBeoofu/j7
	 jG4VFlT5d0ozWPMlqIyVVl8Dp5PKC5ky3EmpdmWyQKw7vzvyJtubUuGrJnJdCVpYRG
	 fUI1t6krc/3GZ2uxEUmry21NK/GxEm9PpstvkQTSJl9fDOEcZgSwy/JYXpRS6EEGoy
	 UZ8AZr991e0N/rYRPwn/2V7sksloShoSFTUMFE+JBtdn0FDwAeiurgG6+MluIBVbAn
	 Rd2EQgfJrz6Gw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Xingui Yang <yangxingui@huawei.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	liyihang9@huawei.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 01/12] scsi: hisi_sas: Fix I/O errors caused by hardware port ID changes
Date: Mon, 21 Apr 2025 22:18:15 -0400
Message-Id: <20250422021826.1941778-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
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
index 2116f5ee36e20..02855164bf28d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -865,8 +865,28 @@ static void hisi_sas_phyup_work_common(struct work_struct *work,
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

