Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3041AC25C;
	Tue, 18 Jun 2024 12:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714506; cv=none; b=HFRWZ2zL7VTuiVvuED6R0trPfv6Ots5XNUnTBhn5SqvVrFlUYRFpJvneCP62mcSH6k10rmL/hHS5kajX+v5IDa2wnCgsBtAU5QU4FPxxutLhIURa+Obxx/VgqEB9ukPPkoiEMci0OCzeSa/h+X6xRMUcK8nRvMsZhLSQ/hbXRZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714506; c=relaxed/simple;
	bh=zHjJf4OWe8e97IUJG1XK+iHWdvna9Yj45AE+/I2wCvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfTR9LzN2Xzqb0JiWXub+d3AQvDnuH4G33YeEaWQw6+4UOerVdufDmWzM/qLS1qCCpItO11dgYKNBQdQKqBawnDjAKnz+a6nAocyA/1R/Zo+t9p37ED7tU++81nTtrWK/DOI3E7C4OinyxnaqsC22PuzClj+edJmdq/Aq07Hhao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BvhKPsCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BvhKPsCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA23C4AF48;
	Tue, 18 Jun 2024 12:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714506;
	bh=zHjJf4OWe8e97IUJG1XK+iHWdvna9Yj45AE+/I2wCvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvhKPsCxZcIsoHFQwFvdXtlToBQgV/SnwNsWe0TvNLHm29CsLa69tsm1GkXZdff2D
	 GY0JTaKKoENJwKm+iquKKL72A7RImcSvS4kXyNErEaZWUwuq0egwEZKlEAc5kaCqtU
	 KuU5xFBTr4wILHcq1ciXJ0Rhb49wj6YpBj5GHGKpUKwTvdLfStEtjrP6OUlXpldjtx
	 KxRzf0vI1m0cOph6PJrFfOgXRBUlmRg5kktymxzTVSma0SZYJFsA7Plp2fZvMDlxM2
	 hxUYnwYDb4FhghI5mxEeFANHZP/jdBrjZOUwVHpeL4Fac/WnwDabY+VMe5AsrJqLvU
	 O7tVgXf2bT1Rw==
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
Subject: [PATCH AUTOSEL 5.15 04/21] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Tue, 18 Jun 2024 08:41:03 -0400
Message-ID: <20240618124139.3303801-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618124139.3303801-1-sashal@kernel.org>
References: <20240618124139.3303801-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.161
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
index 1900acfee88ed..690d3464f8766 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3477,6 +3477,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0

