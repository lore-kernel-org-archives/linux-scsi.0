From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 1/5] scsi/mac_esp: Avoid type warning from sparse
Date: Fri,  4 Aug 2017 01:43:19 -0400 (EDT)
Message-ID: <fffba79b4df85989628a8226aa4dd50b644f1530.1501825111.git.fthain@telegraphics.com.au>
References: <cover.1501825111.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1501825111.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, David Miller <davem@davemloft.net>, Hannes Reinecke <hare@suse.com>, Meelis Roos <mroos@linux.ee>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Avoid the following warning from "make C=1":

  CHECK   drivers/scsi/mac_esp.c
drivers/scsi/mac_esp.c:357:30: warning: incorrect type in initializer (different address spaces)
drivers/scsi/mac_esp.c:357:30:    expected unsigned char [usertype] *fifo
drivers/scsi/mac_esp.c:357:30:    got void [noderef] <asn:2>*

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/mac_esp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index cdb61eaa2d1f..253142f3cf6f 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -348,7 +348,7 @@ static void mac_esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
 				 u32 dma_count, int write, u8 cmd)
 {
 	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
-	u8 *fifo = esp->regs + ESP_FDATA * 16;
+	u8 __iomem *fifo = esp->regs + ESP_FDATA * 16;
 
 	cmd &= ~ESP_CMD_DMA;
 	mep->error = 0;
-- 
2.13.0
