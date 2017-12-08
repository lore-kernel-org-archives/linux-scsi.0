From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 7/7] scsi: libsas: notify event PORTE_BROADCAST_RCVD in sas_enable_revalidation()
Date: Fri, 8 Dec 2017 17:42:10 +0800
Message-ID: <20171208094210.24887-8-yanaijie@huawei.com>
References: <20171208094210.24887-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171208094210.24887-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiyou.wangcong@gmail.com, Jason Yan <yanaijie@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

There are two places queuing the disco event DISCE_REVALIDATE_DOMAIN.
One is in sas_porte_broadcast_rcvd() and uses sas_chain_event() to queue
the event. The other is in sas_enable_revalidation() and uses
sas_queue_event() to queue the event. We have diffrent work queues for
event and discovery now, so the DISCE_REVALIDATE_DOMAIN event may be
processed in both event queue and discovery queue.

Now since we do synchronous event handling, we cannot do it in discovery
queue, so have to trigger a fake broadcast event to re-trigger the
revalidation from event queue.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_event.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 8c82c00..ae923eb 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -116,11 +116,17 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
 		struct asd_sas_port *port = ha->sas_port[i];
 		const int ev = DISCE_REVALIDATE_DOMAIN;
 		struct sas_discovery *d = &port->disc;
+		struct asd_sas_phy *sas_phy;
 
 		if (!test_and_clear_bit(ev, &d->pending))
 			continue;
 
-		sas_queue_event(ev, &d->disc_work[ev].work, ha);
+		if (list_empty(&port->phy_list))
+			continue;
+
+		sas_phy = container_of(port->phy_list.next, struct asd_sas_phy,
+				port_phy_el);
+		ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 	}
 	mutex_unlock(&ha->disco_mutex);
 }
-- 
2.9.5
