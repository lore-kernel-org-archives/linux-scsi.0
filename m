From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 3/5] scsi: libsas: Drop sas_printk()
Date: Thu, 15 Nov 2018 18:20:30 +0800
Message-ID: <1542277232-135789-4-git-send-email-john.garry@huawei.com>
References: <1542277232-135789-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542277232-135789-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.com, yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, joe@perches.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The printk wrapper sas_printk() adds little value now that libsas logs
already have the "sas" prefix through pr_fmt(fmt), so just use
pr_notice() directly.

In addition, strings which span multiple lines are reunited.

Originally-from: Joe Perches <joe@perches.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 22 ++++++++++------------
 drivers/scsi/libsas/sas_init.c     |  4 ++--
 drivers/scsi/libsas/sas_internal.h |  2 --
 drivers/scsi/libsas/sas_phy.c      |  8 ++++----
 4 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 0d1f727..579304d 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -393,7 +393,7 @@ static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *disc_req,
 		return res;
 	dr = &((struct smp_resp *)disc_resp)->disc;
 	if (memcmp(dev->sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE) == 0) {
-		sas_printk("Found loopback topology, just ignore it!\n");
+		pr_notice("Found loopback topology, just ignore it!\n");
 		return 0;
 	}
 	sas_set_ex_phy(dev, single, disc_resp);
@@ -1262,19 +1262,17 @@ static void sas_print_parent_topology_bug(struct domain_device *child,
 	};
 	struct domain_device *parent = child->parent;
 
-	sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx "
-		   "phy 0x%x has %c:%c routing link!\n",
+	pr_notice("%s ex %016llx phy 0x%x <--> %s ex %016llx phy 0x%x has %c:%c routing link!\n",
+		  ex_type[parent->dev_type],
+		  SAS_ADDR(parent->sas_addr),
+		  parent_phy->phy_id,
 
-		   ex_type[parent->dev_type],
-		   SAS_ADDR(parent->sas_addr),
-		   parent_phy->phy_id,
+		  ex_type[child->dev_type],
+		  SAS_ADDR(child->sas_addr),
+		  child_phy->phy_id,
 
-		   ex_type[child->dev_type],
-		   SAS_ADDR(child->sas_addr),
-		   child_phy->phy_id,
-
-		   sas_route_char(parent, parent_phy),
-		   sas_route_char(child, child_phy));
+		  sas_route_char(parent, parent_phy),
+		  sas_route_char(child, child_phy));
 }
 
 static int sas_check_eeds(struct domain_device *child,
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index ede0af7..a3c25e2 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -623,8 +623,8 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
 	if (atomic_read(&phy->event_nr) > phy->ha->event_thres) {
 		if (i->dft->lldd_control_phy) {
 			if (cmpxchg(&phy->in_shutdown, 0, 1) == 0) {
-				sas_printk("The phy%02d bursting events, shut it down.\n",
-					phy->id);
+				pr_notice("The phy%02d bursting events, shut it down.\n",
+					  phy->id);
 				sas_notify_phy_event(phy, PHYE_SHUTDOWN);
 			}
 		} else {
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 94ebf41..910aa31 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -40,8 +40,6 @@
 
 #define pr_fmt(fmt) SAS_FMT fmt
 
-#define sas_printk(fmt, ...) printk(KERN_NOTICE fmt, ## __VA_ARGS__)
-
 #define SAS_DPRINTK(fmt, ...) printk(KERN_DEBUG fmt, ## __VA_ARGS__)
 
 
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index bf3e1b9..0374243 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -122,11 +122,11 @@ static void sas_phye_shutdown(struct work_struct *work)
 		phy->enabled = 0;
 		ret = i->dft->lldd_control_phy(phy, PHY_FUNC_DISABLE, NULL);
 		if (ret)
-			sas_printk("lldd disable phy%02d returned %d\n",
-				phy->id, ret);
+			pr_notice("lldd disable phy%02d returned %d\n",
+				  phy->id, ret);
 	} else
-		sas_printk("phy%02d is not enabled, cannot shutdown\n",
-			phy->id);
+		pr_notice("phy%02d is not enabled, cannot shutdown\n",
+			  phy->id);
 }
 
 /* ---------- Phy class registration ---------- */
-- 
1.9.1
