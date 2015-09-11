From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 28/29] cxlflash: Clear AFU RRQ following reset
Date: Fri, 11 Sep 2015 16:18:09 -0500
Message-ID: <1442006289-47499-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:34486 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbbIKVTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:19:22 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 15:19:22 -0600
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 5722EC90045
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:10:24 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLJCgj63635648
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 21:19:20 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLIkoU005794
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:18:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The AFU RRQ in host memory needs to be cleared after each reset
to avoid stale entries from being processed by the AFU.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index a5b45ed..0487fac 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1609,6 +1609,9 @@ static int start_afu(struct cxlflash_cfg *cfg)
 
 	init_pcr(cfg);
 
+	/* After an AFU reset, RRQ entries are stale, clear them */
+	memset(&afu->rrq_entry, 0, sizeof(afu->rrq_entry));
+
 	/* Initialize RRQ pointers */
 	afu->hrrq_start = &afu->rrq_entry[0];
 	afu->hrrq_end = &afu->rrq_entry[NUM_RRQ_ENTRY - 1];
-- 
2.1.0

