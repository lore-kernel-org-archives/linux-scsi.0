Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD31202C50
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 22:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739399034; cv=none; b=g59SMASPWjiyQj7W8m9ArbddT56BIfAxf2lLhpGidLdGTH7IVJydcHlpWfXlCZ5n63M+jTYqJ2r7/jdZb4gwY/BlDP73Z3nRiA9gYaTZ59Vk91uStv7vK4tR2I2yg7/UixbqkwoD+y1y3QWsz7SKCN/Yl9WzuVyjT9RmCXtcZDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739399034; c=relaxed/simple;
	bh=1jeWaSLD5tHtzDUpc0Naqe9/RXjJP7H4xKkVzPVgMks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tMqXyYGh0fHjeQKkqiFvlYn1vfTOr1mTQy881xCGv6DFqOCHv9YhNZtDVgHgC6pXxdPiejbVH0zVXOPnBuJm9OynfGCFGz/pprTQY6DGatRvqHf7w9BiqGDTSUTmCF/UuV/gaZQsaBmYx1oTCjK+/CEGyw3X4qD3VtQy8iNyF90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e83HsoxU; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e83HsoxU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739399030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cspwxC9nVN+grYvnsk1+x8gpGvhnB9zjEEBy7u03DWo=;
	b=e83HsoxU2P5tv3o1FnLX+D56W4CzaWbBgE89Mgr8mmcbe3Qrp/UFtjnb29kzyxkHatq19L
	zd65jM9ysG8ZE4N5mxcDBWEkJ7DveMpGKkiNcyavyPEuOr5R9ToMFmrBufDwB9iQTPFlzx
	ycHJ2lWphXLd20ulTvVG7opP/qOQESA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-hardening@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: hpsa: Replace deprecated strncpy() with strscpy()
Date: Wed, 12 Feb 2025 23:22:15 +0100
Message-ID: <20250212222214.86110-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strncpy() is deprecated for NUL-terminated destination buffers [1]. Use
strscpy() instead and remove the manual NUL-termination.

Use min() to simplify the size calculation.

Compile-tested only.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Suggested-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hpsa.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 84d8de07b7ae..9399e101f150 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -460,9 +460,8 @@ static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
-	strncpy(tmpbuf, buf, len);
-	tmpbuf[len] = '\0';
+	len = min(count, sizeof(tmpbuf) - 1);
+	strscpy(tmpbuf, buf, len);
 	if (sscanf(tmpbuf, "%d", &status) != 1)
 		return -EINVAL;
 	h = shost_to_hba(shost);
@@ -484,9 +483,8 @@ static ssize_t host_store_raid_offload_debug(struct device *dev,
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
-	strncpy(tmpbuf, buf, len);
-	tmpbuf[len] = '\0';
+	len = min(count, sizeof(tmpbuf) - 1);
+	strscpy(tmpbuf, buf, len);
 	if (sscanf(tmpbuf, "%d", &debug_level) != 1)
 		return -EINVAL;
 	if (debug_level < 0)
-- 
2.48.1

