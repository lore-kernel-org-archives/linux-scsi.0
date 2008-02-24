From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ps3rom: fix wrong resid calculation bug
Date: Sun, 24 Feb 2008 15:25:22 -0800
Message-ID: <1203895523-4009-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60490 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYBXX2k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 18:28:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

sg driver rounds up the length in struct scatterlist to be a multiple
of 512 in some conditions. So LLDs can't use the data length in a sg
list to calculate residual. Instead, the length in struct scsi_cmnd
should be used.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/ps3rom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 0cd614a..6944bda 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -124,7 +124,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf)
 		}
 		req_len += sgpnt->length;
 	}
-	scsi_set_resid(cmd, req_len - act_len);
+	scsi_set_resid(cmd, scsi_bufflen(cmd) - act_len);
 	return 0;
 }
 
-- 
1.5.3.7

