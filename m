From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 09/17] Add thread to allow controllers to register for rescan
	for new devices
Date: Wed, 11 Nov 2009 10:51:09 -0600
Message-ID: <20091111165109.17754.12015.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758068AbZKKQts@vger.kernel.org>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Add thread to allow controllers to register for rescan for new devices
(borrowed code from cciss.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/hpsa.h |    5 ++
 2 files changed, 150 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 74c054a..35267cb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -47,6 +47,7 @@
 #include <linux/string.h>
 #include <linux/bitmap.h>
 #include <asm/atomic.h>
+#include <linux/kthread.h>
 #include "hpsa_cmd.h"
 #include "hpsa.h"
 
@@ -145,6 +146,7 @@ static ssize_t lunid_show(struct device *dev,
 	struct device_attribute *attr, char *buf);
 static ssize_t unique_id_show(struct device *dev,
 	struct device_attribute *attr, char *buf);
+static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
 
 DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
@@ -183,6 +185,129 @@ static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 	return (struct ctlr_info *) *priv;
 }
 
+static struct task_struct *hpsa_scan_thread;
+static DEFINE_MUTEX(scan_mutex);
+static LIST_HEAD(scan_q);
+static int scan_thread(void *data);
+
+/**
+ * add_to_scan_list() - add controller to rescan queue
+ * @h:		      Pointer to the controller.
+ *
+ * Adds the controller to the rescan queue if not already on the queue.
+ *
+ * returns 1 if added to the queue, 0 if skipped (could be on the
+ * queue already, or the controller could be initializing or shutting
+ * down).
+ **/
+static int add_to_scan_list(struct ctlr_info *h)
+{
+	struct ctlr_info *test_h;
+	int found = 0;
+	int ret = 0;
+
+	if (h->busy_initializing)
+		return 0;
+
+	if (!mutex_trylock(&h->busy_shutting_down))
+		return 0;
+
+	mutex_lock(&scan_mutex);
+	list_for_each_entry(test_h, &scan_q, scan_list) {
+		if (test_h == h) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found && !h->busy_scanning) {
+		INIT_COMPLETION(h->scan_wait);
+		list_add_tail(&h->scan_list, &scan_q);
+		ret = 1;
+	}
+	mutex_unlock(&scan_mutex);
+	mutex_unlock(&h->busy_shutting_down);
+
+	return ret;
+}
+
+/**
+ * remove_from_scan_list() - remove controller from rescan queue
+ * @h:			   Pointer to the controller.
+ *
+ * Removes the controller from the rescan queue if present. Blocks if
+ * the controller is currently conducting a rescan.  The controller
+ * can be in one of three states:
+ * 1. Doesn't need a scan
+ * 2. On the scan list, but not scanning yet (we remove it)
+ * 3. Busy scanning (and not on the list). In this case we want to wait for
+ *    the scan to complete to make sure the scanning thread for this
+ *    controller is completely idle.
+ **/
+static void remove_from_scan_list(struct ctlr_info *h)
+{
+	struct ctlr_info *test_h, *tmp_h;
+
+	mutex_lock(&scan_mutex);
+	list_for_each_entry_safe(test_h, tmp_h, &scan_q, scan_list) {
+		if (test_h == h) { /* state 2. */
+			list_del(&h->scan_list);
+			complete_all(&h->scan_wait);
+			mutex_unlock(&scan_mutex);
+			return;
+		}
+	}
+	if (h->busy_scanning) { /* state 3. */
+		mutex_unlock(&scan_mutex);
+		wait_for_completion(&h->scan_wait);
+	} else { /* state 1, nothing to do. */
+		mutex_unlock(&scan_mutex);
+	}
+}
+
+/* scan_thread() - kernel thread used to rescan controllers
+ * @data:	 Ignored.
+ *
+ * A kernel thread used scan for drive topology changes on
+ * controllers. The thread processes only one controller at a time
+ * using a queue.  Controllers are added to the queue using
+ * add_to_scan_list() and removed from the queue either after done
+ * processing or using remove_from_scan_list().
+ *
+ * returns 0.
+ **/
+static int scan_thread(__attribute__((unused)) void *data)
+{
+	struct ctlr_info *h;
+	int host_no;
+
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+		if (kthread_should_stop())
+			break;
+
+		while (1) {
+			mutex_lock(&scan_mutex);
+			if (list_empty(&scan_q)) {
+				mutex_unlock(&scan_mutex);
+				break;
+			}
+			h = list_entry(scan_q.next, struct ctlr_info,
+					scan_list);
+			list_del(&h->scan_list);
+			h->busy_scanning = 1;
+			mutex_unlock(&scan_mutex);
+			host_no = h->scsi_host ?  h->scsi_host->host_no : -1;
+			hpsa_update_scsi_devices(h, host_no);
+			complete_all(&h->scan_wait);
+			mutex_lock(&scan_mutex);
+			h->busy_scanning = 0;
+			mutex_unlock(&scan_mutex);
+		}
+	}
+	return 0;
+}
+
 /* Enqueuing and dequeuing functions for cmdlists. */
 static inline void addQ(struct hlist_head *list, struct CommandList *c)
 {
@@ -3269,8 +3394,11 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	if (!h)
 		return -1;
 
+	h->busy_initializing = 1;
 	INIT_HLIST_HEAD(&h->cmpQ);
 	INIT_HLIST_HEAD(&h->reqQ);
+	mutex_init(&h->busy_shutting_down);
+	init_completion(&h->scan_wait);
 	if (hpsa_pci_init(h, pdev) != 0)
 		goto clean1;
 
@@ -3330,7 +3458,7 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
 
 	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
-
+	h->busy_initializing = 0;
 	return 1;
 
 clean4:
@@ -3347,6 +3475,7 @@ clean4:
 	free_irq(h->intr[SIMPLE_MODE_INT], h);
 clean2:
 clean1:
+	h->busy_initializing = 0;
 	kfree(h);
 	return -1;
 }
