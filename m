Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE5FC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 01:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiE3Bnv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 May 2022 21:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiE3Bnr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 May 2022 21:43:47 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CD7DEB7
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2022 18:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653875026; x=1685411026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=62sd6ZTARlsd5HOF4fAgp3i8n5GB+VqU6F117wCHpZg=;
  b=qX5Ct+yoph84zo+nR+3I5rFvdFASmmQCjPwhKMo7iZwtTwYtxrNQuMDf
   KD/qtez+HnNz2WRNtmz5FqFkl0L1r2fYBF+urF/NMwhGaI98WSVYE8z2p
   Gt4HFtGGDfv6yDlbXTfYTd3kF90mPuX8Z9N45v11KaC0gWM8llPTTBK5i
   cgj/SXh2/OB4IE0vMkDqEZRYM5e6SK5lmCH6Ug81EBktI9IIqq9JSf7tv
   puA2lFiWyK7PxUlx6WaC+GXei82izHCiSYlVh4KF32lccjbVumYr8AZas
   hfv6+ssj0sWBub+wPAtpllxydw7HzF7Kn4hrssaWnI25PnP3sAhXNBijp
   A==;
X-IronPort-AV: E=Sophos;i="5.91,261,1647273600"; 
   d="scan'208";a="313773998"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2022 09:43:46 +0800
IronPort-SDR: AMvPDCr9V9i5i2THlEEvW1lYe6TUVD/pLfCHCHzyqFmM/heDAQWAUFij+ykw5Be7dDWFkjrlFM
 qZ4LRyix/X/ucddaaEMG8LuwaVtOVeWAaL9ikN+BZCTeX8/XRpJJmLhQ75viB50q94oxRA39Hl
 3UMrH4RlSH7cJowqvvMwfgrs5zsdJybz1tBpDREvCZrHRyQWShTTkQIhqq3QPtEaBgFrFvziiQ
 Xv4eVpIAxHnwwGZ3YxLkubN0ecUZZtQ6XqkLeEoap1YEBu8nze1TU5o9g0C633GdtY8gbnaK6b
 PWIKNWGb181pdln21jPDkIZV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 May 2022 18:03:12 -0700
IronPort-SDR: AmjETY8rqpFTOF7m7p8oGLM95gA+8aObPux7GhVbw3hiLm8cr5cDrryDWfRJKrCK3iEWCr1JDY
 vaV08vJIkRM2eqokzaK4yLiECP9ccpF51xrjJ/MPN258pey/zUqDXwnpqFIFDekR1t09+7JtkV
 AJV9qNHzfoqgZX01Rzc1+jVc4m6LyCxn5l+2W81FO1qKlbGs1CpOnIui8bxDEYdJuC8D10gXUR
 IjDgCJIE1SJEN7QmDUkQuYSQn/fp3cWtKRoP1ewFFMChSX9Qc+BKMMrLDLaFwfUm0EduRbeeKh
 Zjk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 May 2022 18:43:46 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LBJ8y0sjtz1Rwrw
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2022 18:43:46 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1653875025; x=1656467026; bh=62sd6ZTARlsd5HOF4f
        Agp3i8n5GB+VqU6F117wCHpZg=; b=W2LfV2INyIHY8LcFaQxtadY666yWj1CkrN
        e7HydkfEymshEHimNqeSaV8PD8BiU5qy4anwVTZDCJ9WnFEYyAzi3Q4ejPq2yKu4
        ecT15ncjVhOIHYEiyyDcVNd7gpMOZbaLlQV4TemS79rw5pg4riR66yXUVowna7GB
        9wrPtLqM0KBm2o1yUV4rkBEkZ3iNOVPLOPga4ycLCNmnvQFDMM9i1r4Pm2dESsgo
        vlVXVAc/+iiVH300FjaNGet1n2GvYXPn7UgoE8gRrI4mx3yAmDoZuhJiY2jcWQSe
        ilk7Nz/Lm+BGaGp7B40JIzCHiyLInCBg/mJEIJIaM4NVahI8Dy+w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Folyo8CDxZ1a for <linux-scsi@vger.kernel.org>;
        Sun, 29 May 2022 18:43:45 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LBJ8x109rz1Rvlc;
        Sun, 29 May 2022 18:43:45 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH 2/2] scsi: sd_zbc: prevent zone information memory leak
Date:   Mon, 30 May 2022 10:43:41 +0900
Message-Id: <20220530014341.115427-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530014341.115427-1-damien.lemoal@opensource.wdc.com>
References: <20220530014341.115427-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure to always clear a scsi disk zone information, even for regular
disks. This ensures that there is no memory leak, even in the case of a
zoned disk changing type to a regular disk (e.g. with a reformat using
the FORMAT WITH PRESET command or other vendor proprietary command).

This change also makes sure that the sdkp rev_mutex is never used while
not being initialized by gating sd_zbc_clear_zone_info() cleanup code
with a check on the zone_wp_update_buf field which is never NULL when
rev_mutex has been initialized.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/sd_zbc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 5b9fad70aa88..6245205b1159 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -788,6 +788,9 @@ static int sd_zbc_init_disk(struct scsi_disk *sdkp)
=20
 static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)
 {
+	if (!sdkp->zone_wp_update_buf)
+		return;
+
 	/* Serialize against revalidate zones */
 	mutex_lock(&sdkp->rev_mutex);
=20
@@ -804,8 +807,7 @@ static void sd_zbc_clear_zone_info(struct scsi_disk *=
sdkp)
=20
 void sd_zbc_release_disk(struct scsi_disk *sdkp)
 {
-	if (sd_is_zoned(sdkp))
-		sd_zbc_clear_zone_info(sdkp);
+	sd_zbc_clear_zone_info(sdkp);
 }
=20
 static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
@@ -914,12 +916,15 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 bu=
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
+		 * required. Nevertheless, clear the disk zone information in
+		 * case the device type changed.
 		 */
+		sd_zbc_clear_zone_info(sdkp);
 		return 0;
+	}
=20
 	/* READ16/WRITE16 is mandatory for ZBC disks */
 	sdkp->device->use_16_for_rw =3D 1;
--=20
2.36.1

