Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59290299523;
	Mon,  5 May 2025 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484960; cv=none; b=KUZCMHQEzaMz5hOJrsdPoZfH+BArkNYx5/cEpxYuKm0t5q7k4exYZ8S1kHQdJ2hpkPOvEGJy4JVg9RKt8u27TPFZYNV/LwUK01h1QsJhAbfGUTQ1dOQn5hZFE0b99xkMtelygq26QQ1BlWbr9DW8TL+b2UgNZJIHKj9NkDB3p8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484960; c=relaxed/simple;
	bh=xZGMbGj6sBc3Sj/fGa8SASsuV+kyncDt16qSx4L3uFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ntwBcftv86Sf1j1WQBrT6pydes5A+5Dzgx0IORCwNm3whR2bMc8oBj31+PTA6vhPJnLXqXPWAVdSYjZJqY1cCIG4F7pLSpQ/Mpp131ZmtuWqDNSF92Mc9iX0WeSdYN0XNpS/6RWTMvjOYd2+Zw3tbrSr+Ye8FLfEk3FWYt5TZXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TD2gon2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TD2gon2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C699C4CEED;
	Mon,  5 May 2025 22:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484959;
	bh=xZGMbGj6sBc3Sj/fGa8SASsuV+kyncDt16qSx4L3uFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TD2gon2aOBLy7I/n0urqB9x5WYns+YENc7NPly3LiMdwLB2UhBzq9J+CbCPi0a/Xz
	 Wt0HhAvlRK4KbDjmw/NWjJzyRYAOU/i2PNpicHSWULhL3gasbRfuo9RE7PeFLY36HN
	 x71kJ8EGq5aIF5PmLXDzCCQF7MbNC/PdgK4eulO/lm1d4cpeV8kXjFo0ZM/fmGQ07Z
	 4z3ShE13KRN+iALfXkLjTDiEc08d0xG1ihGo3T9MR+GVEq4jYiEFob+e7QqlDu5CZc
	 LuoyzH3XLAOH+mBmgROWfgU4aCvY7ISniNvMzPIpj3tgJnz1JFl3txh4I1D6MiHSTB
	 LooJoIczjoBCw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 096/486] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Mon,  5 May 2025 18:32:52 -0400
Message-Id: <20250505223922.2682012-96-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit 8db816c6f176321e42254badd5c1a8df8bfcfdb4 ]

In the days when SCSI-2 was emerging, some drives did claim SCSI-2 but did
not correctly implement it. The st driver first tries MODE SELECT with the
page format bit set to set the block descriptor.  If not successful, the
non-page format is tried.

The test only tests the sense code and this triggers also from illegal
parameter in the parameter list. The test is limited to "old" devices and
made more strict to remove false alarms.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-4-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a17441635ff3a..1c0951168f646 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3081,7 +3081,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			   cmd_in == MTSETDRVBUFFER ||
 			   cmd_in == SET_DENS_AND_BLK) {
 			if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST &&
-			    !(STp->use_pf & PF_TESTED)) {
+				cmdstatp->sense_hdr.asc == 0x24 &&
+				(STp->device)->scsi_level <= SCSI_2 &&
+				!(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
 				STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;
-- 
2.39.5

