From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_debug: fix wrong resid calculation bug
Date: Sun, 24 Feb 2008 15:25:21 -0800
Message-ID: <1203895523-4009-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60449 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYBXX17 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 18:27:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

sg driver rounds up the length in struct scatterlist to be a multiple
of 512 in some conditions. So LLDs can't use the data length in a sg
list to calculate residual. Instead, the length in struct scsi_cmnd
should be used.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d1777a9..691efd9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -651,7 +651,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 	if (sdb->resid)
 		sdb->resid -= act_len;
 	else
-		sdb->resid = req_len - act_len;
+		sdb->resid = scsi_bufflen(scp) - act_len;
 	return 0;
 }
 
-- 
1.5.3.7

