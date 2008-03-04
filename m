From: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Tue, 04 Mar 2008 18:56:30 +0100
Message-ID: <47CD8D4E.3010703@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0803041151510.4039-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0803041151510.4039-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> So I need a
> way to know whether anything is mounted on a device below a SCSI host.

Actually I have been thinking of something related for a while but 
didn't send a patch yet.  Consider this:

[include/scsi/scsi_host.h]

  struct scsi_host_template {
	...
+	int (* slave_sdev_get)(struct scsi_device *);
+	void (* slave_sdev_put)(struct scsi_device *);
	...
  }

[drivers/scsi/scsi.c]

  int scsi_device_get(struct scsi_device *sdev)
  {
+	int err = 0;
+
  	if (sdev->sdev_state == SDEV_DEL)
  		return -ENXIO;
  	if (!get_device(&sdev->sdev_gendev))
  		return -ENXIO;
  	/* We can fail this if we're doing SCSI operations
  	 * from module exit (like cache flush) */
  	try_module_get(sdev->host->hostt->module);

-	return 0;
+	if (sdev->host->hostt->slave_sdev_get)
+		err = sdev->host->hostt->slave_sdev_get(sdev);
+	if (err) {
+		...some ifdef'd module_put stuff...;
+		put_device(&sdev->sdev_gendev);
+	}
+	return err;
}

and equivalent additions to scsi_device_put().

Example usage:

[drivers/ieee1394/sbp2.c]

+int sbp2_slave_sdev_get(struct scsi_device *sdev)
+{
+	struct sbp2_lu *lu = (struct sbp2_lu *)sdev->host->hostdata[0];
+
+	if (!try_module_get(lu->hi->host->driver->owner))
+		return -ENOMEM;
+	return 0;
+}

and an equivalent sbp2_slave_sdev_put().  These examples would prevent 
unloading ohci1394 while somebody has mounted a filesystem on a device 
driven by sbp2, or otherwise opened or referenced that device.  (At the 
moment sbp2 unintelligently gets the host->driver->owner as long as it 
is logged in into a device.  This is somewhat necessary because there 
are unrelated drivers in the ieee1394 stack which when unloaded with 
modprobe would cause ohci1394 to be unloaded too.)

You could use slave_sdev_get()/ slave_sdev_put() callbacks in 
usb-storage to do an own bookkeeping of references there.

(Since I haven't looked at your other current work, all of the above may 
be utterly besides the point...)
-- 
Stefan Richter
-=====-==--- --== --=--
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
