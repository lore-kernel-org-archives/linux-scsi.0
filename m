From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 1/3] esas2r: fir error handling in do_fm_api
Date: Sun, 16 Nov 2014 14:35:32 +0100
Message-ID: <1416144934-21338-2-git-send-email-thenzl@redhat.com>
References: <1416144934-21338-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbaKPNgm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2014 08:36:42 -0500
In-Reply-To: <1416144934-21338-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bgrove@attotech.com

This patch fixes an error path and rearranges error handling.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/esas2r/esas2r_ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index d89a0277a8..9ac8207554 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -117,9 +117,8 @@ static void do_fm_api(struct esas2r_adapter *a, struct esas2r_flash_img *fi)
 
 	rq = esas2r_alloc_request(a);
 	if (rq == NULL) {
-		up(&a->fm_api_semaphore);
 		fi->status = FI_STAT_BUSY;
-		return;
+		goto free_sem;
 	}
 
 	if (fi == &a->firmware.header) {
@@ -135,7 +134,7 @@ static void do_fm_api(struct esas2r_adapter *a, struct esas2r_flash_img *fi)
 		if (a->firmware.header_buff == NULL) {
 			esas2r_debug("failed to allocate header buffer!");
 			fi->status = FI_STAT_BUSY;
-			return;
+			goto free_req;
 		}
 
 		memcpy(a->firmware.header_buff, fi,
@@ -171,9 +170,10 @@ all_done:
 				  a->firmware.header_buff,
 				  (dma_addr_t)a->firmware.header_buff_phys);
 	}
-
-	up(&a->fm_api_semaphore);
+free_req:
 	esas2r_free_request(a, (struct esas2r_request *)rq);
+free_sem:
+	up(&a->fm_api_semaphore);
 	return;
 
 }
-- 
1.9.3

