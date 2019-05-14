From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 1/2] scsi: libsas: only clear phy->in_shutdown after shutdown event done
Date: Tue, 14 May 2019 10:42:38 +0800
Message-ID: <20190514024239.47313-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, john.garry@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

When the event queue is full of phy up and down events and reached the
threshold, we will queue a shutdown-event, and set phy->in_shutdown so
that we will not queue a shutdown-event again. But before the
shutdown-event can be executed, every phy-down event will clear
phy->in_shutdown and a new shutdown-event will be queued. The queue will
be full of these shutdown-events.

Fix this by only clear phy->in_shutdown in sas_phye_shutdown(), that is
after the first shutdown-event has been executed.

Fixes: f12486e06ae8 ("scsi: libsas: shut down the PHY if events reached the threshold")
Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Hannes Reinecke <hare@suse.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_phy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index e030e1452136..b71f5ac6c7dc 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -35,7 +35,6 @@ static void sas_phye_loss_of_signal(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	phy->in_shutdown = 0;
 	phy->error = 0;
 	sas_deform_port(phy, 1);
 }
@@ -45,7 +44,6 @@ static void sas_phye_oob_done(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	phy->in_shutdown = 0;
 	phy->error = 0;
 }
 
@@ -126,6 +124,7 @@ static void sas_phye_shutdown(struct work_struct *work)
 				  ret);
 	} else
 		pr_notice("phy%d is not enabled, cannot shutdown\n", phy->id);
+	phy->in_shutdown = 0;
 }
 
 /* ---------- Phy class registration ---------- */
-- 
2.17.2
