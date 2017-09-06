From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 11/11] libsas: add event to defer list tail instead of head when draining
Date: Wed, 6 Sep 2017 17:15:14 +0800
Message-ID: <1504689314-20072-12-git-send-email-yanaijie@huawei.com>
References: <1504689314-20072-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504689314-20072-1-git-send-email-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, chenweilong@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, yanaijie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: chenxiang <chenxiang66@hisilicon.com>

Events will be added to defer_q list when setting ha->status to
SAS_HA_DRAINING. Events will be called after drain workqueue.

Those events are added to the head of list, but they are scanned one
by one from the head to the tail, which will cause those events be
called in the reverse order of being added. So change list_add to
list_add_tail in function sas_queue_work.

Signed-off-by: chenxiang <chenxiang66@hisilicon.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index c120657..b124198 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -38,7 +38,7 @@ int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
 	if (test_bit(SAS_HA_DRAINING, &ha->state)) {
 		/* add it to the defer list, if not already pending */
 		if (list_empty(&sw->drain_node))
-			list_add(&sw->drain_node, &ha->defer_q);
+			list_add_tail(&sw->drain_node, &ha->defer_q);
 	} else
 		rc = queue_work(ha->event_q, &sw->work);
 
-- 
2.5.0
