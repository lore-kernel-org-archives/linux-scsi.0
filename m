Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2F62BFC7A;
	Mon,  5 May 2025 22:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485319; cv=none; b=QlOTNnJpOlOktmDW6dDUMcgzE67CIk6KkBKXbjL12409akh/Y5I/lCC1TE2aGjA247s/F5KQwAc65xv0miTX+1NqA96OLzrhSDkcY+pTePhBWnvEr1iM8Hnmok/wRtI38sFQT31KHLYdsTByR+zba894S3zEhBX9oz1asrKZJs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485319; c=relaxed/simple;
	bh=nukJkg7Bz886A3Q15leWjngdksB8iowySDQppWfx5/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lkzUHrL5pXScdkMdBgY7AOG34Ja/QYIqt6zGrF0yQYFs7km/qIioPrB74YJtNx+psP++Jv+pbidCHAMj2XeyR/JcQIlW3gTrHQAjFOOpBN8G+XVSYy0frO/1ii19NPwdKprMPUHfs7MKFD5ylpxVBXCE0j3wPivS6/ujLuS1FYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5aHZ5yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5aHZ5yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6999C4CEF2;
	Mon,  5 May 2025 22:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485319;
	bh=nukJkg7Bz886A3Q15leWjngdksB8iowySDQppWfx5/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5aHZ5ygyAlKyZl2ZqR0XbGZPr6OvL7GLqSoTL2TvSyNh9/+FJP396oleyrA62j2c
	 NTyEGZ4nFcNhbK/vsx94j4Bn7LIv6ugQ+ng5DSOktmFO2EB8vpXNQRHnnyXeV5kfUd
	 HTF4gh2139Wni0F7WbZxN3HW3OtqFlXwYAbUbYrEs+pJlMyZYFLrfIYnUNSSznsfL9
	 xec+viQx1mTo6c1X/bTcABPOX9OeaiuNmcgLfNaZD2bif5G0afOdLYH9G2BrSp3tzQ
	 Ivqzn/y2jQYwtR2P3DPdNFSLOUzd/q+TYR2UqWFwqEGHke4jzkQy0ja5cD/k9bXlzM
	 dlyw5WoRhBIPw==
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
Subject: [PATCH AUTOSEL 6.12 264/486] scsi: mpi3mr: Update timestamp only for supervisor IOCs
Date: Mon,  5 May 2025 18:35:40 -0400
Message-Id: <20250505223922.2682012-264-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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

