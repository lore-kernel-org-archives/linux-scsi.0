From: James.Smart@Emulex.Com
Subject: [Patch] Add basic infrastructure for host statistics
Date: Thu, 14 Oct 2004 10:42:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C0866CE@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:29118 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264113AbUJNOmq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 10:42:46 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i9EEgjgI000081
	for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2004 07:42:45 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch adds the basic hooks to the scsi subsystem to support transport-specific statistics to be added to a host. Its basic nature follows the way in which net devices showed their statistics.

-- James


This patch is relative to the scsi-target-2.6 bitkeeper tree

diff -uNr scsi-target-2.6/drivers/scsi/hosts.c scsi-target-2.6.patch/drivers/scsi/hosts.c
--- scsi-target-2.6/drivers/scsi/hosts.c	2004-10-10 09:17:10.613780032 -0400
+++ scsi-target-2.6.patch/drivers/scsi/hosts.c	2004-10-10 09:17:10.623778512 -0400
@@ -82,8 +82,12 @@
 	set_bit(SHOST_DEL, &shost->shost_state);
 
 	class_device_unregister(&shost->shost_classdev);
-	if (shost->transport_classdev.class)
+	if (shost->transport_classdev.class) {
+		if (shost->transportt->host_statistics)
+			sysfs_remove_group(&shost->transport_classdev.kobj,
+				shost->transportt->host_statistics);
 		class_device_unregister(&shost->transport_classdev);
+	}
 	device_del(&shost->shost_gendev);
 }
 
diff -uNr scsi-target-2.6/drivers/scsi/scsi_sysfs.c scsi-target-2.6.patch/drivers/scsi/scsi_sysfs.c
--- scsi-target-2.6/drivers/scsi/scsi_sysfs.c	2004-10-10 09:17:10.631777296 -0400
+++ scsi-target-2.6.patch/drivers/scsi/scsi_sysfs.c	2004-10-10 09:17:10.633776992 -0400
@@ -708,6 +708,14 @@
  			if (error)
 				return error;
  		}
+
+		if (shost->transportt->host_statistics) {
+			error = sysfs_create_group(
+					&shost->transport_classdev.kobj,
+					shost->transportt->host_statistics);
+			if (error)
+				return error;
+		}
  	}
 
 	return 0;
diff -uNr scsi-target-2.6/include/scsi/scsi_transport.h scsi-target-2.6.patch/include/scsi/scsi_transport.h
--- scsi-target-2.6/include/scsi/scsi_transport.h	2004-10-10 09:17:10.548789912 -0400
+++ scsi-target-2.6.patch/include/scsi/scsi_transport.h	2004-10-10 09:17:10.573786112 -0400
@@ -33,6 +33,7 @@
 	struct class *device_class;
 	struct class *target_class;
 	struct class *host_class;
+	struct attribute_group *host_statistics;
 
 	/* Constructor functions */
 	int (*device_setup)(struct scsi_device *);
