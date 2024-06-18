Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AF615A84E;
	Tue, 18 Jun 2024 12:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714582; cv=none; b=sJhu5+2c4s93gVfGxdCWrUqpbA4t8BuR/7Caypr0wi0CWQZ+h8FFctvEsTjVLx7tAM3u3JTnqT/7/V5ZTTVkz3Dldp3YO3Rbf/e9ACHNlBk40XD8RkfD8sRdENoXYtM2kVeZaIFRbQxkeAB/XfjhPuv2Do2lHksuPWCnuT6Fe4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714582; c=relaxed/simple;
	bh=KPgDhhvy/qWYoIhkC4CmnQ47Y6o7/P+1R/JjJF63TEg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t/hqjVILahaEPtpVkC8PjOS1yZWXhsE2qg7U9ZG2mcbLv+yrZeyPoCeYTt0tKgmaAig1hPsIvYUbP3a7o2Pnf6ijkPT+qR77KKxjb77QNNAkoyPet1gn1SJ74LddMps+HgsOI8MSACD7L1SGF+u2+I4v17gJZB+ddiNWbgVN5G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWVPhsk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWVPhsk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D539C4AF52;
	Tue, 18 Jun 2024 12:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714582;
	bh=KPgDhhvy/qWYoIhkC4CmnQ47Y6o7/P+1R/JjJF63TEg=;
	h=From:To:Cc:Subject:Date:From;
	b=TWVPhsk7cDeKEwynjbFZwbyHXZDW2wF/fPfdctdWv+QWY/+p5A7M+Aa88QFsr2cro
	 xuT9KMNP3RgbvrriZVL4hbixLn6FV+L55tdZIg3DyIa060Q1DOeN2xCCJKOShitrTY
	 IclPKfORvvqWbSIXiH1aktnHWJ7PdvkGZYt69la2N+m2zNaxkUAvutMrpI8oN4Kgdm
	 KmyvLApVB97cPf+CohrK7n7Lae2r4BvZU1GcqBoGum8OzdtXA15B2ySxVR+vtU/IWu
	 /8r8C4d4dUFzcXVardrHfJOAvPexjOmYRMINZV7Rh6EQFvNltQ8VyKvmizCZWzU6fA
	 wRaXaOYKdmZhQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jhasan@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 1/9] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Tue, 18 Jun 2024 08:42:49 -0400
Message-ID: <20240618124300.3304600-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.278
Content-Transfer-Encoding: 8bit

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 6c3bb589debd763dc4b94803ddf3c13b4fcca776 ]

Zero qed_slowpath_params before use.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240515091101.18754-4-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 858058f228191..e0601b5520b78 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3299,6 +3299,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0

