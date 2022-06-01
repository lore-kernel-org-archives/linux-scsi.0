Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8691FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 06:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244558AbiFAGZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 02:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbiFAGZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 02:25:50 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7574B6A066
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 23:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654064749; x=1685600749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lkVSNTC6zPp1TqAAoO+yr4uJEVvuBMMtkkuC1CyxSvY=;
  b=XHZyeW8KWvvuJmvfIlC97iOeQgY+GN+kDCIAt/s6srX+qyvg9UpPAkMB
   OO4pvV9lBPYzv7ujgyas6doSzAnqy+2J74Sykpvl9L+2b5F/BykD9jIYu
   crmH0wVp1+9dcNq2bXgdi0e8grRK2Dudx1QWOqN7dKyHNrk+EgIJRDJld
   FqJhPTcYkIccNyFc8OsWi0HIqLX2x3KxuU7TPtvJHf0zLs262IQP685AW
   ncZrZnJFOKHwGkU1gJ3cjmvnJQwUT2zwYFvBx7U6mX8PJsL56dtvT86pe
   ujGrZa1o5WJuiCe+27GTdgkHABxz8mERYTXs96npyqETFi0UArXbuSAjs
   g==;
X-IronPort-AV: E=Sophos;i="5.91,266,1647273600"; 
   d="scan'208";a="200715428"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jun 2022 14:25:48 +0800
IronPort-SDR: aj4cUp32fzg2bMMrkSCoSZvxuCEJC8SApiZqcNzxo6muTYMY0p+GIBg7ZNDiKxbczpPb7IMbSy
 SDXfpVPnnBQouzbjWN9hCZcdUX6TeXeJ4xmiFtzysPz13bagLyLg75QQ2+pixuUeV6qrey4fw7
 Wl+NnrjktxRZB66tZ1cmRsUAUz12nYU2twuc8t1V7U8xFSeyZdhba4l767tOOvi0Ky+pKy/X5y
 B1n9e6GuYJx/rgtZ8N9tZvPG+uz9FfZ02+c/K83RqNVoGrzpMKGXe+ljOodcw7+TiKP/jDIcsf
 bXUfUXOVokA/Uq4w70J0cZUV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 22:45:02 -0700
IronPort-SDR: XjbbKHUgZLH5ydwLQqrW46aji8Zo7C97lhmKP+/jlt3GQ559eUWjLFV5aeOjmaI33dlL/MfSw0
 ua2I7KizkiIckh6M1ChXFisx8Q2aO0Y911AAbDQjU3of1js+hHUdWDAbTVZDO2HGi0McpGipyI
 5kBmDJi1fjMNSZA/2j4/0pRvuBT+P+gTUwWXKQZ+zw4EEKl1m0DLjDE0agFdQPdA4Z3ySDgh/u
 yAeZFuEKHJ1yv8Lf9BgbUCsRN8IW1f/U4141qJQi8/vrNe+Zmo+dzRd0vaxbRkHkJ1RyoHeBmO
 4ao=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 23:25:49 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LCfKS4vxlz1SVnx
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 23:25:48 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1654064748; x=1656656749; bh=lkVSNTC6zPp1TqAAoO
        +yr4uJEVvuBMMtkkuC1CyxSvY=; b=bWqUE+w0HsCEThV3MjTQCNDaqV5sZSotED
        V5hlWlw64CZV1OokMo+ZXMCIpvsgPw98Dph4X4BawwM+pK3InBSKswkVOU6wYmYD
        kxDjx+3CVYyy9hYaxLI43k3YLcvrtHWvuYCpreqpnIJ1ZEwsvTfBEnDBTLZPfhxP
        vVUeKQPARguM8aVh5XVLWyGUtJzFIikmCtOZg5YqcjOwNYI1oGhW/87pIGEzaa0x
        FQ25M29f0VZ6udT2rmKI75UddD0jyieQE/ZxZCR6hHUWlV1fhLw6hw/88YSYvv2F
        3reA1Rl3xPXvKD2cgNiXM5nXrKIpYUVagZwscU+S0HFZO9J86pnA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9VPe0syyFfxl for <linux-scsi@vger.kernel.org>;
        Tue, 31 May 2022 23:25:48 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LCfKR4gpQz1Rvlc;
        Tue, 31 May 2022 23:25:47 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH v3 2/2] scsi: sd_zbc: prevent zone information memory leak
