Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328FDCA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 20:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E0AB217D9
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 20:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfKAUxh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 16:53:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:55124 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726742AbfKAUxg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Nov 2019 16:53:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08C77B396;
        Fri,  1 Nov 2019 20:53:34 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     linuxdrivers@attotech.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH] drivers/scsi/esas2r: Replace binary semaphore with mutex
Date:   Fri,  1 Nov 2019 13:51:59 -0700
Message-Id: <20191101205159.1377-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

At a slight footprint cost (24 vs 32 bytes), mutexes are more optimal
than semaphores; it's also a nicer interface for mutual exclusion,
which is why they are encouraged over binary semaphores, when possible.

Replace the buffered_ioctl_sem, its semantics implies traditional lock
ownership; that is, the lock owner is the same for both lock/unlock
operations. Therefore it is safe to convert.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
This is in an effort to reduce semaphore users in the kernel.
Compile-tested only.

 drivers/scsi/esas2r/esas2r_ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 442c5e70a7b4..aad352fe27cf 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -56,7 +56,7 @@ dma_addr_t esas2r_buffered_ioctl_addr;
 u32 esas2r_buffered_ioctl_size;
 struct pci_dev *esas2r_buffered_ioctl_pcid;
 
-static DEFINE_SEMAPHORE(buffered_ioctl_semaphore);
+static DEFINE_MUTEX(buffered_ioctl_mutex);
 typedef int (*BUFFERED_IOCTL_CALLBACK)(struct esas2r_adapter *,
 				       struct esas2r_request *,
 				       struct esas2r_sg_context *,
@@ -209,7 +209,7 @@ static u8 handle_buffered_ioctl(struct esas2r_buffered_ioctl *bi)
 	struct esas2r_sg_context sgc;
 	u8 result = IOCTL_SUCCESS;
 
-	if (down_interruptible(&buffered_ioctl_semaphore))
+	if (mutex_lock_interruptible(&buffered_ioctl_mutex))
 		return IOCTL_OUT_OF_RESOURCES;
 
 	/* allocate a buffer or use the existing buffer. */
@@ -285,7 +285,7 @@ static u8 handle_buffered_ioctl(struct esas2r_buffered_ioctl *bi)
 	if (result == IOCTL_SUCCESS)
 		memcpy(bi->ioctl, esas2r_buffered_ioctl, bi->length);
 
-	up(&buffered_ioctl_semaphore);
+	mutex_unlock(&buffered_ioctl_mutex);
 	return result;
 }
 
-- 
2.16.4

