From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] qla2xxx: negative error return in qla2x00_change_queue_depth()
Date: Fri, 29 Jan 2010 11:25:19 +0100
Message-ID: <4B62B78F.2010404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756948Ab0A2KTd@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The *change_queue_depth functions usually return a negative error return.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8529eb1..0753877 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1258,7 +1258,7 @@ qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 		qla2x00_adjust_sdev_qdepth_up(sdev, qdepth);
 		break;
 	default:
-		return EOPNOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	return sdev->queue_depth;
