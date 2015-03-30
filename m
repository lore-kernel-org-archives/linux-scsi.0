From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 09/15] target/iblock: Add checks for backend DIF emulation
Date: Mon, 30 Mar 2015 03:28:18 +0000
Message-ID: <1427686104-14231-10-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36785 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbbC3D3d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Mar 2015 23:29:33 -0400
Received: by oicf142 with SMTP id f142so107796984oic.3
        for <linux-scsi@vger.kernel.org>; Sun, 29 Mar 2015 20:29:33 -0700 (PDT)
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Make sure that IBLOCK only attempts to use backend DIF emulation
when it's actually enabled at device level.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 2520cbf..1b7947c 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -774,7 +774,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		sg_num--;
 	}
 
-	if (cmd->prot_type) {
+	if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 		int rc = iblock_alloc_bip(cmd, bio_start);
 		if (rc)
 			goto fail_put_bios;
-- 
1.9.1

