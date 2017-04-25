From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 10/37] smartpqi: correct bdma hw bug
Date: Tue, 25 Apr 2017 14:46:53 -0500
Message-ID: <149314961326.13903.12748326392792076489.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0076.outbound.protection.outlook.com ([104.47.36.76]:63776
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1043702AbdDYTrC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:47:02 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

add workaround for BDMA hardware bug that can cause
hw to read up to 12 SGL elements (192 bytes) beyond the
last element in the list. This fix avoids IOMMU violations

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index eda5a1a..30fc7b1 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -48,6 +48,8 @@
 #define DRIVER_NAME		"Microsemi PQI Driver (v" DRIVER_VERSION ")"
 #define DRIVER_NAME_SHORT	"smartpqi"
 
+#define PQI_EXTRA_SGL_MEMORY	(12 * sizeof(struct pqi_sg_descriptor))
+
 MODULE_AUTHOR("Microsemi");
 MODULE_DESCRIPTION("Driver for Microsemi Smart Family Controller version "
 	DRIVER_VERSION);
@@ -3203,6 +3205,8 @@ static int pqi_alloc_operational_queues(struct pqi_ctrl_info *ctrl_info)
 	alloc_length = (size_t)aligned_pointer +
 		PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT;
 
+	alloc_length += PQI_EXTRA_SGL_MEMORY;
+
 	ctrl_info->queue_memory_base =
 		dma_zalloc_coherent(&ctrl_info->pci_dev->dev,
 			alloc_length,
@@ -4320,7 +4324,8 @@ static void pqi_calculate_io_resources(struct pqi_ctrl_info *ctrl_info)
 	max_transfer_size = (max_sg_entries - 1) * PAGE_SIZE;
 
 	ctrl_info->sg_chain_buffer_length =
-		max_sg_entries * sizeof(struct pqi_sg_descriptor);
+		(max_sg_entries * sizeof(struct pqi_sg_descriptor)) +
+		PQI_EXTRA_SGL_MEMORY;
 	ctrl_info->sg_tablesize = max_sg_entries;
 	ctrl_info->max_sectors = max_transfer_size / 512;
 }
