Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C12B16A92C;
	Tue, 18 Jun 2024 12:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714321; cv=none; b=XiTVvHEhyW3kCoBR2XOvd/+5NmrAvn8ZQe3BSuwwpVON6KVDuxtM7gxJ7gVMsixG0kT25Vj+cxGTlQnCiPKKQR+eEgX+JQwvdGAQ2iQZdqaWZfL23vCiVKHAx86nKdGkjxh2giEGlZSazxT2u+Pyl8ayQN6Jij+oQoN7FoAuWME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714321; c=relaxed/simple;
	bh=cj2fRDf267Unkt5w5tLnfQIY6SThGBJtzaP3RNc8lpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5rdl4J7YmXww+TB9K7ued/m0P/wBnYCp7r3FmFRTUES3pULijnh8x8hBNvrr0ZHJoo2GWDMlR2yzjKlA9U369AZI/fozAlrBdNNq1b9oNSGT6oNba2kKUGUmhCzf7KluxIrqUQYoaPZju0uhLaUxSCbel2NOnbnKzWYFpPeJs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOggm2eC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOggm2eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5FCC4AF49;
	Tue, 18 Jun 2024 12:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714321;
	bh=cj2fRDf267Unkt5w5tLnfQIY6SThGBJtzaP3RNc8lpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOggm2eCVqfAxv/Rk030Xxwx3d0mEKsABa8xh8D+cuq8ToxrrN59dkBSxtPx8PWCG
	 rFuVJuD/iZ6t9rh94wjDrkKH7uAZWwx+0FC3KAGD+sM2MNiLKUo+9KzsWTV4JD0Xh2
	 p07O2PdtESEHo9VR6mdhNG270tBWADHwRGXNtHFvuJODcnfVM9+gXRoC62gX+wsOmb
	 B39Ikqx7xt5AdsSpVjfnTojtBzQVZaEmUavMYUKKy/LJMKJI5BSp48cZTw9FoS1TdA
	 wNB2Wi2u8bRC0Jwrah0cwroAW5/hSKuAKwdABDj5aIwZrqnpsLfsK9oY//wuqw/jmb
	 VVqP+vpr0vLoA==
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
Date: Tue, 18 Jun 2024 08:37:25 -0400
Message-ID: <20240618123831.3302346-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618123831.3302346-1-sashal@kernel.org>
References: <20240618123831.3302346-1-sashal@kernel.org>
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

