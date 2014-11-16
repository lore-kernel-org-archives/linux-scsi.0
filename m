From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/3] esas2r: fix an error path in esas2r_ioctl_handler
Date: Sun, 16 Nov 2014 14:35:33 +0100
Message-ID: <1416144934-21338-3-git-send-email-thenzl@redhat.com>
References: <1416144934-21338-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbaKPNgm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2014 08:36:42 -0500
In-Reply-To: <1416144934-21338-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bgrove@attotech.com

Is seems strange to manipulate nvram_semaphore when in this place,
this patch fixes it.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/esas2r/esas2r_ioctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 9ac8207554..c88b9f9491 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1420,9 +1420,10 @@ int esas2r_ioctl_handler(void *hostdata, int cmd, void __user *arg)
 
 		rq = esas2r_alloc_request(a);
 		if (rq == NULL) {
-			up(&a->nvram_semaphore);
-			ioctl->data.prw.code = 0;
-			break;
+			kfree(ioctl);
+			esas2r_log(ESAS2R_LOG_WARN,
+			   "could not allocate an internal request");
+			return -ENOMEM;
 		}
 
 		code = esas2r_write_params(a, rq,
-- 
1.9.3

