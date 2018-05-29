From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 8/8] scsi: libsas: support SATA phy link rate unmatch the pathway
Date: Tue, 29 May 2018 10:23:09 +0800
Message-ID: <20180529022309.21071-9-yanaijie@huawei.com>
References: <20180529022309.21071-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529022309.21071-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>, chenqilin <chenqilin2@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

If a SATA disk attached to a expander phy and it's linkrate is greater
than the expander host phy's linkrate, the disk will failed to discover.
The topology is like below:

   +----------+           +----------+
   |          |           |          |
   |          |-- 3.0 G --|          |-- 6.0 G -- SAS  disk
   |          |           |          |
   |          |-- 3.0 G --|          |-- 6.0 G -- SAS  disk
   |initiator |           |          |
   | device   |-- 3.0 G --| Expander |-- 6.0 G -- SAS  disk
   |          |           |          |
   |          |-- 3.0 G --|          |-- 6.0 G -- SATA disk  -->failed to connect
   |          |           |          |
   |          |           |          |-- 6.0 G -- SATA disk  -->failed to connect
   |          |           |          |
   +----------+           +----------+

And when we check the sas protocal spec, this scenario is described as
this:

7.13 Rate matching
......
If an expander phy attached to a SATA phy is using a physical link rate
greater than the maximum connection rate supported by the pathway from
an STP initiator port, a management application client should use the
SMP PHY CONTROL function (see 10.4.3.10) to set the PROGRAMMED MAXIMUM
PHYSICAL LINK RATE field of the expander phy to the maximum connection
rate supported by the pathway from that STP initiator port.

In order to support this scenario, checking the SATA disk's linkrate
to see if it is greater than any phy's linkrate it may pass through.
Remember the minimum linkrate of the pathway and set the SATA phy
linkrate to it using the SMP PHY CONTROL function.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: chenxiang <chenxiang66@hisilicon.com>
CC: John Garry <john.garry@huawei.com>
CC: chenqilin <chenqilin2@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libsas/sas_ata.c      | 113 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_discover.c |   2 +
 drivers/scsi/libsas/sas_port.c     |   2 +
 include/scsi/sas_ata.h             |   6 ++
 4 files changed, 123 insertions(+)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 83f2c920480b..0cddce9bf1c8 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -388,6 +388,119 @@ static int sas_ata_printk(const char *level, const struct domain_device *ddev,
 	return r;
 }
 
