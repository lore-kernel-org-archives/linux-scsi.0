From: tom.ty89@gmail.com
Subject: [PATCH 1/2] sd: add missing scenario for sd_config_write_same
Date: Sat, 27 Feb 2016 04:07:29 +0800
Message-ID: <56d0b088.e99c420a.dbca1.0411@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36563 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbcBZUHh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 15:07:37 -0500
Received: by mail-pa0-f65.google.com with SMTP id a7so3631493pax.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2016 12:07:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

Example:

[root@localhost ~]# sg_opcodes /dev/sdb > /dev/null
Report supported operation codes: Illegal request, invalid opcode

[root@localhost ~]# sg_vpd -p bl /dev/sdb | grep 'write same'
  Maximum write same length: 0x0 blocks

[root@localhost ~]# cat /sys/block/sdb/queue/write_same_max_bytes
33553920

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d749da7..1179ec1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -807,6 +807,8 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 	if (sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
 		sdkp->max_ws_blocks = min_not_zero(sdkp->max_ws_blocks,
 						   (u32)SD_MAX_WS16_BLOCKS);
+	else if (sdkp->max_ws_blocks == 0 && sdkp->device->no_report_opcodes)
+		sdkp->device->no_write_same = 1;
 	else if (sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes)
 		sdkp->max_ws_blocks = min_not_zero(sdkp->max_ws_blocks,
 						   (u32)SD_MAX_WS10_BLOCKS);
-- 
2.7.1

