From: linux@dragonhold.org
Subject: [PATCH] qla1280.c patch against 2.6.9 to allow settings of Initiator ID
Date: Fri, 5 Nov 2004 01:18:30 +0000
Message-ID: <20041105011830.GG8974@dragonhold.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ramoth.dragonhold.org ([80.229.192.20]:20370 "EHLO
	ramoth.dragonhold.org") by vger.kernel.org with ESMTP
	id S262541AbUKEBSj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Nov 2004 20:18:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Possible Patch
==============

I've attached a patch to allow the SCSI Initiator ID in NVRAM to be over-ridden for these
controllers.  It is a single ID passed when loaded as a module, allowing you to set all the
controllers attached to your machine to the same specified SCSI ID.  I've tested it on my
machine, but know of no-one else using these cards that is running linux.

I'm also not sure if this is the sort of thing that anyone other than me would be interested
in, and I can't find a maintainer specifically for the qla1280 driver.  So please accept my
apologies if this shouldn't have been sent to you.

It's the first I've done, so I'm more than willing to listen to suggestions on how to
improve the style and/or code.


Thanks,

Graham


Signed-off-by:  Graham Wood <linux@dragonhold.org>


--- /usr/src/linux-2.6.9/drivers/scsi/qla1280.c.orig	2004-11-04 23:36:21.000000000 +0000
+++ /usr/src/linux-2.6.9/drivers/scsi/qla1280.c	2004-11-05 01:01:18.000000000 +0000
@@ -586,9 +586,12 @@ static void __qla1280_dump_buffer(char *
  */
 #ifdef MODULE
 static char *qla1280;
+int adapter_id=-1;
 
 /* insmod qla1280 options=verbose" */
 MODULE_PARM(qla1280, "s");
+MODULE_PARM(adapter_id, "i");
+MODULE_PARM_DESC(adapter_id, "SCSI Initiator ID: -1 use NVRAM, 0-15 set)");
 #else
 __setup("qla1280=", qla1280_setup);
 #endif
@@ -2494,8 +2497,24 @@ qla1280_config_bus(struct scsi_qla_host 
 	/* Initiator ID. */
 	ha->bus_settings[bus].id = nv->bus[bus].config_1.initiator_id;
 	mb[0] = MBC_SET_INITIATOR_ID;
+#ifdef MODULE
+	if (adapter_id <0 || adapter_id>15) {
+		if (adapter_id != -1) {
+			printk(KERN_WARNING
+				"qla1280 provided illegal adapter_id."
+				"  Using NVRAM default\n");
+		}
+		mb[1] = bus ? ha->bus_settings[bus].id | BIT_7 :
+			ha->bus_settings[bus].id;
+	} else {
+		mb[1] = bus ? adapter_id | BIT_7 :
+			adapter_id;
+	}
+#else
 	mb[1] = bus ? ha->bus_settings[bus].id | BIT_7 :
 		ha->bus_settings[bus].id;
+#endif
+
 	status = qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
 
 	/* Reset Delay. */
