From: James.Smart@Emulex.Com
Subject: [Patch] Correct issue with midlayer scsi target allocation and transports that create the targets
Date: Fri, 10 Jun 2005 15:03:58 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC6F@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45275 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261174AbVFJTED convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 15:04:03 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5AJ3x9P001769
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2005 12:03:59 -0700 (PDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I was pinged by Pat Mansfield on an issue with using the scan sysfs
attribute to rescan FC adapters. Especially if the target and luns
structures have been torn down via the delete sysfs attribute. See:
http://marc.theaimsgroup.com/?l=linux-scsi&m=111671146532103&w=2

We have some nasty issues with 2.6.12-rc6. Any request to scan on
the lpfc or qla2xxx FC adapters will oops. What is happening is the
system is defaulting to non-transport registered targets, which
inherit the parent of the scan. On this second scan, performed by
the attribute, the parent becomes the shost instead of the rport.
The slave functions in the 2 FC adapters use starget_to_rport()
routines, which incorrectly map the shost as an rport pointer.

Additionally, this pointed out other weaknesses:
- If the target structure is torn down outside of the transport,
  we have no method for it to be regenerated at the proper parent.
- We have race conditions on the target being allocated by both
  the midlayer scan (parent=shost) and by the fc transport
  (parent=rport).

Mike Christie proposed adding a transport scan function to resolve
this (see link above). However, I'm concerned that his patch does
not catch all potential scan calls, especially those that may be
within the kernel.

Here's a proposed patch. The real problem in all of this was that
we had 2 places allocating a scsi target (or should I say, that
invoked the scan function that makes the target, but the parents
are different).  This patch adds a transport alloc_target function,
which allows the transport to adjusts the parent, and then calls
back into the midlayer to complete the allocation (small recursive
call). It has one additional optimization in that, if the transport
is doling out targets, it fails target allocations on things that
don't exist. This will make scanning slightly faster. I also like
this patch as it leaves all "scan" logic in the midlayer.

-- James S




diff -upNr linux-2.6.12-rc6/drivers/scsi/scsi_priv.h linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_priv.h
--- linux-2.6.12-rc6/drivers/scsi/scsi_priv.h	2005-06-10 10:05:15.000000000 -0400
+++ linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_priv.h	2005-06-10 10:06:21.000000000 -0400
@@ -125,6 +125,7 @@ extern int scsi_scan_host_selected(struc
 				   unsigned int, unsigned int, int);
 extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
+extern struct scsi_target *scsi_alloc_target(struct device *, int , uint);
 
 /* scsi_sysctl.c */
 #ifdef CONFIG_SYSCTL
diff -upNr linux-2.6.12-rc6/drivers/scsi/scsi_scan.c linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_scan.c
--- linux-2.6.12-rc6/drivers/scsi/scsi_scan.c	2005-06-09 15:58:31.000000000 -0400
+++ linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_scan.c	2005-06-10 10:38:27.000000000 -0400
@@ -324,7 +324,7 @@ static struct scsi_target *__scsi_find_t
 	return found_starget;
 }
 
