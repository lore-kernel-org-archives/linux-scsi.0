From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [RFC] adding per scsi-host workqueues for defered processing
Date: Mon, 21 Feb 2005 16:09:37 -0800
Message-ID: <20050222000937.GA7338@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch02.qlogic.com ([198.70.193.200]:51641 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262185AbVBVAJM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 19:09:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Following discussions which resulted from the:

[RFC] target code updates to support scanned targets
http://marc.theaimsgroup.com/?l=linux-scsi&m=110850749515984&w=2

thread, the overall consensus seems to be that transport-classes
should support a 'true-hotplug' mechanism of device discovery and
removal (this involves both registration and lun-scanning).  In order
to facilitate this ability and to not constrain the LLDD from the
typical restrictions of the storage scanning process:

* must be done from process context -- depending on transport type,
  discovery can occur from a non-process context
* potentially _long_ scan times -- even if discovery is done from a
  'sleeping' capable context, halting a LLDD for discovery purposes
  is typically undesirable.

I'd like to propose the addition of a per-Scsi_Host work-queue to
manage these scanning as well as any other (relevant)
lower-level-driver differed requests.

The attached patch adds:

1) a new scsi-host template member 'create_work_queue' which when set
   will create a single-threaded (the per-CPU option seemed too
   heavyweight) work-queue.
2) an exported helper function scsi_queue_work() to queue the work to
   the scsi-host work-queue.

the interface was kept flexible -- queuing of a work_struct object
rather than adding small wrapper functions to perform distinct
operations (i.e. scsi_scan_target_deferred(...), etc) so that any
'deferred' action could be requested by a transport-class or LLDD.

Example usage:

  scsi_transport_fc.h:

	struct fc_rport {
		...
	
		struct work_struct scan_work;
	} __attribute__((aligned(sizeof(unsigned long))));

  scsi_transport_fc.c:

	...	
	static void fc_scan_rport_work(void *data)
	{
		struct fc_rport *rport = (struct fc_rport *)data;

		scsi_scan_target(&rport->dev, rport->channel,
			rport->scsi_target_id, SCAN_WILD_CARD, 0);
	}	

	struct fc_rport *
	fc_create_rport(struct Scsi_Host *shost, int channel,
		struct fc_rport_identifiers  *ids)
	{
		...
		INIT_WORK(&rport->scan_work,
			fc_scan_rport_work, rport);
		...

	
	void
	fc_remote_port_unblock(struct fc_rport *rport)
	{
		struct Scsi_Host *shost = rport_to_shost(rport);
		...
		if (rport->port_state == FC_PORTSTATE_OFFLINE)
			/* Initiate a full rescan, as all
			 * scsi_target objects have been previously
			 * torn-down. */
			scsi_queue_work(shost, &rport->scan_work);
		else
			scsi_target_unblock(&rport->dev);

Anyway, comments?

--
Andrew Vasquez

===== drivers/scsi/hosts.c 1.107 vs edited =====
--- 1.107/drivers/scsi/hosts.c	2005-01-18 11:15:06 -08:00
+++ edited/drivers/scsi/hosts.c	2005-02-21 15:10:38 -08:00
@@ -160,6 +160,9 @@ static void scsi_host_dev_release(struct
 		shost->eh_notify = NULL;
 	}
 
+	if (shost->create_work_queue)
+		destroy_workqueue(shost->work_q);
+
 	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
 	kfree(shost->shost_data);
@@ -247,6 +250,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->cmd_per_lun = sht->cmd_per_lun;
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
+	shost->create_work_queue = sht->create_work_queue;
 
 	if (sht->max_host_blocked)
 		shost->max_host_blocked = sht->max_host_blocked;
@@ -285,16 +289,27 @@ struct Scsi_Host *scsi_host_alloc(struct
 	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
 		  shost->host_no);
 
+	if (shost->create_work_queue) {
+		snprintf(shost->work_q_name, KOBJ_NAME_LEN, "scsi_wq_%d",
+			shost->host_no);
+		shost->work_q = create_singlethread_workqueue(
+			shost->work_q_name);
+		if (!shost->work_q)
+			goto fail_destroy_freelist;
+	}
+
 	shost->eh_notify = &complete;
 	rval = kernel_thread(scsi_error_handler, shost, 0);
 	if (rval < 0)
-		goto fail_destroy_freelist;
+		goto fail_destroy_workqueue;
 	wait_for_completion(&complete);
 	shost->eh_notify = NULL;
 
 	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
 
+ fail_destroy_workqueue:
+	destroy_workqueue(shost->work_q);
  fail_destroy_freelist:
 	scsi_destroy_command_freelist(shost);
  fail_kfree:
@@ -392,3 +407,26 @@ int scsi_is_host_device(const struct dev
 	return dev->release == scsi_host_dev_release;
 }
 EXPORT_SYMBOL(scsi_is_host_device);
+
+/**
+ * scsi_queue_work - Queue work to the Scsi_Host workqueue.
+ * @shost:	Pointer to Scsi_Host.
+ * @work:	Work to queue for execution.
+ *
+ * Return value: 
+ * 	0 on success / != 0 for error
+ **/
+int scsi_queue_work(struct Scsi_Host *shost, struct work_struct *work)
+{
+	if (unlikely(!shost->create_work_queue)) {
+		printk(KERN_ERR
+			"ERROR: Scsi host '%s' attempted to queue scsi-work, "
+			"when no workqueue created.\n", shost->hostt->name);
+		dump_stack();
+
+		return -EINVAL;
+	}
+
+	return queue_work(shost->work_q, work);
+}
+EXPORT_SYMBOL_GPL(scsi_queue_work);
===== include/scsi/scsi_host.h 1.26 vs edited =====
--- 1.26/include/scsi/scsi_host.h	2005-01-19 08:01:21 -08:00
+++ edited/include/scsi/scsi_host.h	2005-02-21 12:13:32 -08:00
@@ -4,6 +4,7 @@
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
 
 struct block_device;
 struct module;
@@ -363,6 +364,11 @@ struct scsi_host_template {
 	unsigned skip_settle_delay:1;
 
 	/*
+	 * True if a work-queue should be created for shost processing.
+	 */
+	unsigned create_work_queue:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding
 	 */
 	unsigned int max_host_blocked;
@@ -501,6 +507,11 @@ struct Scsi_Host {
 	 */
 	unsigned reverse_ordering:1;
 
+	unsigned create_work_queue:1;
+
+	char work_q_name[KOBJ_NAME_LEN];
+	struct workqueue_struct *work_q;
+
 	/*
 	 * Host has rejected a command because it was busy.
 	 */
@@ -598,6 +609,7 @@ extern void scsi_free_host_dev(struct sc
 extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
 int scsi_is_host_device(const struct device *);
 
+extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
 
 /* legacy interfaces */
 extern struct Scsi_Host *scsi_register(struct scsi_host_template *, int);
