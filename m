From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v2 1/3] Add ZBC <-> ZAC xlat support for report, open, close, reset, finish
Date: Wed,  6 Apr 2016 02:29:26 +0700
Message-ID: <1459884568-12091-2-git-send-email-shaun@tancheff.com>
References: <1459884568-12091-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33187 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbcDETaw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2016 15:30:52 -0400
In-Reply-To: <1459884568-12091-1-git-send-email-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>

Add SCSI <-> ATA translation layer for ZBC commands:
  - Open, Close, and Finish zones

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 drivers/ata/libata-scsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f06f389..ad6a8a2 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3504,7 +3504,10 @@ static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
 	/* Compatibility with ZBC r01 */
 	if (!sa)
 		sa = ZO_RESET_WRITE_POINTER;
-	if (sa != ZO_RESET_WRITE_POINTER) {
+	if (!(sa == ZO_CLOSE_ZONE ||
+	      sa == ZO_FINISH_ZONE ||
+	      sa == ZO_OPEN_ZONE ||
+	      sa == ZO_RESET_WRITE_POINTER)) {
 		fp = 1;
 		goto invalid_fld;
 	}
-- 
1.9.1

