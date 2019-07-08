From: Denis Efremov <efremov@linux.com>
Subject: [PATCH] scsi: libsas: remove the exporting of sas_wait_eh
Date: Mon,  8 Jul 2019 19:43:39 +0300
Message-ID: <20190708164339.14465-1-efremov@linux.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Denis Efremov <efremov@linux.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The function sas_wait_eh is declared static and marked
EXPORT_SYMBOL, which is at best an odd combination. Because the
function is not used outside of the drivers/scsi/libsas/sas_scsi_host.c
file it is defined in, this commit removes the EXPORT_SYMBOL() marking.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index ede0674d8399..5564d3f1243a 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -414,7 +414,6 @@ static void sas_wait_eh(struct domain_device *dev)
 		goto retry;
 	}
 }
-EXPORT_SYMBOL(sas_wait_eh);
 
 static int sas_queue_reset(struct domain_device *dev, int reset_type,
 			   u64 lun, int wait)
-- 
2.21.0
