Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A36EC148
	for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2024 16:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726849176; cv=none; b=BKawANMCHg5EQuc3zUKIctTGBAPqrh3UgMYqFFpDGfg3phtQUQ7hF7ehOGV8iAG3XkeeNt3lJi7zZf11SrfIO12Zq3z/vi/vIQ8ZxevIdutpV7n+14dathjHn6NlS+qPdnWMNj8f+PqDXbGbJ07YZGanTj5juNKmO/y4E/mxEgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726849176; c=relaxed/simple;
	bh=kef3zT7zA5Sb/jdI6QhCzGNKRTZ9Zztp3nqADwKmfTY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bqO8pZFkFyN8ip4StvZt4UiRM6BG1bfM9UBCulXq4HZM63E6yAteJHFIYsUs5jRZBCVCCYKQTI9ZqX/g5Zo2apk2mbIZyqDhT3a8UYeQ1iLrnDrNU4GH1xnRrwU4xyM1q/IzhAxQKmAImRgRttZIGkbMb5+CpkIFdC5lBi30G9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mEk74HAb; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mEk74HAb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726849171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mDHiNJW1e1lo/6JqQbD9CPJBSHW79YCrBgJWEbc4OgM=;
	b=mEk74HAbA6ZlmEKMhiaCiXfDNlFNacggRDZ5fs2Al0vLPMv3/4osCUEPYNXg0hls9kxQgv
	LhOZ9jFIffkYPRejts7zFmKZGNkPYPDLYBZ9DQONYVGdMdK0s+WVUqGd2BH62jVWAdaC/Z
	lhBjrJOTj4bL8WUk7sW93mRhKFZBA80=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: satishkh@cisco.com,
	sebaddel@cisco.com,
	kartilak@cisco.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH] scsi: fnic: Use vzalloc() instead of vmalloc() and memset(0)
Date: Fri, 20 Sep 2024 18:13:10 +0200
Message-ID: <20240920161308.143992-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use vzalloc() instead of vmalloc() followed by memset(0) to simplify the
functions fnic_trace_buf_init() and fnic_fc_trace_init().

Compile-tested only.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/fnic/fnic_trace.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index aaa4ea02fb7c..06fcd4d45415 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -485,7 +485,7 @@ int fnic_trace_buf_init(void)
 	}
 
 	fnic_trace_entries.page_offset =
-		vmalloc(array_size(fnic_max_trace_entries,
+		vzalloc(array_size(fnic_max_trace_entries,
 				   sizeof(unsigned long)));
 	if (!fnic_trace_entries.page_offset) {
 		printk(KERN_ERR PFX "Failed to allocate memory for"
@@ -497,8 +497,6 @@ int fnic_trace_buf_init(void)
 		err = -ENOMEM;
 		goto err_fnic_trace_buf_init;
 	}
-	memset((void *)fnic_trace_entries.page_offset, 0,
-		  (fnic_max_trace_entries * sizeof(unsigned long)));
 	fnic_trace_entries.wr_idx = fnic_trace_entries.rd_idx = 0;
 	fnic_buf_head = fnic_trace_buf_p;
 
@@ -559,7 +557,7 @@ int fnic_fc_trace_init(void)
 	fc_trace_max_entries = (fnic_fc_trace_max_pages * PAGE_SIZE)/
 				FC_TRC_SIZE_BYTES;
 	fnic_fc_ctlr_trace_buf_p =
-		(unsigned long)vmalloc(array_size(PAGE_SIZE,
+		(unsigned long)vzalloc(array_size(PAGE_SIZE,
 						  fnic_fc_trace_max_pages));
 	if (!fnic_fc_ctlr_trace_buf_p) {
 		pr_err("fnic: Failed to allocate memory for "
@@ -568,12 +566,9 @@ int fnic_fc_trace_init(void)
 		goto err_fnic_fc_ctlr_trace_buf_init;
 	}
 
-	memset((void *)fnic_fc_ctlr_trace_buf_p, 0,
-			fnic_fc_trace_max_pages * PAGE_SIZE);
-
 	/* Allocate memory for page offset */
 	fc_trace_entries.page_offset =
-		vmalloc(array_size(fc_trace_max_entries,
+		vzalloc(array_size(fc_trace_max_entries,
 				   sizeof(unsigned long)));
 	if (!fc_trace_entries.page_offset) {
 		pr_err("fnic:Failed to allocate memory for page_offset\n");
@@ -585,8 +580,6 @@ int fnic_fc_trace_init(void)
 		err = -ENOMEM;
 		goto err_fnic_fc_ctlr_trace_buf_init;
 	}
-	memset((void *)fc_trace_entries.page_offset, 0,
-	       (fc_trace_max_entries * sizeof(unsigned long)));
 
 	fc_trace_entries.rd_idx = fc_trace_entries.wr_idx = 0;
 	fc_trace_buf_head = fnic_fc_ctlr_trace_buf_p;
-- 
2.46.1

