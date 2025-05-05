Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41433991B3;
	Mon,  5 May 2025 23:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486471; cv=none; b=Dcu1TXtQnfCuzkQdjlwd8cxbE3E28IsNyMR1BMMmVZGg5+sZ6mbK3N2DAgZg+t3GWDIbQqvueURsBUmJcgNPsaSvCi1dfU7WbZh/QohwvXMwChWdCeDjWbM9yYOqWK6GROSMI2QARj2cnpC25pDaHnv2bHUHoXktqlK8gb5FAOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486471; c=relaxed/simple;
	bh=y+UQnZ6ja+c9QuGZ+BWmcG4EplY0x2HsYNaCTmwTssc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5MVYLi1lDZpjiaoYM75mS7OdFyETY3bnPpijb9iFAU+2q5KRhFwC/2E136ibplpPG7TU1cmo4H3BpBogxDWaBMTwmE6Cyf1fhxHSWJFkymMehDMez109bv1iCUtao6PUNJRXXi4QHkptRbhubNZen4dzjp76IcmlW+uZ3GErV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aar0pDTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aar0pDTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0597FC4CEED;
	Mon,  5 May 2025 23:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486470;
	bh=y+UQnZ6ja+c9QuGZ+BWmcG4EplY0x2HsYNaCTmwTssc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aar0pDTUYcIBVWhrqQ524UBbtLfueX0vr2Vt89VpUtvSKZ5NVFoE12eBsVkeMvB/X
	 fOJxw0YqTESPU2/+lS5YYjiD3ec0j4b51KWhh6u8dn2Xj/eWhcL6TeD17EWkj+tG6Y
	 I1q0SuNg1iYmHsEHaMRWzGXyaWb7xX46YS9cXd/WGRdrrDeUnSE2e50QDWrgdS5Yk/
	 aNqn9CoUvRCK/aKa9QL+2+1Rp4REQO4Q4RBZ9aRlrmr/RmDeu1TNUkIGXr/3oCa9OJ
	 plXyH0oELQ09jhvzRzrdOXRXRphqsVYESU2KJnlMDYprolJ/pEfSxf66NnHnpU4LMf
	 pwvdIzrZiFdzA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 047/212] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Mon,  5 May 2025 19:03:39 -0400
Message-Id: <20250505230624.2692522-47-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
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
index 7f107be344236..284c2cf1ae662 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3074,7 +3074,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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

