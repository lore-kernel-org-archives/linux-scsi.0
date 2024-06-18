Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E035613DDDF;
	Tue, 18 Jun 2024 12:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714182; cv=none; b=mBfH2UKSdzUTJX6c4D/HMWqwseQTywCRwlLLIZfgFYBlGlRENUAfgnsWnuBl46k4XyPhx9d/t3IYQoys78IK9V3SXDi05Z65BFjn8QAbdD9F8JFVxl2tt1MAZRirv8RSb1zaJnOwFstqB8tpow78UCIydjBqrtkoHlzB7G7jpgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714182; c=relaxed/simple;
	bh=CeoHqsszhoN5QJ0ujEAwdVcjyLmO5mHjlcGtzmAlaZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giZO8P4oFU/7dZNi6fZscrpxp/4woGtkBWLJ6QRZZvO8D84TT0q18TWZ9fxOUal5AAzuxpgWPZB+kEqKgSHvvOQpdTswwMlpH9eZ3XkcBUPdK+u5bA0FxXq2+fvBbpTS/KEuKM7dyKSaqyVcIKVR+X0XNf1vcePtP178FoESlck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gc5u9wUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gc5u9wUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD20C4AF48;
	Tue, 18 Jun 2024 12:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714181;
	bh=CeoHqsszhoN5QJ0ujEAwdVcjyLmO5mHjlcGtzmAlaZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gc5u9wUkCvBgpG83ppu0YBxDwrvIq0qJ8TCDACoeBjaIdsSwViYUxHYSkpeQUuDwg
	 6BcWZeJv029+WSkSOF+tlrjZYL0vpbLUjlwSQUwpsF1eSfae62vj0f61lWDila3bZu
	 DqNUG/sKa1jLhDJDtFqHKigzsKnoQtKgiKp+ziuWeNsQKwwh2VPDjvywsllieX6iD3
	 ZN91CfNt4Y5WfrKz5Ymos2oh45bNS55UwbT7pF54SUYvgppnjnBRX4IUj5yalMdsLR
	 DDPjjYt/X9AaBfSxQGS091fIDeUHHnOpzf5pGmYOmsjjZ9/W6lhIccx7Lo3xTNcV7E
	 8KSn8/NCJFABA==
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
Subject: [PATCH AUTOSEL 6.9 05/44] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Tue, 18 Jun 2024 08:34:46 -0400
Message-ID: <20240618123611.3301370-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618123611.3301370-1-sashal@kernel.org>
References: <20240618123611.3301370-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.9.5
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
index c98cc666e3e9c..b97a8712d3f66 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3473,6 +3473,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0

