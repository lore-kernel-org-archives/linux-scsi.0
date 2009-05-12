From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [Bugme-new] [Bug 13273] New: Error by disconnecting USB flash
 storage in 2.6.30-rc5 x86-64
Date: Tue, 12 May 2009 11:27:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905121113260.2824-100000@iolanthe.rowland.org>
References: <20090511140153.fe1b3f01.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090511140153.fe1b3f01.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: peter.kovar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 11 May 2009, Andrew Morton wrote:

> > http://bugzilla.kernel.org/show_bug.cgi?id=13273
> > 
> >            Summary: Error by disconnecting USB flash storage in 2.6.30-rc5
> >                     x86-64

> > [36225.730491] Call Trace:
> > [36225.730494]  [<ffffffff8113afdb>] register_disk+0xcb/0x140
> > [36225.730501]  [<ffffffff81208f77>] add_disk+0x87/0x160
> > [36225.730508]  [<ffffffffa002ad06>] sd_probe_async+0x1a6/0x290 [sd_mod]

Like I said earlier, this is a problem in the SCSI stack.  In
particular, sd_probe_sync() fails to acquire the host's scan_mutex or
to test scsi_host_scan_allowed().  Evidently Arjan's conversion to the
async framework did not preserve the software environment as it should
have.

Let us know if this patch helps.

Alan Stern


Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1892,12 +1892,16 @@ static int sd_format_disk_name(char *pre
 static void sd_probe_async(void *data, async_cookie_t cookie)
 {
 	struct scsi_disk *sdkp = data;
-	struct scsi_device *sdp;
+	struct scsi_device *sdp = sdkp->device;
+	struct Scsi_Host *shost = sdp->host;
 	struct gendisk *gd;
 	u32 index;
 	struct device *dev;
 
-	sdp = sdkp->device;
+	mutex_lock(&shost->scan_mutex);
+	if (!scsi_host_scan_allowed(shost))
+		goto out_unlock_host;
+
 	gd = sdkp->disk;
 	index = sdkp->index;
 	dev = &sdp->sdev_gendev;
@@ -1915,8 +1919,10 @@ static void sd_probe_async(void *data, a
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, dev_name(&sdp->sdev_gendev));
 
-	if (device_add(&sdkp->dev))
-		goto out_free_index;
+	if (device_add(&sdkp->dev)) {
+		ida_remove(&sd_index_ida, index);
+		goto out_unlock_host;
+	}
 
 	get_device(&sdp->sdev_gendev);
 
@@ -1955,10 +1961,8 @@ static void sd_probe_async(void *data, a
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 
-	return;
