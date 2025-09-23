Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2D527A919
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2025 17:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758647716; cv=none; b=t8na4Zjxniq7t1QCZVODPl1kcrI8eWgXc4KcTjvoRx80Pcktr8EBnwUSWNgCU8BksfmCU3aKThSTt9u0w7vHN/pd7CixyfBKL7RYdBOdQvBOG78XbHVe1ioOG6RdV2kY/P+Apoat8iW9wch5ikOzUPjz/JqkB5+M1qu88B5IM2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758647716; c=relaxed/simple;
	bh=/4ecEdJ+qGjfmy9yImHlAlNmO8QiCe+KsB7GVqxPqmk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fEIWAiTxrgCS6Q0SA/mylX732CZBVfkCruj+SNX+cjBC3MInUTG/AlGztLpaceuFR+HGuBpk+bzFNMNrYNkN/liSJN6KqIvaLLKfV3iQpeiLI1HUNQtxMg8IN4nM6t8fz4RRsvjNFRE1QgZ5BxXJBYm0rA6tuAfX8Z5nX7dx7js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y2D6VEKk; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y2D6VEKk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758647712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GN4o6Rpepn1nYUO5av96IxMhD2q/WJpyOYfgvLYpNxI=;
	b=Y2D6VEKkYuZLHVEfhlP3Xh2YdeFXpFs13yvbTfGNd3j+OwROnT94F/tbswBH3lhv7bb2T6
	xT+PDgZ8UhdX5AaLPxoixST3OQJmsMhnG/8iLFg3ZOB7Tk1HqKo86nwNHyCU78W9QUdyVA
	u4S1JQTmeOQyhSgDPkF7sKSfLnen1d8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scsi: hpsa: Replace kmalloc + copy_from_user with memdup_user
Date: Tue, 23 Sep 2025 19:15:04 +0200
Message-ID: <20250923171505.1847356-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace kmalloc() followed by copy_from_user() with memdup_user() to
improve and simplify hpsa_passthru_ioctl().

Since memdup_user() already allocates memory, use kzalloc() in the else
branch instead of manually zeroing 'buff' using memset(0).

Return early if an error occurs and remove the 'out_kfree' label.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/hpsa.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c73a71ac3c29..55448238d8ed 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6407,18 +6407,14 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h,
 		return -EINVAL;
 	}
 	if (iocommand->buf_size > 0) {
-		buff = kmalloc(iocommand->buf_size, GFP_KERNEL);
-		if (buff == NULL)
-			return -ENOMEM;
 		if (iocommand->Request.Type.Direction & XFER_WRITE) {
-			/* Copy the data into the buffer we created */
-			if (copy_from_user(buff, iocommand->buf,
-				iocommand->buf_size)) {
-				rc = -EFAULT;
-				goto out_kfree;
-			}
+			buff = memdup_user(iocommand->buf, iocommand->buf_size);
+			if (IS_ERR(buff))
+				return PTR_ERR(buff);
 		} else {
-			memset(buff, 0, iocommand->buf_size);
+			buff = kzalloc(iocommand->buf_size, GFP_KERNEL);
+			if (!buff)
+				return -ENOMEM;
 		}
 	}
 	c = cmd_alloc(h);
@@ -6478,7 +6474,6 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h,
 	}
 out:
 	cmd_free(h, c);
-out_kfree:
 	kfree(buff);
 	return rc;
 }
-- 
2.51.0

