Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A7219F490;
	Tue, 18 Jun 2024 12:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714428; cv=none; b=Q7TbuukA/7CLaPsGX1yTE956gaQVBbdVV0Sx8xSAjiu0YAaanGt5A6ZDv9simTBpC+kE4W6ZST7Mb0JlMCIYiKTPjEe0wRb5UWQzJUWbo2p4mAQzJai9gWQ+cbYFNak0myoTQi7hv8gEidc4iuJgbkJ79rxA8d45uOgBKWDhVqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714428; c=relaxed/simple;
	bh=KB1BAl9JtSHkWwfh6blSRPpQynzr/Uzdt8CT05pJZH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXJXKOxpm2r+M+4ZpQM7GjBshnjAvBjx8ol+S8KYVu7ZXvA1U6j3prThSAnpbrPSfy85l9zmim5I9SndmDy1qgr2+tNTZGhlSSgRf4ba5+i9Y5P4D/lviDvE1eseJrSeUgK570p9/4jvpgSUmY1wG7BVaWP19OwAHyZiBEBOlBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvRzHXK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvRzHXK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D304C3277B;
	Tue, 18 Jun 2024 12:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714427;
	bh=KB1BAl9JtSHkWwfh6blSRPpQynzr/Uzdt8CT05pJZH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvRzHXK10g6Kk+d0VVl78UKVdft4BJlx+n3oN5qVrN3eJn1VO1Sjdd7cyVNX294Y1
	 whpf2sIwHy6wBid5exBySkFnhBO5wHriTy78Jb7bQ39Ma4UQsLGUjkTR6m/vK2xdnc
	 kgfD0UtziBpQdmJCBWgJf6LLsWVIjA3HcCajpfZhSqx1bt7cTPf5nqLdVeD/jfL5g1
	 F1r3fd3qAQp5DniICCv/VD7nQf9VpKyAdDpLmrQNE3tqa/rlcriE5RtkwAEAHYZL97
	 YzDGfV9eEPSnXFkuzZd2Hdp0Ha26doaKhIp3chwT41OuL3YszBGkdzMMsabNxYMWIR
	 L9J7TiBEvSzuw==
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
Subject: [PATCH AUTOSEL 6.1 05/29] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Tue, 18 Jun 2024 08:39:31 -0400
Message-ID: <20240618124018.3303162-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618124018.3303162-1-sashal@kernel.org>
References: <20240618124018.3303162-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.94
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
index 524807f9f4eb1..179967774cc8c 100644
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