-static struct scsi_target *scsi_alloc_target(struct device *parent,
+struct scsi_target *scsi_alloc_target(struct device *parent,
 					     int channel, uint id)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
@@ -332,9 +332,34 @@ static struct scsi_target *scsi_alloc_ta
 	unsigned long flags;
 	const int size = sizeof(struct scsi_target)
 		+ shost->transportt->target_size;
-	struct scsi_target *starget = kmalloc(size, GFP_ATOMIC);
+	struct scsi_target *starget;
 	struct scsi_target *found_target;
 
+	/*
+	 * Allow transport to allocate target struct or reject target.
+	 * Only make this call if the parent is the scsi host. If it
+	 * is not the host, it is the transport calling in to allocate
+	 * the target.
+	 */
+	if ((shost->transportt->alloc_target) &&
+	    (scsi_is_host_device(parent))) {
+		if ((shost->transportt->alloc_target)(shost, channel, id))
+			return NULL;
+	}
+
+	/* Find existing target */
+	spin_lock_irqsave(shost->host_lock, flags);
+	found_target = __scsi_find_target(parent, channel, id);
+	if (found_target) {
+		found_target->reap_ref++;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		put_device(parent);
+		return found_target;
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	/* allocate and add */
+	starget = kmalloc(size, GFP_ATOMIC);
 	if (!starget) {
 		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
 		return NULL;
@@ -352,26 +377,14 @@ static struct scsi_target *scsi_alloc_ta
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
 	spin_lock_irqsave(shost->host_lock, flags);
-
-	found_target = __scsi_find_target(parent, channel, id);
-	if (found_target)
-		goto found;
-
 	list_add_tail(&starget->siblings, &shost->__targets);
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	/* allocate and add */
 	transport_setup_device(&starget->dev);
 	device_add(&starget->dev);
 	transport_add_device(&starget->dev);
 	return starget;
-
- found:
-	found_target->reap_ref++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	put_device(parent);
-	kfree(starget);
-	return found_target;
 }
+EXPORT_SYMBOL(scsi_alloc_target);
 
 /**
  * scsi_target_reap - check to see if target is in use and destroy if not
diff -upNr linux-2.6.12-rc6/drivers/scsi/scsi_transport_fc.c linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_transport_fc.c
--- linux-2.6.12-rc6/drivers/scsi/scsi_transport_fc.c	2005-06-09 15:58:31.000000000 -0400
+++ linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_transport_fc.c	2005-06-10 10:43:36.000000000 -0400
@@ -1022,6 +1022,33 @@ static int fc_rport_match(struct attribu
 	return &i->rport_attr_cont.ac == cont;
 }
 
+/*
+ * Attempts to allocate scsi target for remote port. Invoked typically
+ *   on rescans by the midlayer.
+ * Returns 0 on succes, non-zero on failure
+ */
+static int fc_alloc_target(struct Scsi_Host *shost, int channel, uint id)
+{
+	struct fc_rport *rport, *next_rport;
+	struct scsi_target *starget;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry_safe(rport, next_rport,
+			&fc_host_rports(shost), peers) {
+		if ((rport->channel == channel) &&
+		    (rport->scsi_target_id == id)) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			starget = scsi_alloc_target(&rport->dev, channel, id);
+			if (starget)
+				return 0;
+			return 1;
+		}
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return 1;
+}
+
 struct scsi_transport_template *
 fc_attach_transport(struct fc_function_template *ft)
 {
@@ -1057,6 +1084,9 @@ fc_attach_transport(struct fc_function_t
 
 	/* Transport uses the shost workq for scsi scanning */
 	i->t.create_work_queue = 1;
+
+	/* Transport manages target structure allocation */
+	i->t.alloc_target = fc_alloc_target;
 	
 	/*
 	 * Setup SCSI Target Attributes.
diff -upNr linux-2.6.12-rc6/include/scsi/scsi_transport.h linux-2.6.12-rc6.PATCHED/include/scsi/scsi_transport.h
--- linux-2.6.12-rc6/include/scsi/scsi_transport.h	2005-06-09 15:58:52.000000000 -0400
+++ linux-2.6.12-rc6.PATCHED/include/scsi/scsi_transport.h	2005-06-10 10:37:07.000000000 -0400
@@ -28,6 +28,9 @@ struct scsi_transport_template {
 	struct transport_container target_attrs;
 	struct transport_container device_attrs;
 
+	/* If non-NULL, transport creates targets */
+	int	(* alloc_target)(struct Scsi_Host *, int, uint);
+
 	/* The size of the specific transport attribute structure (a
 	 * space of this size will be left at the end of the
 	 * scsi_* structure */
@@ -35,9 +38,7 @@ struct scsi_transport_template {
 	int	target_size;
 	int	host_size;
 
-	/*
-	 * True if the transport wants to use a host-based work-queue
-	 */
+	/* True if the transport wants to use a host-based work-queue */
 	unsigned int create_work_queue : 1;
 };
 
