From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/10] hpsa: bring logical drives online when format completes
Date: Mon, 23 Sep 2013 13:34:07 -0500
Message-ID: <20130923183407.19995.99203.stgit@beardog.cce.hp.com>
References: <20130923183128.19995.7669.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:30394 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3IWSeH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 14:34:07 -0400
In-Reply-To: <20130923183128.19995.7669.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Now that the driver is hiding logical drives which are
undergoing low level format (e.g. drive erase or rapid parity
initialization) from the OS, it should bring those drives online
when the operation completes.  We poll with test unit ready
every so often to determine when the drives become ready.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |  128 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/hpsa.h |   13 +++++
 2 files changed, 140 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 38e3af4..198288d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -223,6 +223,8 @@ static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id);
 static int hpsa_wait_for_board_state(struct pci_dev *pdev, void __iomem *vaddr,
 				     int wait_for_ready);
 static inline void finish_cmd(struct CommandList *c);
+static unsigned char hpsa_format_in_progress(struct ctlr_info *h,
+		unsigned char scsi3addr[]);
 #define BOARD_NOT_READY 0
 #define BOARD_READY 1
 
@@ -946,6 +948,112 @@ static int hpsa_scsi_find_entry(struct hpsa_scsi_dev_t *needle,
 	return DEVICE_NOT_FOUND;
 }
 
