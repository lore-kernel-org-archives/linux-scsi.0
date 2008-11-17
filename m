From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Reattach device handler for multipath devices
Date: Mon, 17 Nov 2008 12:29:55 +0100
Message-ID: <492155B3.6030204@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030206020509090707060601"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbYKQL35 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2008 06:29:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alasdair G Kergon <agk@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>, device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030206020509090707060601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi James, Aladair,

when using multipath the daemon might have specified
a different device handler than used by default.
(Eg Clariion in ALUA mode).
For these cases we currently cannot setup a multipath map
automatically as scsi_dh_attach() will fail.
Instead we should be trying to reattach with the correct
device handler and only return an error if that fails.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------030206020509090707060601
Content-Type: text/plain;
 name="dm-mpath-reattach-dh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-mpath-reattach-dh"

Reattach device handler for multipath devices

The multipath daemon might have specified a different device_handler
than the one a device is attached to by default.
So we should try to re-attach with the user-specified device_handler
and only return an error if that fails.

Signed-off-by: Hannes Reinecke <hare@suse.de

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 4840733..4e39966 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -592,9 +592,19 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 	}
 
 	if (m->hw_handler_name) {
-		r = scsi_dh_attach(bdev_get_queue(p->path.dev->bdev),
-				   m->hw_handler_name);
+		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+
+		r = scsi_dh_attach(q, m->hw_handler_name);
+		if (r == -EBUSY) {
+			/*
+			 * Already attached to different hw_handler,
+			 * try to reattach with correct one.
+			 */
+			scsi_dh_detach(q);
+			r = scsi_dh_attach(q, m->hw_handler_name);
+		}
 		if (r < 0) {
+			ti->error = "error attaching hardware handler";
 			dm_put_device(ti, p->path.dev);
 			goto bad;
 		}
diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index a518f2e..f5d592f 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -504,12 +504,9 @@ void scsi_dh_detach(struct request_queue *q)
 	if (!sdev)
 		return;
 
-	if (sdev->scsi_dh_data) {
-		/* if sdev is not on internal list, detach */
-		scsi_dh = sdev->scsi_dh_data->scsi_dh;
-		if (!device_handler_match(scsi_dh, sdev))
-			scsi_dh_handler_detach(sdev, scsi_dh);
-	}
+	if (sdev->scsi_dh_data)
+		scsi_dh_handler_detach(sdev, sdev->scsi_dh_data->scsi_dh);
+
 	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL_GPL(scsi_dh_detach);

--------------030206020509090707060601--
