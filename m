Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F79C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jan 2022 22:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiANWCz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiANWCy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jan 2022 17:02:54 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AF0C061574
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2022 14:02:53 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id m3so20551817lfu.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2022 14:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=SQJKHgpaQGdOto3knhZ4v2hslJZP/7R/oEdeUY+LBNw=;
        b=QEKdTjaMi5jYUL7SI8RMSXiqiME7n4We3ITn6Ctsxu4sq9IE/LOo1SA9Nw7xQxfZu3
         M+NmCZUNq/EDv582ODgqOFNTpfeyLM1uvIff5uhXehPagVVNeZD7jIJw8fFs2BahHcLe
         wEJLcjQLLB5uHZzMWCdwsKAzgxlFTV8fT+fsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SQJKHgpaQGdOto3knhZ4v2hslJZP/7R/oEdeUY+LBNw=;
        b=lTCQorGsOuN63kdFSdoVIaGS2GFXQxq1+n+0Fqcklft8iJFgv+2k//OAqw8g8NG9Uw
         GZTZBwBvHNXKQ6sGlxXwV4F7tE/kvOECVfMbp5KW4PX6LyDC7CLHChs7ZkEghiTBySDO
         cnMkrXlMyH1d8xAHrBjRqF2R2DmXHNQ35WTzKPHn6vxpkvs7RkbX+jUEn/6VOZ/r2rB9
         ELYIm041H6N76hno3KUS53t+PIvUWskxGENF1a+VPwdUD+BuQFXVFf/hJe/U/Hmyq/OI
         A4T/YdFvPwrVGuAE0HnpiqGhAtpkm+xDdsceNC3En7CNZ1KuY/pk3IPEPVJpqO9N8ToQ
         qO3w==
X-Gm-Message-State: AOAM531jpcNx7JSWiPDOJD6ikQZu60YL5M0GBJbkO3WUOXqQEqCS7Y1e
        Xrxg/5dsU+gS4ngdl7uWHR18apMdPRZ2xxk+9qCauEImDin8lJb0
X-Google-Smtp-Source: ABdhPJzHyNqsM+vZVC/ml0I5+eT8o4CoczlHpm/5H71LExnWlrgqghr5CHxPQwOoGQ3911urdj5h2DzZI2zgEKSGjVY=
X-Received: by 2002:a2e:a4a7:: with SMTP id g7mr2667772ljm.93.1642197771878;
 Fri, 14 Jan 2022 14:02:51 -0800 (PST)
MIME-Version: 1.0
From:   Brian Bunker <brian@purestorage.com>
Date:   Fri, 14 Jan 2022 14:02:41 -0800
Message-ID: <CAHZQxyKNqnFro33VrirfkdS8ZNga9vWwJDDu8gQtRdr-yW57iQ@mail.gmail.com>
Subject: [PATCH] scsi: scsi_scan purge devices no longer in reported LUN list
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a new volume is added to an ACL list for a host and a unit
attention is posted for that host ASC=0x3f ASCQ=0x0e, REPORTED LUNS
DATA HAS CHANGED, devices are created if the udev rule is active:

ACTION=="change", SUBSYSTEM=="scsi",
ENV{SDEV_UA}=="REPORTED_LUNS_DATA_HAS_CHANGED",
RUN+="scan-scsi-target $env{DEVPATH}"

However when a volume is deleted from the ACL list for a host, those
devices are not deleted. They are orphaned. I am showing multpath
output to show the connected devices pre-removal from the ACL list and
post:

Before:
[root@init501-9 rules.d]# multipath -ll
3624a9370d5779477e526433100011019 dm-2 PURE    ,FlashArray
size=2.0T features='0' hwhandler='1 alua' wp=rw
`-+- policy='service-time 0' prio=50 status=active
 |- 0:0:1:1 sdb 8:16 active ready running
 |- 7:0:1:1 sdc 8:32 active ready running
 |- 8:0:1:1 sdd 8:48 active ready running
 `- 9:0:1:1 sde 8:64 active ready running

