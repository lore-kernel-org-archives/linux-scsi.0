From: Martin Hicks <mort@wildopensource.com>
Subject: [PATCH] Fix error path when adding sysfs attributes
Date: Fri, 16 Jan 2004 14:28:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116192801.GT27591@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zS7rBR6csb6tI2e1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:5015 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S265713AbUAPT2C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 14:28:02 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


--zS7rBR6csb6tI2e1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi James,

Here is a patch that fixes an error path while adding sysfs attributes
in drivers/scsi/scsi_sysfs.c

If we encounter an error while registering the sysfs attributes we mark
the sdev as dead and unregister it from sysfs.  Then we turn around and
continue to add new attributes.

Thanks to Christoph and Martin for pointing this out.

thanks
mh

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

--zS7rBR6csb6tI2e1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-sysfs-add-attribute-fix.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1521  -> 1.1522 
#	drivers/scsi/scsi_sysfs.c	1.38    -> 1.39   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/01/16	mort@green.i.bork.org	1.1522
# Stop adding sysfs attributes after we call scsi_remove_device()
# when we encounter an error.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Fri Jan 16 13:45:02 2004
+++ b/drivers/scsi/scsi_sysfs.c	Fri Jan 16 13:45:02 2004
@@ -370,8 +370,10 @@
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = attr_add(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
-			if (error)
+			if (error) {
 				scsi_remove_device(sdev);
+				goto out;
+			}
 		}
 	}
 	
@@ -380,11 +382,14 @@
 					scsi_sysfs_sdev_attrs[i])) {
 			error = device_create_file(&sdev->sdev_gendev,
 					scsi_sysfs_sdev_attrs[i]);
-			if (error)
+			if (error) {
 				scsi_remove_device(sdev);
+				goto out;
+			}
 		}
 	}
 
+	out:
 	return error;
 
 clean_device:

--zS7rBR6csb6tI2e1--
