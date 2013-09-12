From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH]export device_busy for sdev
Date: Thu, 12 Sep 2013 17:29:52 +0200
Message-ID: <5231DDF0.6020104@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020205010309090207070103"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:63346 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3ILP26 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2013 11:28:58 -0400
Received: by mail-bk0-f50.google.com with SMTP id mz11so4364758bkb.9
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 08:28:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Dongsu Park <dongsu.park@profitbricks.com>, Bart Van Assche <bvanassche@acm.org>, Jack Wang <xjtuwjp@gmail.com>

This is a multi-part message in MIME format.
--------------020205010309090207070103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi James,

Attached please find patch for export device_busy for sdev.

The reason I do this is:

Sometime we see doing IO on several devices, on device may starve
others, eg:

I run fio on top the 4 disks exported by scst using srp:
(SRP default can_queue/cmd_per_lun is 62)
/dev/sdb: (g=0): rw=randread, bs=4K-16K/4K-16K/4K-16K, ioenine=libaio,
iodepth=64
/dev/sdc: (g=0): rw=randread, bs=4K-16K/4K-16K/4K-16K, ioengine=libaio,
iodepth=64
/dev/sdd: (g=0): rw=randread, bs=4K-16K/4K-16K/4K-16K, ioengine=libaio,
iodepth=64
>  sdb: ios=16393/0, merge=2770/0, ticks=863050/0, in_queue=870110, util=99.43%
>   sdc: ios=5896/0, merge=0/0, ticks=997110/0, in_queue=1006470, util=99.52%
>   sdd: ios=15976/0, merge=0/0, ticks=978850/0, in_queue=984960, util=99.38%

A monitor to read device_busy every seconds show:
> Sleeping for 1 seconds...
> Getting device busy data for sdb  0    (tstamp=20130912172053)...
> Getting device busy data for sdc  62    (tstamp=20130912172053)...
> Getting device busy data for sde  0    (tstamp=20130912172053)...
> 
> Sleeping for 1 seconds...
> Getting device busy data for sdb  0    (tstamp=20130912172054)...
> Getting device busy data for sdc  62    (tstamp=20130912172054)...
> Getting device busy data for sde  0    (tstamp=20130912172054)...
> 
> Sleeping for 1 seconds...
> Getting device busy data for sdb  0    (tstamp=20130912172055)...
> Getting device busy data for sdc  62    (tstamp=20130912172055)...
> Getting device busy data for sde  0    (tstamp=20130912172055)...

Which give admin more hint about the situation.

Best regards,
Jack

--------------020205010309090207070103
Content-Type: text/x-patch;
 name="0001-export-device_busy-for-sdev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-export-device_busy-for-sdev.patch"

>From cbca8a40fe3837789129e210365488d329d8a440 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang@profitbricks.com>
Date: Thu, 12 Sep 2013 16:57:16 +0200
Subject: [PATCH] export device_busy for sdev

If you mutiple devices connect to a host, we might be interested in
have an intensive I/O workload on one disk, and notice starvation on others.
This give the user more hint about current infight io for scsi device.

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/scsi_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 40c6394..a734710 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -529,6 +529,7 @@ static int scsi_sdev_check_buf_bit(const char *buf)
  */
 sdev_rd_attr (device_blocked, "%d\n");
 sdev_rd_attr (queue_depth, "%d\n");
+sdev_rd_attr (device_busy, "%d\n");
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
@@ -750,6 +751,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_device_blocked.attr,
 	&dev_attr_type.attr,
 	&dev_attr_scsi_level.attr,
+	&dev_attr_device_busy.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_model.attr,
 	&dev_attr_rev.attr,
-- 
1.8.4


--------------020205010309090207070103--
