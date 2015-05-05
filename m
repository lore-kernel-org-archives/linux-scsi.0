From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v6 0/4] scsi: ufs & ums-* & esp_scsi: fix module
 reference counting
Date: Tue, 05 May 2015 08:35:54 -0700
Message-ID: <1430840154.2173.6.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1505041607350.1450-100000@iolanthe.rowland.org>
	 <1430775664.2177.36.camel@HansenPartnership.com>
	 <CAC5umyjN0h-p=V4jfgLVicEOJ9AJU+wUm1qJndaMYBE0sj9LMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38811 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993416AbbEEPf6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 11:35:58 -0400
In-Reply-To: <CAC5umyjN0h-p=V4jfgLVicEOJ9AJU+wUm1qJndaMYBE0sj9LMQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Tue, 2015-05-05 at 22:39 +0900, Akinobu Mita wrote:
> 2015-05-05 6:41 GMT+09:00 James Bottomley
> <James.Bottomley@hansenpartnership.com>:
> > On Mon, 2015-05-04 at 16:09 -0400, Alan Stern wrote:
> >> On Mon, 4 May 2015, James Bottomley wrote:
> >>
> >> > However, it does also strike me that these three drivers have problems
> >> > because they're using the wrong initialisation pattern: the template is
> >> > supposed to be in the bus connector for compound drivers not in the
> >> > core.
> >>
> >> Why is it supposed to be done that way?  Isn't that less efficient?  It
> >> means you have to have a separate copy of the template for each bus
> >> connector driver, instead of letting them all share a common template
> >> in the core.
> >
> > Well, no it doesn't.  The way 53c700 implements it is that there is a
> > common template in the core.  The drivers just initialise their variant
> > fields (for 53c700 it's name, proc_name and this_id) and the core fills
> > in the rest.  Admittedly wd33c93 doesn't quite get this right, that's
> > why I cited 53c700.
> 
> I have converted usb-storage and ums-alauda in the attached patch.
> Each ums-* driver needs to expand module_usb_driver() macro as we need
> to initialize their scsi host template in module_init().

Actually, I was more thinking something like this (mirroring 53c700).
It hides more of the internals rather than exposing them.

James

---

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 4b55ab6..6cfc5c2 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -1232,6 +1232,12 @@ static int alauda_transport(struct scsi_cmnd *srb, struct us_data *us)
 	return USB_STOR_TRANSPORT_FAILED;
 }
 
