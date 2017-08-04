From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 5/5] scsi/esp_scsi: Always clear msg_out_len after MESSAGE OUT
 phase
Date: Fri,  4 Aug 2017 01:43:20 -0400 (EDT)
Message-ID: <5404651c2e80731082fd1a1cbf94d9f3c765dc34.1501825111.git.fthain@telegraphics.com.au>
References: <cover.1501825111.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1501825111.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, David Miller <davem@davemloft.net>, Hannes Reinecke <hare@suse.com>, Meelis Roos <mroos@linux.ee>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

After sending a message, always clear esp->msg_out_len. Otherwise,
eh_abort_handler may subsequently fail to send an ABORT TASK SET
message.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/esp_scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 4d1e08a87274..c3fc34b9964d 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -1951,6 +1951,8 @@ static int esp_process_event(struct esp *esp)
 				scsi_esp_cmd(esp, ESP_CMD_NULL);
 		}
 
+		esp->msg_out_len = 0;
+
 		esp_event(esp, ESP_EVENT_CHECK_PHASE);
 		goto again;
 	case ESP_EVENT_MSGIN:
-- 
2.13.0
