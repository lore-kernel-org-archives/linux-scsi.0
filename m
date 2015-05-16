From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/7] 3w-xxxx: fix transfer length 0 for 6-byte r/w commands
Date: Sat, 16 May 2015 16:17:48 +0900
Message-ID: <1431760673-7180-3-git-send-email-akinobu.mita@gmail.com>
References: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33714 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbbEPHSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2015 03:18:30 -0400
Received: by pdbqa5 with SMTP id qa5so52169247pdb.0
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2015 00:18:30 -0700 (PDT)
In-Reply-To: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Adam Radford <linuxraid@lsi.com>

For 6-byte r/w commands, transfer length 0 means 256 blocks of data,
not 0 block.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Adam Radford <linuxraid@lsi.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/3w-xxxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 2940bd7..e836aee 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1727,6 +1727,8 @@ static int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id)
 	if (srb->cmnd[0] == READ_6 || srb->cmnd[0] == WRITE_6) {
 		lba = ((u32)srb->cmnd[1] << 16) | ((u32)srb->cmnd[2] << 8) | (u32)srb->cmnd[3];
 		num_sectors = (u32)srb->cmnd[4];
+		if (num_sectors == 0)
+			num_sectors = 256;
 	} else {
 		lba = ((u32)srb->cmnd[2] << 24) | ((u32)srb->cmnd[3] << 16) | ((u32)srb->cmnd[4] << 8) | (u32)srb->cmnd[5];
 		num_sectors = (u32)srb->cmnd[8] | ((u32)srb->cmnd[7] << 8);
-- 
1.9.1

