Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027FB13C91A;
	Tue, 18 Jun 2024 12:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714554; cv=none; b=XbKjV0cxzdt5xOQ/uuW+5gwn12hp7WBSa9I1inG6ZE28P5q1OFChaIYLMRJqjyyWo5UNQcMLgtNjWPnYVFgoGYL7y+4UjVC/w3q3GaOTInLx8CeZ/HuZMQAvEpIG7MmANAoxTb+BHQh+ic2636xATnvb9ZYkia6PnOeB9FXnf/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714554; c=relaxed/simple;
	bh=//3aVNV1+rbdJo2MftE5KH8BpelNcEsO7/rdmGtajjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WTSVgiyvc/kOeQbHI1N7+5rGb7GMv3F0ufZflrR478pdqwtl/ZzuaukhD2UBMROhKF0QtgCmtKv5Ce/70ixYBf8i8nBjA4zSqREn5as7S57K2nlzba5GNZZm3wCb8+N7+LvDAykO1PtfkQkwln+RMn1Yqfubqh4uS60JV9MFMA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uqji+SlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uqji+SlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BF0C3277B;
	Tue, 18 Jun 2024 12:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714553;
	bh=//3aVNV1+rbdJo2MftE5KH8BpelNcEsO7/rdmGtajjU=;
	h=From:To:Cc:Subject:Date:From;
	b=Uqji+SlXBwjomUi8dAaYJUkVf1lnwjn1UtfwhPclkwQjzex45dnMG1E+Y0xrJrljF
	 8wNvvBdmGuLgnRD8WqsnR7C/xiaGor/EuO1DfE39COU4zWMZ7Ns/cUefPKp+jg9VYw
	 dZCw9j285rgkMVtyViwCvpz1g3xqeP2sS4Vxtz8yWF2mzCsEKrVLSG3uj08N2NgA+N
	 Tc4uNGPvNbSblrx/gbMQhnyUkWrI2Pw3sZEWXMnoSYAhfBK7jITowkEAPItLUnne+A
	 i07H6EhFkleiDjWZz3je/kvX/1rWPUnHNCKRWLg30XXV0znCgOADorG++WIr9VJit1
	 ye0NQVnkr085A==
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
Subject: [PATCH AUTOSEL 5.10 01/13] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Tue, 18 Jun 2024 08:42:12 -0400
Message-ID: <20240618124231.3304308-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.219
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
index 6923862be3fbc..2536da96130ea 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3453,6 +3453,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0

