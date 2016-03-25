From: Weongyo Jeong <weongyo.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 1/2] genirq: clean up for irq_set_affinity_notifier().
Date: Fri, 25 Mar 2016 08:51:52 -0700
Message-ID: <c0c368bf9e93a323e4e845b20237798b84a65c9d.1458920770.git.weongyo.linux@gmail.com>
References: <cover.1458920770.git.weongyo.linux@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1458920770.git.weongyo.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <cover.1458920770.git.weongyo.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
References: <cover.1458920770.git.weongyo.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Weongyo Jeong <weongyo.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

At current irq_set_affinity_notifier() implementation, it has two meaning;
set and clear notify.  To be more clear, separate it into two;
irq_set_affinity_notifier() and irq_del_affinity_notifier().

At irq_set_affinity_notifier() function, no longer might_sleep() function
is called unnecessarily and -EEXIST code is returned.

Signed-off-by: Weongyo Jeong <weongyo.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |  8 ++---
 drivers/scsi/qla2xxx/qla_isr.c          |  2 +-
 include/linux/interrupt.h               |  2 ++
 kernel/irq/manage.c                     | 60 ++++++++++++++++++++++++---------
 lib/cpu_rmap.c                          |  2 +-
 5 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 6c8ff10..58c482a 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -3355,10 +3355,10 @@ static void reset_dca_notifier(struct qib_devdata *dd, struct qib_msix_entry *m)
 		"Disabling notifier on HCA %d irq %d\n",
 		dd->unit,
 		m->msix.vector);
-	irq_set_affinity_notifier(
-		m->msix.vector,
-		NULL);
-	m->notifier = NULL;
+	if (m->notifier != NULL) {
+		irq_del_affinity_notifier(&m->notifier->notify);
+		m->notifier = NULL;
+	}
 }
 
 static void setup_dca_notifier(struct qib_devdata *dd, struct qib_msix_entry *m)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5649c20..0a652fa 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3013,7 +3013,7 @@ qla24xx_disable_msix(struct qla_hw_data *ha)
 		qentry = &ha->msix_entries[i];
 		if (qentry->have_irq) {
 			/* un-register irq cpu affinity notification */
-			irq_set_affinity_notifier(qentry->vector, NULL);
+			irq_del_affinity_notifier(&qentry->irq_notify);
 			free_irq(qentry->vector, qentry->rsp);
 		}
 	}
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 358076e..fc54356 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -277,6 +277,8 @@ extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
 
 extern int
 irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
+extern int
+irq_del_affinity_notifier(struct irq_affinity_notify *notify);
 
 #else /* CONFIG_SMP */
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 64731e8..6fb1414 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -282,39 +282,67 @@ out:
 }
 
 /**
- *	irq_set_affinity_notifier - control notification of IRQ affinity changes
- *	@irq:		Interrupt for which to enable/disable notification
- *	@notify:	Context for notification, or %NULL to disable
- *			notification.  Function pointers must be initialised;
+ *	irq_set_affinity_notifier - set notification of IRQ affinity changes
+ *	@irq:		Interrupt for which to enable notification
+ *	@notify:	Context for notification.
+ *			Function pointers must be initialised;
  *			the other fields will be initialised by this function.
  *
- *	Must be called in process context.  Notification may only be enabled
- *	after the IRQ is allocated and must be disabled before the IRQ is
- *	freed using free_irq().
+ *	Notification may only be enabled after the IRQ is allocated.
  */
 int
 irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	if (!desc)
+		return -EINVAL;
+	if (!notify)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	if (desc->affinity_notify != NULL) {
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+		return -EEXIST;
+	}
+	notify->irq = irq;
+	kref_init(&notify->kref);
+	INIT_WORK(&notify->work, irq_affinity_notify);
+
+	desc->affinity_notify = notify;
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_set_affinity_notifier);
+
+/**
+ *	irq_del_affinity_notifier - delete notification of IRQ affinity changes
+ *	@notify:	Context for notification.
+ *
+ *	Must be called in process context.  Notification must be disabled
+ *	before the IRQ is freed using free_irq().
+ */
+int
+irq_del_affinity_notifier(struct irq_affinity_notify *notify)
+{
+	struct irq_desc *desc;
 	struct irq_affinity_notify *old_notify;
 	unsigned long flags;
 
 	/* The release function is promised process context */
 	might_sleep();
 
+	if (!notify)
+		return -EINVAL;
+	desc = irq_to_desc(notify->irq);
 	if (!desc)
 		return -EINVAL;
 
-	/* Complete initialisation of *notify */
-	if (notify) {
-		notify->irq = irq;
-		kref_init(&notify->kref);
-		INIT_WORK(&notify->work, irq_affinity_notify);
-	}
-
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	old_notify = desc->affinity_notify;
-	desc->affinity_notify = notify;
+	desc->affinity_notify = NULL;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	if (old_notify)
@@ -322,7 +350,7 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(irq_set_affinity_notifier);
+EXPORT_SYMBOL_GPL(irq_del_affinity_notifier);
 
 #ifndef CONFIG_AUTO_IRQ_AFFINITY
 /*
diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index f610b2a..0412a51 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -235,7 +235,7 @@ void free_irq_cpu_rmap(struct cpu_rmap *rmap)
 
 	for (index = 0; index < rmap->used; index++) {
 		glue = rmap->obj[index];
-		irq_set_affinity_notifier(glue->notify.irq, NULL);
+		irq_del_affinity_notifier(&glue->notify);
 	}
 
 	cpu_rmap_put(rmap);
-- 
2.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
