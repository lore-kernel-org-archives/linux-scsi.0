Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0274240F0D;
	Tue, 29 Apr 2025 23:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970649; cv=none; b=iq5q3AAPrJB7e3x6jexC2VW2X9fIDw+mufXI++8Kcl5bU1xOODB4g6t6HXe6++kGkxCeNxvqkcPUj1v7RzXQyue1KnTBs1bZbKKbo18UN6suobURUdQ4ZlPk1anwmC8UtDzNumDHZwmf5cTvjkRoPUI/iVzmjqtpoUJ7aIE/F3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970649; c=relaxed/simple;
	bh=GSShjkSefXVjJ320Soai3s/rEN4erY190WSPuUY01ao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r+344ag6jnMtWgrUzCq1P8SfcklJIBc88nVG/BNPtsLIPMHe4vQ3SW19xJlK8xkW6FHa+kvQoJ7NSW0nG4bRpdAwUpnZisTKJp4Nk6hrFbP0KRA4Zr2zmYn5FkCfkZTiut/yr8I+hUxnUVPICVyJYGsAX9LTbs+Cqg8WfhxbbYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bstMdPqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bstMdPqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4213C4CEE3;
	Tue, 29 Apr 2025 23:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970649;
	bh=GSShjkSefXVjJ320Soai3s/rEN4erY190WSPuUY01ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bstMdPqdZ2qoZuHV3ewXB+1FHDjdX9BgS+Y6eyOFh1Gb7ubkBjjT++/9wcxTyOi86
	 VU2OFxcBeUZf5uHj9OYNCfOveISahJZTulAd/ujFtwOR5+oiXuzLi2H06cu2LRW6Mk
	 JArGONLSzA1g8xIkxJbIK+InWAPP6/lyx6ZJiu2hBrSdvXWBoFNDEElH6J2o9UKUZj
	 ihW4wcg5NbFRStEaB3i5lu00z1/HMy/16S7c13Doaj8xCAqaQPY3Wm60PQfD/VraZ+
	 /9+dv/T85RFZDDtgE/Z7gFZYcpZEw/QDFCtxeZwvMJpKHyRbD7R/8/nIFMjCQb7lHo
	 Ud1cjZCnflctA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 22/39] scsi: mpi3mr: Add level check to control event logging
Date: Tue, 29 Apr 2025 19:49:49 -0400
Message-Id: <20250429235006.536648-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235006.536648-1-sashal@kernel.org>
References: <20250429235006.536648-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.4
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit b0b7ee3b574a72283399b9232f6190be07f220c0 ]

Ensure event logs are only generated when the debug logging level
MPI3_DEBUG_EVENT is enabled. This prevents unnecessary logging.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250415101546.204018-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index ec5b1ab287177..1cf5a517b4758 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -174,6 +174,9 @@ static void mpi3mr_print_event_data(struct mpi3mr_ioc *mrioc,
 	char *desc = NULL;
 	u16 event;
 
+	if (!(mrioc->logging_level & MPI3_DEBUG_EVENT))
+		return;
+
 	event = event_reply->event;
 
 	switch (event) {
-- 
2.39.5

