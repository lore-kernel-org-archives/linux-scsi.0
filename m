From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] libsas: align sata_device's rps_resp on a cacheline
Date: Tue, 21 Nov 2017 14:23:39 +0100
Message-ID: <20171121132339.1702-4-hch@lst.de>
References: <20171121132339.1702-1-hch@lst.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171121132339.1702-1-hch@lst.de>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Huacai Chen <chenhc@lemote.com>, linux-scsi@vger.kernel.org, iommu@lists.linux-foundation.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

The rps_resp buffer in ata_device is a DMA target, but it isn't
explicitly cacheline aligned. Due to this, adjacent fields can be
overwritten with stale data from memory on non-coherent architectures.
As a result, the kernel is sometimes unable to communicate with an
SATA device behind a SAS expander.

Fix this by ensuring that the rps_resp buffer is cacheline aligned.

This issue is similar to that fixed by Commit 84bda12af31f93 ("libata:
align ap->sector_buf") and Commit 4ee34ea3a12396f35b26 ("libata: Align
ata_device's id on a cacheline").

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/scsi/libsas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 0f9cbf96c093..6df6fe0c2198 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -159,11 +159,11 @@ struct expander_device {
 
 struct sata_device {
 	unsigned int class;
-	struct smp_resp        rps_resp; /* report_phy_sata_resp */
 	u8     port_no;        /* port number, if this is a PM (Port) */
 
 	struct ata_port *ap;
 	struct ata_host ata_host;
+	struct smp_resp rps_resp ____cacheline_aligned; /* report_phy_sata_resp */
 	u8     fis[ATA_RESP_FIS_SIZE];
 };
 
-- 
2.14.2
