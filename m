From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/9] scsi_transport_sas: check reply payload length instead of bidi request
Date: Tue,  3 Oct 2017 12:48:41 +0200
Message-ID: <20171003104845.10417-6-hch@lst.de>
References: <20171003104845.10417-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58863 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdJCKtC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2017 06:49:02 -0400
In-Reply-To: <20171003104845.10417-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>

As a user of bsg-lib the SAS transport should not poke into request
internals but use the bsg_job fields instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_transport_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 319dff970237..736a1f4f9676 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -177,7 +177,7 @@ static int sas_smp_dispatch(struct bsg_job *job)
 	if (!scsi_is_host_device(job->dev))
 		rphy = dev_to_rphy(job->dev);
 
-	if (!job->req->next_rq) {
+	if (!job->reply_payload.payload_len) {
 		dev_warn(job->dev, "space for a smp response is missing\n");
 		bsg_job_done(job, -EINVAL, 0);
 		return 0;
-- 
2.14.1
