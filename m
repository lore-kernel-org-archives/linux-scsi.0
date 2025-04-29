Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CD7299A8B;
	Tue, 29 Apr 2025 23:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970721; cv=none; b=dtBtFq5xiiLK525APZhfD62AwoZKxFcTZ50Xkma+jv2jf/r8429CjB6o+TJ2wo4JDOx2LTAjb4jJIjWHAIXnyIOhHOl58B5EMdc2Gk7Tsscgq057jC1dTjk4lf/eEQzS+BEPDJiclH5M1LT2ECPPwmf8L+YnxL34Yg/A2NxTHXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970721; c=relaxed/simple;
	bh=GSShjkSefXVjJ320Soai3s/rEN4erY190WSPuUY01ao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rDnQVwv7y6chdEcsjAZR3Udsy3neovYzZw3H1xIatq/B0lKhl+on7YQnQ1e+ULXD4pTieRRGKbDV2kRwnVOHlTS/t+53ThcI7HLAHxl6Tor4njfh0xjntnyEsQqzv2ym0rR7nAB7Xph5zWmgV26cWpSX2MxmHlW6eRu8P7VuLSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQHouyYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQHouyYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5059CC4CEE3;
	Tue, 29 Apr 2025 23:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970721;
	bh=GSShjkSefXVjJ320Soai3s/rEN4erY190WSPuUY01ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQHouyYEXIBeWt13drNOXmR5JG8xO21GNriau3vyWx0Ij1VyVuyYhxf173YWfKpwx
	 GjuWwK1RkmAURuEYZ4UclL+8F5mAQWstQ8wQ/Sct6OjldbZEQW5barZXE8xiPiANyM
	 /fWsBrgT8HheqPH5GGFHZc+VsxtdSAs0YrYcF6lNb0fkhC6z5QhHgVc9oG1ZVjru3s
	 4EHAw/ncZX8qG2NsohmCvpBjIrz0H6st/PCPhJYyRbVrb/mRV2DAL2llfpkm8sJImL
	 ZNvpqDndgkk5Anb2BTvTV80qpfZoOWOqAyZRZ4iKvY0Bmvjk2RnDISR8yBqoRIcJM4
	 aC6Tu7wtygBcA==
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
Subject: [PATCH AUTOSEL 6.12 21/37] scsi: mpi3mr: Add level check to control event logging
Date: Tue, 29 Apr 2025 19:51:06 -0400
Message-Id: <20250429235122.537321-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235122.537321-1-sashal@kernel.org>
References: <20250429235122.537321-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.25
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

