From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 7/8] scsi: libsas: fix issue of swapping two sas disks
Date: Tue, 29 May 2018 10:23:08 +0800
Message-ID: <20180529022309.21071-8-yanaijie@huawei.com>
References: <20180529022309.21071-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529022309.21071-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>, Xiaofei Tan <tanxiaofei@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

The work flow of revalidation now is scanning expander phy by the
sequence of the phy and check if the phy have changed. This will leads
to an issue of swapping two sas disks on one expander.

Assume we have two sas disks, connected with expander phy10 and phy11:

phy10: 5000cca04eb1001d  port-0:0:10
phy11: 5000cca04eb043ad  port-0:0:11

Swap these two disks, and imaging the following scenario:

revalidation 1:
  -->phy10: 0 --> delete phy10 domain device
  -->phy11: 5000cca04eb043ad (no change)
revalidation done

revalidation 2:
  -->step 1, check phy10:
  -->phy10: 5000cca04eb043ad   --> add to wide port(port-0:0:11) (phy11
       address is still 5000cca04eb043ad now)

  -->step 2, check phy11:
  -->phy11: 0  --> phy11 address is 0 now, but it's part of wide
       port(port-0:0:11), the domain device will not be deleted.
revalidation done

revalidation 3:
  -->phy10, 5000cca04eb043ad (no change)
  -->phy11: 5000cca04eb1001d --> try to add port-0:0:11 but failed,
       port-0:0:11 already exist, trigger a warning as follows
revalidation done

[14790.189699] sysfs: cannot create duplicate filename
'/devices/pci0000:74/0000:74:02.0/host0/port-0:0/expander-0:0/port-0:0:11'
[14790.201081] CPU: 25 PID: 5031 Comm: kworker/u192:3 Not tainted
4.16.0-rc1-191134-g138f084-dirty #228
[14790.210199] Hardware name: Huawei D06/D06, BIOS Hisilicon D06 EC UEFI
Nemo 2.0 RC0 - B303 05/16/2018
[14790.219323] Workqueue: 0000:74:02.0_disco_q sas_revalidate_domain
[14790.225404] Call trace:
[14790.227842]  dump_backtrace+0x0/0x18c
[14790.231492]  show_stack+0x14/0x1c
[14790.234798]  dump_stack+0x88/0xac
[14790.238101]  sysfs_warn_dup+0x64/0x7c
[14790.241751]  sysfs_create_dir_ns+0x90/0xa0
[14790.245835]  kobject_add_internal+0xa0/0x284
[14790.250092]  kobject_add+0xb8/0x11c
[14790.253570]  device_add+0xe8/0x598
[14790.256960]  sas_port_add+0x24/0x50
[14790.260436]  sas_ex_discover_devices+0xb10/0xc30
[14790.265040]  sas_ex_revalidate_domain+0x1d8/0x518
[14790.269731]  sas_revalidate_domain+0x12c/0x154
[14790.274163]  process_one_work+0x128/0x2b0
[14790.278160]  worker_thread+0x14c/0x408
[14790.281897]  kthread+0xfc/0x128
[14790.285026]  ret_from_fork+0x10/0x18
[14790.288598] ------------[ cut here ]------------

At last, the disk 5000cca04eb1001d is lost.

The basic idea of fix this issue is to let the revalidation first scan
all phys, and then unregisterring devices. Only when no devices need to
be unregisterred, go to the next step to discover new devices. If there
are devices need unregister, unregister those devices and raise a new
bcast. The next revalidation will process the discovering of the new
devices.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: Xiaofei Tan <tanxiaofei@huawei.com>
CC: chenxiang <chenxiang66@hisilicon.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libsas/sas_expander.c | 149 ++++++++++++++++++++++++++++---------
 1 file changed, 112 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 6b6de85466c6..52d96965191c 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2022,8 +2022,6 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
-	struct asd_sas_port *port = dev->port;
-	struct asd_sas_phy *sas_phy;
 	enum sas_device_type type = SAS_PHY_UNUSED;
 	u8 sas_addr[8];
 	int res;
@@ -2101,10 +2099,6 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 
 	/* force the next revalidation find this phy and bring it up */
 	phy->phy_change_count = -1;
-	ex->ex_change_count = -1;
-	sas_phy = container_of(port->phy_list.next, struct asd_sas_phy,
-			port_phy_el);
-	port->ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 
 	return 0;
 }
@@ -2127,30 +2121,74 @@ static int sas_rediscover(struct domain_device *dev, const int phy_id)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *changed_phy = &ex->ex_phy[phy_id];
-	int res = 0;
 	int i;
 	bool last = true;	/* is this the last phy of the port */
 
