From: tom.ty89@gmail.com
Subject: [PATCH 1/1] scsi: bump SCSI_DEFAULT_MAX_SECTORS to SD_DEF_XFER_BLOCKS
Date: Wed, 18 May 2016 12:25:32 +0800
Message-ID: <573beec3.1314620a.54ed4.4ad4@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35886 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbcEREZl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2016 00:25:41 -0400
Received: by mail-pa0-f68.google.com with SMTP id xm6so3684981pab.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2016 21:25:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

As of commit ca369d51b3e1649be4a72addd6d6a168cfb3f537, max_sectors
(rw_max) of a scsi disk can be as high as SD_DEF_XFER_BLOCKS.

Therefore, bump SCSI_DEFAULT_MAX_SECTORS to 65535 to make hosts
that do not have max_sectors set in their templates benefit
from the commit.

Hosts that are not capable of handling SCSI_DEFAULT_MAX_SECTORS
should have max_sectors set in their templates (like usb-storage
does in scsiglue.c).

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index fcfa3d7..f3c43bd 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -383,7 +383,7 @@ struct scsi_host_template {
 	 * maximum, and may be over the transfer limits allowed for
 	 * individual devices (e.g. 256 for SCSI-1).
 	 */
-#define SCSI_DEFAULT_MAX_SECTORS	1024
+#define SCSI_DEFAULT_MAX_SECTORS        65535
 
 	/*
 	 * True if this host adapter can make good use of linked commands.
-- 
2.8.2

