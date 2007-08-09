From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] SCSI: Get SG_ALL out of the way
Date: Thu, 09 Aug 2007 20:09:37 +0300
Message-ID: <46BB4A51.2080104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:22495 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758645AbXHIRPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Aug 2007 13:15:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Jens hi playing with sglist and iscsi I stumbled on this.
You might want to add it to the sglist tree. Or maybe
James wants to include it for next merge window.

===============================================================

  - Some 50 scsi drivers use SG_ALL for their .sg_tablesize
    So a value of 255 is a bit specific. Change it to ~0
    as meaning MAX_ what ever unsigned type it will ever be.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 include/scsi/scsi_host.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 88f6871..b84a4eb 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -30,7 +30,7 @@ struct blk_queue_tags;
  *	 used in one scatter-gather request.
  */
 #define SG_NONE 0
-#define SG_ALL 0xff
+#define SG_ALL (~0)
 
 
 #define DISABLE_CLUSTERING 0
-- 
1.5.2.2.249.g45fd

