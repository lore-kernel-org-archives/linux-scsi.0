Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE71257459
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 06:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749796257; cv=none; b=O9KeVLRadaP+LOup1iVQA13xMgu7B7Ir5YLRqoQsjW+ziNdNfLhg9lZY5Ch7ZreoMVri7sbpDSPtJu3kljJpHH6XSTGmJfTHDLkQ7DNio9Z+NECRJlUjxRDbVd5WyaWt36uQwadTfXJ0bMMvPWo6DfAVmb2R120J/2c9kvxwT5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749796257; c=relaxed/simple;
	bh=+jKzSFzHNmDNXJuLUbvPWR/o/wthXuUOq4Ag/k9KVbs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3FQKPwqKnAuZof/QqegtU8GlNx5RW+GGTnVFkILev7jkJusrBirn6S9HS1DRRnyk2D4Qvjnw+blehnOfs2XPPcgXY/PvSBVELEYMNQLYy2ccaTWsQSJ/z4bQgkij+iw3xiIKEHWGOtptWR2A3m602U6+fz0kltktIzrweSMyeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxfmxxtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxfmxxtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7BCC4CEED;
	Fri, 13 Jun 2025 06:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749796256;
	bh=+jKzSFzHNmDNXJuLUbvPWR/o/wthXuUOq4Ag/k9KVbs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AxfmxxtKusLK99ZhTv2h2XDNenR7qZukCIZA4XT5ZLyRham89gnjjhRqcYrse1tjV
	 /ayuZ+pylvQWg8NVH9ru/mQQYELi/Jr2rNycKRTbQDmrdepAsjS4ervbwtr00+AbmI
	 ci8iAnLC+8Y7vbi2y8VMz9N+Z5zSzOZCpue44ub863HtAFL95CvHAEhCCoeOPlL7ym
	 YQyp/nCqHs3EeacfOTjj9ee0YfzlFFruVm9t1dONowXGrEJZSV8nehv6NNafv21iEw
	 3acoDG5kvpnY3lH/lBDzrFozu+TIUxq/vErkIw1ctcLFrS/fo/NH6CrDLPu3LQo6F8
	 7e94wVUfjQoxg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v4 1/2] scsi: sd: Prevent logical_to_bytes() from returning overflowed values
Date: Fri, 13 Jun 2025 15:29:08 +0900
Message-ID: <20250613062909.2505759-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613062909.2505759-1-dlemoal@kernel.org>
References: <20250613062909.2505759-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure that logical_to_bytes() does not return an overflowed value
by changing its return type from unsigned int (32-bits) to u64
(64-bits). And while at it, also use a bit-shift instead of a
multiplication, similar to logical_to_sectors() and bytes_to_logical().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 36382eca941c..53658679e063 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -213,9 +213,9 @@ static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blo
 	return blocks << (ilog2(sdev->sector_size) - 9);
 }
 
-static inline unsigned int logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
+static inline u64 logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
 {
-	return blocks * sdev->sector_size;
+	return (u64)blocks << ilog2(sdev->sector_size);
 }
 
 static inline sector_t bytes_to_logical(struct scsi_device *sdev, unsigned int bytes)
-- 
2.49.0

