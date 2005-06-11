From: James.Smart@Emulex.Com
Subject: RE: [Patch] Correct issue with midlayer scsi target allocation and transports that create the targets
Date: Fri, 10 Jun 2005 22:24:30 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC72@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:54676 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261185AbVFKCYh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 22:24:37 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

Yep... I heard from some others with the same comments. 

Here's a streamlined version of this patch. Gets rid of all
the list searching, atomic add to the list, etc...

-- James

> I don't like the recursion part of this at all.  I'd suggest to make
> scsi_alloc_target a tiny wrapper around the transport ->alloc_target +
> a default action, the shared body that's in scsi_alloc_target will
> become __scsi_alloc_target.
> 
> > +	spin_lock_irqsave(shost->host_lock, flags);
> > +	list_for_each_entry_safe(rport, next_rport,
> > +			&fc_host_rports(shost), peers) {
> 
> you don't actually need list_for_each_entry_safe here as 
> you're dropping
> out of the loop once the right rport has been found.
> 
> > +		if ((rport->channel == channel) &&
> > +		    (rport->scsi_target_id == id)) {
> > +			spin_unlock_irqrestore(shost->host_lock, flags);
> > +			starget = 
> scsi_alloc_target(&rport->dev, channel, id);
> > +			if (starget)
> > +				return 0;
> > +			return 1;
> 
> this is always under the scan_mutex, right?  else we'd get a 
> race after
> the sin_unlock but before registering the new target.



diff -upNr linux-2.6.12-rc6/drivers/scsi/scsi_scan.c linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_scan.c
--- linux-2.6.12-rc6/drivers/scsi/scsi_scan.c	2005-06-09 15:58:31.000000000 -0400
+++ linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_scan.c	2005-06-10 16:11:04.000000000 -0400
@@ -332,9 +332,23 @@ static struct scsi_target *scsi_alloc_ta
 	unsigned long flags;
 	const int size = sizeof(struct scsi_target)
 		+ shost->transportt->target_size;
-	struct scsi_target *starget = kmalloc(size, GFP_ATOMIC);
+	struct scsi_target *starget;
 	struct scsi_target *found_target;
 
+	/*
+	 * Obtain the real parent from the transport. The transport
+	 * is allowed to fail (no error) if there is nothing at that
+	 * target id.
+	 */
+	if (shost->transportt->target_parent) {
+		spin_lock_irqsave(shost->host_lock, flags);
+		parent = shost->transportt->target_parent(shost, channel, id);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		if (!parent)
+			return NULL;
+	}
+
+	starget = kmalloc(size, GFP_KERNEL);
 	if (!starget) {
 		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
 		return NULL;
diff -upNr linux-2.6.12-rc6/drivers/scsi/scsi_transport_fc.c linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_transport_fc.c
--- linux-2.6.12-rc6/drivers/scsi/scsi_transport_fc.c	2005-06-09 15:58:31.000000000 -0400
+++ linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_transport_fc.c	2005-06-10 16:01:20.000000000 -0400
@@ -1022,6 +1022,23 @@ static int fc_rport_match(struct attribu
 	return &i->rport_attr_cont.ac == cont;
 }
 
+
+/*
+ * Must be called with shost->host_lock held
+ */
+static struct device *fc_target_parent(struct Scsi_Host *shost,
+					int channel, uint id)
+{
+	struct fc_rport *rport;
+
+	list_for_each_entry(rport, &fc_host_rports(shost), peers)
+		if ((rport->channel == channel) &&
+		    (rport->scsi_target_id == id))
+			return &rport->dev;
+
+	return NULL;
+}
+
 struct scsi_transport_template *
 fc_attach_transport(struct fc_function_template *ft)
 {
@@ -1057,6 +1074,8 @@ fc_attach_transport(struct fc_function_t
 
 	/* Transport uses the shost workq for scsi scanning */
 	i->t.create_work_queue = 1;
+
+	i->t.target_parent = fc_target_parent;
 	
 	/*
 	 * Setup SCSI Target Attributes.
diff -upNr linux-2.6.12-rc6/include/scsi/scsi_transport.h linux-2.6.12-rc6.PATCHED/include/scsi/scsi_transport.h
--- linux-2.6.12-rc6/include/scsi/scsi_transport.h	2005-06-09 15:58:52.000000000 -0400
+++ linux-2.6.12-rc6.PATCHED/include/scsi/scsi_transport.h	2005-06-10 15:58:32.000000000 -0400
@@ -28,6 +28,14 @@ struct scsi_transport_template {
 	struct transport_container target_attrs;
 	struct transport_container device_attrs;
 
+	/*
+	 * If set, call target_parent prior to allocating a scsi_target,
+	 * so we get the appropriate parent for the target. This function
+	 * is required for transports like FC and iSCSI that do not put the
+	 * scsi_target under scsi_host.
+	 */
+	struct device *(*target_parent)(struct Scsi_Host *, int, uint);
+
 	/* The size of the specific transport attribute structure (a
 	 * space of this size will be left at the end of the
 	 * scsi_* structure */
@@ -35,9 +43,7 @@ struct scsi_transport_template {
 	int	target_size;
 	int	host_size;
 
-	/*
-	 * True if the transport wants to use a host-based work-queue
-	 */
+	/* True if the transport wants to use a host-based work-queue */
 	unsigned int create_work_queue : 1;
 };
 
