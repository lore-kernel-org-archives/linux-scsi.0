Return-Path: <SRS0=kvmt=4R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE1DC3F2D3
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 14:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D2CC24680
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 14:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="QsIs23SR";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="aMo/4DBf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgB2OOb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Feb 2020 09:14:31 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59744 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727049AbgB2OOb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 29 Feb 2020 09:14:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 177848EE181;
        Sat, 29 Feb 2020 06:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1582985671;
        bh=bdhvsntzGVRG9/8+oCYfW4Kbq6J5QY6qWbQ6zxuu31I=;
        h=Subject:From:To:Cc:Date:From;
        b=QsIs23SR2MXmuU4SiG6GT7inczEHjCYCclxjWCbf1gqgu+n3dwJOXo/4pIXCbATx3
         71LEV6YkyRqXP5y9U49PNiz9QxGwSSnJbeJ75AzKLxILAlyubMrr4G7VfHBtR0/DCT
         5PXlq4O00FdTESZKYBt44BUkqvyXxkjbkYOpaS20=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ivNqMek5aN3Y; Sat, 29 Feb 2020 06:14:30 -0800 (PST)
Received: from jarvis.ext.hansenpartnership.com (jarvis.ext.hansenpartnership.com [153.66.160.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 51A0B8EE0E2;
        Sat, 29 Feb 2020 06:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1582985670;
        bh=bdhvsntzGVRG9/8+oCYfW4Kbq6J5QY6qWbQ6zxuu31I=;
        h=Subject:From:To:Cc:Date:From;
        b=aMo/4DBfUwcF9AJLrI5TdhqfV+GN24fIMDQiuTiTjgZvGjwdGHn5Q6ap6/FT4crOT
         6h21MgrvmkQjq8kqb+MfOHvKMHypznwQTQyGkscsvzV3Vq1loUbQTZfgsuaKGT6Ux8
         3TvIsGenNet3yAK2+M4iT5l5kdo7I/C0/zwPEsAM=
Message-ID: <1582985668.3507.9.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.6-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 29 Feb 2020 09:14:28 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Four small fixes.  Three are in drivers for fairly obvious bugs.  The
fourth is a set of regressions introduced by the compat_ioctl changes
because some of the compat updates wrongly replaced .ioctl instead of
.compat_ioctl.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Adam Williamson (1):
      scsi: compat_ioctl: cdrom: Replace .ioctl with .compat_ioctl in four appropriate places

Benjamin Block (1):
      scsi: zfcp: fix wrong data and display format of SFP+ temperature

Damien Le Moal (1):
      scsi: sd_sbc: Fix sd_zbc_report_zones()

Igor Druzhinin (1):
      scsi: libfc: free response frame from GPN_ID

And the diffstat:

 drivers/block/paride/pcd.c     | 2 +-
 drivers/cdrom/gdrom.c          | 2 +-
 drivers/ide/ide-gd.c           | 2 +-
 drivers/s390/scsi/zfcp_fsf.h   | 2 +-
 drivers/s390/scsi/zfcp_sysfs.c | 2 +-
 drivers/scsi/libfc/fc_disc.c   | 2 ++
 drivers/scsi/sd_zbc.c          | 7 ++++++-
 drivers/scsi/sr.c              | 2 +-
 8 files changed, 14 insertions(+), 7 deletions(-)

With full diff below.

James

---

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 117cfc8cd05a..cda5cf917e9a 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -276,7 +276,7 @@ static const struct block_device_operations pcd_bdops = {
 	.release	= pcd_block_release,
 	.ioctl		= pcd_block_ioctl,
 #ifdef CONFIG_COMPAT
-	.ioctl		= blkdev_compat_ptr_ioctl,
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 #endif
 	.check_events	= pcd_block_check_events,
 };
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 886b2638c730..c51292c2a131 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -519,7 +519,7 @@ static const struct block_device_operations gdrom_bdops = {
 	.check_events		= gdrom_bdops_check_events,
 	.ioctl			= gdrom_bdops_ioctl,
 #ifdef CONFIG_COMPAT
-	.ioctl			= blkdev_compat_ptr_ioctl,
+	.compat_ioctl		= blkdev_compat_ptr_ioctl,
 #endif
 };
 
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 1bb99b556393..05c26986637b 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -361,7 +361,7 @@ static const struct block_device_operations ide_gd_ops = {
 	.release		= ide_gd_release,
 	.ioctl			= ide_gd_ioctl,
 #ifdef CONFIG_COMPAT
-	.ioctl			= ide_gd_compat_ioctl,
+	.compat_ioctl		= ide_gd_compat_ioctl,
 #endif
 	.getgeo			= ide_gd_getgeo,
 	.check_events		= ide_gd_check_events,
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 2b1e4da1944f..4bfb79f20588 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -410,7 +410,7 @@ struct fsf_qtcb_bottom_port {
 	u8 cb_util;
 	u8 a_util;
 	u8 res2;
-	u16 temperature;
+	s16 temperature;
 	u16 vcc;
 	u16 tx_bias;
 	u16 tx_power;
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 494b9fe9cc94..a711a0d15100 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -800,7 +800,7 @@ static ZFCP_DEV_ATTR(adapter_diag, b2b_credit, 0400,
 	static ZFCP_DEV_ATTR(adapter_diag_sfp, _name, 0400,		       \
 			     zfcp_sysfs_adapter_diag_sfp_##_name##_show, NULL)
 
-ZFCP_DEFINE_DIAG_SFP_ATTR(temperature, temperature, 5, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(temperature, temperature, 6, "%hd");
 ZFCP_DEFINE_DIAG_SFP_ATTR(vcc, vcc, 5, "%hu");
 ZFCP_DEFINE_DIAG_SFP_ATTR(tx_bias, tx_bias, 5, "%hu");
 ZFCP_DEFINE_DIAG_SFP_ATTR(tx_power, tx_power, 5, "%hu");
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 9c5f7c9178c6..2b865c6423e2 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -628,6 +628,8 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
+	if (!IS_ERR(fp))
+		fc_frame_free(fp);
 }
 
 /**
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index e4282bce5834..f45c22b09726 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -161,6 +161,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	unsigned int nr, i;
 	unsigned char *buf;
 	size_t offset, buflen = 0;
@@ -171,11 +172,15 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		/* Not a zoned device */
 		return -EOPNOTSUPP;
 
+	if (!capacity)
+		/* Device gone or invalid */
+		return -ENODEV;
+
 	buf = sd_zbc_alloc_report_buffer(sdkp, nr_zones, &buflen);
 	if (!buf)
 		return -ENOMEM;
 
-	while (zone_idx < nr_zones && sector < get_capacity(disk)) {
+	while (zone_idx < nr_zones && sector < capacity) {
 		ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
 				sectors_to_logical(sdkp->device, sector), true);
 		if (ret)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0fbb8fe6e521..e4240e4ae8bb 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -688,7 +688,7 @@ static const struct block_device_operations sr_bdops =
 	.release	= sr_block_release,
 	.ioctl		= sr_block_ioctl,
 #ifdef CONFIG_COMPAT
-	.ioctl		= sr_block_compat_ioctl,
+	.compat_ioctl	= sr_block_compat_ioctl,
 #endif
 	.check_events	= sr_block_check_events,
 	.revalidate_disk = sr_block_revalidate_disk,

