From: Gwendal Grignou <gwendal@google.com>
Subject: [PATCH] Allow ATA_ passthrough command through sg.
Date: Mon, 29 Jun 2009 14:24:25 -0700
Message-ID: <1246310665-31727-1-git-send-email-gwendal@google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:6640 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZF2VYc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 17:24:32 -0400
In-Reply-To: <>
References: <>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Gwendal Grignou <gwendal@google.com>

We can already send ATA specific commands using /dev/sd device files.
This patch allow to use /dev/sg device files as well.

Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 block/scsi_ioctl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 82a0ca2..93fa53e 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -186,6 +186,12 @@ void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
 	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
 	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
+
+	/* ATA Passthrough */
+	__set_bit(ATA_12, filter->read_ok);
+	__set_bit(ATA_12, filter->write_ok);
+	__set_bit(ATA_16, filter->read_ok);
+	__set_bit(ATA_16, filter->write_ok);
 }
 EXPORT_SYMBOL_GPL(blk_set_cmd_filter_defaults);
 
-- 
1.5.4.3

