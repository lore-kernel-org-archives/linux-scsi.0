From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Thu, 02 Mar 2006 22:34:41 -0600
Message-ID: <1141360482.3238.91.camel@mulgrave.il.steeleye.com>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>
	 <20060302231323.GA12869@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33729 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750991AbWCCEet (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 23:34:49 -0500
In-Reply-To: <20060302231323.GA12869@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

On Thu, 2006-03-02 at 15:13 -0800, Mike Anderson wrote:
> The issue also results in the device discovery not completing by the time
> the module load completes resulting in the initrd not finding the boot
> disk
> http://bugzilla.kernel.org/show_bug.cgi?id=6045
> 
> I agree that we need a solution for this. Should the solution be in the
> LLDDs.I thought previous comments was that we wanted this fixed outside
> the kernel in user space. Though I have not seen any enabled support in
> initrds or support in the initrd bins.
> 
> This appears to not only be an issue with aic94xx as it appears this could
> happen with some of the fc transport LLDDs.

This is caused by two problems: one is the asynchronicity of the threads
and the other is that the driver can finish loading before the threads
finish.  I fixed both by moving the discovery thread over to the scsi
work queue (so there's only one per host, so all discoveries are
serialised) and by waiting for all work to be flushed before finishing
module loading.

Of course, now there's the slight race of the hotplug events going to
udev, but it's now no worse than any other driver.

I also pulled out a few more useless definitions.

James

diff --git a/drivers/scsi/sas/sas_discover.c b/drivers/scsi/sas/sas_discover.c
index ed5f658..f259289 100644
--- a/drivers/scsi/sas/sas_discover.c
+++ b/drivers/scsi/sas/sas_discover.c
@@ -710,16 +710,13 @@ static int sas_revalidate_domain(struct 
 
 static DECLARE_COMPLETION(disc_comp_start);
 
-static int sas_discover_thread(void *_sas_port)
+static void sas_discover_work_fn(void *_sas_port)
 {
 	struct sas_port *port = _sas_port;
-	struct sas_ha_struct *sas_ha = port->ha;
 	struct sas_discovery *disc = &port->disc;
 
-	daemonize("sas_disc_h%dp%d", sas_ha->core.shost->host_no, port->id);
-
 	spin_lock(&disc->disc_event_lock);
-	disc->disc_thread = current;
+	disc->disc_thread = 1;
 	complete(&disc_comp_start);
 	while (!disc->disc_thread_quit && !list_empty(&disc->disc_event_list)){
 		struct list_head *head = disc->disc_event_list.next;
@@ -744,28 +741,13 @@ static int sas_discover_thread(void *_sa
 		spin_lock(&disc->disc_event_lock);
 	}
 	INIT_LIST_HEAD(&disc->disc_event_list);
-	disc->disc_thread = NULL;
+	disc->disc_thread = 0;
 	spin_unlock(&disc->disc_event_lock);
 	up(&disc->disc_sema);
-
-	return 0;
-}
-
-static int sas_create_discover_thread(struct sas_port *port)
-{
-	int i;
-
-	init_completion(&disc_comp_start);
-	i = kernel_thread(sas_discover_thread, port, 0);
-	if (i >= 0)
-		wait_for_completion(&disc_comp_start);
-
-	return i < 0 ? i : 0;
 }
 
 int sas_discover_event(struct sas_port *port, enum discover_event ev)
 {
-	int res;
 	struct sas_discovery *disc = &port->disc;
 
 	spin_lock(&disc->disc_event_lock);
@@ -780,13 +762,10 @@ int sas_discover_event(struct sas_port *
 	spin_unlock(&disc->disc_event_lock);
 
 	/* The event thread (caller) is single threaded so this is safe. */
-	res = sas_create_discover_thread(port);
-	if (res) {
-		SAS_DPRINTK("sas port%d: couldn't create discovery thread!\n",
-			    port->id);
-		up(&disc->disc_sema);
-	}
-	return res;
+	INIT_WORK(&port->work, sas_discover_work_fn, port);
+	scsi_queue_work(port->ha->core.shost, &port->work);
+
+	return 0;
 }
 
 void sas_kill_disc_thread(struct sas_port *port)
@@ -796,8 +775,8 @@ void sas_kill_disc_thread(struct sas_por
 	spin_lock(&disc->disc_event_lock);
 	disc->disc_thread_quit = 1;
 	if (disc->disc_thread) {
-		wake_up_process(disc->disc_thread);
 		spin_unlock(&disc->disc_event_lock);
+		scsi_flush_work(port->ha->core.shost);
 		down_interruptible(&disc->disc_sema);
 		return;
 	}
@@ -817,7 +796,7 @@ void sas_init_disc(struct sas_discovery 
 	spin_lock_init(&disc->disc_event_lock);
 	INIT_LIST_HEAD(&disc->disc_event_list);
 	init_MUTEX(&disc->disc_sema);
-	disc->disc_thread = NULL;
+	disc->disc_thread = 0;
 	disc->disc_thread_quit = 0;
 
 	for (i = 0; i < DISC_NUM_EVENTS; i++) {
diff --git a/drivers/scsi/sas/sas_init.c b/drivers/scsi/sas/sas_init.c
index 67c4402..d675bed 100644
--- a/drivers/scsi/sas/sas_init.c
+++ b/drivers/scsi/sas/sas_init.c
@@ -92,6 +92,8 @@ int sas_register_ha(struct sas_ha_struct
 		}
 	}
 
+	/* wait for discovery to finish */
+	scsi_flush_work(sas_ha->core.shost);
 	return 0;
 
 Undo_ports:
diff --git a/drivers/scsi/sas/sas_scsi_host.c b/drivers/scsi/sas/sas_scsi_host.c
index b21a980..af5fa7e 100644
--- a/drivers/scsi/sas/sas_scsi_host.c
+++ b/drivers/scsi/sas/sas_scsi_host.c
@@ -32,22 +32,13 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
-#include <linux/kobject.h>
 #include <linux/scatterlist.h>
 
-/* The SAM LUN structure should be _completely_ opaque to SCSI Core.
- * This is why this macro here, and not using the broken
- * scsilun_to_int().  Ideally, a SCSI LUN should be communicated in
- * its entirety, and not as an integer.  For some unknown to myself
- * reason, SCSI Core thinks that SCSI LUNs can be interpreted as
- * integers.
- */
-#define SCSI_LUN(_sam_lun)   ((unsigned int)be32_to_cpu(*(__be32 *)_sam_lun))
-
 /* ---------- SCSI Host glue ---------- */
 
 #define TO_SAS_TASK(_scsi_cmd)  ((void *)(_scsi_cmd)->host_scribble)
@@ -663,6 +654,9 @@ int sas_register_scsi_host(struct sas_ha
 {
 	int err = -ENOMEM;
 
+	/* used for event processing */
+	tt->create_work_queue = 1;
+
 	sas_ha->core.sht = kzalloc(sizeof(*sas_ha->core.sht), GFP_KERNEL);
 	if (!sas_ha->core.sht)
 		return -ENOMEM;
diff --git a/include/scsi/sas/sas_class.h b/include/scsi/sas/sas_class.h
index 19de177..3732e80 100644
--- a/include/scsi/sas/sas_class.h
+++ b/include/scsi/sas/sas_class.h
@@ -142,10 +142,10 @@ struct sas_port;
 
 struct sas_discovery {
 	spinlock_t disc_event_lock;
-	int        disc_thread_quit;
+	unsigned        disc_thread_quit:1;
+	unsigned	disc_thread:1;
 	struct list_head disc_event_list;
 	struct sas_event disc_events[DISC_NUM_EVENTS];
-	struct task_struct *disc_thread;
 	struct semaphore  disc_sema;
 
 	u8     fanout_sas_addr[8];
@@ -176,6 +176,7 @@ struct sas_port {
 
 	struct scsi_id_map id_map;
 	struct sas_phy *phy;
+	struct work_struct work;
 
 /* public: */
 	int id;
diff --git a/include/scsi/sas/sas_discover.h b/include/scsi/sas/sas_discover.h
index 366ca4a..1584d4e 100644
--- a/include/scsi/sas/sas_discover.h
+++ b/include/scsi/sas/sas_discover.h
@@ -70,7 +70,6 @@ enum ata_command_set {
 struct domain_device;
 
 struct sata_device {
-	struct kset  pm_port_kset;
 	enum   ata_command_set command_set;
 	struct smp_resp        rps_resp; /* report_phy_sata_resp */
 	__le16 *identify_device;
@@ -84,17 +83,6 @@ struct sata_device {
 
 #define SAS_INQUIRY_DATA_LEN 36
 
-struct scsi_core_mapping {
-	int  channel;
-	int  id;
-};
-
-enum task_management_type {
-	TASK_MANAGEMENT_NONE  = 0,
-	TASK_MANAGEMENT_FULL  = 1,
-	TASK_MANAGEMENT_BASIC = 2,
-};
-
 struct end_device {
 	u8     ms_10:1;
 	u8     ready_led_meaning:1;
diff --git a/include/scsi/sas/sas_expander.h b/include/scsi/sas/sas_expander.h
index 87de7e9..b7d63fb 100644
--- a/include/scsi/sas/sas_expander.h
+++ b/include/scsi/sas/sas_expander.h
@@ -102,28 +102,6 @@ struct expander_device {
 	struct semaphore smp_sema;
 };
 
-/* ---------- Attributes and inlined ---------- */
-
-struct domain_dev_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct domain_device *dev, char *);
-	ssize_t (*store)(struct domain_device *dev, const char *, size_t);
-};
-
-void sas_kobj_set(struct domain_device *dev);
-
-extern struct kobj_type ex_dev_ktype;
-extern struct sysfs_ops dev_sysfs_ops;
-
-ssize_t dev_show_type(struct domain_device *dev, char *page);
-ssize_t dev_show_iproto(struct domain_device *dev, char *page);
-ssize_t dev_show_tproto(struct domain_device *dev, char *page);
-ssize_t dev_show_sas_addr(struct domain_device *dev, char *page);
-ssize_t dev_show_linkrate(struct domain_device *dev, char *page);
-ssize_t dev_show_min_linkrate(struct domain_device *dev, char *page);
-ssize_t dev_show_max_linkrate(struct domain_device *dev, char *page);
-ssize_t dev_show_pathways(struct domain_device *dev, char *page);
-
 int  sas_discover_root_expander(struct domain_device *dev);
 
 void sas_init_ex_attr(void);


