Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7896D4C8E;
	Sun, 19 May 2024 08:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716105971; cv=none; b=pqch8FohxpqOzv+erkG2wHCGUoj+MJfWq890EjhsIezfpXiT6RwEymL9Zc93R/UVlaKkBWBK8BbTpKTlkqfbVFUogpy7l7fqY0PzkXGwtT+YDh12rOw44kHauPO6DQ4eAunizxiu2jB5l94fwue3Sk1LtpoBTB6wqLhYM8FuEp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716105971; c=relaxed/simple;
	bh=PBVa6gwyfI7ikzqB0Jg4jElxnuzleVFC8ZWnH20UwdA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jpc7EKiDkG/x4SoHbAzn99vNk18Cpf6m1l+Ld+fbne3fhdmH3wHmdeXUqcqdbFnGxkxWvV389Wt42XtcN/bVwv3I3WPVrVHd69DWnM2D6kZ72aoQgmN4ZLOJTINBE5+JfNhF/lilvy1gNAEFK2GPMArQUTH5igJjda1LbnUHROo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=Q2JEOcG5; arc=none smtp.client-ip=80.12.242.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="Q2JEOcG5"
Received: from localhost.localdomain ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id 8bYQsFlLZyBie8bYQsSbPx; Sun, 19 May 2024 10:06:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1716105964;
	bh=17wjD51cm+BPeBrAvICXXERovsnzXo7hkI8s3mqy7uc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Q2JEOcG5SYy7MaeNp+AoUSFfvDgpj6jv4aQ8JPEhtoD6Fqejjf/03tlor+Hs0Hgz+
	 ttC+w+LEBXXo6v8ClbDUKcx0mrG6tzsPHV/KBKbMpwOVZ0uth9bTs3JKAHgniSWyIR
	 wnKILMeWfNEGiyTFyrJ9Mi5b3q4p1W8OzHmQ/XxFQP8FnXJdZDjqDxDccwgL+VbkJ/
	 yIStTF0YoHQAhoPyFF6sj6X/b9tuBi+Ht/4rIid9YBdj4s1QAtwho0+umhi21qjJKb
	 zr63SHmRS8foi1/i7KD5CWmUpF+i5u249ytQjdTRsR1J5wnIpDK+bs1/ieaXgRH4EM
	 8Ogx66LxGWlgg==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 19 May 2024 10:06:04 +0200
X-ME-IP: 86.243.17.157
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: bnx2fc: Use a flexible array at the end of struct bnx2fc_cmd_mgr
Date: Sun, 19 May 2024 10:05:54 +0200
Message-ID: <e98b5759ef34ce00fdb83eeec4d7c27dfe47cc7f.1716105874.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 'cmds' field in "struct bnx2fc_cmd_mgr" can be turned into a flexible
array.

This:
   - makes the code more readable and safer because struct_size() can now
     be used
   - saves the size of a pointer when allocating struct bnx2fc_cmd_mgr in
     bnx2fc_cmd_mgr_alloc()
   - avoid some pointer arithmetic when computing "cmgr->cmds"
   - saves an indirection when using the 'cmds array

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 drivers/scsi/bnx2fc/bnx2fc.h    | 2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c | 7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 7e74f77da14f..dfe7e0e8fdbd 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -281,7 +281,7 @@ struct bnx2fc_cmd_mgr {
 	struct list_head *free_list;
 	spinlock_t *free_list_lock;
 	struct io_bdt **io_bdt_pool;
-	struct bnx2fc_cmd **cmds;
+	struct bnx2fc_cmd *cmds[];
 };
 
 struct bnx2fc_rport {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 33057908f147..8e381081e487 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -213,7 +213,6 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 	struct bnx2fc_cmd_mgr *cmgr;
 	struct io_bdt *bdt_info;
 	struct bnx2fc_cmd *io_req;
-	size_t len;
 	u32 mem_size;
 	u16 xid;
 	int i;
@@ -231,10 +230,8 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 	BNX2FC_MISC_DBG("min xid 0x%x, max xid 0x%x\n", min_xid, max_xid);
 
 	num_ios = max_xid - min_xid + 1;
-	len = (num_ios * (sizeof(struct bnx2fc_cmd *)));
-	len += sizeof(struct bnx2fc_cmd_mgr);
 
-	cmgr = kzalloc(len, GFP_KERNEL);
+	cmgr = kzalloc(struct_size(cmgr, cmds, num_ios), GFP_KERNEL);
 	if (!cmgr) {
 		printk(KERN_ERR PFX "failed to alloc cmgr\n");
 		return NULL;
@@ -257,8 +254,6 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 		goto mem_err;
 	}
 
-	cmgr->cmds = (struct bnx2fc_cmd **)(cmgr + 1);
-
 	for (i = 0; i < arr_sz; i++)  {
 		INIT_LIST_HEAD(&cmgr->free_list[i]);
 		spin_lock_init(&cmgr->free_list_lock[i]);
-- 
2.45.1

