Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046A61BBBC7;
	Mon, 17 Jun 2024 13:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630599; cv=none; b=greFdeJRwuOKKz8vAdWpt24zjMF7V4hUZ/HERnJJUmrmMUO3UZIX3SQBy4Ia/mNmtbq0dbClYwQ2DIklB3pFI+VTyeaXiAVZn5vHGU9UJoD5hXL++CkiT7B8IdLHItQ5ynVxliS1mHxBmIVaDjoKgTd/G5wKgTj3x7CGfciu61A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630599; c=relaxed/simple;
	bh=cj2fRDf267Unkt5w5tLnfQIY6SThGBJtzaP3RNc8lpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXQrXhhug29m4hggkvvs16TaeGVif61eZj57B/eWkFCJ0fzLb0f9Juss4cEobqzNDEvNiUYKfY1T8Cy7sx2GS/hVd6RVej/VmHTlLt5BMryT5ty07RnenGxIYPDtqTR3ehIHTOO1bY+yKZhPPJbRt9QvEW1mKDwSEHj1j9uvFOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfCPJQWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfCPJQWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84BAC4AF48;
	Mon, 17 Jun 2024 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630598;
	bh=cj2fRDf267Unkt5w5tLnfQIY6SThGBJtzaP3RNc8lpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfCPJQWX5wCxJD39IhqxEvb5468Pz1gTInoQWhkN5FQoetxUGFlUpwWZyuTqEuzgm
	 2O9CMhV0dhppoY6ueMWBdLI2GQaIB+D5l47/ci/e4pZNcimG9WRAt0qffU7zRsJ7mI
	 CKoeU3QdMqfUQJOVj6WWLwzzCuEtwoBcEwR8KTlpYtRCIB+dgNJirogq3TrAcW9LvM
	 Oq+gSMsC9S2hwYOTTSFRsXwy0dRgWgrzNNqJl/32/aDR4b/INQ6AZg1fBNoRmnRPP+
	 QquhOLreHM710B2dX0t1d1S1+U8adQ8wZtViaEhPCIM4qgt+Wu6VG9xK52h5ZufijZ
	 jR0PGRJg71fMg==
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
Subject: [PATCH AUTOSEL 6.6 05/35] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Mon, 17 Jun 2024 09:22:03 -0400
Message-ID: <20240617132309.2588101-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240617132309.2588101-1-sashal@kernel.org>
References: <20240617132309.2588101-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.34
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
index c97e129194f78..14625e6bc8824 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3472,6 +3472,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0

