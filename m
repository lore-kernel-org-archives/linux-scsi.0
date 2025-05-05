Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97C72FA116;
	Mon,  5 May 2025 23:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487346; cv=none; b=m/TGSsfsYR55WyGJhfvV/1z5CZjbYbvtaASQ2hDK4BaKVY2qsvjD22T8bKj1F6nDUDk1jsdWZJm8eqjaC3QaaCG3ybv6Akvsb/MzT/bEJ2wWcBMv7qeA0bhRtNZ3L0LWboMT8s2jChM1DhNbhQ4P991pv19g8TvGHPY2Rr1lDvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487346; c=relaxed/simple;
	bh=GDhtgJbQZBwYTJEjmRrnC25UbBpD9N12xAJTAGozXJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXri8nQkexTv3/Bi/QocSplD2EhNwG0QZVx/OoczfkxqWhZtjJ2v7R3/DwMBAAZ15iYHlx+aJgwXcjprPjyUH/cCE11cWvI9ZEP1zTBu27jE3a7LQ90WJrjKUt5xW4espPVxnqvAS23LTFVMzE6VXCUEXSkeQfb6La9MXOWQ97k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oIMB7Cf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oIMB7Cf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB241C4CEED;
	Mon,  5 May 2025 23:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746487345;
	bh=GDhtgJbQZBwYTJEjmRrnC25UbBpD9N12xAJTAGozXJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIMB7Cf57GhK9Zw8KD+UMd2O/FEQcO2Rk0kFUCUPgRmrjAixyxxMeXrVLV0mOgDWt
	 NVnUqRMbxLeAT0rpi8MpQWklMjNb3lS4jOwgzYUSQAnCP11g+pKFwe1tBr00WDhzra
	 FIdSZDHRiktdNgBY28HIS5yuE4xAU1fDayXacs7lfogBMcLNH4a2gf1l/OobHwzG4D
	 c0tye6j8xHJhNlhpDzQMDHmvuz8o0FIW/XB41pHDYHt8kaJ7m05cqxR1pauaj0DvQr
	 Z3xguEHNFfBSrZA+oxcbbu66yWaZMUzA84FeRlbtbaxJuU1m1n0swZE7IQZM+kWWxE
	 39OLrjJZZ3wtg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/79] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Mon,  5 May 2025 19:20:51 -0400
Message-Id: <20250505232151.2698893-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505232151.2698893-1-sashal@kernel.org>
References: <20250505232151.2698893-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
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
index 2b5e3e2ba3b8b..8f927851ccf86 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3076,7 +3076,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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

