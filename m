From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 1/7] scsi: libsas: reset the negotiated_linkrate when phy is down
Date: Wed, 30 Jan 2019 16:24:06 +0800
Message-ID: <20190130082412.9357-2-yanaijie@huawei.com>
References: <20190130082412.9357-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190130082412.9357-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

If the device is unplugged or disconnected, the negotiated_linkrate
still can be seen from the userspace by sysfs. This makes people
confused and leaks information of the device last used. So let's reset
the negotiated_linkrate after the phy is down.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libsas/sas_expander.c | 2 ++
 include/scsi/libsas.h              | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 17eb4185f29d..7b0e6dcef6e6 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1904,6 +1904,8 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 				&parent->port->sas_port_del_list);
 		phy->port = NULL;
 	}
+	if (phy->phy)
+		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
 }
 
 static int sas_discover_bfs_by_root_level(struct domain_device *root,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3de3b10da19a..420156cea3ee 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -448,6 +448,9 @@ static inline void sas_phy_disconnected(struct asd_sas_phy *phy)
 {
 	phy->oob_mode = OOB_NOT_CONNECTED;
 	phy->linkrate = SAS_LINK_RATE_UNKNOWN;
+
+	if (phy->phy)
+		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
 }
 
 static inline unsigned int to_sas_gpio_od(int device, int bit)
-- 
2.14.4
