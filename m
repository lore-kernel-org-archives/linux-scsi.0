From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: [PATCH] Correctly release and allocate a new request on TUR retries
Date: Fri, 05 Dec 2008 09:36:56 -0500
Message-ID: <49393C88.8080103@hp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040707080809010102050106"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:10793 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYLEOhA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:37:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040707080809010102050106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------040707080809010102050106
Content-Type: text/x-diff;
 name="0001-Correctly-release-and-allocate-a-new-request-on-TUR.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Correctly-release-and-allocate-a-new-request-on-TUR.pat";
 filename*1="ch"


Commands needing to be retried (TUR in this case) would result in a block
I/O request being re-used, without being re-initialized properly. This
patch ensures that the requests are correctly re-initialized via
standard allocation means.

Prior to this patch, boots were failing consistently as in:
http://lkml.org/lkml/2008/12/5/161

With this patch in place, the system is booting reliably.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 9aec4ca..1f6b6a8 100644
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
-- 
1.5.6.3


--------------040707080809010102050106--
