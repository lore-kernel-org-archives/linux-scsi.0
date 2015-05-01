From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 1/4] target: Fix inconsistent address passed to kunmap_atomic() in sbc_dif_copy_prot()
Date: Fri,  1 May 2015 15:23:48 +0900
Message-ID: <1430461431-5936-2-git-send-email-akinobu.mita@gmail.com>
References: <1430461431-5936-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35276 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbbEAGYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2015 02:24:12 -0400
In-Reply-To: <1430461431-5936-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

In sbc_dif_copy_prot(), the addresses passed to kunmap_atomic() are
inconsistent with the addresses which are mapped by kmap_atomic().
That could be problematic if an SG element has its length larger than
PAGE_SIZE as kunmap_atomic() will attempt to unmap different page.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
* New patch from v3

 drivers/target/target_core_sbc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index edba39f..b765cdd 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1299,13 +1299,14 @@ void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 			copied += len;
 			psg_len -= len;
 
+			kunmap_atomic(addr - sg->offset - offset);
+
 			if (offset >= sg->length) {
 				sg = sg_next(sg);
 				offset = 0;
 			}
-			kunmap_atomic(addr);
 		}
-		kunmap_atomic(paddr);
+		kunmap_atomic(paddr - psg->offset);
 	}
 }
 EXPORT_SYMBOL(sbc_dif_copy_prot);
-- 
1.9.1

