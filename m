From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] scsi_transport_srp: Fix shost to rport translation
Date: Thu, 12 Apr 2018 13:32:07 -0600
Message-ID: <20180412193207.13253-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Since an SRP remote port is attached as a child to shost->shost_gendev
and as the only child, the translation from the shost pointer into an
rport pointer must happen by looking up the shost child that is an
rport. This patch fixes the following KASAN complaint:

BUG: KASAN: slab-out-of-bounds in srp_timed_out+0x57/0x110 [scsi_transport_srp]
Read of size 4 at addr ffff880035d3fcc0 by task kworker/1:0H/19

CPU: 1 PID: 19 Comm: kworker/1:0H Not tainted 4.16.0-rc3-dbg+ #1
Workqueue: kblockd blk_mq_timeout_work
Call Trace:
dump_stack+0x85/0xc7
print_address_description+0x65/0x270
kasan_report+0x231/0x350
srp_timed_out+0x57/0x110 [scsi_transport_srp]
scsi_times_out+0xc7/0x3f0 [scsi_mod]
blk_mq_terminate_expired+0xc2/0x140
bt_iter+0xbc/0xd0
blk_mq_queue_tag_busy_iter+0x1c7/0x350
blk_mq_timeout_work+0x325/0x3f0
process_one_work+0x441/0xa50
worker_thread+0x76/0x6c0
kthread+0x1b2/0x1d0
ret_from_fork+0x24/0x30

Fixes: e68ca75200fe ("scsi_transport_srp: Reduce failover time")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/scsi_transport_srp.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 36f6190931bc..0d0515615847 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -51,6 +51,8 @@ struct srp_internal {
 	struct transport_container rport_attr_cont;
 };
 
+static int scsi_is_srp_rport(const struct device *dev);
+
 #define to_srp_internal(tmpl) container_of(tmpl, struct srp_internal, t)
 
 #define	dev_to_rport(d)	container_of(d, struct srp_rport, dev)
@@ -60,9 +62,24 @@ static inline struct Scsi_Host *rport_to_shost(struct srp_rport *r)
 	return dev_to_shost(r->dev.parent);
 }
 
+static int find_child_rport(struct device *dev, void *data)
+{
+	struct device **child = data;
+
+	if (scsi_is_srp_rport(dev)) {
+		WARN_ON_ONCE(*child);
+		*child = dev;
+	}
+	return 0;
+}
+
 static inline struct srp_rport *shost_to_rport(struct Scsi_Host *shost)
 {
-	return transport_class_to_srp_rport(&shost->shost_gendev);
+	struct device *child = NULL;
+
+	WARN_ON_ONCE(device_for_each_child(&shost->shost_gendev, &child,
+					   find_child_rport) < 0);
+	return child ? dev_to_rport(child) : NULL;
 }
 
 /**
-- 
2.16.2
