From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/5] Staging: hv: storvsc: Fix a bug in copy_from_bounce_buffer()
Date: Thu,  1 Dec 2011 04:59:19 -0800
Message-ID: <1322744360-13067-4-git-send-email-kys@microsoft.com>
References: <1322744315-13017-1-git-send-email-kys@microsoft.com>
 <1322744360-13067-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322744360-13067-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Fix a bug in copy_from_bounce_buffer().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 8dafe52..c22de06 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -880,7 +880,8 @@ cleanup:
 /* Assume the original sgl has enough room */
 static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 					    struct scatterlist *bounce_sgl,
-					    unsigned int orig_sgl_count)
+					    unsigned int orig_sgl_count,
+					    unsigned int bounce_sgl_count)
 {
 	int i;
 	int j = 0;
@@ -921,6 +922,24 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
 				j++;
 
+				/*
+				 * It is possible that the number of elements
+				 * in the bounce buffer may not be equal to
+				 * the number of elements in the original
+				 * scatter list. Handle this correctly.
+				 */
+
+				if (j == bounce_sgl_count) {
+					/*
+					 * We are done; cleanup and return.
+					 */
+					kunmap_atomic((void *)(dest_addr -
+							orig_sgl[i].offset),
+							KM_IRQ0);
+					local_irq_restore(flags);
+					return total_copied;
+				}
+
 				/* if we need to use another bounce buffer */
 				if (destlen || i != orig_sgl_count - 1)
 					bounce_addr =
@@ -1126,7 +1145,8 @@ static void storvsc_command_completion(struct hv_storvsc_request *request)
 		if (vm_srb->data_in == READ_TYPE)
 			copy_from_bounce_buffer(scsi_sglist(scmnd),
 					cmd_request->bounce_sgl,
-					scsi_sg_count(scmnd));
+					scsi_sg_count(scmnd),
+					cmd_request->bounce_sgl_count);
 		destroy_bounce_buffer(cmd_request->bounce_sgl,
 					cmd_request->bounce_sgl_count);
 	}
-- 
1.7.4.1
