From: roel kluin <roel.kluin@gmail.com>
Subject: [PATCH] [SCSI] libsas: unsigned req->data_len cannot be negative
 and fix typo
Date: Wed, 29 Oct 2008 16:28:08 -0400
Message-ID: <4908C758.2060505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:29826 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbYJ2U2N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 16:28:13 -0400
Received: by ug-out-1314.google.com with SMTP id 39so738125ugf.37
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 13:28:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

unsigned req->data_len cannot be negative, and fix typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Sorry, I just found out there were more similar issues, please
ignore previous patch.
I am not sure whether this is what was intended, please review.
Also I am unable to respond for a few weeks.

diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index 16f9312..6eb0779 100644
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
@@ -215,12 +215,12 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_REPORT_PHY_SATA:
-		req->data_len =- 16;
-		if (req->data_len < 0) {
+		if (req->data_len < 15) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
+		req->data_len -= 16;
 		resp_data_len -= 60;
 		sas_report_phy_sata(sas_ha, resp_data, req_data[9]);
 		break;
@@ -238,12 +238,12 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_PHY_CONTROL:
-		req->data_len =- 44;
-		if (req->data_len < 0) {
+		if (req->data_len < 43) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
+		req->data_len -= 44;
 		resp_data_len -= 8;
 		sas_phy_control(sas_ha, req_data[9], req_data[10],
 				req_data[32] >> 4, req_data[33] >> 4,

