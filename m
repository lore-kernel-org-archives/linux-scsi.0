From: Weongyo Jeong <weongyo.linux@gmail.com>
Subject: [PATCH v1 2/2] genirq: support multiple IRQ notifier.
Date: Fri, 25 Mar 2016 08:51:53 -0700
Message-ID: <150f84b627280fa9d4397e6a4cdb5d096bef70bd.1458920770.git.weongyo.linux@gmail.com>
References: <cover.1458920770.git.weongyo.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1458920770.git.weongyo.linux@gmail.com>
In-Reply-To: <cover.1458920770.git.weongyo.linux@gmail.com>
References: <cover.1458920770.git.weongyo.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Weongyo Jeong <weongyo.linux@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Mike Marciniszyn <infinipath@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

At current implementation, it only supports one IRQ notifier for irq_desc.
When if we try to register another IRQ notifier, it automatically
un-register previous one and register new one.  With this patch, multiple
IRQ notifier is supported.

Signed-off-by: Weongyo Jeong <weongyo.linux@gmail.com>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c          |  2 +-
 include/linux/interrupt.h               | 11 ++++++++--
 include/linux/irqdesc.h                 |  2 +-
 kernel/irq/irqdesc.c                    |  1 +
 kernel/irq/manage.c                     | 38 +++++++++++++++++----------------
 lib/cpu_rmap.c                          |  2 +-
 7 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 58c482a..5376592 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -3380,7 +3380,7 @@ static void setup_dca_notifier(struct qib_devdata *dd, struct qib_msix_entry *m)
 		qib_devinfo(dd->pcidev,
 			"set notifier irq %d rcv %d notify %p\n",
 			n->notify.irq, n->rcv, &n->notify);
