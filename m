From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: oops on usb storage device disconnect with
	2.6.14-rc1
Date: Sat, 17 Sep 2005 19:36:41 -0500
Message-ID: <1127003801.4794.13.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509152133170.9589-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0509152133170.9589-100000@netrider.rowland.org>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Thu, 2005-09-15 at 21:52 -0400, Alan Stern wrote:
> In short, those iterations must be carried out as in my patch.

OK, I looked at making this work while reaping the target correctly, but
I couldn't (basic problem is that the target list keeps the target until
it has no more devices, a condition that could be made untrue by
something as simple as an open of the sysfs file).

So, rather than try that, I thought a better approach might be to make
the host state model work for us.  i.e. if we know the host is being
removed, there's no point allowing target or device removal because at
some point the host removal will do it for us.  This enforcement would
ensure we're the only legitimate removers of the target and device.

The alternative is to migrate to klists, I think ...

James

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -7,6 +7,7 @@
 struct request_queue;
 struct scsi_cmnd;
 struct scsi_device;
+struct scsi_target;
 struct scsi_host_template;
 struct scsi_request;
 struct Scsi_Host;
@@ -125,6 +126,7 @@ extern void scsi_sysfs_device_initialize
 extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
+extern void __scsi_remove_target(struct scsi_target *);
 
 extern struct bus_type scsi_bus_type;
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1481,7 +1481,7 @@ void scsi_forget_host(struct Scsi_Host *
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		scsi_remove_target(&starget->dev);
+		__scsi_remove_target(starget);
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -710,7 +710,8 @@ void scsi_remove_device(struct scsi_devi
 	struct Scsi_Host *shost = sdev->host;
 
 	down(&shost->scan_mutex);
-	__scsi_remove_device(sdev);
+	if (scsi_host_scan_allowed(shost))
+		__scsi_remove_device(sdev);
 	up(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
@@ -728,7 +729,7 @@ void __scsi_remove_target(struct scsi_ta
 		    sdev->id != starget->id)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		scsi_remove_device(sdev);
+		__scsi_remove_device(sdev);
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -755,7 +756,16 @@ void scsi_remove_target(struct device *d
 	struct device *rdev;
 
 	if (scsi_is_target_device(dev)) {
+		struct Scsi_Host *shost = dev_to_shost(dev);
+
+		down(&shost->scan_mutex);
+		/* We deny target removal here if the host is being
+		 * deleted, since it will remove the target itself */
+		if (!scsi_host_scan_allowed(shost))
+			goto out;
 		__scsi_remove_target(to_scsi_target(dev));
+	out:
+		up(&shost->scan_mutex);
 		return;
 	}
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -654,7 +654,8 @@ static inline struct device *scsi_get_de
  **/
 static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
 {
-	return shost->shost_state == SHOST_RUNNING;
+	return shost->shost_state == SHOST_RUNNING ||
+		shost->shost_state == SHOST_RECOVERY;
 }
 
 extern void scsi_unblock_requests(struct Scsi_Host *);





-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