+static struct scsi_host_template aluda_template = {
+	.name = "aluda",
+	.proc_name = "aluda",
+	.module = THIS_MODULE,
+};
+
 static int alauda_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -1239,7 +1245,8 @@ static int alauda_probe(struct usb_interface *intf,
 	int result;
 
 	result = usb_stor_probe1(&us, intf, id,
-			(id - alauda_usb_ids) + alauda_unusual_dev_list);
+			(id - alauda_usb_ids) + alauda_unusual_dev_list,
+			&aluda_template);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 0e400f3..3d84a41 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -539,58 +539,58 @@ static struct device_attribute *sysfs_device_attr_list[] = {
 /*
  * this defines our host template, with which we'll allocate hosts
  */
-
-struct scsi_host_template usb_stor_host_template = {
+void usb_stor_template_init(struct scsi_host_template *tpnt)
+{
 	/* basic userland interface stuff */
-	.name =				"usb-storage",
-	.proc_name =			"usb-storage",
-	.show_info =			show_info,
-	.write_info =			write_info,
-	.info =				host_info,
+	if (!tpnt->name)
+		tpnt->name = "usb-storage";
+	if (!tpnt->proc_name)
+		tpnt->proc_name = "usb-storage";
+
+	tpnt->show_info = show_info;
+	tpnt->write_info = write_info;
+	tpnt->info = host_info;
 
 	/* command interface -- queued only */
-	.queuecommand =			queuecommand,
+	tpnt->queuecommand = queuecommand;
 
 	/* error and abort handlers */
-	.eh_abort_handler =		command_abort,
-	.eh_device_reset_handler =	device_reset,
-	.eh_bus_reset_handler =		bus_reset,
+	tpnt->eh_abort_handler = command_abort;
+	tpnt->eh_device_reset_handler = device_reset;
+	tpnt->eh_bus_reset_handler = bus_reset;
 
 	/* queue commands only, only one command per LUN */
-	.can_queue =			1,
-	.cmd_per_lun =			1,
+	tpnt->can_queue = 1;
+	tpnt->cmd_per_lun = 1;
 
 	/* unknown initiator id */
-	.this_id =			-1,
+	tpnt->this_id = -1;
 
-	.slave_alloc =			slave_alloc,
-	.slave_configure =		slave_configure,
-	.target_alloc =			target_alloc,
+	tpnt->slave_alloc = slave_alloc;
+	tpnt->slave_configure = slave_configure;
+	tpnt->target_alloc = target_alloc;
 
 	/* lots of sg segments can be handled */
-	.sg_tablesize =			SCSI_MAX_SG_CHAIN_SEGMENTS,
+	tpnt->sg_tablesize = SCSI_MAX_SG_CHAIN_SEGMENTS;
 
 	/* limit the total size of a transfer to 120 KB */
-	.max_sectors =                  240,
+	tpnt->max_sectors =                   240;
 
 	/* merge commands... this seems to help performance, but
 	 * periodically someone should test to see which setting is more
 	 * optimal.
 	 */
-	.use_clustering =		1,
+	tpnt->use_clustering = 1;
 
 	/* emulated HBA */
-	.emulated =			1,
+	tpnt->emulated = 1;
 
 	/* we do our own delay after a device or bus reset */
-	.skip_settle_delay =		1,
+	tpnt->skip_settle_delay = 1;
 
 	/* sysfs device attributes */
-	.sdev_attrs =			sysfs_device_attr_list,
-
-	/* module management */
-	.module =			THIS_MODULE
-};
+	tpnt->sdev_attrs = sysfs_device_attr_list;
+}
 
 /* To Report "Illegal Request: Invalid Field in CDB */
 unsigned char usb_stor_sense_invalidCDB[18] = {
diff --git a/drivers/usb/storage/scsiglue.h b/drivers/usb/storage/scsiglue.h
index ffa1cca..ae0ed71 100644
--- a/drivers/usb/storage/scsiglue.h
+++ b/drivers/usb/storage/scsiglue.h
@@ -41,8 +41,8 @@
 
 extern void usb_stor_report_device_reset(struct us_data *us);
 extern void usb_stor_report_bus_reset(struct us_data *us);
+extern void usb_stor_template_init(struct scsi_host_template *tpnt);
 
 extern unsigned char usb_stor_sense_invalidCDB[18];
-extern struct scsi_host_template usb_stor_host_template;
 
 #endif
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 5600c33..020d7ed 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -920,7 +920,8 @@ static unsigned int usb_stor_sg_tablesize(struct usb_interface *intf)
 int usb_stor_probe1(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
-		struct us_unusual_dev *unusual_dev)
+		struct us_unusual_dev *unusual_dev,
+		struct scsi_host_template *tpnt)
 {
 	struct Scsi_Host *host;
 	struct us_data *us;
@@ -928,11 +929,13 @@ int usb_stor_probe1(struct us_data **pus,
 
 	dev_info(&intf->dev, "USB Mass Storage device detected\n");
 
+
 	/*
 	 * Ask the SCSI layer to allocate a host structure, with extra
 	 * space at the end for our private us_data structure.
 	 */
-	host = scsi_host_alloc(&usb_stor_host_template, sizeof(*us));
+	usb_stor_template_init(tpnt);
+	host = scsi_host_alloc(tpnt, sizeof(*us));
 	if (!host) {
 		dev_warn(&intf->dev, "Unable to allocate the scsi host\n");
 		return -ENOMEM;
@@ -1069,6 +1072,10 @@ void usb_stor_disconnect(struct usb_interface *intf)
 }
 EXPORT_SYMBOL_GPL(usb_stor_disconnect);
 
+static struct scsi_host_template storage_template = {
+	.module = THIS_MODULE,
+};
+
 /* The main probe routine for standard devices */
 static int storage_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
@@ -1109,7 +1116,7 @@ static int storage_probe(struct usb_interface *intf,
 			id->idVendor, id->idProduct);
 	}
 
-	result = usb_stor_probe1(&us, intf, id, unusual_dev);
+	result = usb_stor_probe1(&us, intf, id, unusual_dev, &storage_template);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
index 307e339..918cee8 100644
--- a/drivers/usb/storage/usb.h
+++ b/drivers/usb/storage/usb.h
@@ -197,7 +197,8 @@ extern int usb_stor_post_reset(struct usb_interface *iface);
 extern int usb_stor_probe1(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
-		struct us_unusual_dev *unusual_dev);
+		struct us_unusual_dev *unusual_dev,
+		struct scsi_host_template *tpnt);
 extern int usb_stor_probe2(struct us_data *us);
 extern void usb_stor_disconnect(struct usb_interface *intf);
 


