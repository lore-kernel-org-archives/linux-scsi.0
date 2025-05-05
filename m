Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C608D35D7BB;
	Mon,  5 May 2025 22:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485906; cv=none; b=b1D/lNXqBW+LmuwLC4fdKI10G0iZ1/FnDg5NLisSX7xtmteBWSeyxzB9MZV+8XiQiUJkvKot6h37ZQsLd3am9Kgz48uR+9KjMb/1y6NvNRITnfN87qSBvuu3UVrRDI/Cez5nVywkxPkrg9QLb0/j9hw5zemY9L88wRcT95KSkOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485906; c=relaxed/simple;
	bh=ptyUP18uHVTbecN1W1P7sS32RvPDU/5QXcxuPG2yEpE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eKR4AKH3OLb4iytZhNrbqrnC0MMB3CrkEh2ZrFS7BZXXaNMuml3Qa5L3pFdPUvzpECw8xLu4XzR+u6y1RheKJWOBME39hAz99tl+08bNa3jFXib+5YxprpRK43/I49wMxnDZLqPoGTXvzRjTQUv3GwTHXGjYY0vQ7bOcrmGKUYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VuVcm/+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuVcm/+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4242C4CEF1;
	Mon,  5 May 2025 22:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485905;
	bh=ptyUP18uHVTbecN1W1P7sS32RvPDU/5QXcxuPG2yEpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuVcm/+cmZxQE54NNQGFdMBSxJTS77XGydUJ660M8Zn9r8zhSROjF3ZIK5BXe8ZhB
	 8Xvax6S0Rrn/hXmNfj+x7+8MklaDkjpiHauQBx62PsChGKBo88nQpfF+UWwwYbFR3q
	 F6AvGrUl1B1+qMMf23QsErQVQh+9xS7toc/BZRJlsnSX2FTuyuq0kDOOmvQCBkxf0d
	 yNRuzwRY/jmFzPOXEQ5TyHlvhXv2WmWEbVZIfpqVFmZhh4j3YKAUKbj5oNLdTxzVY/
	 5Sq0Z8+QlZWarCx9pOm7OBafHaZNs1q9pENxGerzrdZ5ZmjjKewontTh1RR8UhKOgt
	 ymM/di8b4C79Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 058/294] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Mon,  5 May 2025 18:52:38 -0400
Message-Id: <20250505225634.2688578-58-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
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
index 900322bad4f3b..293074f30906f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3082,7 +3082,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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

