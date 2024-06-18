Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C52115AAD9;
	Tue, 18 Jun 2024 12:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714601; cv=none; b=s8LfLqRhO/Y0JSmG9jJzGYvJuIOjXfw3GA5kz5PSkwo0OEZPjtIUYdjMG9esaXAo+fids1a2+gd/EXvuG2z+IhQQYSV7muaxqPBtko0a3HQzQE0i6UlAQg+BpFalnsOwOa35NuxmiGsd0/NAvfjOugqQ05POnVPvVf6eDb7QRqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714601; c=relaxed/simple;
	bh=mrr1/gnGhxIFsA7Wmc+9BmFIO5sb64qepIbcGbCrJak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i7ESgVbxQjMJC9Y/GAFDGm8We/YhMsRHk7YMupJHenDfXlWhhVlbHsSb7M7nsjT/1aG5m6KC7puqp1SWWHHQwkrSfDdYnDq4vwG7rgnn2rR3XypkrhsTCJszEu0l0beinFdkWb/2ToYLPocmjFk1WbzaV5yM1s8akINu8e1AZg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVRxQWjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVRxQWjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4A1C32786;
	Tue, 18 Jun 2024 12:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714601;
	bh=mrr1/gnGhxIFsA7Wmc+9BmFIO5sb64qepIbcGbCrJak=;
	h=From:To:Cc:Subject:Date:From;
	b=JVRxQWjTPl3UBl27L1b40yuaIsgdB1MfVq1zGuqxMXJty2iBuLnpTW7zGyA3I+6Vy
	 bzFH7Hk0mECslNjj0OLmx3Oc5PlK4FzY6WFzuc1k33AhgzjCVGJOw2rWwCgV8Pxpsb
	 3c9zAnRbGLIcuSL58VXIZWJXAHG426j9x8oSKr6GzxS/fRHJJNnWVigjIQMt5DTPsW
	 jx9e5pzf3emkQDE+/8EgJa2sq8gDkd04GvntXrYYXVNkB13saUazEV0Rj9sU9lAxv3
	 RSmtiIUto0AdQnweF2UAJTmVbnqPWdWnJepwFvXlXhSdA37wwrt4Xz7Y53Tu+/ORjg
	 xS3oRF58btJHA==
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
Subject: [PATCH AUTOSEL 4.19 1/9] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Tue, 18 Jun 2024 08:43:07 -0400
Message-ID: <20240618124318.3304798-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 4.19.316
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
index 01e27285b26ba..33fb0e1926831 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3101,6 +3101,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0

