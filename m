From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 8/8] Change SG_ALL to mean "any size"
Date: Thu, 17 Jan 2008 18:55:16 +0200
Message-ID: <478F8874.7070705@panasas.com>
References: <478F8435.5000907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:16484 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751283AbYAQQzT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 11:55:19 -0500
In-Reply-To: <478F8435.5000907@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


  Change the definition of SG_ALL from 255, which was the biggest possible
  scatter list array in 32 bit ARCHs (minus one who knows why), to be ~0.
  Which means that LLD has no size limit on number of scatter-list array
  and the actual size will be determined by upper layers.
  Also SG_NONE is removed because it is no longer supported.
  Note: SG_ALL can not be used as an allocation size anymore.

  FIXME: Important/capable drivers like iscsi have moved away from
         SG_ALL to hard coded numbers like 4096. They should reuse
         SG_ALL now.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 include/scsi/scsi_host.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5c58d59..6032d07 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -21,16 +21,14 @@ struct blk_queue_tags;
 
 
 /*
- * The various choices mean:
- * NONE: Self evident.	Host adapter is not capable of scatter-gather.
+ * values to use with .sg_tablesize:
  * ALL:	 Means that the host adapter module can do scatter-gather,
  *	 and that there is no limit to the size of the table to which
  *	 we scatter/gather data.
  * Anything else:  Indicates the maximum number of chains that can be
  *	 used in one scatter-gather request.
  */
-#define SG_NONE 0
-#define SG_ALL 0xff
+#define SG_ALL (~0)
 
 #define MODE_UNKNOWN 0x00
 #define MODE_INITIATOR 0x01
-- 
1.5.3.3


