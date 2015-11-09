From: Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v5 2/2] ibmvscsi: set max_lun to 32
Date: Mon,  9 Nov 2015 17:49:09 +0100
Message-ID: <1447087749-10828-3-git-send-email-lvivier@redhat.com>
References: <1447087749-10828-1-git-send-email-lvivier@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbbKIQtQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 11:49:16 -0500
In-Reply-To: <1447087749-10828-1-git-send-email-lvivier@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lvivier@redhat.com

As defined in 4.6.9 of SAM-4, the encoding of LUN is
on 5 bits (max_lun=32) and the current value is only 8.
Set max_lun to IBMVSCSI_MAX_LUN (32).

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index b153150..adfef9d 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2289,7 +2289,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 		goto init_pool_failed;
 	}
 
-	host->max_lun = 8;
+	host->max_lun = IBMVSCSI_MAX_LUN;
 	host->max_id = max_id;
 	host->max_channel = max_channel;
 	host->max_cmd_len = 16;
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.h b/drivers/scsi/ibmvscsi/ibmvscsi.h
index 7d64867..1067367 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.h
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
@@ -48,6 +48,7 @@ struct Scsi_Host;
 #define IBMVSCSI_CMDS_PER_LUN_DEFAULT 16
 #define IBMVSCSI_MAX_SECTORS_DEFAULT 256 /* 32 * 8 = default max I/O 32 pages */
 #define IBMVSCSI_MAX_CMDS_PER_LUN 64
+#define IBMVSCSI_MAX_LUN 32
 
 /* ------------------------------------------------------------
  * Data Structures
-- 
2.1.0

