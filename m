Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D7225742A;
	Tue, 22 Apr 2025 02:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288226; cv=none; b=El1z/3bvtz2Ll/tI+wSb/CaQANjwE3m6XJ5YaRWLFJxiWFsUr0Fm1lBb8KOqiq7p7QtTVDygswtPNBj1XnS+QDyQrKwAMO72OJRUOeTQO4ETJJIbomjR5pbKj9zwyPuTlIuLMUxevqFWtRbisAmGtXLu9bcdSCIW4EaZr28wrfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288226; c=relaxed/simple;
	bh=j+fUGnv7YKkcUuUQxnLrSZ1qoD7jE5j9nuPiWGELX7s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sUzwYxVNupdqZU3DSnb81vdqIi5AWgcPwJq+1kFao4NaIV5UeRsEgyhyz27l1nH5rgAE/1nVYjvg6WZtJn9pnksN3jFlkPU5C+h8Su6bNy4lN2Rk44xzZvyx+Na7Q4cc6XMzjp4Sph+H7IycI2uN+JS0pH/yacSB4Oz6t+3xY7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ukHARs1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ukHARs1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31F5C4CEEC;
	Tue, 22 Apr 2025 02:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288225;
	bh=j+fUGnv7YKkcUuUQxnLrSZ1qoD7jE5j9nuPiWGELX7s=;
	h=From:To:Cc:Subject:Date:From;
	b=ukHARs1CkTx3296tuXGcnLq5UGy9cSvRTw9MJtI4dm9fhdQSg1EIO/6jgevs9yIy3
	 iWdOWVs0CGEdQW40ecNQnL8bCjaUb5xDn4Nfvq6ddHBT+9WimX+lh7I4ZfFpy6VjTd
	 xUeQMokQ9kp/SrUbz2IsJn93igrzeYHNts3WOqLJc+k1Aw7FIGDc6VMavmanPbhi+e
	 sCNWaKr+UEK2fkZfD2zCnMC3ghh5E2kXolK2tbTSijpKAsSqsVRfk/TtXbwlvUG+PC
	 MBZAceCDh8WMLNT1o1flItFriAx8KMhzhjduFohztX5EC78ovIKalfjtCA+ttd0NPJ
	 m7F2eyPBUzYWw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Xingui Yang <yangxingui@huawei.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	liyihang9@huawei.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 01/23] scsi: hisi_sas: Fix I/O errors caused by hardware port ID changes
Date: Mon, 21 Apr 2025 22:16:41 -0400
Message-Id: <20250422021703.1941244-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
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
index ffd15fa4f9e59..e98e6b2b9f570 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -912,8 +912,28 @@ static void hisi_sas_phyup_work_common(struct work_struct *work,
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