-	SAS_DPRINTK("ex %016llx phy%d originated BROADCAST(CHANGE)\n",
-		    SAS_ADDR(dev->sas_addr), phy_id);
+	for (i = 0; i < ex->num_phys; i++) {
+		struct ex_phy *phy = &ex->ex_phy[i];
 
-	if (SAS_ADDR(changed_phy->attached_sas_addr) != 0) {
-		for (i = 0; i < ex->num_phys; i++) {
-			struct ex_phy *phy = &ex->ex_phy[i];
+		if (i == phy_id)
+			continue;
+		if (SAS_ADDR(phy->attached_sas_addr) ==
+		    SAS_ADDR(changed_phy->attached_sas_addr)) {
+			SAS_DPRINTK("phy%d part of wide port with "
+				    "phy%d\n", phy_id, i);
+			last = false;
+			break;
+		}
+	}
+	return sas_rediscover_dev(dev, phy_id, last);
+}
 
-			if (i == phy_id)
-				continue;
-			if (SAS_ADDR(phy->attached_sas_addr) ==
-			    SAS_ADDR(changed_phy->attached_sas_addr)) {
-				SAS_DPRINTK("phy%d part of wide port with "
-					    "phy%d\n", phy_id, i);
-				last = false;
-				break;
-			}
+static inline int sas_ex_unregister(struct domain_device *dev,
+				 u8 *changed_phy,
+				 int nr)
+{
+	struct expander_device *ex = &dev->ex_dev;
+	int unregistered = 0;
+	struct ex_phy *phy;
+	int res;
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		SAS_DPRINTK("ex %016llx phy%d originated BROADCAST(CHANGE)\n",
+			    SAS_ADDR(dev->sas_addr), changed_phy[i]);
+
+		phy = &ex->ex_phy[changed_phy[i]];
+
+		if (SAS_ADDR(phy->attached_sas_addr) != 0) {
+			res = sas_rediscover(dev, changed_phy[i]);
+			changed_phy[i] = 0xff;
+			unregistered++;
 		}
-		res = sas_rediscover_dev(dev, phy_id, last);
-	} else
-		res = sas_discover_new(dev, phy_id);
+	}
+
+	return unregistered;
+}
+
+static inline int sas_ex_register(struct domain_device *dev,
+				 u8 *changed_phy,
+				 int nr)
+{
+	struct expander_device *ex = &dev->ex_dev;
+	struct ex_phy *phy;
+	int res = 0;
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		if (changed_phy[i] == 0xff)
+			continue;
+
+		phy = &ex->ex_phy[changed_phy[i]];
+
+		WARN(SAS_ADDR(phy->attached_sas_addr) != 0,
+		     "phy%02d impossible attached_sas_addr %016llx\n",
+		     changed_phy[i],
+		     SAS_ADDR(phy->attached_sas_addr));
+
+		res = sas_discover_new(dev, changed_phy[i]);
+	}
+
 	return res;
 }
 
@@ -2166,23 +2204,60 @@ static int sas_rediscover(struct domain_device *dev, const int phy_id)
 int sas_ex_revalidate_domain(struct domain_device *port_dev)
 {
 	int res;
+	struct expander_device *ex;
 	struct domain_device *dev = NULL;
+	u8 changed_phy[MAX_EXPANDER_PHYS];
+	int unregistered = 0;
+	int phy_id;
+	int nr = 0;
+	int i = 0;
 
 	res = sas_find_bcast_dev(port_dev, &dev);
-	if (res == 0 && dev) {
-		struct expander_device *ex = &dev->ex_dev;
-		int i = 0, phy_id;
-
-		do {
-			phy_id = -1;
-			res = sas_find_bcast_phy(dev, &phy_id, i, true);
-			if (phy_id == -1)
-				break;
-			res = sas_rediscover(dev, phy_id);
-			i = phy_id + 1;
-		} while (i < ex->num_phys);
+	if (res != 0 || !dev)
+		return res;
+
+	memset(changed_phy, 0xff, MAX_EXPANDER_PHYS);
+	ex = &dev->ex_dev;
+
+	do {
+		phy_id = -1;
+		res = sas_find_bcast_phy(dev, &phy_id, i, true);
+		if (phy_id == -1)
+			break;
+		changed_phy[nr++] = phy_id;
+		i = phy_id + 1;
+	} while (i < dev->ex_dev.num_phys);
+
+	if (nr == 0)
+		return res;
+
+	unregistered = sas_ex_unregister(dev, changed_phy, nr);
+
+	/* we have unregistered some devices in this pass and need to
+	 * go again to pick up on any new devices on a separate pass
+	 */
+	if (unregistered > 0) {
+		struct asd_sas_port *port = dev->port;
+		struct asd_sas_phy *sas_phy;
+		struct ex_phy *phy;
+
+		for (i = 0; i < nr; i++) {
+			if (changed_phy[i] == 0xff)
+				continue;
+			phy = &ex->ex_phy[changed_phy[i]];
+			phy->phy_change_count = -1;
+		}
+		ex->ex_change_count = -1;
+
+		sas_phy = container_of(dev->port->phy_list.next,
+				struct asd_sas_phy,
+				port_phy_el);
+		port->ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+
+		return 0;
 	}
-	return res;
+
+	return sas_ex_register(dev, changed_phy, nr);
 }
 
 void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
-- 
2.13.6
