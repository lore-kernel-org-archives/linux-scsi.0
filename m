Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC842D6429;
	Tue, 29 Apr 2025 23:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970807; cv=none; b=uswBy2g4xjoMsjDFKgKsVHf/coZ5+jVTBnIRTl984SPakmyDeaHCp8rC4VLlBPDSUmmGxeIaa4rGxPXvVgL40ZkqVRugUYqXck2DFAGnDagPdBbu2r6HEc4gkoZz67WZYxz6dwlORrQN10oiVPY11dI+4bv2zDFOQF3MHeY6dyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970807; c=relaxed/simple;
	bh=dUGj9+5U0vcBW3+fqU+Kd5+EuzUZdaoO0HiRTIZY7lU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SWck7SeEdFqHr+60NvTraKrCIJcHpy3Oaur/YnLrrdkvUrAPJXvgn2PTDtePa3OwksTCi9DUrE9Egxi4whhbo9Ii/il6O6JJtRFmQ1l75ZG+2g+TUZuy57k04d2VCOZ97N6yo+Ru0Lzk1oioJTXtIvIU5R1ejUn2j1nBy9CoIAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kdH/Trui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdH/Trui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDAAC4CEE3;
	Tue, 29 Apr 2025 23:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970807;
	bh=dUGj9+5U0vcBW3+fqU+Kd5+EuzUZdaoO0HiRTIZY7lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdH/TruiYLLcPjwPnprpIY7YmniwVPKAyHIb2ZjQ1mD1V8tkWbsIMLnKabnsMwKXg
	 Dp8m1qVP2N3/6UFRgIcdZKSo4oilcTgZUizr8G0xHLLYE1wHLmpmLCG83nOxiTzmtH
	 NOr6AtCk4fTu7puZ0+wWrU57+blazcxuKmpxILqHtke1vSka8V5GZC2Wfn/Eai9Pm1
	 fVpe2oJBPRKBHsewG6EM+570o63dUJ+tEwjPp9DmKzcys9OeLWqgsZWAwXGOfLc9FG
	 E5eUdOGaoEC9hWk600vkpxOOebNcBX+iYa7Y9GVhBgawRS5fOPGV5aAibnnuCh9GHO
	 8wYaKNiiQ3MKw==
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
Subject: [PATCH AUTOSEL 6.1 05/10] scsi: mpi3mr: Add level check to control event logging
Date: Tue, 29 Apr 2025 19:53:10 -0400
Message-Id: <20250429235316.538129-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235316.538129-1-sashal@kernel.org>
References: <20250429235316.538129-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.135
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
index 41636c4c43af0..015a875a46a19 100644
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

