From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/6] scsi: libsas: Try to retain programmed min linkrate for SATA min pathway unmatch fixing
Date: Fri, 12 Apr 2019 16:57:53 +0800
Message-ID: <1555059478-36224-3-git-send-email-john.garry@huawei.com>
References: <1555059478-36224-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1555059478-36224-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, yanaijie@huawei.com, chenxiang66@hisilicon.com, luojiaxing@huawei.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently for fixing the linkrate matching during discovery such that
the linkrate of a SATA PHY does not exceed min pathway to initiator,
we set the SATA PHY programmed min linkrate to the same value as the
programmed max linkrate.

This is unnecessary, and we should be able to keep the same programmed
min linkrate if it is already lower than this new max programmed linkrate.

This patch makes that change.

In effect, this will not make much difference since we generally will
negotiate a linkrate at the programmed max linkrate, and the programmed
min linkrate will have no impact.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 93f297199d4c..dfdf3c94d326 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -826,9 +826,14 @@ static struct domain_device *sas_ex_discover_end_dev(
 #ifdef CONFIG_SCSI_SAS_ATA
 	if ((phy->attached_tproto & SAS_PROTOCOL_STP) || phy->attached_sata_dev) {
 		if (child->linkrate > parent->min_linkrate) {
+			struct sas_phy *cphy = child->phy;
+			enum sas_linkrate min_prate = cphy->minimum_linkrate,
+				parent_min_lrate = parent->min_linkrate,
+				min_linkrate = (min_prate > parent_min_lrate) ?
+					       parent_min_lrate : 0;
 			struct sas_phy_linkrates rates = {
 				.maximum_linkrate = parent->min_linkrate,
-				.minimum_linkrate = parent->min_linkrate,
+				.minimum_linkrate = min_linkrate,
 			};
 			int ret;
 
-- 
2.17.1
