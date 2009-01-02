From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH v2] [SCSI] libsas: fix test for negative unsigned and typos
Date: Fri, 02 Jan 2009 17:32:55 +0100
Message-ID: <495E41B7.6010706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:36211 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbZABQc5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jan 2009 11:32:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>

unsigned req->data_len cannot be negative, and fix =-/-= typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index 16f9312..d110a36 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -199,8 +199,8 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_DISCOVER:
-		req->data_len =- 16;
-		if (req->data_len < 0) {
+		req->data_len -= 16;
+		if ((int)req->data_len < 0) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
@@ -215,8 +215,8 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_REPORT_PHY_SATA:
-		req->data_len =- 16;
-		if (req->data_len < 0) {
+		req->data_len -= 16;
+		if ((int)req->data_len < 0) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
@@ -238,8 +238,8 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_PHY_CONTROL:
-		req->data_len =- 44;
-		if (req->data_len < 0) {
+		req->data_len -= 44;
+		if ((int)req->data_len < 0) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
