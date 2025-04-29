Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B422D268B;
	Tue, 29 Apr 2025 23:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970782; cv=none; b=pbX/9TrHfam/z536BwT00XvFwZY7LJXJL5zj910OAaMbN3dBQmU2cKkYrVRFk/MqRLLDzJuKDNfLLLGGMUK3qLOabHcu78B5TU2A+SBqRvvyD9hXyaFnKX0sSvpFkHddg1YBB/o7zKfZ8rdtZOX9cuzH/y1K2K3udTGGdmmTyM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970782; c=relaxed/simple;
	bh=COWLj79dpWMIyMzXi7B+njZVsskogsohijzWz47SUME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sghK9tegFPTrhgVt3PhGwlKt+9iTxX2sp8/chTjQ6Vy/CUtTqqxbf6+QJPcly563wqwtpe9dn/Lv8U+DOuBFA4EB2nEs67H1CIM24V3icMb4vp6ajIArVoe1sy5za58Rr8KKORNTXraU8f+VW8hIGS348GS8a+lvgFY2Ucc4oz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlTwq4fU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlTwq4fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51708C4CEEE;
	Tue, 29 Apr 2025 23:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970782;
	bh=COWLj79dpWMIyMzXi7B+njZVsskogsohijzWz47SUME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlTwq4fUhAa3Ne4e5/jkuefa6+fwTR7MkMiUGIAxVspfCofHuUlYD1bd9jBH3tHF9
	 SQiCbKrXRfufxtdRhRD620IByOs0sIHlqEsDqaLCFqvUUEEJW8UEAYtIz9VctkpJ7q
	 Wf07CSfZEPGN7j/3iAGRldTMkm/RLvfd/pYPMHyTeWP0Y9HCt3gz3yjWjnxh4W24DT
	 GjslurJyYMg9/oQ6JO5gByEGoQQ5dNBhp8J6jAFFQn/td2G5ukYK4QKJ8J5Sozb43E
	 a8a7+NDrbSWoe5EeC083GgOIV5m+swTKRqawQt8BzxL7o1unbRSheM3FpPWpPECMb2
	 h+Dt5CKJFp+6g==
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
Subject: [PATCH AUTOSEL 6.6 15/21] scsi: mpi3mr: Add level check to control event logging
Date: Tue, 29 Apr 2025 19:52:27 -0400
Message-Id: <20250429235233.537828-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235233.537828-1-sashal@kernel.org>
References: <20250429235233.537828-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.88
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
index 0d148c39ebcc9..60714a6c26375 100644
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

