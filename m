From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] [SCSI] qla2xxx: improve error returns in
 qla2x00_process_vendor_specific
Date: Thu, 18 Feb 2010 15:11:07 +1100
Message-ID: <20100218151107.3684ebdf.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:56204 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab0BRELL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Feb 2010 23:11:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Sarang Radke <sarang.radke@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, LKML <linux-kernel@vger.kernel.org>

These changes mean that the request sg will be unmapped if the response
sg map fails, both the dma_allocs are freed and the dma_allocs only get
freed if necessary.  There are still two places that return from this
routine without doing either the unmaps or the dma_frees.

This gets rid of these warnings:

drivers/scsi/qla2xxx/qla_attr.c: In function 'qla2x00_process_vendor_specific':
drivers/scsi/qla2xxx/qla_attr.c:2150: warning: 'req_data' may be used uninitialized in this function
drivers/scsi/qla2xxx/qla_attr.c:2152: warning: 'req_data_len' may be used uninitialized in this function

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/qla2xxx/qla_attr.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

I have only build tested these changes as I do not have the hardware
involved.  Also, I am not sure if some of the infrastructure does the
dma_free_coherent() for the rsp_data.

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5a19aea..d8c5bf3 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2173,7 +2173,7 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
         if (!elreq.rsp_sg_cnt) {
 		rval = -ENOMEM;
-                goto done;
+                goto done_unmap_sg_req;
 	}
 
 	if ((elreq.req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
@@ -2224,7 +2224,7 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 				DEBUG2(qla_printk(KERN_INFO, ha, "scsi(%ld)"
 				"loopback option:0x%x not supported\n", vha->host_no, elreq.options));
 				rval = -EINVAL;
-				goto done_unmap_sg;
+				goto done_dma_free;
 			}
 
 			DEBUG2(qla_printk(KERN_INFO, ha,
@@ -2304,17 +2304,21 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 	}
 	bsg_job->job_done(bsg_job);
 
+done_dma_free:
+	dma_free_coherent(&ha->pdev->dev, rsp_data_len,
+		rsp_data, rsp_data_dma);
+	dma_free_coherent(&ha->pdev->dev, req_data_len,
+		req_data, req_data_dma);
+
 done_unmap_sg:
+	dma_unmap_sg(&ha->pdev->dev,
+	    bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
 
-	if(req_data)
-		dma_free_coherent(&ha->pdev->dev, req_data_len,
-			req_data, req_data_dma);
+done_unmap_sg_req:
 	dma_unmap_sg(&ha->pdev->dev,
 	    bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-	dma_unmap_sg(&ha->pdev->dev,
-	    bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
 
 done:
         return rval;
-- 
1.6.6.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
