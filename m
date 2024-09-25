Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E901C2327;
	Wed, 25 Sep 2024 11:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727265075; cv=none; b=l8Mq5H6AwE2/GMTMoWfrdYyx69ONxtXF7xCRZPXApyzA7aSvOGsvCIYj4Hete5fTR0BscLzZUu5uoYGugc/8QbFlIBdggt6lLYggZ7uNe5XrPVPGPnKDMEK3seymsxy1Qcjg5l0iX/0q/jF/dXBbBksr2Xp2x0jD4BGGQggR+P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727265075; c=relaxed/simple;
	bh=uwvlE86YHQU/hfeMbPJqPOnWFDozBb2zVNDOcuYEcH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9aPzQMWN8ZusJ3hXAkAr6MJbbH1Fz02swmIlseGu/gJ2sM/0Y0TaKSMvaOLb0maHYIc2bZJzBr8Pl0Vptl9cY3WdSPGF3faiRD3uZI2xy+uM4NWrd4EzbdMG4W0BDDxR9CxurvKHEh4ESrK4jtxS1+lwlVRUFBknjbIaIVfVBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W9w+s8RY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W9w+s8RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AA6C4CEC3;
	Wed, 25 Sep 2024 11:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727265075;
	bh=uwvlE86YHQU/hfeMbPJqPOnWFDozBb2zVNDOcuYEcH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9w+s8RYkeQf/zIIfwMNsR+D5BkZo8Hai8Ok4nW3fF80W2kjmB0w8xgAJcBjgipSZ
	 Pc78/VMPMIVXum3Ft0jRjYc5FGW315gZXj3x5XmAZi8fLr2SuAWSgAbV4n6bo2JG8R
	 UAnUECSS/gtFhNKmZZ/k0LILHCPxiibPDmScexqZm8yPJ3aZp5rFmVLt/IKmNyaVBs
	 zYn9RZMkSDrDHuLfAw3FtaHH2VEguh04j9mAysaUqpGhMsHd07R+EnkyDER/dqQtCE
	 +7l0OnoQ6xvt+PZbIC/rtaC839oNo9Am8JTr4BheDOPHKWKK6OJnn/qRqBQJo2F1h4
	 nFfRuVQUB5W4A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	schmitzmic@gmail.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 206/244] scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers
Date: Wed, 25 Sep 2024 07:27:07 -0400
Message-ID: <20240925113641.1297102-206-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925113641.1297102-1-sashal@kernel.org>
References: <20240925113641.1297102-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11
Content-Transfer-Encoding: 8bit

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 1c71065df2df693d208dd32758171c1dece66341 ]

Following an incomplete transfer in MSG IN phase, the driver would not
notice the problem and would make use of invalid data. Initialize 'tmp'
appropriately and bail out if no message was received. For STATUS phase,
preserve the existing status code unless a new value was transferred.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/52e02a8812ae1a2d810d7f9f7fd800c3ccc320c4.1723001788.git.fthain@linux-m68k.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index cea3a79d538e4..a99221ead3e00 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1807,8 +1807,11 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				return;
 			case PHASE_MSGIN:
 				len = 1;
+				tmp = 0xff;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
+				if (tmp == 0xff)
+					break;
 				ncmd->message = tmp;
 
 				switch (tmp) {
@@ -1996,6 +1999,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				break;
 			case PHASE_STATIN:
 				len = 1;
+				tmp = ncmd->status;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				ncmd->status = tmp;
-- 
2.43.0

