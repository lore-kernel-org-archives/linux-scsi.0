From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: storvsc: Fix a bug in create_bounce_buffer()
Date: Wed,  7 Dec 2011 07:15:52 -0800
Message-ID: <1323270952-22646-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:44324
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756339Ab1LGPPx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Dec 2011 10:15:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>

Set the length field of the scatter gather elements correctly when we create
the bounce buffer. When we use the bounce buffer for a "write" operation,
the act of copying to the bounce buffer, correctly deals with this issue.
However, on the "read" side, the current code was not correctly setting
the buffer length. Fix this bug. Note that when we copy from the bounce
buffer (for the read case), the amount we copy is controlled by the original
scatter gather list given to the driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Dadok Milan <dadok@kvados.cz> 
---
 drivers/staging/hv/storvsc_drv.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 18f8771..eb853f7 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -893,12 +893,14 @@ static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count)
 
 static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
 						unsigned int sg_count,
-						unsigned int len)
+						unsigned int len,
+						int write)
 {
 	int i;
 	int num_pages;
 	struct scatterlist *bounce_sgl;
 	struct page *page_buf;
+	unsigned int buf_len = ((write == WRITE_TYPE) ? 0 : PAGE_SIZE);
 
 	num_pages = ALIGN(len, PAGE_SIZE) >> PAGE_SHIFT;
 
@@ -910,7 +912,7 @@ static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
 		page_buf = alloc_page(GFP_ATOMIC);
 		if (!page_buf)
 			goto cleanup;
-		sg_set_page(&bounce_sgl[i], page_buf, 0, 0);
+		sg_set_page(&bounce_sgl[i], page_buf, buf_len, 0);
 	}
 
 	return bounce_sgl;
@@ -1348,7 +1350,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		if (do_bounce_buffer(sgl, scsi_sg_count(scmnd)) != -1) {
 			cmd_request->bounce_sgl =
 				create_bounce_buffer(sgl, scsi_sg_count(scmnd),
-						     scsi_bufflen(scmnd));
+						     scsi_bufflen(scmnd),
+						     vm_srb->data_in);
 			if (!cmd_request->bounce_sgl) {
 				scmnd->host_scribble = NULL;
 				mempool_free(cmd_request,
-- 
1.7.4.1

