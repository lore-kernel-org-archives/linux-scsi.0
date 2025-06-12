Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0E153598
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 06:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749708239; cv=none; b=YSldp6V4Ctbfp5B29PEmdWPVaPlzJunUw36TRuSdPV+X8/T7Q+yttd+tKEwfVmm2H3CZHw74EKVcw3/sBBruyAUAoHQ2P7YGw9hCb9Bs1f8qRNso4Fum1/rZXT61Kn1ukwbtZ9ZWkcro+yvoQCF4TAgBa//GwOEXNqhRg7g0Og0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749708239; c=relaxed/simple;
	bh=Qkk9fJUpwJdHjR+9Wipu+d2XRSMaJTKkFESl97m/QX8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVgXMEtX2y+y7hbckx/Xm3EzOxMdbh/g8t2cs/p+6kJGAQChm6EA1jqbPwyt4yrqPX0CW9w9koV5qRklNLJqzD37LKx1Pv4TXlERMRXG3iYYB1I6Mw9hb70iy19CPzbmgI4SkivDsi7WbGY+r2841nl+o4LGnuiREgcSxJNsK4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRTstZNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRTstZNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44860C4CEEB;
	Thu, 12 Jun 2025 06:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749708238;
	bh=Qkk9fJUpwJdHjR+9Wipu+d2XRSMaJTKkFESl97m/QX8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FRTstZNS1+cjzJlNWRMBTe1nbNHiUocNUOB7igeVkqJ+6BJR+lLhVpub1nL66E4z1
	 KirinuY/3G3cL6MErDDM6r0+xCAZL7oBcS3/uk2vLLJyjesqKtEtXyYe6eix5cPJmy
	 nR4f9uFu7FF5Nodix4FGkBRYFpbXsEE20dc8IQnBOipv9sUzmSTTHeNnPPPNnmXdV9
	 0kqvlmEbcf/o0S4i78frCvCEo7o1HQJjPUHOk5v5SzWCeQaoJ+yY96YT9OKQPT8Hh0
	 HdsmOeWqsPhQ5fDcma+n2VU4Ij8nE+MT0MEeGOb0piLONGxedmkFQBdVHrbGP8KbHZ
	 rJzGUZJSqehyg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v3 1/2] scsi: sd: Prevent logical_to_bytes() from returning overflowed values
Date: Thu, 12 Jun 2025 15:02:10 +0900
Message-ID: <20250612060211.1970933-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612060211.1970933-1-dlemoal@kernel.org>
References: <20250612060211.1970933-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure that logical_to_bytes() does not return an overflowed value
by changing its return type from unsigned int (32-bits) to size_t
(64-bits).

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 36382eca941c..3803eb8cb532 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -213,7 +213,7 @@ static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blo
 	return blocks << (ilog2(sdev->sector_size) - 9);
 }
 
-static inline unsigned int logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
+static inline size_t logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
 {
 	return blocks * sdev->sector_size;
 }
-- 
2.49.0

