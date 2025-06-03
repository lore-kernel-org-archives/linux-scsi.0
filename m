Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DB22AD02;
	Tue,  3 Jun 2025 10:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945169; cv=none; b=hvJJ5Sd3wjNHY1eDgTiJA94BUEC+Ezk+8IDs9Iy6eASTXmwsXoCP4J7zf4BT4FZzaKV1X+FrWk8/Q/Awx515RPPm74Pjcnq2m4ngU5on/pAvupT+Aia5dxuw3X0CctQ+M9DpIQ0pNYrYx95ffqQJuIUV71KMDfCK9aYkVOqRi7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945169; c=relaxed/simple;
	bh=Fxuz0OajvxuzpLg2IerPHvE8qh8nzI9KPaajqSoERQQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QUJlnBfRGj0uUT/yaBpJdmmLQOO9+QtwBBlHkN4Kc+8m8QaiF3wrfh0JsG9Os2YSUmFarqFUHcxzDHZArEciD7XVM8T7gKfhcEk3kX35yYSNOgMVcInkBO8zaNRITxJAJbADKxToRCrQg04VFeUSwaIZlyRDKBsoUW6LelxHMtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ouz+gu00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ouz+gu00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8240FC4CEEF;
	Tue,  3 Jun 2025 10:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748945169;
	bh=Fxuz0OajvxuzpLg2IerPHvE8qh8nzI9KPaajqSoERQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ouz+gu00j8EmYRCoB0wZRLuGqX4oFCm905Z7iNNKKWmfl1DxwXILvyZaTK36BEVqc
	 8bDawuKsPyL8RappnT2sR/h+p1qHhxlVe9CqjdarmfiVbE9hqXhXx3jy+mTqCtO4Ga
	 AajBJ3BaV/6wwn2BaX+GoRylij/SO7VHu+XlPRBv0tHql+LXP8bf7Fd5Nmf7ZzWIN+
	 jw5suWauAHLA7094p/C+bZ2ESGvf/Ol3EFk8qkXgD9frOE/TQTOuqmEtsApPIno+uH
	 r7pN1tdvzFP2gZzTIs5xP7/JF1Mq0k78wXqpukoq3TzfQUYASY/bTz3KeIX52eOsN9
	 lvLRwOYcU0C6A==
From: Hannes Reinecke <hare@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 3/3] scsi: return PR generation if no reservation is held
Date: Tue,  3 Jun 2025 12:04:16 +0200
Message-Id: <20250603100416.131490-4-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20250603100416.131490-1-hare@kernel.org>
References: <20250603100416.131490-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For READ RESERVATION the PRgeneration value is always present, even
if no reservations are held.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/sd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 950d8c9fb884..daa61feaf441 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2008,9 +2008,13 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 	if (result)
 		return result;
 
+	rsv->generation = get_unaligned_be32(&data[0]);
+	rsv->type = 0;
 	len = get_unaligned_be32(&data[4]);
-	if (!len)
+	if (!len) {
+		rsv->key = 0;
 		return 0;
+	}
 
 	/* Make sure we have at least the key and type */
 	if (len < 14) {
@@ -2020,9 +2024,9 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 		return -EINVAL;
 	}
 
-	rsv->generation = get_unaligned_be32(&data[0]);
 	rsv->key = get_unaligned_be64(&data[8]);
-	rsv->type = scsi_pr_type_to_block(data[21] & 0x0f);
+	if (len == 16)
+		rsv->type = scsi_pr_type_to_block(data[21] & 0x0f);
 	return 0;
 }
 
-- 
2.35.3

