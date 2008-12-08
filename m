From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: [PATCH] Correctly release and allocate a new request upon retries
Date: Mon, 08 Dec 2008 09:24:05 -0500
Message-ID: <493D2E05.3070108@hp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020003000404040604010308"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9038 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYLHOYL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2008 09:24:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, LKML-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020003000404040604010308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------020003000404040604010308
Content-Type: text/x-diff;
 name="0001-Correctly-release-and-allocate-a-new-request-upon-re.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Correctly-release-and-allocate-a-new-request-upon-re.pa";
 filename*1="tch"

Commands needing to be retried require a complete re-initialization.

The test-unit-ready portion of this patch was causing boots to fail on
my test machine (as in http://lkml.org/lkml/2008/12/5/161). With this
patch in place, the system is booting reliably.

Mike Anderson found the same problem in the hp_hw_start_stop code,
and I applied the same solution in cdrom_read_cdda_bpc.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/cdrom/cdrom.c                       |   16 ++++++++++------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   12 ++++++++----
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index d16b024..7d2e91c 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2081,10 +2081,6 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 	if (!q)
 		return -ENXIO;
 
-	rq = blk_get_request(q, READ, GFP_KERNEL);
-	if (!rq)
-		return -ENOMEM;
-
 	cdi->last_sense = 0;
 
 	while (nframes) {
@@ -2096,9 +2092,17 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		len = nr * CD_FRAMESIZE_RAW;
 
+		rq = blk_get_request(q, READ, GFP_KERNEL);
+		if (!rq) {
+			ret = -ENOMEM;
+			break;
+		}
+
 		ret = blk_rq_map_user(q, rq, NULL, ubuf, len, GFP_KERNEL);
-		if (ret)
+		if (ret) {
+			blk_put_request(rq);
 			break;
+		}
 
 		rq->cmd[0] = GPCMD_READ_CD;
 		rq->cmd[1] = 1 << 2;
@@ -2124,6 +2128,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		if (blk_rq_unmap_user(bio))
 			ret = -EFAULT;
+		blk_put_request(rq);
 
 		if (ret)
 			break;
@@ -2133,7 +2138,6 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		ubuf += len;
 	}
 
-	blk_put_request(rq);
 	return ret;
 }
 
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 9aec4ca..f7da753 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -107,6 +107,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	struct request *req;
 	int ret;
 
+retry:
 	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
 	if (!req)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
@@ -121,7 +122,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	req->sense_len = 0;
 
-retry:
 	ret = blk_execute_rq(req->q, NULL, req, 1);
 	if (ret == -EIO) {
 		if (req->sense_len > 0) {
@@ -136,8 +136,10 @@ retry:
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY)
+	if (ret == SCSI_DH_IMM_RETRY) {
+		blk_put_request(req);
 		goto retry;
+	}
 	if (ret == SCSI_DH_DEV_OFFLINED) {
 		h->path_state = HP_SW_PATH_PASSIVE;
 		ret = SCSI_DH_OK;
@@ -200,6 +202,7 @@ static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	struct request *req;
 	int ret, retry;
 
+retry:
 	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
 	if (!req)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
@@ -216,7 +219,6 @@ static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	req->sense_len = 0;
 	retry = h->retries;
 
-retry:
 	ret = blk_execute_rq(req->q, NULL, req, 1);
 	if (ret == -EIO) {
 		if (req->sense_len > 0) {
@@ -231,8 +233,10 @@ retry:
 		ret = SCSI_DH_OK;
 
 	if (ret == SCSI_DH_RETRY) {
-		if (--retry)
+		if (--retry) {
+			blk_put_request(req);
 			goto retry;
+		}
 		ret = SCSI_DH_IO;
 	}
 
-- 
1.5.6.3


--------------020003000404040604010308--
