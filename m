Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A765C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jan 2022 16:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379148AbiAUQuE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jan 2022 11:50:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379036AbiAUQt5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Jan 2022 11:49:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642783795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=HVnnVwtCTnO/pfuGePYvdodEiY6Tf3CYC7/HBMOZEho=;
        b=ghgBDkXOq5LnhoZc42vteZ3Vm+er3BSZGSb8INB/vpjI4L8fYpyFlCGt+osdHv/j7RlVOK
        kxoUnZgtDkbJ3kOoP88HCJIXZrz6XG9hyS+Pp/YEE1xlRljn6sLAHp87X/HuEtaZLcuG1t
        OOr6Z2bbno6oafLKLrbVSTcCH6wVR3c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-oiSNQG2wNmKR6YH3yzetiA-1; Fri, 21 Jan 2022 11:49:52 -0500
X-MC-Unique: oiSNQG2wNmKR6YH3yzetiA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 374978144E1;
        Fri, 21 Jan 2022 16:49:51 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.17.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 227BC84A32;
        Fri, 21 Jan 2022 16:49:41 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, dgilbert@interlog.com, djeffery@redhat.com,
        loberman@redhat.com, linux-scsi@vger.kernel.org,
        John Pittman <jpittman@redhat.com>
Subject: [PATCH] scsi: print actual pointer addresses if using scsi debug logging
Date:   Fri, 21 Jan 2022 11:49:38 -0500
Message-Id: <20220121164938.18190-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since commit ad67b74d2469 ("printk: hash addresses printed with
%p"), any addresses printed with an unadorned %p will be hashed.
However, when scsi debug logging is enabled, in general, the
user needs the actual address for use with address tracking or
vmcore analysis.  Print the actual address for pointers when
using the SCSI_LOG_* macros.

Signed-off-by: John Pittman <jpittman@redhat.com>
Collab-from: David Jeffery <djeffery@redhat.com>
---
 drivers/scsi/scsi.c     | 2 +-
 drivers/scsi/scsi_lib.c | 2 +-
 drivers/scsi/sg.c       | 8 ++++----
 drivers/scsi/sr.c       | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 211aace69c22..0f558135637c 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -106,7 +106,7 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
 			scmd_printk(KERN_INFO, cmd,
-				    "Send: scmd 0x%p\n", cmd);
+				    "Send: scmd 0x%px\n", cmd);
 			scsi_print_command(cmd);
 		}
 	}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 35e381f6d371..a25ab894383b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -148,7 +148,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
 	struct scsi_device *device = cmd->device;
 
 	SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
-		"Inserting command %p into mlqueue\n", cmd));
+		"Inserting command %px into mlqueue\n", cmd));
 
 	scsi_set_blocked(cmd, reason);
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ad12b3261845..2b11dc84d04b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1274,7 +1274,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -ENXIO;
 	req_sz = vma->vm_end - vma->vm_start;
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
-				      "sg_mmap starting, vm_start=%p, len=%d\n",
+				      "sg_mmap starting, vm_start=%px, len=%d\n",
 				      (void *) vma->vm_start, (int) req_sz));
 	if (vma->vm_pgoff)
 		return -EINVAL;	/* want no offset */
@@ -1944,7 +1944,7 @@ sg_remove_scat(Sg_fd * sfp, Sg_scatter_hold * schp)
 			for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
 				SCSI_LOG_TIMEOUT(5,
 					sg_printk(KERN_INFO, sfp->parentdp,
-					"sg_remove_scat: k=%d, pg=0x%p\n",
+					"sg_remove_scat: k=%d, pg=0x%px\n",
 					k, schp->pages[k]));
 				__free_pages(schp->pages[k], schp->page_order);
 			}
@@ -2156,7 +2156,7 @@ sg_add_sfp(Sg_device * sdp)
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
 	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
-				      "sg_add_sfp: sfp=0x%p\n", sfp));
+				      "sg_add_sfp: sfp=0x%px\n", sfp));
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
 
@@ -2200,7 +2200,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	}
 
 	SCSI_LOG_TIMEOUT(6, sg_printk(KERN_INFO, sdp,
-			"sg_remove_sfp: sfp=0x%p\n", sfp));
+			"sg_remove_sfp: sfp=0x%px\n", sfp));
 	kfree(sfp);
 
 	scsi_device_put(sdp->device);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index f925b1f1f9ad..3b942c99a783 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -411,7 +411,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
 			"Finishing %u sectors\n", blk_rq_sectors(rq)));
 		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
-			"Retry with 0x%p\n", SCpnt));
+			"Retry with 0x%px\n", SCpnt));
 		goto out;
 	}
 
-- 
2.17.2