+static enum sas_linkrate sas_find_min_pathway(struct domain_device *ddev)
+{
+	enum sas_linkrate min_linkrate = SAS_LINK_RATE_12_0_GBPS;
+	struct domain_device *child;
+	struct expander_device *ex;
+	struct asd_sas_phy *phy;
+	int i;
+
+	child = ddev;
+	ddev = ddev->parent;
+
+	while (ddev) {
+		if (ddev->dev_type != SAS_EDGE_EXPANDER_DEVICE &&
+		    ddev->dev_type != SAS_FANOUT_EXPANDER_DEVICE)
+			break;
+
+		ex = &ddev->ex_dev;
+
+		for (i = 0; i < ex->num_phys; i++) {
+			struct ex_phy *phy = &ex->ex_phy[i];
+
+			if (phy->phy_state == PHY_VACANT ||
+			    phy->phy_state == PHY_NOT_PRESENT)
+				continue;
+
+			if (phy->linkrate < SAS_LINK_RATE_1_5_GBPS)
+				continue;
+
+			if (SAS_ADDR(phy->attached_sas_addr) == SAS_ADDR(child->sas_addr))
+				if (min_linkrate > phy->linkrate)
+					min_linkrate = phy->linkrate;
+		}
+
+		child = ddev;
+		ddev = ddev->parent;
+	}
+
+	/* check the direct attached phy linkrate */
+	list_for_each_entry(phy, &child->port->phy_list, port_phy_el) {
+		if (SAS_ADDR(phy->attached_sas_addr) == SAS_ADDR(child->sas_addr))
+			if (min_linkrate > phy->linkrate)
+				min_linkrate = phy->linkrate;
+	}
+
+	return min_linkrate;
+}
+
+static void sas_ata_check_pathway(void *data, async_cookie_t cookie)
+{
+	struct domain_device *dev = data;
+	struct domain_device *ddev = dev->parent;
+	struct sas_phy_linkrates rates;
+	enum sas_linkrate linkrate;
+	int ret;
+
+	if (!ddev) {
+		sas_put_device(dev);
+		return;
+	}
+
+	/*
+	 * According to Serial Attached SCSI - 1.1 (SAS-1.1):
+	 * If an expander phy attached to a SATA phy is using a physical link
+	 * rate greater than the maximum connection rate supported by the
+	 * pathway from an STP initiator port, a management application client
+	 * should use the SMP PHY CONTROL function (see 10.4.3.10) to set the
+	 * PROGRAMMED MAXIMUM PHYSICAL LINK RATE field of the expander phy to
+	 * the maximum connection rate supported by the pathway from that STP
+	 * initiator port.
+	 */
+
+	linkrate = sas_find_min_pathway(ddev);
+
+	if (dev->linkrate > linkrate) {
+		struct sas_phy *phy = sas_get_local_phy(dev);
+
+		rates.minimum_linkrate = 0;
+		rates.maximum_linkrate = linkrate;
+		ret = sas_smp_phy_control(ddev, phy->number,
+			PHY_FUNC_LINK_RESET, &rates);
+
+		SAS_DPRINTK("ex %016llx phy%02d set max linkrate to %X %s\n",
+			    SAS_ADDR(ddev->sas_addr), phy->number, linkrate,
+			    ret ? "failed" : "succeed");
+		sas_put_local_phy(phy);
+	}
+
+	sas_put_device(dev);
+}
+
+void sas_ata_check_topology(struct asd_sas_port *port)
+{
+	ASYNC_DOMAIN_EXCLUSIVE(async);
+	struct domain_device *dev;
+
+	spin_lock(&port->dev_list_lock);
+	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
+		if (!dev_is_sata(dev))
+			continue;
+
+		/* hold a reference since we may be
+		 * racing with final remove
+		 */
+		kref_get(&dev->kref);
+
+		async_schedule_domain(sas_ata_check_pathway, dev, &async);
+	}
+	spin_unlock(&port->dev_list_lock);
+
+	async_synchronize_full_domain(&async);
+
+}
+
 static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
 			      unsigned long deadline)
 {
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 354f6db5bb66..34bfc622b910 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -529,6 +529,8 @@ static void sas_revalidate_domain(struct work_struct *work)
 	sas_destruct_devices(port);
 	sas_destruct_ports(port);
 	sas_probe_devices(port);
+
+	sas_ata_check_topology(port);
 }
 
 /* ---------- Events ---------- */
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index fad23dd39114..ddf004bf667e 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -194,6 +194,8 @@ static void sas_form_port(struct asd_sas_phy *phy)
 
 	sas_discover_event(phy->port, DISCE_DISCOVER_DOMAIN);
 	flush_workqueue(sas_ha->disco_q);
+
+	sas_ata_check_topology(port);
 }
 
 /**
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 00f41aeeecf5..9be6437c3777 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -48,6 +48,7 @@ void sas_probe_sata(struct asd_sas_port *port);
 void sas_suspend_sata(struct asd_sas_port *port);
 void sas_resume_sata(struct asd_sas_port *port);
 void sas_ata_end_eh(struct ata_port *ap);
+void sas_ata_check_topology(struct asd_sas_port *port);
 #else
 
 
@@ -100,6 +101,11 @@ static inline int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy
 static inline void sas_ata_end_eh(struct ata_port *ap)
 {
 }
+
+static inline void sas_ata_check_topology(struct asd_sas_port *port)
+{
+}
+
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
2.13.6
