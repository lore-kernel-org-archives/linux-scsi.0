From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 2/3] [SCSI] ufs: Limit sense data size to 18 bytes
Date: Sat, 21 Apr 2012 14:39:18 +0530
Message-ID: <1334999359-3181-2-git-send-email-santoshsy@gmail.com>
References: <1334999359-3181-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47865 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2DUJJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Apr 2012 05:09:36 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so1948683pbc.19
        for <linux-scsi@vger.kernel.org>; Sat, 21 Apr 2012 02:09:36 -0700 (PDT)
In-Reply-To: <1334999359-3181-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

As per the UFS specification a UFS device server should return upto
18 bytes of sense data. Currently, if a SCSI command completes with
a check condition, min_t(sense_data_length, SCSI_SENSE_BUFFERSIZE)
bytes of sense data is being copied to sense_buffer.

Correct sense_data_length(<= 18 bytes), from a UFS device will not
cause any problem. If a UFS device returns wrong sense_data_length
( > 18 bytes), then the wrong sense data will be copied to
sense_buffer.

Signed-off-by: Santosh Y <santoshsy@gmail.com>
Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
---
 drivers/scsi/ufs/ufs.h    |    1 +
 drivers/scsi/ufs/ufshcd.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index b207529..0af1aac 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -47,6 +47,7 @@
 #define _UFS_H
 
 #define MAX_CDB_SIZE	16
+#define MAX_SENSE_SIZE	18
 
 #define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
 			((byte3 << 24) | (byte2 << 16) |\
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3e4e102..662d00f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -479,7 +479,7 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sense_data_len);
 		memcpy(lrbp->sense_buffer,
 			lrbp->ucd_rsp_ptr->sense_data,
-			min_t(int, len, SCSI_SENSE_BUFFERSIZE));
+			min_t(int, len, MAX_SENSE_SIZE));
 	}
 }
 
-- 
1.7.5.4

