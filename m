From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH] usb/uas: use unique tags for all LUNs
Date: Mon, 19 Dec 2011 17:14:02 +0100
Message-ID: <20111219161402.GJ20801@linutronix.de>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
 <20111214225331.GA5508@xanatos>
 <4EE9B375.4020606@linutronix.de>
 <20111215211201.GA6482@xanatos>
 <20111216144724.GC19563@linutronix.de>
 <20111216201236.GE19563@linutronix.de>
 <20111216203146.GN14291@linux.intel.com>
 <20111216204241.GA30915@linutronix.de>
 <20111216213628.GA5509@xanatos>
 <1324072059.10429.27.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1324072059.10429.27.camel@dabdike>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

I observed that on a device with multiple LUNs UAS was re-using the same
tag number for requests which were issued at the same time to both LUNs.
This patch uses scsi_init_shared_tag_map() to use unique tags for all
LUNs. With this patch I haven't seen the same tag number during the init
sequence anymore. Devices which do not adverise command queueing I saw
only tag 1.
This patch initilizes the queue before adding the host like the other
two user in tree.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
* James Bottomley | 2011-12-16 22:47:39 [+0100]:

>Well, no, what you want to do is use a shared tag map at the block
>level.  That will manage a joint tag space for N queues without your
>having to partition it arbitrarily.  see scsi_host_find_tag() and
>scsi_init_shared_tag_map().

James, thank you for the two hints. This patch implements one of them.

 drivers/usb/storage/uas.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 09f55f9..4a8c062 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -690,6 +690,17 @@ static void uas_configure_endpoints(struct uas_dev_info *devinfo)
 	}
 }
 
+static void uas_free_streams(struct uas_dev_info *devinfo)
+{
+	struct usb_device *udev = devinfo->udev;
+	struct usb_host_endpoint *eps[3];
+
+	eps[0] = usb_pipe_endpoint(udev, devinfo->status_pipe);
+	eps[1] = usb_pipe_endpoint(udev, devinfo->data_in_pipe);
+	eps[2] = usb_pipe_endpoint(udev, devinfo->data_out_pipe);
+	usb_free_streams(devinfo->intf, eps, 3, GFP_KERNEL);
+}
+
 /*
  * XXX: What I'd like to do here is register a SCSI host for each USB host in
  * the system.  Follow usb-storage's design of registering a SCSI host for
@@ -719,18 +730,26 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	shost->max_id = 1;
 	shost->sg_tablesize = udev->bus->sg_tablesize;
 
-	result = scsi_add_host(shost, &intf->dev);
-	if (result)
-		goto free;
-	shost->hostdata[0] = (unsigned long)devinfo;
-
 	devinfo->intf = intf;
 	devinfo->udev = udev;
 	uas_configure_endpoints(devinfo);
 
+	result = scsi_init_shared_tag_map(shost, devinfo->qdepth - 1);
+	if (result)
+		goto free;
+
+	result = scsi_add_host(shost, &intf->dev);
+	if (result)
+		goto deconfig_eps;
+
+	shost->hostdata[0] = (unsigned long)devinfo;
+
 	scsi_scan_host(shost);
 	usb_set_intfdata(intf, shost);
 	return result;
+
+deconfig_eps:
+	uas_free_streams(devinfo);
  free:
 	kfree(devinfo);
 	if (shost)
@@ -752,18 +771,11 @@ static int uas_post_reset(struct usb_interface *intf)
 
 static void uas_disconnect(struct usb_interface *intf)
 {
-	struct usb_device *udev = interface_to_usbdev(intf);
-	struct usb_host_endpoint *eps[3];
 	struct Scsi_Host *shost = usb_get_intfdata(intf);
 	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
 
 	scsi_remove_host(shost);
-
-	eps[0] = usb_pipe_endpoint(udev, devinfo->status_pipe);
-	eps[1] = usb_pipe_endpoint(udev, devinfo->data_in_pipe);
-	eps[2] = usb_pipe_endpoint(udev, devinfo->data_out_pipe);
-	usb_free_streams(intf, eps, 3, GFP_KERNEL);
