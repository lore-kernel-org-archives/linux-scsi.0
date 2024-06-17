Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1871993A2;
	Mon, 17 Jun 2024 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630456; cv=none; b=oLg+UvNoc76MUv5haM0G6KuUuzoaRfEQc4ptOHXHHvtmtTnun25kz4UDXrxyRa7MSYxFDJJkHROp5ywFV6Jwjskgg+oltq1sAmowbxesGf0u9SibYo1YSIyvXvcUqJK7Crstuep8fS3wJTjmWgv/SbBV8rKLL4jO46XjizplW3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630456; c=relaxed/simple;
	bh=CeoHqsszhoN5QJ0ujEAwdVcjyLmO5mHjlcGtzmAlaZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1+MJB1yn7PDzkuCxN4LGOyAml58aAnN6wwPcy1Bc50nRM6F3PrrUOoumEnQk+bDxeMRbZFcisXlgBvEeyAAVWMBf1w27P26tHzJcW6NraON2LbasLJzb7/mzaS+C9cPlWTrZGHieLCrb7HpteivvJdH4Ku4lufPmYH9uOpLav4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0tAvhIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0tAvhIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5CBC4AF1D;
	Mon, 17 Jun 2024 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630456;
	bh=CeoHqsszhoN5QJ0ujEAwdVcjyLmO5mHjlcGtzmAlaZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0tAvhISrPC1Wdb3um2BE/SRILOR4ZPD9cVdvNzUtmv2fyKS4WwEBW+c55al/cA9J
	 cLYVULqnTAX0HELYStEB3f9yLPjviUKYJAKV/gpNuUU6qPbU2XJKvCeZHNnrnSVwDd
	 4IhHEhUz1pT9ugXcRV/qg3JSWJEiPyMX2q/Ka1Gl4PGJclekmk8Dq6662FFVuCFjKC
	 4dKL83fGmIu9sPo2gSabSQBqYXzgws59ejuQVFHxL0+Gdey/nloA1GAX+tBQhYe2y4
	 OqbKq7UUgDd1BK81TK7TDW5QF/b1zPnWOna9gsN8QsSXXm7S/vEoGFgEwj/mYzaK+z
	 Tn2nZVzCZjEDw==
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
Date: Mon, 17 Jun 2024 09:19:18 -0400
Message-ID: <20240617132046.2587008-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240617132046.2587008-1-sashal@kernel.org>
References: <20240617132046.2587008-1-sashal@kernel.org>
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

