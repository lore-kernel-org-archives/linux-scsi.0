From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [RESEND] [PATCH]: scsi_dh: create sysfs file,
	dh_state for SCSI devices even if they are not in the internal lists
Date: Fri, 11 Sep 2009 10:20:35 -0700
Message-ID: <1252689635.2541.4.camel@chandra-ubuntu>
References: <1246069888.14164.53.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1246069888.14164.53.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mario Mech <mech@meteo.uni-koeln.de>, dm-devel <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Hi James,

This patch was sent to the list long back and was Acked by Hannes on Aug
11.

Please consider for inclusion. Let me know if you see any issues with
the patch.

regards,

chandra
-------------------------
Create the sysfs file, dh_state even if the new SCSI device is not
in the any of the device handler's internal lists.

Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Acked-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6.31/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.31.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.31/drivers/scsi/device_handler/scsi_dh.c
@@ -292,18 +292,15 @@ static int scsi_dh_notifier(struct notif
 	sdev = to_scsi_device(dev);
 
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		err = device_create_file(dev, &scsi_dh_state_attr);
+		/* don't care about err */
 		devinfo = device_handler_match(NULL, sdev);
-		if (!devinfo)
-			goto out;
-
-		err = scsi_dh_handler_attach(sdev, devinfo);
-		if (!err)
-			err = device_create_file(dev, &scsi_dh_state_attr);
+		if (devinfo)
+			err = scsi_dh_handler_attach(sdev, devinfo);
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		device_remove_file(dev, &scsi_dh_state_attr);
 		scsi_dh_handler_detach(sdev, NULL);
 	}
-out:
 	return err;
 }
 
