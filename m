From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: [PATCH 2/4] usb-storage: Associate the name of the interface with
	the scsi host
Date: Thu, 24 Sep 2009 16:19:11 -0600
Message-ID: <20090924221911.GC7943@parisc-linux.org>
References: <20090920225348.GB3690@parisc-linux.org> <Pine.LNX.4.44L0.0909202104300.14465-100000@netrider.rowland.org> <20090924221702.GA7943@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090924221702.GA7943-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Instead of reporting "SCSI emulation for USB Mass Storage devices",
report "usb-storage 1-4:1.0".

Signed-off-by: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/usb/storage/scsiglue.c |    3 ++-
 drivers/usb/storage/usb.c      |    2 ++
 drivers/usb/storage/usb.h      |    1 +
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index cfa26d5..e5e6df3 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -73,7 +73,8 @@
 
 static const char* host_info(struct Scsi_Host *host)
 {
-	return "SCSI emulation for USB Mass Storage devices";
+	struct us_data *us = host_to_us(host);
+	return us->scsi_name;
 }
 
 static int slave_alloc (struct scsi_device *sdev)
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 8060b85..39d3e54 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -929,6 +929,8 @@ int usb_stor_probe2(struct us_data *us)
 	result = usb_stor_acquire_resources(us);
 	if (result)
 		goto BadDevice;
+	snprintf(us->scsi_name, sizeof(us->scsi_name), "usb-storage %s",
+					dev_name(&us->pusb_intf->dev));
 	result = scsi_add_host(us_to_host(us), &us->pusb_intf->dev);
 	if (result) {
 		printk(KERN_WARNING USB_STORAGE
diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
index 2609efb..6971713 100644
--- a/drivers/usb/storage/usb.h
+++ b/drivers/usb/storage/usb.h
@@ -132,6 +132,7 @@ struct us_data {
 	/* SCSI interfaces */
 	struct scsi_cmnd	*srb;		 /* current srb		*/
 	unsigned int		tag;		 /* current dCBWTag	*/
+	char			scsi_name[32];	 /* scsi_host name	*/
 
 	/* control and bulk communications data */
 	struct urb		*current_urb;	 /* USB requests	 */
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
