From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] writable scsi_level [was: [Merging ATA passthru] on integrating
 SMART/ATA-Security in usb-storage driver]
Date: Thu, 01 Dec 2005 21:35:41 +1000
Message-ID: <438EE00D.1030108@torque.net>
References: <Pine.LNX.4.44L0.0511071552360.5165-100000@iolanthe.rowland.org> <1131401153.3333.6.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010609050604070309020204"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:51349 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932159AbVLALef (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2005 06:34:35 -0500
In-Reply-To: <1131401153.3333.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, thomas schorpp <t.schorpp@gmx.de>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Timothy Thelin <Timothy.Thelin@wdc.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

This is a multi-part message in MIME format.
--------------010609050604070309020204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Mon, 2005-11-07 at 15:59 -0500, Alan Stern wrote:
> 
>>>That is, is usb-storage forcing scsi-2 when the device tells us it is
>>>scsi-3 compliant, or is the hardware reporting devices are scsi-2, yet
>>>requiring non-LUN value in cdb[1]?
>>
>>I think we may have both.  However I don't know how this Cypress chip
>>reports itself.  A system log showing the INQUIRY data would be very
>>helpful.
> 
> 
> We were told in prior emails that it actually reports a level of zero
> (i.e. no compliance with any SCSI standard).  My original proposal was
> just not to modify the CDB[1] for this case if we could get the INQUIRY
> passed through unmangled.
> 
> 
>>It's quite possible that usb-storage no longer needs to force the 
>>scsi-level to 2.  No one has recently tested what would happen without 
>>it.  Matt probably has the best selection of devices for testing...
>>
>>There is one problem we have with devices that report themselves as SCSI-3 
>>or SCSI-4 but hang when they receive a REPORT LUNS command.  That's easily 
>>handled by making usb-storage set the NOREPORTLUN flag.  Maybe that's all 
>>we need to do.

This patch may add some flexibility. It allows
/sys/class/scsi_device/<hcil>/device/scsi_level
to be written. It won't help during scanning but
will indirectly allow people to get the functionality
of SG_FLAG_LUN_INHIBIT back (via writing a number
greater than 3 into scsi_level).

The patch is against lk 2.6.15-rc3

Changelog:
  - make sysfs scsi_level attribute writable
  - fix bug in sdev_rw_attr macro (but can't
    use it because scsi_device::scsi_level is
    a char)

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert


--------------010609050604070309020204
Content-Type: text/x-patch;
 name="scsi_level_wr2615rc3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_level_wr2615rc3.diff"

--- linux/drivers/scsi/scsi_sysfs.c	2005-11-30 08:43:00.000000000 +1000
+++ linux/drivers/scsi/scsi_sysfs.c2615rc3sl	2005-12-01 21:04:40.000000000 +1000
@@ -322,7 +322,7 @@
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
-	snscanf (buf, 20, format_string, &sdev->field);			\
+	sscanf (buf, format_string, &sdev->field);			\
 	return count;							\
 }									\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
@@ -375,12 +375,32 @@
 sdev_rd_attr (device_blocked, "%d\n");
 sdev_rd_attr (queue_depth, "%d\n");
 sdev_rd_attr (type, "%d\n");
-sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
 
 static ssize_t
+sdev_show_scsi_level (struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf (buf, 20, "%d\n", (int)sdev->scsi_level);
+}
+
+static ssize_t
+sdev_store_scsi_level (struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t count)
+{
+	struct scsi_device *sdev;
+	int val;
+	sdev = to_scsi_device(dev);
+	sscanf (buf, "%d\n", &val);
+	sdev->scsi_level = val;
+	return count;
+}
+static DEVICE_ATTR(scsi_level, S_IRUGO | S_IWUSR, sdev_show_scsi_level, sdev_store_scsi_level);
+
+static ssize_t
 sdev_show_timeout (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev;

--------------010609050604070309020204--
