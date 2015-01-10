From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: remove scsi_to_u32
Date: Sat, 10 Jan 2015 11:10:41 +0100
Message-ID: <1420884641-29518-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60197 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbbAJKLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 05:11:33 -0500
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y9t11-000627-DA
	for linux-scsi@vger.kernel.org; Sat, 10 Jan 2015 10:11:31 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

scsi_to_u32 is a non-optimized reimplementation of get_unaligned_be32,
just use the real thing (TM).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/libsas/sas_expander.c | 8 ++++----
 include/scsi/scsi.h                | 6 ------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 022bb6e..01ff10f 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -678,10 +678,10 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
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
index d0a66aa..42e5e49 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -585,10 +585,4 @@ static inline int scsi_is_wlun(u64 lun)
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
1.9.1

