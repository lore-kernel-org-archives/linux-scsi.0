From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 2/3] smartpqi: cleanup raid map warning message
Date: Wed, 27 Sep 2017 16:30:05 -0500
Message-ID: <150654780575.11494.9545979297048993619.stgit@brunhilda>
References: <150654770573.11494.168365142464423047.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0068.outbound.protection.outlook.com ([104.47.37.68]:19872
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751801AbdI0VaZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Sep 2017 17:30:25 -0400
In-Reply-To: <150654770573.11494.168365142464423047.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Fix a small cosmetic bug in a very rarely encountered
error message that can occur when a LD has a corrupted
raid map.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 677b88e..be83d92 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1078,9 +1078,9 @@ static int pqi_validate_raid_map(struct pqi_ctrl_info *ctrl_info,
 
 bad_raid_map:
 	dev_warn(&ctrl_info->pci_dev->dev,
-		"scsi %d:%d:%d:%d %s\n",
-		ctrl_info->scsi_host->host_no,
-		device->bus, device->target, device->lun, err_msg);
+		"logical device %08x%08x %s\n",
+		*((u32 *)&device->scsi3addr),
+		*((u32 *)&device->scsi3addr[4]), err_msg);
 
 	return -EINVAL;
 }
