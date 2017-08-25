From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 3/3] cxlflash: Fix vlun resize failure in the shrink path
Date: Fri, 25 Aug 2017 17:18:12 -0500
Message-ID: <1503699492-61577-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1503699440-61464-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48431 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933883AbdHYWSU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 18:18:20 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7PMDjRD030648
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2017 18:18:19 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cjv02sdc2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2017 18:18:19 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Fri, 25 Aug 2017 18:18:18 -0400
In-Reply-To: <1503699440-61464-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

The ioctl DK_CAPI_VLUN_RESIZE can fail if the allocated vlun size is
reduced from almost maximum capacity and then increased again.

The shrink_lxt() routine is currently using the SISL_ASTATUS_MASK to mask
the higher 48 bits of the lxt entry. This is unnecessary and incorrect as
it uses a mask designed for the asynchronous interrupt status register.
When the 4 port support was added to cxlflash, the SISL_ASTATUS_MASK was
updated to reflect the status bits for all 4 ports. This change indirectly
affected the shrink_lxt() code path.

To extract the base, simply shift the bits without masking.

Fixes: 565180723294 ("scsi: cxlflash: SISlite updates to support 4 ports")

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/vlun.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index bdfb930..703bf1e 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -694,11 +694,7 @@ static int shrink_lxt(struct afu *afu,
 	/* Free LBAs allocated to freed chunks */
 	mutex_lock(&blka->mutex);
 	for (i = delta - 1; i >= 0; i--) {
-		/* Mask the higher 48 bits before shifting, even though
-		 * it is a noop
-		 */
-		aun = (lxt_old[my_new_size + i].rlba_base & SISL_ASTATUS_MASK);
-		aun = (aun >> MC_CHUNK_SHIFT);
+		aun = lxt_old[my_new_size + i].rlba_base >> MC_CHUNK_SHIFT;
 		if (needs_ws)
 			write_same16(sdev, aun, MC_CHUNK_SIZE);
 		ba_free(&blka->ba_lun, aun);
-- 
2.1.0
