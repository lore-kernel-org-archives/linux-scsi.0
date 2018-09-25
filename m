From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 2/5] scsi: libsas: make the lldd_port_deformed method optional
Date: Tue, 25 Sep 2018 10:56:51 +0800
Message-ID: <20180925025654.44053-3-yanaijie@huawei.com>
References: <20180925025654.44053-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180925025654.44053-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Now LLDDs have to implement lldd_port_deformed method otherwise NULL
dereference will happen. Make it optional and remove the dummy
implementation in hisi_sas.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Hannes Reinecke <hare@suse.com>
Acked-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 9 ++-------
 drivers/scsi/libsas/sas_discover.c    | 2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a4e2e6aa9a6b..1975c9266978 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1861,10 +1861,6 @@ static void hisi_sas_port_formed(struct asd_sas_phy *sas_phy)
 	hisi_sas_port_notify_formed(sas_phy);
 }
 
-static void hisi_sas_port_deformed(struct asd_sas_phy *sas_phy)
-{
-}
-
 static int hisi_sas_write_gpio(struct sas_ha_struct *sha, u8 reg_type,
 			u8 reg_index, u8 reg_count, u8 *write_data)
 {
@@ -1954,10 +1950,9 @@ static struct sas_domain_function_template hisi_sas_transport_ops = {
 	.lldd_I_T_nexus_reset	= hisi_sas_I_T_nexus_reset,
 	.lldd_lu_reset		= hisi_sas_lu_reset,
 	.lldd_query_task	= hisi_sas_query_task,
-	.lldd_clear_nexus_ha = hisi_sas_clear_nexus_ha,
+	.lldd_clear_nexus_ha	= hisi_sas_clear_nexus_ha,
 	.lldd_port_formed	= hisi_sas_port_formed,
-	.lldd_port_deformed = hisi_sas_port_deformed,
-	.lldd_write_gpio = hisi_sas_write_gpio,
+	.lldd_write_gpio	= hisi_sas_write_gpio,
 };
 
 void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 0148ae62a52a..dde433aa59c2 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -260,7 +260,7 @@ static void sas_suspend_devices(struct work_struct *work)
 	 * phy_list is not being mutated
 	 */
 	list_for_each_entry(phy, &port->phy_list, port_phy_el) {
-		if (si->dft->lldd_port_formed)
+		if (si->dft->lldd_port_deformed)
 			si->dft->lldd_port_deformed(phy);
 		phy->suspended = 1;
 		port->suspended = 1;
-- 
2.14.4
