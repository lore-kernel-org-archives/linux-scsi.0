From: brking@us.ibm.com
Subject: [PATCH 04/26] ipr: Generic adapter error cleaup
Date: Tue, 01 Nov 2005 17:00:34 -0600
Message-ID: <200511012300.jA1N0ZWa022257@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:25986 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751400AbVKAXAg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2005 18:00:36 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N0a5C018822
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:00:36 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jA1N1eDC464180
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:01:40 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N0Z30022295
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:00:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The generic ipr adapter error log currently logs 2 lines of useless
data. Delete these lines.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_generic_error_cleanup drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_generic_error_cleanup	2005-08-30 10:26:33.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-08-30 10:26:33.000000000 -0500
@@ -1061,9 +1061,6 @@ static void ipr_log_generic_error(struct
 	if (ioa_data_len == 0)
 		return;
 
-	ipr_err("IOA Error Data:\n");
-	ipr_err("Offset    0 1 2 3  4 5 6 7  8 9 A B  C D E F\n");
-
 	for (i = 0; i < ioa_data_len / 4; i += 4) {
 		ipr_err("%08X: %08X %08X %08X %08X\n", i*4,
 			be32_to_cpu(hostrcb->hcam.u.raw.data[i]),
_