[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdb
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E526433100011019
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdc
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E526433100011019
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdd
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E526433100011019
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sde
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E526433100011019

After:
[root@init501-9 rules.d]# multipath -ll
3624a9370d5779477e526433100011019 dm-2 PURE    ,FlashArray
size=2.0T features='0' hwhandler='1 alua' wp=rw
`-+- policy='service-time 0' prio=0 status=enabled
 |- 0:0:1:1 sdb 8:16 failed faulty running
 |- 7:0:1:1 sdc 8:32 failed faulty running
 |- 8:0:1:1 sdd 8:48 failed faulty running
 `- 9:0:1:1 sde 8:64 failed faulty running
[root@init501-9 rules.d]# sg_map -i -x
/dev/sg0  1 0 0 0  0  /dev/sda  ATA       TOSHIBA THNSNH25  N101
/dev/sg1  0 0 1 1  0  /dev/sdb
/dev/sg2  7 0 1 1  0  /dev/sdc
/dev/sg3  8 0 1 1  0  /dev/sdd
/dev/sg4  9 0 1 1  0  /dev/sde

Now if a new volume is connected, different serial number same LUN, it
will use those orphaned devices:

[root@init501-9 rules.d]# multipath -ll
3624a9370d5779477e526433100011019 dm-2 PURE    ,FlashArray
size=2.0T features='0' hwhandler='1 alua' wp=rw
`-+- policy='service-time 0' prio=50 status=active
 |- 0:0:1:1 sdb 8:16 active ready running
 |- 7:0:1:1 sdc 8:32 active ready running
 |- 8:0:1:1 sdd 8:48 active ready running
 `- 9:0:1:1 sde 8:64 active ready running

[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdb
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101A
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdc
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101A
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdd
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101A
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sde
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101A

This situation becomes more problematic if multiple target devices are
presenting the same volume and each target device has its own ACL
management, we can end up in situations where some paths have one
serial number and some have another.

[root@init501-9 rules.d]# multipath -ll
3624a9370d5779477e52643310001101b dm-2 PURE    ,FlashArray
size=2.0T features='0' hwhandler='1 alua' wp=rw
`-+- policy='service-time 0' prio=50 status=active
 |- 0:0:0:1 sdf 8:80  active ready running
 |- 7:0:0:1 sdg 8:96  active ready running
 |- 8:0:0:1 sdh 8:112 active ready running
 |- 9:0:0:1 sdi 8:128 active ready running
 |- 0:0:1:1 sdb 8:16  active ready running
 |- 7:0:1:1 sdc 8:32  active ready running
 |- 8:0:1:1 sdd 8:48  active ready running
 `- 9:0:1:1 sde 8:64  active ready running

[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdb
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101B
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdc
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101B
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdd
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101B
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sde
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101B
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdf
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101C
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdg
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101C
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdh
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101C
[root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdi
VPD INQUIRY: Unit serial number page
 Unit serial number: D5779477E52643310001101C

I understand that this situation can be avoided with a rescan that
purges stale disks when an ACL is removed like rescan-scsi-bus.sh -r.
But the ACL removal itself does initiate a rescan, it is just that
rescan doesn't have the ability to purge devices whose LUNs are no
longer returned in the reported LUN list.

Signed-off-by: Seamus Conorr <jsconnor@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <yokim@purestorage.com>
__
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c7080454aea9..cfc6c3cc2996 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -220,6 +220,7 @@ static struct {
       {"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
       {"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
       {"Promise", "", NULL, BLIST_SPARSELUN},
+       {"PURE", "FlashArray", "*", BLIST_REMOVE_STALE},
       {"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
       {"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
       {"SYNOLOGY", "iSCSI Storage", NULL, BLIST_MAX_1024},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3520b9384428..15f6d8a9b61b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1102,6 +1102,7 @@ static int scsi_probe_and_add_lun(struct
scsi_target *starget,
        */
       sdev = scsi_device_lookup_by_target(starget, lun);
       if (sdev) {
+               sdev->in_lun_list = 1;
               if (rescan != SCSI_SCAN_INITIAL || !scsi_device_created(sdev)) {
                       SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
                               "scsi scan: device exists on %s\n",
@@ -1198,6 +1199,7 @@ static int scsi_probe_and_add_lun(struct
scsi_target *starget,
       }

       res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
+       sdev->in_lun_list = 1;
       if (res == SCSI_SCAN_LUN_PRESENT) {
               if (bflags & BLIST_KEY) {
                       sdev->lockable = 0;
@@ -1309,6 +1311,23 @@ static void scsi_sequential_lun_scan(struct
scsi_target *starget,
                       return;
}

+static void
+_reset_lun_list(struct scsi_device *sdev, void *data)
+{
+       if (sdev->is_visible) {
+               sdev->in_lun_list = 0;
+       }
+}
+
+static void
+_remove_stale_devices(struct scsi_device *sdev, void *data)
+{
+       if (sdev->in_lun_list || sdev->is_visible == 0)
+               return;
+       __scsi_remove_device(sdev);
+       sdev_printk(KERN_INFO, sdev, "lun_scan: Stale\n");
+}
+
/**
 * scsi_report_lun_scan - Scan using SCSI REPORT LUN results
 * @starget: which target
@@ -1373,6 +1392,9 @@ static int scsi_report_lun_scan(struct
scsi_target *starget, blist_flags_t bflag
               }
       }

+       if (bflags & BLIST_REMOVE_STALE)
+               starget_for_each_device(starget, NULL, _reset_lun_list);
+
       /*
        * Allocate enough to hold the header (the same size as one scsi_lun)
        * plus the number of luns we are requesting.  511 was the default
@@ -1487,6 +1509,9 @@ static int scsi_report_lun_scan(struct
scsi_target *starget, blist_flags_t bflag
               }
       }

+       if (bflags & BLIST_REMOVE_STALE)
+               starget_for_each_device(starget, NULL, _remove_stale_devices);
+
 out_err:
       kfree(lun_data);
 out:
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ab7557d84f75..c5446ee73af6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -206,6 +206,7 @@ struct scsi_device {
       unsigned rpm_autosuspend:1;     /* Enable runtime autosuspend at device
                                        * creation time */
       unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
+       unsigned in_lun_list:1;         /* contained in report luns response */

       unsigned int queue_stopped;     /* request queue is quiesced */
       bool offline_already;           /* Device offline message logged */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 5d14adae21c7..2e620ca2b7bc 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -68,8 +68,10 @@
#define BLIST_RETRY_ITF                ((__force blist_flags_t)(1ULL << 32))
/* Always retry ABORTED_COMMAND with ASC 0xc1 */
#define BLIST_RETRY_ASC_C1     ((__force blist_flags_t)(1ULL << 33))
+/* Remove devices no longer in reported luns data */
+#define BLIST_REMOVE_STALE      ((__force blist_flags_t)(1ULL << 34))

-#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
+#define __BLIST_LAST_USED BLIST_REMOVE_STALE

#define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
                              (__force blist_flags_t) \




--
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
