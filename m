Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62DF29C32D;
	Mon,  5 May 2025 22:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483575; cv=none; b=leVzJ2mESqniuRhdHCFWuuIq/blr2ZhvF8WWWFfFsQUKp6h/IhTnCaxspIYjG0lV3CaGIVqznYipWx2OyfGmXWfxa6dDIlJOw7jr3EdSQ8OOVQSIP4k6v8PiyzAAZbjkQnBZF0nSOnCvSuIzgN/ucI6CM6NPrIm11h3QREHfFdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483575; c=relaxed/simple;
	bh=EnIkgj2vg3NjWH8Red7uQyYeZ34MBik4q2hqqlUnDkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7h4qS0e6oupmbBAZZOZ4KZJSc0XSGkhEzHf+2/MkrePH60U17xilLUSU1IOIdh5jntu4LEl9CqDmcYiYv7RYRVEG0su83sOsvJHyy9JvhG+RLH6ZUYnUmANRazWeVTnvnlekKqGPJAz3gwIwZVh52jutTwTWyo3pmZU87EsypY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1ZIsBci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1ZIsBci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CBEC4CEED;
	Mon,  5 May 2025 22:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483574;
	bh=EnIkgj2vg3NjWH8Red7uQyYeZ34MBik4q2hqqlUnDkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1ZIsBci5mOrtjv+DI8a8E5VVD5oWoGPhFcj7TFCr4TJNEZBCQ7qE3p17T6AJnShf
	 0445iAaz9kCjtrWkON1lVAR2/Ynr09y1RXg8Pb19d/euM7tsvK3S+X3Ccc7BKBsnNK
	 674cIXyZri1GrKNXGPH09Z5/U5HNza2BhI8nJuVpOjfJJiNbAy5eHYpZ5VwLw1LaKQ
	 hqM4DjB0VsIMvcmyoEv0+sy4j3mC8EfCIbxfZMu3/znhb55zGSU7fbwdrpg7KNTRVh
	 ioHldwzJoKBWsYwcLUIPMpaVFNPod7VkIXJD7CGnoXvZrYCOh5OHzWZKQzQ9QxVmIm
	 tZoYyivYjqD8A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 122/642] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Mon,  5 May 2025 18:05:38 -0400
Message-Id: <20250505221419.2672473-122-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 344e4da336bb5..2a18ba51427ac 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3084,7 +3084,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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

