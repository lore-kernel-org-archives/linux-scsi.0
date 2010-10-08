From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] block: Fix double free in blk_integrity_unregister
Date: Fri, 08 Oct 2010 01:18:16 -0400
Message-ID: <yq1d3rls1nr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:23839 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0JHFUL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2010 01:20:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, linux-scsi@vger.kernel.org


Commit 3839e4b introduced a kobject_put but failed to remove the
kmem_cache_free beneath it, leading to a double free.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 885cbb5..54bcba6 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -432,7 +432,6 @@ void blk_integrity_unregister(struct gendisk *disk)
 	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
 	kobject_del(&bi->kobj);
 	kobject_put(&bi->kobj);
-	kmem_cache_free(integrity_cachep, bi);
 	disk->integrity = NULL;
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
