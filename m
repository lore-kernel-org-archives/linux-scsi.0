From: roel kluin <roel.kluin@gmail.com>
Subject: [PATCH] [SCSI] libsas: unsigned X cannot be negative
Date: Wed, 29 Oct 2008 16:23:22 -0400
Message-ID: <4908C63A.9010304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:30109 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYJ2UX3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 16:23:29 -0400
Received: by ug-out-1314.google.com with SMTP id 39so736514ugf.37
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 13:23:26 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

unsigned req->data_len cannot be negative, and fix typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I am not sure whether this is what was intended, please review.
Also I am unable to respond for a few weeks.

diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index 16f9312..caf9316 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -199,12 +199,12 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_DISCOVER:
-		req->data_len =- 16;
-		if (req->data_len < 0) {
+		if (req->data_len < 15) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
+		req->data_len -= 16;
 		resp_data_len -= 56;
 		sas_host_smp_discover(sas_ha, resp_data, req_data[9]);
 		break;

