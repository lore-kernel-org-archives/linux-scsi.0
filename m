From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] gdth: use offset_in_page() macro
Date: Sat, 22 Apr 2017 09:21:09 +0800
Message-ID: <d59a52e71d50674189d121c5ed9d4b451101ff96.1492758211.git.geliangtang@gmail.com>
References: <4dbc77ccaaed98b183cf4dba58a4fa325fd65048.1492758503.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4dbc77ccaaed98b183cf4dba58a4fa325fd65048.1492758503.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use offset_in_page() macro instead of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/scsi/gdth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index d020a13..557ce73 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2648,7 +2648,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 b)
 
     } else {
         page = virt_to_page(scp->sense_buffer);
-        offset = (unsigned long)scp->sense_buffer & ~PAGE_MASK;
+	offset = offset_in_page(scp->sense_buffer);
         sense_paddr = pci_map_page(ha->pdev,page,offset,
                                    16,PCI_DMA_FROMDEVICE);
 
-- 
2.9.3
