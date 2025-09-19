Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9862F291B
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 09:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758274017; cv=none; b=gEHEFX1QYzJEbICegAEprqA1WGInEudDRPiLu7mtXecfrs2KAzsa2SScAHST4nKq/MLc/LwvkkP/Ed8Bmce/IsPtwtwHI6lrrhKoB4Wf4UTuDSQpQj5ODeMDRmvDAGI1biSSS3Ad7T4xLI4FJj3ywGXyGYQsc5eXT+RV81ubjHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758274017; c=relaxed/simple;
	bh=dKCx85s/6PwtEqwRZtinMLXnxG+yVQJWnrxtNuzd434=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=emNypHP3Bd4WQBMaDokTl8mDUSWUVDXBQAzM0C7WIgFS1zDv+21o2Pi1lkcMqaYSDMcyvk616FV3DyLbVCcOzEwQO/eXhIGR7yDTHdFeixD8PQ1qzWZgfZ629nVf692HEz9tMRxkzLNNYdIyTt8eD0ygV50Jp5IPAFWQgO7qohM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y1BKNLPF; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y1BKNLPF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758274003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lHA5A5Q3mB9GbMIkMKtbrVhd8m+plyRqseHgs1TRbeY=;
	b=Y1BKNLPF8QBUOjfsyh8CesFs2DtdZ4NcSYe4o46wSglwMTeH6OYmrpmRTbJzfhbDyj17a4
	REyo+KMhfE7FJjpOHi3vrGyh+UpI3frvlLhri+4enDMz4FIPviMOS5Yw71DboNfksh1Q6f
	miPC5vWjez+XGDlpmBE5zijqtec6zLY=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Miller <mikem@beardog.cce.hp.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Chiang <achiang@hp.com>,
	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scsi: hpsa: Fix potential memory leak in hpsa_big_passthru_ioctl()
Date: Fri, 19 Sep 2025 11:26:37 +0200
Message-ID: <20250919092637.721325-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace kmalloc() followed by copy_from_user() with memdup_user() to fix
a memory leak that occurs when copy_from_user(buff[sg_used],,) fails and
the 'cleanup1:' path does not free the memory for 'buff[sg_used]'. Using
memdup_user() avoids this by freeing the memory internally.

Since memdup_user() already allocates memory, use kzalloc() in the else
branch instead of manually zeroing 'buff[sg_used]' using memset(0).

Cc: stable@vger.kernel.org
Fixes: edd163687ea5 ("[SCSI] hpsa: add driver for HP Smart Array controllers.")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/hpsa.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c73a71ac3c29..1c6161d0b85c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6522,18 +6522,21 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h,
 	while (left) {
 		sz = (left > ioc->malloc_size) ? ioc->malloc_size : left;
 		buff_size[sg_used] = sz;
-		buff[sg_used] = kmalloc(sz, GFP_KERNEL);
-		if (buff[sg_used] == NULL) {
-			status = -ENOMEM;
-			goto cleanup1;
-		}
+
 		if (ioc->Request.Type.Direction & XFER_WRITE) {
-			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
-				status = -EFAULT;
+			buff[sg_used] = memdup_user(data_ptr, sz);
+			if (IS_ERR(buff[sg_used])) {
+				status = PTR_ERR(buff[sg_used]);
 				goto cleanup1;
 			}
-		} else
-			memset(buff[sg_used], 0, sz);
+		} else {
+			buff[sg_used] = kzalloc(sz, GFP_KERNEL);
+			if (!buff[sg_used]) {
+				status = -ENOMEM;
+				goto cleanup1;
+			}
+		}
+
 		left -= sz;
 		data_ptr += sz;
 		sg_used++;
-- 
2.51.0

