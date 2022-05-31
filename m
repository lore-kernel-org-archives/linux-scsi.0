Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAB1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 00:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241288AbiEaA2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 20:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238080AbiEaA2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 20:28:18 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA17E6C55F
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 17:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653956898; x=1685492898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gvV6Cg0LuveZSuFj/vxy07eBY3mYCak+vp3JRRo4VB0=;
  b=Z2ZpeX+blSE159zAKLJAA8A2jGldbM6rs4DpSVYX3bfJG3zjqpYZS/6K
   jiNBFNWqACxEc4cTr7daco0NuEMrJzGRTG4SiHHf7p5BBaT4shggCvrxN
   4gkBfmVNZM3a1fjn99911//jCj0Hw1W+5JIcoNGmBAd71eQbBjxB5Hq9+
   X21W6fpfjFDr1MvSsg0WHZtxFqaRX+ieVQySf9e8WfzWwXZlxkZHGC1TW
   Q45iF7wQxGFZ76z/ajFW0/VqEef5ua3wivsYtEMmagZeFh+etqoMyVKXS
   DTtCro+UJwPsYIHZjdwMvF2qRUfb1ednq6Sn5ToAWGTOWi+OAXA2gj4l6
   A==;
X-IronPort-AV: E=Sophos;i="5.91,263,1647273600"; 
   d="scan'208";a="202641869"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 May 2022 08:28:17 +0800
IronPort-SDR: 3YhyRroIpMD49jAh9isLOy4HaraEgtJ/yaKfIe5hBWEwa8aFRYxD6/hx+vuvn0G16jR6GM2fXY
 rQwjMD3hz118AS4K/CpLIqRGGDrGplJbH45kK7Ga9TefYN9Gxx1yg3MFsI3OM7EnlLSxX7H9Kp
 p3IatqDCzjleRVRZ34EOKp5/QhYdZcxyp+fhUZIrJixf0SLnyZjLAo5aqHgP08Io9y4qf2Tyfy
 TclQAH0DRcVf2OFGzlOoLcrUbRIhETkzVynEaIcOyiqzB6SlwgGa0/EXRJEOL+55EhtjE7qgcM
 VOIN1wO5qcEN5aZy4c4NK1RX
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2022 16:47:41 -0700
IronPort-SDR: OxPuBtsFplg51T2y1aLjIcbN1Pw0ZZg5XhEqDbmS3wVk0laGDxREE3yyPEbyeDe/vdEgZGXlGC
 +6vsbPJnvdJ1EmX0J7FhiRwrePvplG3qG8oQN3wZDpBYw3P2b3Ki4QKukpRJUNGpde0HF9XkJQ
 /e7/wLhh8RRbvam/8OKK+x0OS2CUs3zofuEaaiEWQPE1DPe6Q/Xo41aEmBb0cUz4fJnUDvCJj0
 91AeEoi2HYpwyKL6bIDrv26bIwlE4GwpDOdLQuI+ijJyOD42pG4RYdKse4a2b2gXnRvmMG0CHo
 0iI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2022 17:28:16 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LBtRN2tGSz1Rvlx
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 17:28:16 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1653956896; x=1656548897; bh=gvV6Cg0LuveZSuFj/v
        xy07eBY3mYCak+vp3JRRo4VB0=; b=PtfgRZatrkeayV5kEbriQPGMIa0mj6tmnt
        +yyeT3H4Zmsx6RV1b3h1hqXVSyoz8G4K7yXaCjB07+Xx1Mj1Ga/kJwJQ5mS1Dt5K
        GEthkce7NAcf7KdOhlD37AqNy0e6y/mUnnNPdEfLDZbMsnXoexpg8B0aqyDeAlea
        gA/MPhaadSz+phz0yZj4a9jVLrm2HCEyiAm9ZaQymzdf0pdo+AwZdaiGlKNqEdgI
        CMe+YYwNRW4XvxmfPMBmPhlD//Tu3ucXqTt0zx4CbBv8SGz8cnie92K0d7nocmX2
        w1UepsR11xcY8oMFgo987HUaqRiuLshEPpt3yRPYTgqXGR0GoTNQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id g6u-EMs2NhnN for <linux-scsi@vger.kernel.org>;
        Mon, 30 May 2022 17:28:16 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LBtRM37D0z1Rvlc;
        Mon, 30 May 2022 17:28:15 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH v2 2/2] scsi: sd_zbc: prevent zone information memory leak
Date:   Tue, 31 May 2022 09:28:12 +0900
Message-Id: <20220531002812.527368-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531002812.527368-1-damien.lemoal@opensource.wdc.com>
References: <20220531002812.527368-1-damien.lemoal@opensource.wdc.com>
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
---
 drivers/scsi/sd.c     |  4 ++--
 drivers/scsi/sd.h     |  4 ++--
 drivers/scsi/sd_zbc.c | 26 +++++++++++++-------------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 749316462075..5cc6cddd25d4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3542,7 +3542,7 @@ static int sd_probe(struct device *dev)
  out_put:
 	put_disk(gd);
  out_free:
-	sd_zbc_release_disk(sdkp);
+	sd_zbc_free_zone_info(sdkp);
 	kfree(sdkp);
  out:
 	scsi_autopm_put_device(sdp);
@@ -3579,7 +3579,7 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
=20
 	ida_free(&sd_index_ida, sdkp->index);
-	sd_zbc_release_disk(sdkp);
+	sd_zbc_free_zone_info(sdkp);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
=20
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index b90b96e8834e..6a8969eae5bc 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -242,7 +242,7 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
=20
 #ifdef CONFIG_BLK_DEV_ZONED
=20
-void sd_zbc_release_disk(struct scsi_disk *sdkp);
+void sd_zbc_free_zone_info(struct scsi_disk *sdkp);
 int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE]);
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
@@ -257,7 +257,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_c=
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

