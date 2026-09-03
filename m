Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597A537F726;
	Thu,  3 Sep 2026 03:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406994; cv=none; b=RpSpCCvgHSq++qt24WxkNbdOxltE0CH09fdmqiRQfTfIq5EDuQDFRAjfzDvFIqK+vEWWIKeO6q5f6EEtDSioJRjqx3buH0shIA4cHkRoOdBJbInexesrSTerdUWu+SBT/6kaUW+7ioMbuu5uYnr8HjteeD/tAojWEbVgCMDwA1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406994; c=relaxed/simple;
	bh=0EYWFEYW65Y16rbTiCerbOr1TaGf/UwUikK6l+Fxl2k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlxDgjktHz7HtRPRwfXKNnn6NPuiaixpCmes84sYfYKIwkUAMCApqYgfCs0peEe3pGJLscImtFw2bVZAoqVL0hR2D1wg9lsC5KnotIKK2I3mCcBik1+RoW6oZSgiGE/YmPSgad8unGaV98s9YqxKiGbNP148EYrGlV/cEP/mc4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D120BWL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D120BWL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3BF1F00A3D;
	Thu,  3 Sep 2026 03:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406986;
	bh=OOmP+AAn35Yx6p3Mt4dGknMDab/j7jCN8TP38qbLk7c=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=D120BWL+TFNP1elqiyvcOYhio190NrcLYVh858zXTON/kXuhSJezy6ERqyK6euWQf
	 doAS4dYxtKDScEID7qP+MkvIdcdK5B0ei7km/UmE1bB48gYOYapmg9owtKlh+nQSzH
	 fVKgmCy51kTnH3GQvqTmVvPuZbo3p4Yvna8dSj+lX6AQD96fhJSnP1mDBDiBfZu2gY
	 ukjzFuCXUuo1sEoqiVP76YTFXLfTloU+GoPyQPVAWL5kDRvzdnWLuwUHDiLDPQ9NJG
	 SrPa0roudrIUT8xlBCo5USSfoDviB05X4wqAqrJIIShn7hIK0b5Wu9hwQtK1Nuic6m
	 yHPWVLerzeB4g==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v2 28/40] scsi: mvumi: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:49 +0900
Message-ID: <20260903034201.112211-29-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the Marvell UMI driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e70d336b4ab3..a5bd3258a399 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2067,7 +2067,7 @@ static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
 	return 0;
 
 error:
-	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
+	scsi_set_sense(scmd, 0, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB);
 	return -1;
 }
 
-- 
2.55.0

