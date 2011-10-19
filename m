From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v2] [SCSI] remove arbitrary SD_MAX_DISKS namespace limit
Date: Wed, 19 Oct 2011 11:49:04 -0500
Message-ID: <4E9EFF80.7080500@oracle.com>
References: <4E89E721.7000308@oracle.com> <1317664679.3041.48.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:36106 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab1JSQtN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2011 12:49:13 -0400
In-Reply-To: <1317664679.3041.48.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 10/03/2011 12:57 PM, James Bottomley wrote:
> On Mon, 2011-10-03 at 11:47 -0500, Dave Kleikamp wrote:
>> I see no reason to limit the SCSI disk namespace to sdXXX. We test
>> systems with more than 18278 LUNs.
> 
> I suppose we kept the old limit for historical reasons, so I've no real
> objection to raising it, except the error messages now need to be beefed
> up.  We need one for the ida_get_new() failure and the original
> exhaustion messages needs to move to the sd_format_disk_name() check ...
> that's now what checks we don't go over the possible size in
> DISK_NAME_LEN (I know at 32 it's way beyond INT_MAX ... but just in case
> someone decides to lower it) ... probably it's the same error message
> (but better make it unique for the static checkers).

There is no reason to limit the SCSI disk namespace to sdXXX.

Add new error messages to sd_probe() in the unlikely event that either
ida_get_new() or sd_format_disk_name() fail.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 953773c..55424c8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2589,18 +2589,16 @@ static int sd_probe(struct device *dev)
 		spin_unlock(&sd_index_lock);
 	} while (error == -EAGAIN);
 
-	if (error)
+	if (error) {
+		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
 		goto out_put;
-
-	if (index >= SD_MAX_DISKS) {
-		error = -ENODEV;
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name space exhausted.\n");
-		goto out_free_index;
 	}
 
 	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
-	if (error)
+	if (error) {
+		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
 		goto out_free_index;
+	}
 
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 6ad798b..4163f29 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -9,12 +9,6 @@
 #define SD_MAJORS	16
 
 /*
- * This is limited by the naming scheme enforced in sd_probe,
- * add another character to it if you really need more disks.
- */
-#define SD_MAX_DISKS	(((26 * 26) + 26 + 1) * 26)
-
-/*
  * Time out in seconds for disks and Magneto-opticals (which are slower).
  */
 #define SD_TIMEOUT		(30 * HZ)
