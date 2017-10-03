From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/9] bfa: don't reset max_segments for every bsg request
Date: Tue,  3 Oct 2017 12:48:38 +0200
Message-ID: <20171003104845.10417-3-hch@lst.de>
References: <20171003104845.10417-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

We already support 256 or more segments as long as the architecture
supports SG chaining (all the ones that matter do), so removed the
weird playing with limits from the job handler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/bfa/bfad_bsg.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index b2e8c0dfc79c..72ca2a2e08e2 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3137,16 +3137,9 @@ bfad_im_bsg_vendor_request(struct bsg_job *job)
 	uint32_t vendor_cmd = bsg_request->rqst_data.h_vendor.vendor_cmd[0];
 	struct bfad_im_port_s *im_port = shost_priv(fc_bsg_to_shost(job));
 	struct bfad_s *bfad = im_port->bfad;
-	struct request_queue *request_q = job->req->q;
 	void *payload_kbuf;
 	int rc = -EINVAL;
 
-	/*
-	 * Set the BSG device request_queue size to 256 to support
-	 * payloads larger than 512*1024K bytes.
-	 */
-	blk_queue_max_segments(request_q, 256);
-
 	/* Allocate a temp buffer to hold the passed in user space command */
 	payload_kbuf = kzalloc(job->request_payload.payload_len, GFP_KERNEL);
 	if (!payload_kbuf) {
-- 
2.14.1
