From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] ide-scsi: Close narrow race in release
Date: Wed, 15 Aug 2007 12:57:01 -0600
Message-ID: <11872042223972-git-send-email-matthew@wil.cx>
References: <11872042213451-git-send-email-matthew@wil.cx>
 <11872042213665-git-send-email-matthew@wil.cx>
 <11872042211224-git-send-email-matthew@wil.cx>
 <11872042212630-git-send-email-matthew@wil.cx>
 <1187204221432-git-send-email-matthew@wil.cx>
 <1187204221728-git-send-email-matthew@wil.cx>
 <11872042212682-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43134 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933399AbXHOS45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 14:56:57 -0400
In-Reply-To: <11872042212682-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

We were releasing the block devices before removing the host, so commands
could still be coming in which would cause a panic.  Just remove the
host before releasing the block devices to close this race.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/ide-scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 1cc01ac..219518d 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -758,6 +758,7 @@ static void ide_scsi_remove(ide_drive_t *drive)
 	struct ide_scsi_obj *scsi = scsihost_to_idescsi(scsihost);
 	struct gendisk *g = scsi->disk;
 
+	scsi_remove_host(scsihost);
 	ide_proc_unregister_driver(drive, scsi->driver);
 
 	ide_unregister_region(g);
@@ -766,7 +767,6 @@ static void ide_scsi_remove(ide_drive_t *drive)
 	g->private_data = NULL;
 	put_disk(g);
 
-	scsi_remove_host(scsihost);
 	ide_scsi_put(scsi);
 }
 
-- 
1.5.2.4

