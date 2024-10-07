Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A661D2B03
	for <linux-scsi@vger.kernel.org>; Mon,  7 Oct 2024 12:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728302490; cv=none; b=cD454kbOGo8UY78AiDNoLZeuvr1+uzgB8UcZycrgSjYpzFyutTqoIhQSr1KgLrKtZ/RrkSZoV0FXQgBFUwsQCisCzblflkYxW2gqiue41sTRKVSedPI7L2hpbvNJY0PcMh53y8+BviNp2f0JiOKsKoZUbvx7R/CpU97EIfULBSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728302490; c=relaxed/simple;
	bh=+nrchSnda+tewARAeBp+e+62j0pRo6BPJQZGj4VGHxI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dT0c9vNBHmHf0sC9IOf0NQSy+Cdo1T9WweKgCJjJe5aRE+UrzQ5LEV7PaMjR43WnJkYPHvq3yKCsGJb1PqC9uxs+IF2fK2o6OMyYmDajYwcuLqJV4WfcCKEb8DmqigXIJpe4w2xWR78M4OV0NjwdkcIfGN83zQAbtI912LIwAZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ChZHRuEW; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ChZHRuEW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728302486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C/duGT/1qYBpA4YmUlEsjP4bzlbLx1ZiXrnJ50OERHU=;
	b=ChZHRuEWs0Bn0d+ueXJKxMewbDl99g+kMOjEOorRrFK9DhEg5QMJV/134zqJfIlNlK2bq1
	X1OMJhE3uy9VSSq6VpDaCaHV10xgWJqVQ11lZh6RwOX18aIgrDeRJPPzGHbZOhrlHf9Spo
	Jx9PfyCT1cChdw9we4exjmjkF7zLb24=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] scsi: fnic: Use vzalloc() instead of vmalloc() and memset(0)
Date: Mon,  7 Oct 2024 13:58:45 +0200
Message-ID: <20241007115840.2239-6-thorsten.blum@linux.dev>
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
2.46.2

