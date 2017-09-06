From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 04/11] libsas: rename notify_port_event() for consistency
Date: Wed, 6 Sep 2017 17:15:07 +0800
Message-ID: <1504689314-20072-5-git-send-email-yanaijie@huawei.com>
References: <1504689314-20072-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504689314-20072-1-git-send-email-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, chenweilong@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, yanaijie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Rename function notify_port_event() to sas_notify_port_event(), which
will be consistent with sas_notify_phy_event().

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 70c4653..3e225ef 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -124,7 +124,7 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
 	mutex_unlock(&ha->disco_mutex);
 }
 
-static int notify_port_event(struct asd_sas_phy *phy, enum port_event event)
+static int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 {
 	struct sas_ha_struct *ha = phy->ha;
 
@@ -146,7 +146,7 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 
 int sas_init_events(struct sas_ha_struct *sas_ha)
 {
-	sas_ha->notify_port_event = notify_port_event;
+	sas_ha->notify_port_event = sas_notify_port_event;
 	sas_ha->notify_phy_event = sas_notify_phy_event;
 
 	return 0;
-- 
2.5.0
