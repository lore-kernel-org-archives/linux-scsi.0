From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V9 4/4] libsas: Align sata_device's rps_resp on a cacheline
Date: Mon, 23 Oct 2017 15:12:47 +0800
Message-ID: <1508742767-28366-4-git-send-email-chenhc@lemote.com>
References: <1508742767-28366-1-git-send-email-chenhc@lemote.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:34489 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdJWHKk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Oct 2017 03:10:40 -0400
In-Reply-To: <1508742767-28366-1-git-send-email-chenhc@lemote.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org

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
---
 include/scsi/libsas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 6c0dc61..a966d28 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -165,11 +165,11 @@ struct expander_device {
 
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
2.7.0
