Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED36F305F17;
	Mon,  5 May 2025 22:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484074; cv=none; b=pwaiU9pINQgECDEG3s13iw6hDja6M3Mp7agQAQYWqYVJGQUc0YcW2oMzciDTJy0cygjV1BN3ttsai+WtGUmuRjaDOFe72n0pNoxHyPjD+26soP/LTnaUb8aVsZY+lw1dYoADWxS00lxgoGKCbcVOdx5NpQvlVeKSemEUbf/1d40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484074; c=relaxed/simple;
	bh=nukJkg7Bz886A3Q15leWjngdksB8iowySDQppWfx5/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lu/op16e0L3Nxk8WX0FcUC4+l9BAPPWSJiRF9d4brFZ/GvUfDhARDGuj+sD6hOd3J5cL+yGXhjNIwOsM093+4SaXiUDNAbu984bOcy982I9qcp8Vuk2P9C0RHWh1WzhCWjGNE1gbU3RaQ/1Atv6iB7L7jEvepmSfCHmYAmYpg90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLP67cgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLP67cgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31871C4CEEF;
	Mon,  5 May 2025 22:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484073;
	bh=nukJkg7Bz886A3Q15leWjngdksB8iowySDQppWfx5/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLP67cgDvfyhQdu8SEubPEilUnfDyUtf/XtQedgGklIuRehFTp4g2Hlcp4pUbNOhG
	 mxfFnvkFVgRa/hgwkUpXP2F4/4a+nBGPxGGMueC5ukjZBCBvggSJN5CPgZ/YBN1hEG
	 d6BL+JHznqEJo87paKfMJ3GtdSHPp7xFWqpSbnqjUt3hE9pVF12gSyP1girmKsApEk
	 ZTQ8QmublM++o08XlrTc3HtA50vxinqsafojaSUGoUw3cQCQGxgXTOn5pwBmYhwWmS
	 yaPr6vKQWYBEQAtTCaORwJQT0mbs2SXVQhc17anGBzQED/HQZbYpvXLdhyfQg4lqlO
	 1NCdX+Q3jmX+A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 336/642] scsi: mpi3mr: Update timestamp only for supervisor IOCs
Date: Mon,  5 May 2025 18:09:12 -0400
Message-Id: <20250505221419.2672473-336-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 83a9d30d29f275571f6e8f879f04b2379be7eb6c ]

The driver issues the time stamp update command periodically. Even if the
command fails with supervisor only IOC Status.

Instead check the Non-Supervisor capability bit reported by IOC as part of
IOC Facts.

Co-developed-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250220142528.20837-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index c0a372868e1d7..dee3ea8d4837e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2744,7 +2744,10 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		return;
 	}
 
-	if (mrioc->ts_update_counter++ >= mrioc->ts_update_interval) {
+	if (!(mrioc->facts.ioc_capabilities &
+		MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_IOC) &&
+		(mrioc->ts_update_counter++ >= mrioc->ts_update_interval)) {
+
 		mrioc->ts_update_counter = 0;
 		mpi3mr_sync_timestamp(mrioc);
 	}
-- 
2.39.5

