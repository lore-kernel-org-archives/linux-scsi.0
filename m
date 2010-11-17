From: Hillf Danton <dhillf@gmail.com>
Subject: [patch] fix TUR method in HP/COMPAQ MSA Device Handler
Date: Wed, 17 Nov 2010 20:47:29 +0800
Message-ID: <AANLkTikG+kH5RJj3TH0kiRde+kgvEz-Qwhd4TF3sE4Wo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49563 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0KQMra (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 07:47:30 -0500
Received: by wwa36 with SMTP id 36so1977296wwa.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2010 04:47:29 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[1] In case of tur_done(), though the result of scsi_normalize_sense()
could be reused, the default ret is fixed to be SCSI_DH_IO, since
tomato is not potato.

[2] in case of hp_sw_tur(), retry is fixed according to HP_SW_RETRIES,
though the sdev asks to try again.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2010-11-01
19:54:12.000000000 +0800
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2010-11-17
20:30:34.000000000 +0800
@@ -95,6 +95,8 @@ static int tur_done(struct scsi_device *
 			   "%s: sending tur failed, sense %x/%x/%x\n",
 			   HP_SW_NAME, sshdr.sense_key, sshdr.asc,
 			   sshdr.ascq);
+
+		ret = SCSI_DH_IO;
 		break;
 	}

@@ -113,6 +115,7 @@ static int hp_sw_tur(struct scsi_device
 {
 	struct request *req;
 	int ret;
+	int retry_cnt = 0;

 retry:
 	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
@@ -145,7 +148,12 @@ retry:
 	}
 	if (ret == SCSI_DH_IMM_RETRY) {
 		blk_put_request(req);
-		goto retry;
+		if (retry_cnt++ < HP_SW_RETRIES)
+			goto retry;
+		else {
+			ret = SCSI_DH_IO;
+			goto out;
+		}
 	}
 	if (ret == SCSI_DH_DEV_OFFLINED) {
 		h->path_state = HP_SW_PATH_PASSIVE;
@@ -153,7 +161,7 @@ retry:
 	}

 	blk_put_request(req);
-
+ out:
 	return ret;
 }
