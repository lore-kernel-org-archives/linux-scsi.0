From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] arcmsr: fix up sysfs values
Date: Fri, 28 Jul 2006 17:36:46 -0500
Message-ID: <1154126207.9447.50.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:24724 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161336AbWG1WhA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jul 2006 18:37:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The sysfs files in arcmsr are non-standard in that they aren't simple
filename value pairs, the values actually contain preceeding text which
would have to be parsed.  The idea of sysfs files is that the file name
is the description and the contents is a simple value.

Fix up arcmsr to conform to this standard.

James

diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 0459f41..13b60c1 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -276,7 +276,7 @@ arcmsr_free_sysfs_attr(struct AdapterCon
 static ssize_t
 arcmsr_attr_host_driver_version(struct class_device *cdev, char *buf) {
 	return snprintf(buf, PAGE_SIZE,
-			"ARCMSR: %s\n",
+			"%s\n",
 			ARCMSR_DRIVER_VERSION);
 }
 
@@ -285,7 +285,7 @@ arcmsr_attr_host_driver_posted_cmd(struc
 	struct Scsi_Host *host = class_to_shost(cdev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 	return snprintf(buf, PAGE_SIZE,
-			"Current commands posted:     %4d\n",
+			"%4d\n",
 			atomic_read(&acb->ccboutstandingcount));
 }
 
@@ -294,7 +294,7 @@ arcmsr_attr_host_driver_reset(struct cla
 	struct Scsi_Host *host = class_to_shost(cdev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 	return snprintf(buf, PAGE_SIZE,
-			"SCSI Host Resets:            %4d\n",
+			"%4d\n",
 			acb->num_resets);
 }
 
@@ -303,7 +303,7 @@ arcmsr_attr_host_driver_abort(struct cla
 	struct Scsi_Host *host = class_to_shost(cdev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 	return snprintf(buf, PAGE_SIZE,
-			"SCSI Aborts/Timeouts:        %4d\n",
+			"%4d\n",
 			acb->num_aborts);
 }
 
@@ -312,7 +312,7 @@ arcmsr_attr_host_fw_model(struct class_d
     struct Scsi_Host *host = class_to_shost(cdev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 	return snprintf(buf, PAGE_SIZE,
-			"Adapter Model: %s\n",
+			"%s\n",
 			acb->firm_model);
 }
 
@@ -322,7 +322,7 @@ arcmsr_attr_host_fw_version(struct class
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 
 	return snprintf(buf, PAGE_SIZE,
-			"Firmware Version:  %s\n",
+			"%s\n",
 			acb->firm_version);
 }
 
@@ -332,7 +332,7 @@ arcmsr_attr_host_fw_request_len(struct c
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 
 	return snprintf(buf, PAGE_SIZE,
-			"Reguest Lenth: %4d\n",
+			"%4d\n",
 			acb->firm_request_len);
 }
 
@@ -342,7 +342,7 @@ arcmsr_attr_host_fw_numbers_queue(struct
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 
 	return snprintf(buf, PAGE_SIZE,
-			"Numbers of Queue: %4d\n",
+			"%4d\n",
 			acb->firm_numbers_queue);
 }
 
@@ -352,7 +352,7 @@ arcmsr_attr_host_fw_sdram_size(struct cl
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 
 	return snprintf(buf, PAGE_SIZE,
-			"SDRAM Size: %4d\n",
+			"%4d\n",
 			acb->firm_sdram_size);
 }
 
@@ -362,7 +362,7 @@ arcmsr_attr_host_fw_hd_channels(struct c
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 
 	return snprintf(buf, PAGE_SIZE,
-			"Hard Disk Channels: %4d\n",
+			"%4d\n",
 			acb->firm_hd_channels);
 }
 


