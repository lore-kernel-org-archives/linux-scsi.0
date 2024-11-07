Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4401EF923
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 10:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730976232; cv=none; b=Es0JfHyRjaYppTs4SBNJVb8n9w8Xz0OmKS1kFcTzdGnTVoAt2Ua5ZQuzrc93GcAEmpYGouNz2zbvBvj3ETYakRsTCJL1mc7DIoy2HD8+GXtAIU6FBTYp1H8HFTDGjgt3dhYPWPEbMmzvkzMK6ZSSbHSTjrixuE1fv81IXGtzsxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730976232; c=relaxed/simple;
	bh=089FIH+q/iK6fZuPXSbvfkLNzsXJOfDvSzeXDonC9GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oVXiRCWcIo5LsTVxExlBl94PoDCeG/NrXUUnmTuZsyWJD64np27bhOWzRupFGpMXKcFkrI0HvyvSVGXT63tCRktZBLBHfhpLMkAyyyxrCzTIpO0KbxBTF/ha0dPOjMMYli1CkkL7/fyHpfOtwE2FECLxnyc3qyzcWS+ph9lgT70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D9JtShIv; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D9JtShIv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730976227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vJrN5WQBoFc1qT+O7w7iQFTbxpNp9tNvO7YGMzJN5JU=;
	b=D9JtShIvULaFzc3IrxuhrDo4OjExdmb9xvICA8dxJ/nI9PWouBwHcyS/x0n+2P8sR+cE12
	ldZLxoZ4YQDFIf8FJ260ti6tdqjfbMzVsKe836i8/QLPO5yXL4XFp/H0aECH5WeGLjHQwN
	kdDnjUC1nQCyk60O2wTz4W9gUaxwHMk=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v3] scsi: fnic: Use vcalloc() instead of vmalloc() and memset(0)
Date: Thu,  7 Nov 2024 11:42:59 +0100
Message-ID: <20241107104300.1252-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use vcalloc() instead of vmalloc() followed by memset(0) to simplify the
functions fnic_trace_buf_init() and fnic_fc_trace_init().

Compile-tested only.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Remove unsigned long cast as suggested by Johannes Thumshirn
- Link to v1: https://lore.kernel.org/r/20241007115840.2239-6-thorsten.blum@linux.dev/

Changes in v3:
- Keep the unsigned long cast removed in v2
- Use vcalloc() instead of vzalloc() as suggested by Johannes Thumshirn
- Compile-tested again
- Link to v2: https://lore.kernel.org/r/20241008095152.1831-2-thorsten.blum@linux.dev/
---
 drivers/scsi/fnic/fnic_trace.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index aaa4ea02fb7c..e5e0c0492f23 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -485,8 +485,7 @@ int fnic_trace_buf_init(void)
 	}
 
 	fnic_trace_entries.page_offset =
-		vmalloc(array_size(fnic_max_trace_entries,
-				   sizeof(unsigned long)));
+		vcalloc(fnic_max_trace_entries, sizeof(unsigned long));
 	if (!fnic_trace_entries.page_offset) {
 		printk(KERN_ERR PFX "Failed to allocate memory for"
 				  " page_offset\n");
@@ -497,8 +496,6 @@ int fnic_trace_buf_init(void)
 		err = -ENOMEM;
 		goto err_fnic_trace_buf_init;
 	}
-	memset((void *)fnic_trace_entries.page_offset, 0,
-		  (fnic_max_trace_entries * sizeof(unsigned long)));
 	fnic_trace_entries.wr_idx = fnic_trace_entries.rd_idx = 0;
 	fnic_buf_head = fnic_trace_buf_p;
 
@@ -559,8 +556,7 @@ int fnic_fc_trace_init(void)
 	fc_trace_max_entries = (fnic_fc_trace_max_pages * PAGE_SIZE)/
 				FC_TRC_SIZE_BYTES;
 	fnic_fc_ctlr_trace_buf_p =
-		(unsigned long)vmalloc(array_size(PAGE_SIZE,
-						  fnic_fc_trace_max_pages));
+		(unsigned long)vcalloc(fnic_fc_trace_max_pages, PAGE_SIZE);
 	if (!fnic_fc_ctlr_trace_buf_p) {
 		pr_err("fnic: Failed to allocate memory for "
 		       "FC Control Trace Buf\n");
@@ -568,13 +564,9 @@ int fnic_fc_trace_init(void)
 		goto err_fnic_fc_ctlr_trace_buf_init;
 	}
 
-	memset((void *)fnic_fc_ctlr_trace_buf_p, 0,
-			fnic_fc_trace_max_pages * PAGE_SIZE);
-
 	/* Allocate memory for page offset */
 	fc_trace_entries.page_offset =
-		vmalloc(array_size(fc_trace_max_entries,
-				   sizeof(unsigned long)));
+		vcalloc(fc_trace_max_entries, sizeof(unsigned long));
 	if (!fc_trace_entries.page_offset) {
 		pr_err("fnic:Failed to allocate memory for page_offset\n");
 		if (fnic_fc_ctlr_trace_buf_p) {
@@ -585,8 +577,6 @@ int fnic_fc_trace_init(void)
 		err = -ENOMEM;
 		goto err_fnic_fc_ctlr_trace_buf_init;
 	}
-	memset((void *)fc_trace_entries.page_offset, 0,
-	       (fc_trace_max_entries * sizeof(unsigned long)));
 
 	fc_trace_entries.rd_idx = fc_trace_entries.wr_idx = 0;
 	fc_trace_buf_head = fnic_fc_ctlr_trace_buf_p;
-- 
2.47.0