@@ -3387,6 +3516,8 @@ static void __devexit hpsa_remove_one(struct pci_dev *pdev)
 		return;
 	}
 	h = pci_get_drvdata(pdev);
+	mutex_lock(&h->busy_shutting_down);
+	remove_from_scan_list(h);
 	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
 	hpsa_shutdown(pdev);
 	iounmap(h->vaddr);
@@ -3403,6 +3534,7 @@ static void __devexit hpsa_remove_one(struct pci_dev *pdev)
 	 */
 	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
+	mutex_unlock(&h->busy_shutting_down);
 	kfree(h);
 }
 
@@ -3433,12 +3565,23 @@ static struct pci_driver hpsa_pci_driver = {
  */
 static int __init hpsa_init(void)
 {
-	return pci_register_driver(&hpsa_pci_driver);
+	int err;
+	/* Start the scan thread */
+	hpsa_scan_thread = kthread_run(scan_thread, NULL, "hpsa_scan");
+	if (IS_ERR(hpsa_scan_thread)) {
+		err = PTR_ERR(hpsa_scan_thread);
+		return -ENODEV;
+	}
+	err = pci_register_driver(&hpsa_pci_driver);
+	if (err)
+		kthread_stop(hpsa_scan_thread);
+	return err;
 }
 
 static void __exit hpsa_cleanup(void)
 {
 	pci_unregister_driver(&hpsa_pci_driver);
+	kthread_stop(hpsa_scan_thread);
 }
 
 module_init(hpsa_init);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 6491d4e..ffa8c50 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -91,6 +91,11 @@ struct ctlr_info {
 	unsigned long  		*cmd_pool_bits;
 	int			nr_allocs;
 	int			nr_frees;
+	int			busy_initializing;
+	int			busy_scanning;
+	struct mutex		busy_shutting_down;
+	struct list_head	scan_list;
+	struct completion	scan_wait;
 
 	struct Scsi_Host *scsi_host;
 	spinlock_t devlock; /* to protect hba[ctlr]->dev[];  */
