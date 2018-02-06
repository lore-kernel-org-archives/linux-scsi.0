From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC 5/6] scsi: Add NO_DMA dummies for SCSI DMA mapping API
Date: Tue,  6 Feb 2018 11:14:51 +0100
Message-ID: <1517912092-15470-6-git-send-email-geert@linux-m68k.org>
References: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:46884 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbeBFKPD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 05:15:03 -0500
In-Reply-To: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>, Richard Weinberger <richard@nod.at>
Cc: Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, iommu@lists.linux-foundation.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

Add dummies for scsi_dma_{,un}map(), to allow compile-testing if
NO_DMA=y.

This prevents the following from showing up later:

    ERROR: "scsi_dma_unmap" [drivers/firewire/firewire-sbp2.ko] undefined!
    ERROR: "scsi_dma_map" [drivers/firewire/firewire-sbp2.ko] undefined!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/scsi/scsi_cmnd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index d8d4a902a88dedbc..6a123d1dd2f80624 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -171,8 +171,13 @@ extern void scsi_kunmap_atomic_sg(void *virt);
 
 extern int scsi_init_io(struct scsi_cmnd *cmd);
 
+#ifdef CONFIG_SCSI_DMA
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
+#else /* !CONFIG_SCSI_DMA */
+static inline int scsi_dma_map(struct scsi_cmnd *cmd) { return -ENOSYS; }
+static inline void scsi_dma_unmap(struct scsi_cmnd *cmd) { }
+#endif /* !CONFIG_SCSI_DMA */
 
 static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
 {
-- 
2.7.4
