From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH] Fix error path when adding sysfs attributes
Date: Fri, 16 Jan 2004 15:52:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116205223.GY27591@localhost>
References: <20040116192801.GT27591@localhost> <20040116194839.GA1053@beaverton.ibm.com> <20040116203325.GX27591@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C94crkcyjafcjHxo"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:9624 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S265553AbUAPUwY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 15:52:24 -0500
Content-Disposition: inline
In-Reply-To: <20040116203325.GX27591@localhost>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



On Fri, Jan 16, 2004 at 03:33:25PM -0500, Martin Hicks wrote:
> 
> 
> On Fri, Jan 16, 2004 at 11:48:39AM -0800, Mike Anderson wrote:
> > While we are cleaning there appears to also be an extra return on line
> > 364 after a goto. It might be good to include this change in the patch.
> > 
> 
> Good idea.  Here's an updated patch that fixes the original bugs, the
> extra "return" and a bit of whitespace.
> 

And now the patch...

mh

-- 
Martin Hicks || mort@bork.org || PGP/GnuPG: 0x4C7F2BEE

--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-sysfs-add-attribute-fix-2.diff"

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
# when we encounter an error.  Also a small whitespace cleanup
# and removing a useless "return".
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Fri Jan 16 15:24:41 2004
+++ b/drivers/scsi/scsi_sysfs.c	Fri Jan 16 15:24:41 2004
@@ -361,7 +361,6 @@
 	if (error) {
 		printk(KERN_INFO "error 2\n");
 		goto clean_device;
-		return error;
 	}
 
 	get_device(&sdev->sdev_gendev);
@@ -370,8 +369,10 @@
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
 	
@@ -380,11 +381,14 @@
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
 
+ out:
 	return error;
 
 clean_device:
@@ -394,7 +398,6 @@
 	put_device(&sdev->sdev_gendev);
 
 	return error;
-
 }
 
 /**

--C94crkcyjafcjHxo--
