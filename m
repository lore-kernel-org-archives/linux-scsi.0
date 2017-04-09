From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/5] target: Use kmalloc_array() in transport_kmap_data_sg()
Date: Sun, 9 Apr 2017 21:53:17 +0200
Message-ID: <0e590666-0658-dbfc-1438-b378cb45cfce@users.sourceforge.net>
References: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:54298 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752322AbdDITxZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 9 Apr 2017 15:53:25 -0400
In-Reply-To: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Apr 2017 21:07:14 +0200

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus use the corresponding function "kmalloc_array".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b1a3cdb29468..3ef1cadd3c32 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2280,7 +2280,7 @@ void *transport_kmap_data_sg(struct se_cmd *cmd)
 		return kmap(sg_page(sg)) + sg->offset;
 
 	/* >1 page. use vmap */
-	pages = kmalloc(sizeof(*pages) * cmd->t_data_nents, GFP_KERNEL);
+	pages = kmalloc_array(cmd->t_data_nents, sizeof(*pages), GFP_KERNEL);
 	if (!pages)
 		return NULL;
 
-- 
2.12.2
