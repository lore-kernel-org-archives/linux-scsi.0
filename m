Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616AF1AA4B1;
	Mon, 17 Jun 2024 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630833; cv=none; b=QuWi5gJWyzh4b5wmmVAF7CTpHVZf+IjrVcqX4nymfYC258CYavIf6uVohqJTPAV/jVsveZoOlg1Kd29vl8FmJg5TUsQZjFie0IN0nJCacyH5YUTK3SJlRqx54L9sy4PO8bM3t6kK3IGzx6KY6dmYt0/Asn8gjPW1H8qCeUsdYoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630833; c=relaxed/simple;
	bh=//3aVNV1+rbdJo2MftE5KH8BpelNcEsO7/rdmGtajjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WNbMDE4RgfhWFw8pAyyKlNniyu3v0FQfZWMJj6vdznFcCRNfR4KNtJNfx+f3i9d4ZfqwM9WZPaturnC9Vc2/r4a5FYAjwSNz2MDQSAhQbc+lwT8RedX1BfPO4ysbmB+Rj7TBHGtcCo5Wz06XbkBSPyH57M7teg0aoF8hqBknXAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tq80RPP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tq80RPP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C819FC4AF48;
	Mon, 17 Jun 2024 13:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630832;
	bh=//3aVNV1+rbdJo2MftE5KH8BpelNcEsO7/rdmGtajjU=;
	h=From:To:Cc:Subject:Date:From;
	b=tq80RPP5vOJvKsHqS+gMapx9L5jic0QtVuAiLIo1GbdP7ml1XBgTnYps0crGbasbe
	 r39RFGHJnYhkhAOXaTuV8Gll5pkzNlz3TOmRSU6X9KjUOZAnN2aat9b1FWkj8fVFFM
	 87jObltvJvZRAtwAIGNTcn5Yu/potGvCY02LL1OFKgRI7u+rX+FzgnigTL+s48tjcw
	 JI2PFXX0VcZeBMef3YY3vk0SVGz0XadYk80OEIURmMvdrzF4cC5oW0SfL5yfQ1El5k
	 q5geO4T24/TMKdc8tM7WCz1jY4Wqi5ZuD2C2rOjKaYvP695Zci79BSJ6AM2MDq7QMI
	 aJfOlu3/Ca6Lw==
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
Date: Mon, 17 Jun 2024 09:26:50 -0400
Message-ID: <20240617132710.2590101-1-sashal@kernel.org>
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

