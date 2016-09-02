From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 6/6] cxlflash: Fix context reference tracking on detach
Date: Fri,  2 Sep 2016 15:40:41 -0500
Message-ID: <1472848841-65216-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752847AbcIBUku (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2016 16:40:50 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82KXFsb057869
        for <linux-scsi@vger.kernel.org>; Fri, 2 Sep 2016 16:40:50 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2575vwyf11-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 02 Sep 2016 16:40:50 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Fri, 2 Sep 2016 14:40:49 -0600
In-Reply-To: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Commit 888baf069f49 ("scsi: cxlflash: Add kref to context") introduced a
kref to the context. In particular, the detach routine was updated to use
the kref services for managing the removal and destruction of a context.

As part of this change, the tracking mechanism internal to the detach
handler was refactored. This introduced a bug that can cause the tracking
state to be lost. This can lead to a situation where exclusive access to a
context is prematurely [and unknowingly] relinquished for the executing
thread.

To remedy, only update the tracking state when the kref operation indicates
the context was removed.

Fixes: 888baf069f49 ("scsi: cxlflash: Add kref to context")
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index c91fe6f..9636970 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -912,7 +912,8 @@ static int _cxlflash_disk_detach(struct scsi_device *sdev,
 	 * Release the context reference and the sdev reference that
 	 * bound this LUN to the context.
 	 */
-	put_ctx = !kref_put(&ctxi->kref, remove_context);
+	if (kref_put(&ctxi->kref, remove_context))
+		put_ctx = false;
 	scsi_device_put(sdev);
 out:
 	if (put_ctx)
-- 
2.1.0

