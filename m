From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] scsi: remove private implementation of get_unaligned_be32
Date: Fri, 03 Oct 2008 13:49:35 -0700
Message-ID: <1223066975.6512.34.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:63524 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYJCUth (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2008 16:49:37 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1801484wfd.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2008 13:49:36 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/libsas/sas_expander.c |    9 +++++----
 include/scsi/scsi.h                |    6 ------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 3da02e4..d8a34b5 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -24,6 +24,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
+#include <asm/unaligned.h>
 
 #include "sas_internal.h"
 
@@ -541,10 +542,10 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
 	if (!res)
 		goto out;
 
-	phy->invalid_dword_count = scsi_to_u32(&resp[12]);
-	phy->running_disparity_error_count = scsi_to_u32(&resp[16]);
-	phy->loss_of_dword_sync_count = scsi_to_u32(&resp[20]);
-	phy->phy_reset_problem_count = scsi_to_u32(&resp[24]);
+	phy->invalid_dword_count = get_unaligned_be32(&resp[12]);
+	phy->running_disparity_error_count = get_unaligned_be32(&resp[16]);
+	phy->loss_of_dword_sync_count = get_unaligned_be32(&resp[20]);
+	phy->phy_reset_problem_count = get_unaligned_be32(&resp[24]);
 
  out:
 	kfree(resp);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 192f871..66be589 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -521,10 +521,4 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
-/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
-static inline __u32 scsi_to_u32(__u8 *ptr)
-{
-	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
-}
-
 #endif /* _SCSI_SCSI_H */
-- 
1.6.0.2.471.g47a76

