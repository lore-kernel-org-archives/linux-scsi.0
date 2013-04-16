From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/6] scsi_debug: add translation functions between LBA and index of provisioning map
Date: Tue, 16 Apr 2013 22:11:58 +0900
Message-ID: <1366117920-11740-5-git-send-email-akinobu.mita@gmail.com>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63220 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715Ab3DPNMc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 09:12:32 -0400
Received: by mail-pb0-f47.google.com with SMTP id rq13so289813pbb.20
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 06:12:30 -0700 (PDT)
In-Reply-To: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

The translation from LBA to index of provisioning map (map_storep) is used
in various places (map_state(), map_region(), and unmap_region()).  But it
is not correctly calculated if scsi_debug_unmap_alignment is zero.

This introduces correct translation functions between LBA and index
of  provisioning map:

        static unsigned long lba_to_map_index(sector_t lba);
        static sector_t map_index_to_lba(unsigned long index);

Actual bug fixes with using these functions will be done by forthcoming
patches.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4b5d388..c6de36c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1997,6 +1997,23 @@ out:
 	return ret;
 }
 
+static unsigned long lba_to_map_index(sector_t lba)
+{
+	if (scsi_debug_unmap_alignment) {
+		lba += scsi_debug_unmap_granularity -
+			scsi_debug_unmap_alignment;
+	}
+	do_div(lba, scsi_debug_unmap_granularity);
+
+	return lba;
+}
+
+static sector_t map_index_to_lba(unsigned long index)
+{
+	return index * scsi_debug_unmap_granularity -
+		scsi_debug_unmap_alignment;
+}
+
 static unsigned int map_state(sector_t lba, unsigned int *num)
 {
 	unsigned int granularity, alignment, mapped;
-- 
1.8.1.4

