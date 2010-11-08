From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/2] scsi.h: Remove pointless and wrong scsi_to_u32
Date: Mon, 08 Nov 2010 18:36:09 +0200
Message-ID: <4CD826F9.3030409@panasas.com>
References: <4CD825E1.2040105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:51897 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754515Ab0KHQgO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 11:36:14 -0500
In-Reply-To: <4CD825E1.2040105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Harvey Harrison <harvey.harrison@gmail.com>


In most architectures current code is 50-90 times
slower than the proper Kernel's routines.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/libsas/sas_expander.c |    9 +++++----
 include/scsi/scsi.h                |    7 -------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 505ffe3..ef63142 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -25,6 +25,7 @@
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 
 #include "sas_internal.h"
 
@@ -545,10 +546,10 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
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
index b217c7c..67ce303 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -474,13 +474,6 @@ static inline int scsi_is_wlun(unsigned int lun)
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
-/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
-static inline __u32 scsi_to_u32(__u8 *ptr)
-{
-	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
-}
-
-
 #ifdef __KERNEL__
 
 struct scsi_cmnd;
-- 
1.7.2.3


