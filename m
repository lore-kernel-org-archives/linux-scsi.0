From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 3/6] esp_scsi: Grant disconnect privilege for untagged
 commands
Date: Sat, 13 Oct 2018 11:51:16 +1100
Message-ID: <536cb5d0cc8a091a5b36baa53ff736d56a254724.1539391876.git.fthain@telegraphics.com.au>
References: <cover.1539391876.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1539391876.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A SCSI device is not granted disconnect privilege by an esp_scsi host
unless that device has its simple_tags flag set. However, a device may
support disconnect/reselect and not support command queueing. Allow
these devices to disconnect and improve bus utilization.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/esp_scsi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 9e5d3f7d29ae..b7c41aa9927c 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -800,13 +800,9 @@ static void esp_maybe_execute_command(struct esp *esp)
 
 build_identify:
 	/* If we don't have a lun-data struct yet, we're probing
-	 * so do not disconnect.  Also, do not disconnect unless
-	 * we have a tag on this command.
+	 * so do not disconnect.
 	 */
-	if (lp && (tp->flags & ESP_TGT_DISCONNECT) && ent->tag[0])
-		*p++ = IDENTIFY(1, lun);
-	else
-		*p++ = IDENTIFY(0, lun);
+	*p++ = IDENTIFY(lp && (tp->flags & ESP_TGT_DISCONNECT), lun);
 
 	if (ent->tag[0] && esp->rev == ESP100) {
 		/* ESP100 lacks select w/atn3 command, use select
-- 
2.16.4
