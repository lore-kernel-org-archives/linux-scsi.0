From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH] scsi_dh_rdac: Add dynamic match functionality to rdac
 handler
Date: Tue, 10 Apr 2012 17:06:42 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B0574C6@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:37097 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2DJRGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2012 13:06:43 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@netapp.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>

This patch adds the dynamic match functionality to scsi_dh_rdac driver.
New vendor and product strings are normally not there in the kernel. Whenever
the new product is tested with this driver we see failures during the disco-
very. Without the handler attached, the default scsi mid-level retries would
take effect for certain check-conditions. Default retries(5) are not enough in
some cases(especially with large configuration or huge lun cases).

This patch will send an inquiry if the vendor/product strings are not in the
device list and match with vendor signature.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
Reviewed-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@netapp.com>
---

--- linux-3.4-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2012-04-07 20:30:41.000000000 -0500
+++ linux-3.4-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c	2012-04-10 10:48:40.000000000 -0500
@@ -818,7 +818,10 @@ static const struct scsi_dh_devlist rdac
 
 static bool rdac_match(struct scsi_device *sdev)
 {
-	int i;
+	int i, err;
+	struct c8_inquiry inqp;
+	struct request *rq;
+	struct request_queue *q = sdev->request_queue;
 
 	if (scsi_device_tpgs(sdev))
 		return false;
@@ -831,6 +834,27 @@ static bool rdac_match(struct scsi_devic
 			return true;
 		}
 	}
+
+	/* Now lets try to match the signature on 0xC8 page */
+	memset(&inqp, 0, sizeof(struct c8_inquiry));
+	rq = get_rdac_req(sdev, &inqp, sizeof(struct c8_inquiry), READ);
+	if (!rq)
+		return false;
+
+	rq->cmd[0] = INQUIRY;
+	rq->cmd[1] = 1;
+	rq->cmd[2] = 0xC8;
+	rq->cmd[4] = sizeof(struct c8_inquiry);
+	rq->cmd_len = COMMAND_SIZE(INQUIRY);
+
+	err = blk_execute_rq(q, NULL, rq, 1);
+	blk_put_request(rq);
+	if (err != -EIO) {
+		if (inqp.page_id[0] == 'e' && inqp.page_id[1] == 'd' &&
+		    inqp.page_id[2] == 'i' && inqp.page_id[3] == 'd')
+			return true;
+	}
+
 	return false;
 }
 


