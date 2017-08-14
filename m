From: tom.ty89@gmail.com
Subject: [PATCH] sd: read unmap block limits even if lbpme=0
Date: Tue, 15 Aug 2017 05:13:26 +0800
Message-ID: <59921282.c3341c0a.a8437.1b70@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33249 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752133AbdHNVNk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2017 17:13:40 -0400
Received: by mail-wm0-f67.google.com with SMTP id q189so15840164wmd.0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2017 14:13:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

Some devices may not be decent enough to report lbpme bit properly
even when they do support unmap and report relevant information
in the block limits and logical block provisioning VPDs properly
(Namely, ASMedia ASM1351, a UAS-SATA bridge). One of the reasons
is, lbpme=1 is not a requirement for "DeleteNotify" in Windows to
be activated:

[root@archlinux ~]# sg_readcap -l /dev/sda | grep lb
   Logical block provisioning: lbpme=0, lbprz=0
[root@archlinux ~]# sg_vpd -p lbpv /dev/sda | grep \(LB
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBWS): 0
  Write same (10) with unmap bit supported (LBWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
[root@archlinux ~]# sg_vpd -p bl /dev/sda | grep -i unmap
  Maximum unmap LBA count: 4194240
  Maximum unmap block descriptor count: 1
  Optimal unmap granularity: 1
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0

While there may be a point to retain the "strict policy" on this,
by not configuring discard for such device automatically, there
is little reason not to read the relevant data from the VPD, for
users are allowed to configure discard for a device via the
provisioning_mode sysfs file.

While discard_max_bytes can be changed manually, it is better
if the value would be limited by a discard_max_hw_bytes that is
set from the hardware limit that is reported in the VPD.

Before this commit:
[root@archlinux ~]# cat (...)/provisioning_mode
full
[root@archlinux ~]# grep . /sys/block/sda/queue/discard_*
/sys/block/sda/queue/discard_granularity:0
/sys/block/sda/queue/discard_max_bytes:0
/sys/block/sda/queue/discard_max_hw_bytes:0
/sys/block/sda/queue/discard_zeroes_data:0
[root@archlinux ~]# echo -n unmap > (...)/provisioning_mode
[root@archlinux ~]# grep . /sys/block/sda/queue/discard_*
/sys/block/sda/queue/discard_granularity:512
/sys/block/sda/queue/discard_max_bytes:4294966784
/sys/block/sda/queue/discard_max_hw_bytes:4294966784
/sys/block/sda/queue/discard_zeroes_data:0

After this commit:
[root@archlinux ~]# cat (...)/provisioning_mode
full
[root@archlinux ~]# grep . /sys/block/sda/queue/discard_*
/sys/block/sda/queue/discard_granularity:0
/sys/block/sda/queue/discard_max_bytes:0
/sys/block/sda/queue/discard_max_hw_bytes:0
/sys/block/sda/queue/discard_zeroes_data:0
[root@archlinux ~]# echo -n unmap > (...)/provisioning_mode
[root@archlinux ~]# grep . /sys/block/sda/queue/discard_*
/sys/block/sda/queue/discard_granularity:512
/sys/block/sda/queue/discard_max_bytes:2147450880
/sys/block/sda/queue/discard_max_hw_bytes:2147450880
/sys/block/sda/queue/discard_zeroes_data:0

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bea36adeee17..ea9e6fc76b63 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2883,9 +2883,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
 
-		if (!sdkp->lbpme)
-			goto out;
-
 		lba_count = get_unaligned_be32(&buffer[20]);
 		desc_count = get_unaligned_be32(&buffer[24]);
 
@@ -2898,6 +2895,9 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 			sdkp->unmap_alignment =
 				get_unaligned_be32(&buffer[32]) & ~(1 << 31);
 
+		if (!sdkp->lbpme)
+			goto out;
+
 		if (!sdkp->lbpvpd) { /* LBP VPD page not provided */
 
 			if (sdkp->max_unmap_blocks)
-- 
2.14.1