-		ret = irq_set_affinity_notifier(
+		ret = irq_add_affinity_notifier(
 				n->notify.irq,
 				&n->notify);
 		if (ret) {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 0a652fa..13318c0 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3101,7 +3101,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		rsp->msix = qentry;
 
 		/* Register for CPU affinity notification. */
-		irq_set_affinity_notifier(qentry->vector, &qentry->irq_notify);
+		irq_add_affinity_notifier(qentry->vector, &qentry->irq_notify);
 
 		/* Schedule work (ie. trigger a notification) to read cpu
 		 * mask for this specific irq.
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index fc54356..d7368ab 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -230,6 +230,7 @@ struct irq_affinity_notify {
 	struct work_struct work;
 	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
 	void (*release)(struct kref *ref);
+	struct list_head list;
 };
 
 #if defined(CONFIG_SMP)
@@ -276,7 +277,7 @@ extern int irq_select_affinity(unsigned int irq);
 extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
 
 extern int
-irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
+irq_add_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
 extern int
 irq_del_affinity_notifier(struct irq_affinity_notify *notify);
 
@@ -306,7 +307,13 @@ static inline int irq_set_affinity_hint(unsigned int irq,
 }
 
 static inline int
-irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
+irq_add_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
+{
+	return 0;
+}
+
+static inline int
+irq_del_affinity_notifier(struct irq_affinity_notify *notify)
 {
 	return 0;
 }
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index dcca77c..51cc163 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -68,7 +68,7 @@ struct irq_desc {
 	struct cpumask		*percpu_enabled;
 #ifdef CONFIG_SMP
 	const struct cpumask	*affinity_hint;
-	struct irq_affinity_notify *affinity_notify;
+	struct list_head	affinity_notify_list;
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_var_t		pending_mask;
 #endif
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 0ccd028..4f99fb3 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -70,6 +70,7 @@ static int alloc_masks(struct irq_desc *desc, gfp_t gfp, int node)
 
 static void desc_smp_init(struct irq_desc *desc, int node)
 {
+	INIT_LIST_HEAD(&desc->affinity_notify_list);
 	cpumask_copy(desc->irq_common_data.affinity, irq_default_affinity);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_clear(desc->pending_mask);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 6fb1414..bfd7673 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -202,6 +202,7 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 			    bool force)
 {
+	struct irq_affinity_notify *notify;
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	struct irq_desc *desc = irq_data_to_desc(data);
 	int ret = 0;
@@ -216,9 +217,9 @@ int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 		irq_copy_pending(desc, mask);
 	}
 
-	if (desc->affinity_notify) {
-		kref_get(&desc->affinity_notify->kref);
-		schedule_work(&desc->affinity_notify->work);
+	list_for_each_entry(notify, &desc->affinity_notify_list, list) {
+		kref_get(&notify->kref);
+		schedule_work(&notify->work);
 	}
 	irqd_set(data, IRQD_AFFINITY_SET);
 
@@ -282,7 +283,7 @@ out:
 }
 
 /**
- *	irq_set_affinity_notifier - set notification of IRQ affinity changes
+ *	irq_add_affinity_notifier - set notification of IRQ affinity changes
  *	@irq:		Interrupt for which to enable notification
  *	@notify:	Context for notification.
  *			Function pointers must be initialised;
@@ -291,7 +292,7 @@ out:
  *	Notification may only be enabled after the IRQ is allocated.
  */
 int
-irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
+irq_add_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -302,20 +303,16 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	if (desc->affinity_notify != NULL) {
-		raw_spin_unlock_irqrestore(&desc->lock, flags);
-		return -EEXIST;
-	}
 	notify->irq = irq;
 	kref_init(&notify->kref);
 	INIT_WORK(&notify->work, irq_affinity_notify);
 
-	desc->affinity_notify = notify;
+	list_add(&notify->list, &desc->affinity_notify_list);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(irq_set_affinity_notifier);
+EXPORT_SYMBOL_GPL(irq_add_affinity_notifier);
 
 /**
  *	irq_del_affinity_notifier - delete notification of IRQ affinity changes
@@ -328,7 +325,6 @@ int
 irq_del_affinity_notifier(struct irq_affinity_notify *notify)
 {
 	struct irq_desc *desc;
-	struct irq_affinity_notify *old_notify;
 	unsigned long flags;
 
 	/* The release function is promised process context */
@@ -341,12 +337,10 @@ irq_del_affinity_notifier(struct irq_affinity_notify *notify)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	old_notify = desc->affinity_notify;
-	desc->affinity_notify = NULL;
+	list_del(&notify->list);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
-	if (old_notify)
-		kref_put(&old_notify->kref, old_notify->release);
+	kref_put(&notify->kref, notify->release);
 
 	return 0;
 }
@@ -1571,14 +1565,22 @@ EXPORT_SYMBOL_GPL(remove_irq);
  */
 void free_irq(unsigned int irq, void *dev_id)
 {
+#ifdef CONFIG_SMP
+	struct irq_affinity_notify *notify, *notifytmp;
+#endif
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (!desc || WARN_ON(irq_settings_is_per_cpu_devid(desc)))
 		return;
 
 #ifdef CONFIG_SMP
-	if (WARN_ON(desc->affinity_notify))
-		desc->affinity_notify = NULL;
+	list_for_each_entry_safe(notify, notifytmp, &desc->affinity_notify_list,
+				 list) {
+		if (notify->irq != irq)
+			continue;
+		__WARN();
+		list_del(&notify->list);
+	}
 #endif
 
 	kfree(__free_irq(irq, dev_id));
diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index 0412a51..fb3a8e4 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -297,7 +297,7 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
 	glue->rmap = rmap;
 	cpu_rmap_get(rmap);
 	glue->index = cpu_rmap_add(rmap, glue);
-	rc = irq_set_affinity_notifier(irq, &glue->notify);
+	rc = irq_add_affinity_notifier(irq, &glue->notify);
 	if (rc) {
 		cpu_rmap_put(glue->rmap);
 		kfree(glue);
-- 
2.1.3
