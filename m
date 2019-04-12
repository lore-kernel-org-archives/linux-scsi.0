From: John Garry <john.garry@huawei.com>
Subject: [PATCH 5/6] scsi: libsas: Do discovery on empty PHY to update PHY info
Date: Fri, 12 Apr 2019 16:57:56 +0800
Message-ID: <1555059478-36224-6-git-send-email-john.garry@huawei.com>
References: <1555059478-36224-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1555059478-36224-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, yanaijie@huawei.com, chenxiang66@hisilicon.com, luojiaxing@huawei.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

When we discover the PHY is empty in sas_rediscover_dev(), the PHY
information (like negotiated linkrate) is not updated.

As such, for a user examining sysfs for that PHY, they would see
incorrect values:
root@(none)$ cd /sys/class/sas_phy/phy-0:0:20
root@(none)$ more negotiated_linkrate
3.0 Gbit
root@(none)$ echo 0 > enable
root@(none)$ more negotiated_linkrate
3.0 Gbit

So fix this, simply discover the PHY again, even though we know it's
empty; in the above example, this gives us:
root@(none)$ more negotiated_linkrate
Phy disabled

We must do this after unregistering the device associated with the PHY
(in sas_unregister_devs_sas_addr()).

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 6f569a65d791..ad96bc843acc 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2068,6 +2068,11 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
 	if ((SAS_ADDR(sas_addr) == 0) || (res == -ECOMM)) {
 		phy->phy_state = PHY_EMPTY;
 		sas_unregister_devs_sas_addr(dev, phy_id, last);
+		/*
+		 * Even though the PHY is empty, for convenience we discover
+		 * the PHY to update the PHY info, like negotiated linkrate.
+		 */
+		sas_ex_phy_discover(dev, phy_id);
 		return res;
 	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
 		   dev_type_flutter(type, phy->attached_dev_type)) {
-- 
2.17.1
