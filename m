Received: from mail-m15574.qiye.163.com (mail-m15574.qiye.163.com [101.71.155.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634F414A4F0
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2025 02:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764122927; cv=none; b=dxafPVsQbTJGkUvb8VifykuwUFhkGheLdEtuOZMsaePlXjCNCC/m4IdMj6GfffYvVzwtzK6MuoM+tVGrBp8IYKiyNbzXxKGurCpvnGahci4FQmaaOq+N48pEna319AF+QiyJvHRvT8SEw8NLdYbj9gVSYDJsdQTC+0y/2Fx9CUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764122927; c=relaxed/simple;
	bh=NcEQJ23oN8zc5WHPpCdoZrBsdam7SH3uG6/ERj5cMXc=;
	h=From:To:Cc:Subject:Date:Message-Id; b=iMX7j2L455zu0uUx7+8mzu5s6s/reEuqsUBynJ1UiF2OEVb2k8YPm7c+sS9ZxOamE6axD2oVY+qhRPKSfw6GxoWS+JNdRmKudOVKnTbE/jqamapibREggl22dn/OPP2HuaoTUDYMXAO4IoaNHoBCzQtI4VJCSk8/T7LfczDC+aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=E/uYZ+CJ; arc=none smtp.client-ip=101.71.155.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="E/uYZ+CJ"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2ae7332c5;
	Wed, 26 Nov 2025 10:08:33 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH] scsi: ufs: core: Remove the alignment check in ufshcd_memory_alloc()
Date: Wed, 26 Nov 2025 10:08:20 +0800
Message-Id: <1764122900-30868-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Tid: 0a9abdeb69b909cckunm6e41bacf4f200c
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGhlIQlYdQh1OS01KTh8eQhlWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=E/uYZ+CJfC4FDUIdtE0zkgOj/4Z0eH2LNWPgydA/l9DP+NwQyw57oBzaycRwd9aqowgiJp06vNepor6CSdEso9qCJNSj96qsz2TecJcNkoyiFDyvyv9KCG/4KDmjPEPoCvSjTW5oT37OOWVhkBW+KV422KECzJuc0TNgBb793Gc=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=fIoXqUNzfuKVQ3x0Hd4iICa2DRJGCGE28VopFMFojEQ=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The dmam_alloc_coherent() function guarantees page-aligned memory on
successful allocation. The current alignment checks using WARN_ON() for
buffers smaller than PAGE_SIZE are therefore redundant and can be safely
removed to simplify the code.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---
 drivers/ufs/core/ufshcd.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8f68e305e83c..89737f0c299c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3916,18 +3916,16 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 {
 	size_t utmrdl_size, utrdl_size, ucdl_size;
 
-	/* Allocate memory for UTP command descriptors */
+	/*
+	 * Allocate memory for UTP command descriptors
+	 * UFSHCI requires 128 byte alignment of UCDL
+	 */
 	ucdl_size = ufshcd_get_ucd_size(hba) * hba->nutrs;
 	hba->ucdl_base_addr = dmam_alloc_coherent(hba->dev,
 						  ucdl_size,
 						  &hba->ucdl_dma_addr,
 						  GFP_KERNEL);
-
-	/*
-	 * UFSHCI requires UTP command descriptor to be 128 byte aligned.
-	 */
-	if (!hba->ucdl_base_addr ||
-	    WARN_ON(hba->ucdl_dma_addr & (128 - 1))) {
+	if (!hba->ucdl_base_addr) {
 		dev_err(hba->dev,
 			"Command Descriptor Memory allocation failed\n");
 		goto out;
@@ -3942,8 +3940,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 						   utrdl_size,
 						   &hba->utrdl_dma_addr,
 						   GFP_KERNEL);
-	if (!hba->utrdl_base_addr ||
-	    WARN_ON(hba->utrdl_dma_addr & (SZ_1K - 1))) {
+	if (!hba->utrdl_base_addr) {
 		dev_err(hba->dev,
 			"Transfer Descriptor Memory allocation failed\n");
 		goto out;
@@ -3966,8 +3963,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 						    utmrdl_size,
 						    &hba->utmrdl_dma_addr,
 						    GFP_KERNEL);
-	if (!hba->utmrdl_base_addr ||
-	    WARN_ON(hba->utmrdl_dma_addr & (SZ_1K - 1))) {
+	if (!hba->utmrdl_base_addr) {
 		dev_err(hba->dev,
 		"Task Management Descriptor Memory allocation failed\n");
 		goto out;
-- 
2.43.0

