From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] scsi: replace custom approach to hexdump small buffers
Date: Fri,  6 May 2016 19:38:02 +0300
Message-ID: <1462552682-47093-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:19305 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbcEFQiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 12:38:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com, Jon Mason <jonmason@broadcom.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

In kernel we have defined specifier (%*ph[C]) to dump small buffers in a hex
format. Replace custom approach by a generic one.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/scsi_transport_srp.c | 11 +----------
 drivers/scsi/sd.c                 |  4 +---
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index e3cd3ec..02cfc6b 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -115,21 +115,12 @@ static DECLARE_TRANSPORT_CLASS(srp_host_class, "srp_host", srp_host_setup,
 static DECLARE_TRANSPORT_CLASS(srp_rport_class, "srp_remote_ports",
 			       NULL, NULL, NULL);
 
-#define SRP_PID(p) \
-	(p)->port_id[0], (p)->port_id[1], (p)->port_id[2], (p)->port_id[3], \
-	(p)->port_id[4], (p)->port_id[5], (p)->port_id[6], (p)->port_id[7], \
-	(p)->port_id[8], (p)->port_id[9], (p)->port_id[10], (p)->port_id[11], \
-	(p)->port_id[12], (p)->port_id[13], (p)->port_id[14], (p)->port_id[15]
-
-#define SRP_PID_FMT "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:" \
-	"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x"
-
 static ssize_t
 show_srp_rport_id(struct device *dev, struct device_attribute *attr,
 		  char *buf)
 {
 	struct srp_rport *rport = transport_class_to_srp_rport(dev);
-	return sprintf(buf, SRP_PID_FMT "\n", SRP_PID(rport));
+	return sprintf(buf, "%16phC\n", rport->port_id);
 }
 
 static DEVICE_ATTR(port_id, S_IRUGO, show_srp_rport_id, NULL);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 428c03e..c1b6b45 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2408,9 +2408,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
 				  sdkp->write_prot ? "on" : "off");
-			sd_printk(KERN_DEBUG, sdkp,
-				  "Mode Sense: %02x %02x %02x %02x\n",
-				  buffer[0], buffer[1], buffer[2], buffer[3]);
+			sd_printk(KERN_DEBUG, sdkp, "Mode Sense: %4ph\n", buffer);
 		}
 	}
 }
-- 
2.8.1

