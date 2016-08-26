From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 13/17] smartpqi: remove timeout for cache flush operations
Date: Fri, 26 Aug 2016 11:45:24 -0500
Message-ID: <147222992420.31214.16768734205314588696.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0085.outbound.protection.outlook.com ([104.47.38.85]:61701
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752840AbcHZRCH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:02:07 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Some cache flush operations can take longer than the
timeout value. Best to not impose a time limit to
handle all cases.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 87eb603..e7d7e99 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -407,7 +407,6 @@ static int pqi_identify_physical_device(struct pqi_ctrl_info *ctrl_info,
 }
 
 #define SA_CACHE_FLUSH_BUFFER_LENGTH	4
-#define PQI_FLUSH_CACHE_TIMEOUT		(30 * 1000)
 
 static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info)
 {
@@ -434,7 +433,7 @@ static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info)
 		goto out;
 
 	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		0, NULL, PQI_FLUSH_CACHE_TIMEOUT);
+		0, NULL, NO_TIMEOUT);
 
 	pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1,
 		pci_direction);