Date:   Wed,  1 Jun 2022 15:25:44 +0900
Message-Id: <20220601062544.905141-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220601062544.905141-1-damien.lemoal@opensource.wdc.com>
References: <20220601062544.905141-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure to always free a scsi disk zone information, even for regular
disks. This ensures that there is no memory leak, even in the case of a
zoned disk changing type to a regular disk (e.g. with a reformat using
the FORMAT WITH PRESET command or other vendor proprietary command).

To do this, rename sd_zbc_clear_zone_info() to sd_zbc_free_zone_info()
and remove sd_zbc_release_disk(). A call to sd_zbc_free_zone_info() is
added to sd_zbc_read_zones() for drives for which sd_is_zoned() returns
false. Furthermore, sd_zbc_free_zone_info() code make s sure that the
sdkp rev_mutex is never used while not being initialized by gating the
cleanup code with a a check on the zone_wp_update_buf field as it is
never NULL when rev_mutex has been initialized.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/sd.c     |  2 +-
 drivers/scsi/sd.h     |  4 ++--
 drivers/scsi/sd_zbc.c | 26 +++++++++++++-------------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dabdc0eeb3dc..be812987aa3f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3578,7 +3578,7 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
=20
 	ida_free(&sd_index_ida, sdkp->index);
-	sd_zbc_release_disk(sdkp);
+	sd_zbc_free_zone_info(sdkp);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
=20
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 2abad54fd23f..5eea762f84d1 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -241,7 +241,7 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
=20
 #ifdef CONFIG_BLK_DEV_ZONED
=20
-void sd_zbc_release_disk(struct scsi_disk *sdkp);
+void sd_zbc_free_zone_info(struct scsi_disk *sdkp);
 int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE]);
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
@@ -256,7 +256,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_c=
mnd *cmd, sector_t *lba,
=20
 #else /* CONFIG_BLK_DEV_ZONED */
=20
-static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}
+static inline void sd_zbc_free_zone_info(struct scsi_disk *sdkp) {}
=20
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BU=
F_SIZE])
 {
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 5b9fad70aa88..6acc4f406eb8 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -786,8 +786,11 @@ static int sd_zbc_init_disk(struct scsi_disk *sdkp)
 	return 0;
 }
=20
-static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)
+void sd_zbc_free_zone_info(struct scsi_disk *sdkp)
 {
+	if (!sdkp->zone_wp_update_buf)
+		return;
+
 	/* Serialize against revalidate zones */
 	mutex_lock(&sdkp->rev_mutex);
=20
@@ -802,12 +805,6 @@ static void sd_zbc_clear_zone_info(struct scsi_disk =
*sdkp)
 	mutex_unlock(&sdkp->rev_mutex);
 }
=20
-void sd_zbc_release_disk(struct scsi_disk *sdkp)
-{
-	if (sd_is_zoned(sdkp))
-		sd_zbc_clear_zone_info(sdkp);
-}
-
 static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp =3D scsi_disk(disk);
@@ -914,12 +911,15 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 bu=
f[SD_BUF_SIZE])
 	u32 zone_blocks =3D 0;
 	int ret;
=20
-	if (!sd_is_zoned(sdkp))
+	if (!sd_is_zoned(sdkp)) {
 		/*
-		 * Device managed or normal SCSI disk,
-		 * no special handling required
+		 * Device managed or normal SCSI disk, no special handling
+		 * required. Nevertheless, free the disk zone information in
+		 * case the device type changed.
 		 */
+		sd_zbc_free_zone_info(sdkp);
 		return 0;
+	}
=20
 	/* READ16/WRITE16 is mandatory for ZBC disks */
 	sdkp->device->use_16_for_rw =3D 1;
@@ -928,11 +928,11 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 bu=
f[SD_BUF_SIZE])
 	if (!blk_queue_is_zoned(q)) {
 		/*
 		 * This can happen for a host aware disk with partitions.
-		 * The block device zone information was already cleared
-		 * by blk_queue_set_zoned(). Only clear the scsi disk zone
+		 * The block device zone model was already cleared by
+		 * blk_queue_set_zoned(). Only free the scsi disk zone
 		 * information and exit early.
 		 */
-		sd_zbc_clear_zone_info(sdkp);
+		sd_zbc_free_zone_info(sdkp);
 		return 0;
 	}
=20
--=20
2.36.1

