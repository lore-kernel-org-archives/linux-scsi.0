From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [Patch] take 4: Correct issue with midlayer scsi target allocation and transports that create the targets
Date: Tue, 14 Jun 2005 15:17:00 -0700
Message-ID: <20050614221700.GA15695@us.ibm.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC72@xbl3.ad.emulex.com> <20050611153745.GA31943@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:58292 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261378AbVFNWRn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 18:17:43 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j5EMHh3o160620
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2005 18:17:43 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5EMHgjx123926
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2005 16:17:42 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j5EMHgpc000630
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2005 16:17:42 -0600
Content-Disposition: inline
In-Reply-To: <20050611153745.GA31943@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Hi ... yet another patch to fix user space scanning.

Based on code in James Smart patch, but moves the ->target_parent call
outside of scsi_alloc_target.

Adding a transport->scan does not play well with __scsi_add_device and
scsi_get_host_dev.

There appears to be a ref-counting issue with rport->dev, both in this
patch, and in current code calling scsi_scan_target(&rport->dev ...), or I
am misunderstanding the code (rport->dev ref count is not incremented)
hence the FIXME.

Signed off by: Patrick Mansfield <patmans@us.ibm.coM>

diff -uprN -X /home/patman/dontdiff scsi-rc-fixes-2.6/drivers/scsi/scsi_scan.c uscan-scsi-rc-fixes-2.6/drivers/scsi/scsi_scan.c
--- scsi-rc-fixes-2.6/drivers/scsi/scsi_scan.c	Tue Jun 14 10:15:57 2005
+++ uscan-scsi-rc-fixes-2.6/drivers/scsi/scsi_scan.c	Tue Jun 14 11:40:56 2005
@@ -373,6 +373,15 @@ static struct scsi_target *scsi_alloc_ta
 	return found_target;
 }
 
+static struct device *scsi_target_parent(struct Scsi_Host *shost, unsigned
+					int channel, unsigned int id)
+{
+	if (shost->transportt->target_parent)
+		return shost->transportt->target_parent(shost, channel, id);
+	else 
+		return &shost->shost_gendev;
+}
+
 /**
  * scsi_target_reap - check to see if target is in use and destroy if not
  *
@@ -1190,10 +1199,15 @@ struct scsi_device *__scsi_add_device(st
 				      uint id, uint lun, void *hostdata)
 {
 	struct scsi_device *sdev;
-	struct device *parent = &shost->shost_gendev;
+	struct device *parent;
 	int res;
-	struct scsi_target *starget = scsi_alloc_target(parent, channel, id);
+	struct scsi_target *starget;
 
+	parent = scsi_target_parent(shost, channel, id);
+	if (!parent)
+		return ERR_PTR(-ENODEV);
+
+	starget = scsi_alloc_target(parent, channel, id);
 	if (!starget)
 		return ERR_PTR(-ENOMEM);
 
@@ -1314,6 +1328,7 @@ static void scsi_scan_channel(struct Scs
 			      unsigned int id, unsigned int lun, int rescan)
 {
 	uint order_id;
+	struct device *parent;
 
 	if (id == SCAN_WILD_CARD)
 		for (id = 0; id < shost->max_id; ++id) {
@@ -1333,10 +1348,16 @@ static void scsi_scan_channel(struct Scs
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			scsi_scan_target(&shost->shost_gendev, channel, order_id, lun, rescan);
+			parent = scsi_target_parent(shost, channel, id);
+			if (parent)
+				scsi_scan_target(parent, channel,
+						 order_id, lun, rescan);
 		}
-	else
-		scsi_scan_target(&shost->shost_gendev, channel, id, lun, rescan);
+	else {
+		parent = scsi_target_parent(shost, channel, id);
+		if (parent)
+			scsi_scan_target(parent, channel, id, lun, rescan);
+	}
 }
 
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
@@ -1432,8 +1453,12 @@ struct scsi_device *scsi_get_host_dev(st
 {
 	struct scsi_device *sdev;
 	struct scsi_target *starget;
+	struct device *parent;
 
-	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
+	parent = scsi_target_parent(shost, 0, shost->this_id);
+	if (!parent)
+		return NULL;
+	starget = scsi_alloc_target(parent, 0, shost->this_id);
 	if (!starget)
 		return NULL;
 
diff -uprN -X /home/patman/dontdiff scsi-rc-fixes-2.6/drivers/scsi/scsi_transport_fc.c uscan-scsi-rc-fixes-2.6/drivers/scsi/scsi_transport_fc.c
--- scsi-rc-fixes-2.6/drivers/scsi/scsi_transport_fc.c	Tue Jun 14 10:15:57 2005
+++ uscan-scsi-rc-fixes-2.6/drivers/scsi/scsi_transport_fc.c	Tue Jun 14 13:25:35 2005
@@ -1022,6 +1022,27 @@ static int fc_rport_match(struct attribu
 	return &i->rport_attr_cont.ac == cont;
 }
 
+static struct device *fc_target_parent(struct Scsi_Host *shost,
+					int channel, uint id)
+{
+	struct fc_rport *rport;
+	struct device *parent = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(rport, &fc_host_rports(shost), peers)
+		if ((rport->channel == channel) &&
+		    (rport->scsi_target_id == id)) {
+			parent = &rport->dev;
+			/*
+			 * FIXME who holds parent in place?
+			 */
+			break;
+		}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return parent;
+}
+
 struct scsi_transport_template *
 fc_attach_transport(struct fc_function_template *ft)
 {
@@ -1057,6 +1078,8 @@ fc_attach_transport(struct fc_function_t
 
 	/* Transport uses the shost workq for scsi scanning */
 	i->t.create_work_queue = 1;
+
+	i->t.target_parent = fc_target_parent;
 	
 	/*
 	 * Setup SCSI Target Attributes.
diff -uprN -X /home/patman/dontdiff scsi-rc-fixes-2.6/include/scsi/scsi_transport.h uscan-scsi-rc-fixes-2.6/include/scsi/scsi_transport.h
--- scsi-rc-fixes-2.6/include/scsi/scsi_transport.h	Tue Jun 14 10:16:26 2005
+++ uscan-scsi-rc-fixes-2.6/include/scsi/scsi_transport.h	Tue Jun 14 11:21:36 2005
@@ -27,6 +27,13 @@ struct scsi_transport_template {
 	struct transport_container host_attrs;
 	struct transport_container target_attrs;
 	struct transport_container device_attrs;
+	/*
+	 * If set, call target_parent prior to allocating or scanning a
+	 * scsi_target, so we get the appropriate parent for the target.
+	 * This function is required for transports like FC and iSCSI that
+	 * do not put the scsi_target under scsi_host.
+	 */
+	struct device *(*target_parent)(struct Scsi_Host *, int, uint);
 
 	/* The size of the specific transport attribute structure (a
 	 * space of this size will be left at the end of the
