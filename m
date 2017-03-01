From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] libsas: add sas_unregister_devs_sas_addr in flutter case
Date: Wed, 1 Mar 2017 09:23:29 +0800
Message-ID: <1488331409-11336-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, miaoxie@huawei.com, fangwei1@huawei.com, wangyijing@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>
List-Id: linux-scsi@vger.kernel.org

In sas_rediscover_dev when we call sas_get_phy_attached_dev to find the
device is ok and when in the flutter case when we call
sas_ex_phy_discover the device is gone, the sas_addr was changed to
zero.
[300247.584696] sas: ex 500e004aaaaaaa1f phy0 originated
BROADCAST(CHANGE)
[300247.663516] sas: ex 500e004aaaaaaa1f phy00:U:0 attached:
0000000000000000 (no device)
[300247.663518] sas: ex 500e004aaaaaaa1f phy 0x0 broadcast flutter

When the device is up again, the libsas checked that the old sas_addr
zero so just add a new device.
[300247.846326] sas: Expander phy change count has changed
[300247.846418] sas: ex 500e004aaaaaaa1f phy0 originated
BROADCAST(CHANGE)
[300247.846420] sas: ex 500e004aaaaaaa1f phy0 new device attached
[300247.846519] sas: ex 500e004aaaaaaa1f phy00:U:A attached:
500e004aaaaaaa00 (stp)
[300247.875873] sas: done REVALIDATING DOMAIN on port 0, pid:12565, res
0x0

This will cause a panic when these two device were destroyed. Fix this
by call sas_unregister_devs_sas_addr in the flutter case if the sas_addr
is zero.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 570b2cb..1a784d7 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2032,6 +2032,11 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 
 		sas_ex_phy_discover(dev, phy_id);
 
+		if (!SAS_ADDR(phy->attached_sas_addr)) {
+			sas_unregister_devs_sas_addr(dev, phy_id, last);
+			return res;
+		}
+
 		if (ata_dev && phy->attached_dev_type == SAS_SATA_PENDING)
 			action = ", needs recovery";
 		SAS_DPRINTK("ex %016llx phy 0x%x broadcast flutter%s\n",
-- 
2.5.0
