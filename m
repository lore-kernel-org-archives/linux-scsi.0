From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] scsi: libsas: no need to join wide port again in sas_ex_discover_dev()
Date: Sat, 18 May 2019 17:40:57 +0800
Message-ID: <20190518094057.18046-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, john.garry@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Since we are processing events synchronously now, the second call of
sas_ex_join_wide_port() in sas_ex_discover_dev() is not needed. There
will be no races with other works in disco workqueue. So remove the
second sas_ex_join_wide_port().

I did not change the return value of 'res' to error when discover failed
because we need to continue to discover other phys if one phy discover
failed. So let's keep that logic as before and just add a debug log to
detect the failure.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 83f2fd70ce76..8f90dd497dfe 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1116,27 +1116,9 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 		break;
 	}
 
-	if (child) {
-		int i;
-
-		for (i = 0; i < ex->num_phys; i++) {
-			if (ex->ex_phy[i].phy_state == PHY_VACANT ||
-			    ex->ex_phy[i].phy_state == PHY_NOT_PRESENT)
-				continue;
-			/*
-			 * Due to races, the phy might not get added to the
-			 * wide port, so we add the phy to the wide port here.
-			 */
-			if (SAS_ADDR(ex->ex_phy[i].attached_sas_addr) ==
-			    SAS_ADDR(child->sas_addr)) {
-				ex->ex_phy[i].phy_state= PHY_DEVICE_DISCOVERED;
-				if (sas_ex_join_wide_port(dev, i))
-					pr_debug("Attaching ex phy%02d to wide port %016llx\n",
-						 i, SAS_ADDR(ex->ex_phy[i].attached_sas_addr));
-			}
-		}
-	}
-
+	if (!child)
+		pr_debug("Ex %016llx phy%02d failed to discover\n",
+			 SAS_ADDR(dev->sas_addr), phy_id);
 	return res;
 }
 
-- 
2.17.2
