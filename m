From: James.Smart@Emulex.Com
Subject: RE: [RFC] adding per scsi-host workqueues for defered processing
Date: Sat, 5 Mar 2005 08:07:48 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12ECD6@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:38563 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261283AbVCENH6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Mar 2005 08:07:58 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

>Following discussions which resulted from the:
>
>[RFC] target code updates to support scanned targets
>http://marc.theaimsgroup.com/?l=linux-scsi&m=110850749515984&w=2
>
>thread, the overall consensus seems to be that transport-classes
>should support a 'true-hotplug' mechanism of device discovery and
>removal (this involves both registration and lun-scanning).  In order
>to facilitate this ability and to not constrain the LLDD from the
>typical restrictions of the storage scanning process:
>
>* must be done from process context -- depending on transport type,
>  discovery can occur from a non-process context
>* potentially _long_ scan times -- even if discovery is done from a
>  'sleeping' capable context, halting a LLDD for discovery purposes
>  is typically undesirable.
>
>I'd like to propose the addition of a per-Scsi_Host work-queue to
>manage these scanning as well as any other (relevant)
>lower-level-driver differed requests.

The thing I disliked about this patch was that it required the
LLDD to know that the transport needs a workq, thus set the host
template appropriately.

Instead, we should have the transport template, initialized by the
transport, indicate whether the workq needs to exist or not. This does
mean that the new interface is more restricted, as it essentially
excludes the LLDD from using it. It doesn't seem unreasonable as the
LLDD is always free to create it's own work queues.

I've attached a revised patch.

One other note:
>		scsi_scan_target(&rport->dev, rport->channel,
>			rport->scsi_target_id, SCAN_WILD_CARD, 0);

The rescan flag should be 1, not 0. If 0, all kinds of bad things can
happen as of the 2nd scan request.

-- james s



diff -puN a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	2005-03-05 06:55:47.000000000 -0500
+++ b/drivers/scsi/hosts.c	2005-03-05 07:13:43.000000000 -0500
@@ -129,6 +129,15 @@ int scsi_add_host(struct Scsi_Host *shos
 					 GFP_KERNEL)) == NULL)
 		goto out_del_classdev;
 
+	if (shost->transportt->create_work_queue) {
+		snprintf(shost->work_q_name, KOBJ_NAME_LEN, "scsi_wq_%d",
+			shost->host_no);
+		shost->work_q = create_singlethread_workqueue(
+					shost->work_q_name);
+		if (!shost->work_q)
+			goto out_free_shost_data;
+	}
+
 	error = scsi_sysfs_add_host(shost);
 	if (error)
 		goto out_destroy_host;
@@ -137,6 +146,10 @@ int scsi_add_host(struct Scsi_Host *shos
 	return error;
 
  out_destroy_host:
+	if (shost->work_q)
+		destroy_workqueue(shost->work_q);
+ out_free_shost_data:
+	kfree(shost->shost_data);
  out_del_classdev:
 	class_device_del(&shost->shost_classdev);
  out_del_gendev:
@@ -160,6 +173,9 @@ static void scsi_host_dev_release(struct
 		shost->eh_notify = NULL;
 	}
 
+	if (shost->work_q)
+		destroy_workqueue(shost->work_q);
+
 	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
 	kfree(shost->shost_data);
@@ -393,3 +409,27 @@ int scsi_is_host_device(const struct dev
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
+	if (unlikely(!shost->work_q)) {
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
+
diff -puN a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2005-03-05 06:56:48.000000000 -0500
+++ b/include/scsi/scsi_host.h	2005-03-05 07:07:12.000000000 -0500
@@ -4,6 +4,7 @@
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
 
 struct block_device;
 struct module;
@@ -508,6 +509,12 @@ struct Scsi_Host {
 	unsigned reverse_ordering:1;
 
 	/*
+	 * Optional work queue to be utilized by the transport
+	 */
+	char work_q_name[KOBJ_NAME_LEN];
+	struct workqueue_struct *work_q;
+
+	/*
 	 * Host has rejected a command because it was busy.
 	 */
 	unsigned int host_blocked;
@@ -570,6 +577,8 @@ static inline struct Scsi_Host *dev_to_s
 	return container_of(dev, struct Scsi_Host, shost_gendev);
 }
 
+extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
+
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int __must_check scsi_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_scan_host(struct Scsi_Host *);
diff -puN a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
--- a/include/scsi/scsi_transport.h	2005-03-05 07:01:29.000000000 -0500
+++ b/include/scsi/scsi_transport.h	2005-03-05 07:03:21.000000000 -0500
@@ -34,6 +34,11 @@ struct scsi_transport_template {
 	int	device_size;
 	int	target_size;
 	int	host_size;
+
+	/*
+	 * True if the transport wants to use a host-based work-queue
+	 */
+	unsigned int create_work_queue : 1;
 };
 
 #define transport_class_to_shost(tc) \
_
