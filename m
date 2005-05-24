From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/3] MidLayer updates - extending scsi_target support
Date: Tue, 24 May 2005 12:06:38 -0500
Message-ID: <1116954398.5897.10.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C12EAB3@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:1496 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261292AbVEXRGq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 13:06:46 -0400
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EAB3@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-01-29 at 09:03 -0500, James.Smart@Emulex.Com wrote:
> Patch 3: 
>   This patch extends scsi_target support:
>   - Allows for driver-specific data to be allocated along with the
>     target structure and accessible via the starget->hostdata pointer.
>   - Adds scsi target alloc/configure/destory callbacks to the
>     scsi host template.
>   - Rearranges the calling sequences for scsi targets so that the
>     target and slave alloc/configure/destory callbacks are in
>     order (target before slave on alloc/configure).

Well, after making you do this another way, it turns out I have a use
for a simplified version of the patch (attached below).

All I really want to do is get the target alloc/destroy signals (no
configure).  I also removed the storage sizing, since I have a simpler
method for that in the transport class.

James

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -293,6 +293,10 @@ static void scsi_target_dev_release(stru
 {
 	struct device *parent = dev->parent;
 	struct scsi_target *starget = to_scsi_target(dev);
+	struct Scsi_Host *shost = dev_to_shost(parent);
+
+	if (shost->hostt->target_destroy)
+		shost->hostt->target_destroy(starget);
 	kfree(starget);
 	put_device(parent);
 }
@@ -360,9 +364,23 @@ static struct scsi_target *scsi_alloc_ta
 	list_add_tail(&starget->siblings, &shost->__targets);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
-	transport_setup_device(&starget->dev);
-	device_add(&starget->dev);
-	transport_add_device(&starget->dev);
+	transport_setup_device(dev);
+	device_add(dev);
+	transport_add_device(dev);
+	if (shost->hostt->target_alloc) {
+		int error = shost->hostt->target_alloc(starget);
+
+		if(error) {
+			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
+			/* don't want scsi_target_reap to do the final
+			 * put because it will be under the host lock */
+			get_device(dev);
+			scsi_target_reap(starget);
+			put_device(dev);
+			return NULL;
+		}
+	}
+
 	return starget;
 
  found:
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -154,7 +154,9 @@ struct scsi_target {
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
 	unsigned long		create:1; /* signal that it needs to be added */
-	unsigned long		starget_data[0];
+	void 			*hostdata; /* available to low-level driver */
+	unsigned long		starget_data[0]; /* for the transport */
+	/* starget_data must be the last element!!!! */
 } __attribute__((aligned(sizeof(unsigned long))));
 
 #define to_scsi_target(d)	container_of(d, struct scsi_target, dev)
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -10,6 +10,7 @@ struct block_device;
 struct module;
 struct scsi_cmnd;
 struct scsi_device;
+struct scsi_target;
 struct Scsi_Host;
 struct scsi_host_cmd_pool;
 struct scsi_transport_template;
@@ -228,6 +229,30 @@ struct scsi_host_template {
 	void (* slave_destroy)(struct scsi_device *);
 
 	/*
+	 * Before the mid layer attempts to scan for a new device attached
+	 * to a target where no target currently exists, it will call this
+	 * entry in your driver.  Should your driver need to allocate any
+	 * structs or perform any other init items in order to send commands
+	 * to a currently unused target, then this is where you can perform
+	 * those allocations.
+	 *
+	 * Return values: 0 on success, non-0 on failure
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* target_alloc)(struct scsi_target *);
+
+	/*
+	 * Immediately prior to deallocating the target structure, and
+	 * after all activity to attached scsi devices has ceased, the
+	 * midlayer calls this point so that the driver may deallocate
+	 * and terminate any references to the target.
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (* target_destroy)(struct scsi_target *);
+
+	/*
 	 * fill in this function to allow the queue depth of this host
 	 * to be changeable (on a per device basis).  returns either
 	 * the current queue depth setting (may be different from what


