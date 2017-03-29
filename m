From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/2] scsi: sas: flush destruct workqueue on device unregister
Date: Wed, 29 Mar 2017 11:41:08 +0200
Message-ID: <9580eaf323f5da17dcace9e32b22a1df4099961d.1490775958.git.jthumshirn@suse.de>
References: <cover.1490775958.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1490775958.git.jthumshirn@suse.de>
In-Reply-To: <cover.1490775958.git.jthumshirn@suse.de>
References: <cover.1490775958.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, John Garry <john.garry@huawei.com>, Jack Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

In the advent of an SAS device unregister we have to wait for all destruct
works to be done to not accidently delay deletion of a SAS rphy or it's
children to the point when we're removing the SCSI or SAS hosts.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/libsas/sas_discover.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 60de662..75b18f1 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -382,9 +382,13 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 	}
 
 	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
+		struct sas_discovery *disc = &dev->port->disc;
+		struct sas_work *sw = &disc->disc_work[DISCE_DESTRUCT].work;
+
 		sas_rphy_unlink(dev->rphy);
 		list_move_tail(&dev->disco_list_node, &port->destroy_list);
 		sas_discover_event(dev->port, DISCE_DESTRUCT);
+		flush_work(&sw->work);
 	}
 }
 
-- 
1.8.5.6
