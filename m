From: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] scsi: dc395x: fix sparse warning
Date: Thu,  5 Feb 2015 12:15:05 +0000
Message-ID: <1423138505-6326-1-git-send-email-prabhakar.csengg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: dc395x@twibble.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following sparse warning:

dc395x.c:1525:17: warning: Using plain integer as NULL pointer

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Found this issue on linux-next (gcc  version 4.9.2,
 sparse version  0.4.5-rc1)and applies on top linux-next.

 drivers/scsi/dc395x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 5ee7f44..4a46ca2 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1526,7 +1526,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 			"command while another command (0x%p) is active.",
 			srb->cmd,
 			acb->active_dcb->active_srb ?
-			    acb->active_dcb->active_srb->cmd : 0);
+			    acb->active_dcb->active_srb->cmd : NULL);
 		return 1;
 	}
 	if (DC395x_read16(acb, TRM_S1040_SCSI_STATUS) & SCSIINTERRUPT) {
-- 
1.9.1
