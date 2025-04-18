Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C48426AA93;
	Fri, 18 Apr 2025 07:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744962969; cv=none; b=p9zaeCk1GcdDbWteqJ09t8kQf9kDeSuLyiu66rSccsDg4frarXACdbXsDELexvoezReERwSlIbxyPyBcW77RwfrlmEa3XjArLu4aSlbPNDrsBShO0AdFUkM+AV8x5WGe16yuatvXxF0JJDAemseYlH05PjkThSq65ah+1M71XfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744962969; c=relaxed/simple;
	bh=G6q4Hp+wvfNJ64ikYUG8gWnNsxL66dJDVyKDX0EVSLI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ne71uUDfYgG7Z9Vp3LS22XBK707CPFkiARkm2zEfIY00RHLiSxRWZm3T7wXLUXqvPSy6YbpPtMtqQt8RXzFd3Qh6XjuPlH40HwCgvik/jhIHw9wgc2Koe7uMPrhPaw+NMhuADkJEVx5bexfArfH4fwEpz1Hi1Sl2IAHTM+nRe9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gzp7/2OW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gzp7/2OW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7A0C4CEE2;
	Fri, 18 Apr 2025 07:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744962969;
	bh=G6q4Hp+wvfNJ64ikYUG8gWnNsxL66dJDVyKDX0EVSLI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Gzp7/2OWBY3RA4D0XxezJZ0epxxfAs/Qvme9CSrl3ZkzK6tJBYMChvgc02qjzi81D
	 T+zMmEm7pz877TBBNleAQyNzDihc5nC2GcP/azjt1CpxM31EYP5BB4JgSvG/JOXCOY
	 rqal5TU1c+6dP5QfoQZgclEb7KbLQQH1WEAfn0zWIDn+geKrehq/AdrCLT7lLkwYmH
	 9uP6Es03E5SK+k2E0lOo4i1ZPNZlFDCtpgOQF9WzC8bxmYNTElOFfhqgYbHBiF2CVC
	 k2SBOjvkD/miXUuvuaTv6CVWizSqxpeS5jz0yqUNlmRNaf8z+qTjWJ36HStcRmdNX6
	 DBSPzENnTAu1A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 3/5] ata: libata-scsi: Fix ata_msense_control_ata_feature()
Date: Fri, 18 Apr 2025 16:55:15 +0900
Message-ID: <20250418075517.369098-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250418075517.369098-1-dlemoal@kernel.org>
References: <20250418075517.369098-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the ATA features subpage of the control mode page, the T10 SAT-6
specifications state that:

For a MODE SENSE command, the SATL shall return the CDL_CTRL field value
that was last set by an application client.

However, the function ata_msense_control_ata_feature() always sets the
CDL_CTRL field to the 0x02 value to indicate support for the CDL T2A and
T2B pages. This is thus incorrect and the value 0x02 must be reported
only after the user enables the CDL feature, which is indicated with the
ATA_DFLAG_CDL_ENABLED device flag. When this flag is not set, the
CDL_CTRL field of the ATA feature subpage of the control mode page must
report a value of 0x00.

Fix ata_msense_control_ata_feature() to report the correct values for
the CDL_CTRL field, according to the enable/disable state of the device
CDL feature.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/ata/libata-scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 15661b05cb48..f54e8a3dc46d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2453,8 +2453,8 @@ static unsigned int ata_msense_control_ata_feature(struct ata_device *dev,
 	 */
 	put_unaligned_be16(ATA_FEATURE_SUB_MPAGE_LEN - 4, &buf[2]);
 
-	if (dev->flags & ATA_DFLAG_CDL)
-		buf[4] = 0x02; /* Support T2A and T2B pages */
+	if (dev->flags & ATA_DFLAG_CDL_ENABLED)
+		buf[4] = 0x02; /* T2A and T2B pages enabled */
 	else
 		buf[4] = 0;
 
-- 
2.49.0