+#define OFFLINE_DEVICE_POLL_INTERVAL (120 * HZ)
+static int hpsa_offline_device_thread(void *v)
+{
+	struct ctlr_info *h = v;
+	unsigned long flags;
+	struct offline_device_entry *d;
+	unsigned char need_rescan = 0;
+	struct list_head *this, *tmp;
+
+	while (1) {
+		schedule_timeout_interruptible(OFFLINE_DEVICE_POLL_INTERVAL);
+		if (kthread_should_stop())
+			break;
+
+		/* Check if any of the offline devices have become ready */
+		spin_lock_irqsave(&h->offline_device_lock, flags);
+		list_for_each_safe(this, tmp, &h->offline_device_list) {
+			d = list_entry(this, struct offline_device_entry,
+					offline_list);
+			spin_unlock_irqrestore(&h->offline_device_lock, flags);
+			if (!hpsa_format_in_progress(h, d->scsi3addr)) {
+				need_rescan = 1;
+				goto do_rescan;
+			}
+			spin_lock_irqsave(&h->offline_device_lock, flags);
+		}
+		spin_unlock_irqrestore(&h->offline_device_lock, flags);
+	}
+
+do_rescan:
+
+	/* Remove all entries from the list and rescan and exit this thread.
+	 * If there are still offline devices, the rescan will make a new list
+	 * and create a new offline device monitor thread.
+	 */
+	spin_lock_irqsave(&h->offline_device_lock, flags);
+	list_for_each_safe(this, tmp, &h->offline_device_list) {
+		d = list_entry(this, struct offline_device_entry, offline_list);
+		list_del_init(this);
+		kfree(d);
+	}
+	h->offline_device_monitor = NULL;
+	h->offline_device_thread_state = OFFLINE_DEVICE_THREAD_STOPPED;
+	spin_unlock_irqrestore(&h->offline_device_lock, flags);
+	if (need_rescan)
+		hpsa_scan_start(h->scsi_host);
+	return 0;
+}
+
+static void hpsa_monitor_offline_device(struct ctlr_info *h,
+					unsigned char scsi3addr[])
+{
+	struct offline_device_entry *device;
+	unsigned long flags;
+
+	/* Check to see if device is already on the list */
+	spin_lock_irqsave(&h->offline_device_lock, flags);
+	list_for_each_entry(device, &h->offline_device_list, offline_list) {
+		if (memcmp(device->scsi3addr, scsi3addr,
+				sizeof(device->scsi3addr)) == 0) {
+			spin_unlock_irqrestore(&h->offline_device_lock, flags);
+			return;
+		}
+	}
+	spin_unlock_irqrestore(&h->offline_device_lock, flags);
+
+	/* Device is not on the list, add it. */
+	device = kmalloc(sizeof(*device), GFP_KERNEL);
+	if (!device) {
+		dev_warn(&h->pdev->dev, "out of memory in %s\n", __func__);
+		return;
+	}
+	memcpy(device->scsi3addr, scsi3addr, sizeof(device->scsi3addr));
+	spin_lock_irqsave(&h->offline_device_lock, flags);
+	list_add_tail(&device->offline_list, &h->offline_device_list);
+	if (h->offline_device_thread_state == OFFLINE_DEVICE_THREAD_STOPPED) {
+		h->offline_device_thread_state = OFFLINE_DEVICE_THREAD_RUNNING;
+		spin_unlock_irqrestore(&h->offline_device_lock, flags);
+		h->offline_device_monitor =
+			kthread_run(hpsa_offline_device_thread, h, HPSA "-odm");
+		spin_lock_irqsave(&h->offline_device_lock, flags);
+	}
+	if (!h->offline_device_monitor) {
+		dev_warn(&h->pdev->dev, "failed to start offline device monitor thread.\n");
+		h->offline_device_thread_state = OFFLINE_DEVICE_THREAD_STOPPED;
+	}
+	spin_unlock_irqrestore(&h->offline_device_lock, flags);
+}
+
+static void stop_offline_device_monitor(struct ctlr_info *h)
+{
+	unsigned long flags;
+	int stop_thread;
+
+	spin_lock_irqsave(&h->offline_device_lock, flags);
+	stop_thread = (h->offline_device_thread_state ==
+				OFFLINE_DEVICE_THREAD_RUNNING);
+	if (stop_thread)
+		/* STOPPING state prevents new thread from starting. */
+		h->offline_device_thread_state =
+				OFFLINE_DEVICE_THREAD_STOPPING;
+	spin_unlock_irqrestore(&h->offline_device_lock, flags);
+	if (stop_thread)
+		kthread_stop(h->offline_device_monitor);
+}
+
 static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	struct hpsa_scsi_dev_t *sd[], int nsds)
 {
@@ -1018,7 +1126,10 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 		 */
 		if (sd[i]->format_in_progress) {
 			dev_info(&h->pdev->dev,
-				"Logical drive format in progress, device c%db%dt%dl%d offline.\n",
+				"c%db%dt%dl%d: Logical drive parity initialization, erase or format in progress\n",
+				h->scsi_host->host_no,
+				sd[i]->bus, sd[i]->target, sd[i]->lun);
+			dev_info(&h->pdev->dev, "c%db%dt%dl%d: temporarily offline\n",
 				h->scsi_host->host_no,
 				sd[i]->bus, sd[i]->target, sd[i]->lun);
 			continue;
@@ -1042,6 +1153,17 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	}
 	spin_unlock_irqrestore(&h->devlock, flags);
 
+	/* Monitor devices which are NOT READY, FORMAT IN PROGRESS to be
+	 * brought online later. This must be done without holding h->devlock,
+	 * so don't touch h->dev[]
+	 */
+	for (i = 0; i < nsds; i++) {
+		if (!sd[i]) /* if already added above. */
+			continue;
+		if (sd[i]->format_in_progress)
+			hpsa_monitor_offline_device(h, sd[i]->scsi3addr);
+	}
+
 	/* Don't notify scsi mid layer of any changes the first time through
 	 * (or if there are no changes) scsi_scan_host will do it later the
 	 * first time through.
@@ -4879,8 +5001,10 @@ reinit_after_soft_reset:
 	h->intr_mode = hpsa_simple_mode ? SIMPLE_MODE_INT : PERF_MODE_INT;
 	INIT_LIST_HEAD(&h->cmpQ);
 	INIT_LIST_HEAD(&h->reqQ);
+	INIT_LIST_HEAD(&h->offline_device_list);
 	spin_lock_init(&h->lock);
 	spin_lock_init(&h->scan_lock);
+	spin_lock_init(&h->offline_device_lock);
 	rc = hpsa_pci_init(h);
 	if (rc != 0)
 		goto clean1;
@@ -4888,6 +5012,7 @@ reinit_after_soft_reset:
 	sprintf(h->devname, HPSA "%d", number_of_controllers);
 	h->ctlr = number_of_controllers;
 	number_of_controllers++;
+	h->offline_device_thread_state = OFFLINE_DEVICE_THREAD_STOPPED;
 
 	/* configure PCI DMA stuff */
 	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
@@ -5066,6 +5191,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	}
 	h = pci_get_drvdata(pdev);
 	stop_controller_lockup_detector(h);
+	stop_offline_device_monitor(h);
 	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
 	hpsa_shutdown(pdev);
 	iounmap(h->vaddr);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 4fd0d45..4953fe3 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -155,7 +155,20 @@ struct ctlr_info {
 #define HPSATMF_LOG_QRY_TASK    (1 << 23)
 #define HPSATMF_LOG_QRY_TSET    (1 << 24)
 #define HPSATMF_LOG_QRY_ASYNC   (1 << 25)
+	spinlock_t offline_device_lock;
+	struct list_head offline_device_list;
+	struct task_struct *offline_device_monitor;
+	unsigned char offline_device_thread_state;
+#define OFFLINE_DEVICE_THREAD_STOPPED 0
+#define OFFLINE_DEVICE_THREAD_STOPPING 1
+#define OFFLINE_DEVICE_THREAD_RUNNING 2
 };
+
+struct offline_device_entry {
+	unsigned char scsi3addr[8];
+	struct list_head offline_list;
+};
+
 #define HPSA_ABORT_MSG 0
 #define HPSA_DEVICE_RESET_MSG 1
 #define HPSA_RESET_TYPE_CONTROLLER 0x00

