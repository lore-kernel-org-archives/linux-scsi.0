From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/18] scsi_dh_alua: sanitze sense code handling
Date: Tue,  1 Dec 2015 10:16:46 +0100
Message-ID: <1448961418-29013-7-git-send-email-hare@suse.de>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbbLAJRI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:08 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The only check for a valid sense code is calling scsi_normalize_sense()
and check the return value. So drop the pointless checks and rely on
scsi_normalize_sense() to figure out if the sense code is valid.
With that we can also remove the 'senselen' field.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.com>
Reviewed-by: Bart van Assche <bvanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index c63f304..240a5dc 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -73,7 +73,6 @@ struct alua_dh_data {
 	int			bufflen;
 	unsigned char		transition_tmo;
 	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
-	int			senselen;
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
 	void			*callback_data;
@@ -158,14 +157,13 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 
 	rq->sense = h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
+	rq->sense_len = 0;
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (err == -EIO) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: rtpg failed with %x\n",
 			    ALUA_DH_NAME, rq->errors);
-		h->senselen = rq->sense_len;
 		err = SCSI_DH_IO;
 	}
 	blk_put_request(rq);
@@ -194,9 +192,8 @@ static void stpg_endio(struct request *req, int error)
 		goto done;
 	}
 
-	if (req->sense_len > 0) {
-		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					   &sense_hdr);
+	if (scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+				 &sense_hdr)) {
 		if (!err) {
 			err = SCSI_DH_IO;
 			goto done;
@@ -265,7 +262,7 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 
 	rq->sense = h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
+	rq->sense_len = 0;
 	rq->end_io_data = h;
 
 	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
@@ -514,10 +511,9 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
  retry:
 	err = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
 
-	if (err == SCSI_DH_IO && h->senselen > 0) {
-		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					   &sense_hdr);
-		if (!err)
+	if (err == SCSI_DH_IO) {
+		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+					  &sense_hdr))
 			return SCSI_DH_IO;
 
 		/*
-- 
1.8.5.6

