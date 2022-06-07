Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF6EC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 01:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbiFGBuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jun 2022 21:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbiFGBtr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jun 2022 21:49:47 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F386898C
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 18:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654566584; x=1686102584;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mr7vD/aVuZRaSqjcuuSXAugAhOn3+DlOFDR5RHGItnY=;
  b=BPxOlWXqSBZ5V3HqbO3uYe1mn3K5x2chryzl7aHS+afGfVAcsKWe8mJI
   lqacv/PMmSQEuDIqEuXOAcTbCb3muBQX6Y/Oby9dneWb4MZOUI2BiCYoG
   oJ98XykyC3hncNCNgRw38zFqYW5mTT6Hgo/1svl1bV1XND26/q5sW2HhT
   98s9Eojkm7QWpBh6QY/KGZ9DJlMsEspTRsq7OE5BJGFjIXZD0FcPloHw0
   JZGEUwmMXCHo+5e7V4GakuJT4TnZiGfa4Pl7rbekJJJHzyDN+ldX1C3Ex
   NIYWTQBrx/8FCeJB/8aK1q5TJAaB38jHA25yt8194kXtqVxeflCsR2vy7
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,282,1647273600"; 
   d="scan'208";a="202428300"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2022 09:49:43 +0800
IronPort-SDR: cqYOSeCtoxiY5aBHVEZ9U6frpfg+S3A7EeXMujUVlyNv2Hz1d40/G2+tRSvu+VGcuqz7OOTeYm
 634cVvNNCVDh9rHNmnuP79U8XCCRz1J4ozsGNIvCKFLz/DPWvVrfx/OyARxNTV3TTTVMyaPoxT
 96E/ZorapgYE9pkD87XdnKfNAX9Rcg0Y941SHlbPCzrZhyW8SIOSt5G7lfPMM4mip4tgWq4XAg
 9L/Nd2Njvqe/NtTag5/k9rL7up5gK9JhFXms3myLJg6mbqId9DOc/80BrEVmTyzlZ3Rmw7CQuh
 0SFqQeBaBDFblOdSg2jI1czu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jun 2022 18:13:05 -0700
IronPort-SDR: qcwxkNHEQz7HV89ca1Oog3k0YaRs22hlb+yPWiMvOH6nrMf0Nws+s9k6xhsXa6RYMZXSSvJmvV
 2DXSUKZGBgTHpju2+n1BeixRbt0dYtkgMx6LU5s9D2QJVkpHZnsLSJJAqdAWUxQaV5AwGyaoOp
 Re1bkdSDu9hoT5O4r3X6mTt6z8/CTA31P9hKSXAijpOnVJOw3zKp/mDN76eBJRGBkr5DTBea+0
 xL6Dq9J+vu/3HF+RjCb34wmZsibwDtFNIEsDvUvPnVrtKrvANfUlz+i+Sgphu8cJD6E+lNegWK
 F2o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jun 2022 18:49:45 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LHCw85JnYz1Rvlx
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 18:49:44 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1654566584;
         x=1657158585; bh=mr7vD/aVuZRaSqjcuuSXAugAhOn3+DlOFDR5RHGItnY=; b=
        rsnpHJ1D20RJB+bjrxhDf4ogjEFyJ1wqVdOOXYY4vY9zYvZICaX1MElLEUQGnSHy
        jnhLlS6VlJAEZU80UOTnnJIhBhAmrqkifM4huBd2h6NWPL+SGkFPn3NkaGq/SPol
        9aR+L2FrkzizNanANQc9YLHREagYcdabiOania0lUqYtF8gJNNm0A+DDb/1YE5Uf
        684Ul8K+JlHVrCdNfrXliU2X/YosBVeCudCovc6VfPzp4It66+8+yCx8IRT8r8W3
        SSdm7PEWI26NbQpjbxHa6UZUpXLJA8ZdNGE4ZRJhQsfRDLRNEJsNRsT/HdUootAP
        W2drPAv/FlcIpB55XNap2Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ejayujcqpmRU for <linux-scsi@vger.kernel.org>;
        Mon,  6 Jun 2022 18:49:44 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LHCw75w71z1Rvlc;
        Mon,  6 Jun 2022 18:49:43 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi: scsi_debug: fix zone transition to full condition
Date:   Tue,  7 Jun 2022 10:49:42 +0900
Message-Id: <20220607014942.38384-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a write command to a sequential write required or sequential write
preferred zone result in the zone write pointer reaching the end of the
zone, the zone condition must be set to full AND the number of
implicitly or explicitly open zones updated to have a correct accounting
for zone resources. However, the function zbc_inc_wp() only sets the
zone condition to full without updating the open zone counters,
resulting in a zone state machine breakage.

Factor out the correct code from zbc_finish_zone() to transition a zone
to the full condition and introduce the helper zbc_set_zone_full(). Use
this helper in zbc_finish_zone() and zbc_inc_wp() to correctly
transition zones to the full condition.

Fixes: 0d1cf9378bd4 ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/scsi_debug.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1f423f723d06..6c2bb02a42d8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2826,6 +2826,19 @@ static void zbc_open_zone(struct sdebug_dev_info *=
devip,
 	}
 }
=20
+static inline void zbc_set_zone_full(struct sdebug_dev_info *devip,
+				     struct sdeb_zone_state *zsp)
+{
+	enum sdebug_z_cond zc =3D zsp->z_cond;
+
+	if (zc =3D=3D ZC2_IMPLICIT_OPEN || zc =3D=3D ZC3_EXPLICIT_OPEN)
+		zbc_close_zone(devip, zsp);
+	if (zsp->z_cond =3D=3D ZC4_CLOSED)
+		devip->nr_closed--;
+	zsp->z_wp =3D zsp->z_start + zsp->z_size;
+	zsp->z_cond =3D ZC5_FULL;
+}
+
 static void zbc_inc_wp(struct sdebug_dev_info *devip,
 		       unsigned long long lba, unsigned int num)
 {
@@ -2838,7 +2851,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devi=
p,
 	if (zsp->z_type =3D=3D ZBC_ZTYPE_SWR) {
 		zsp->z_wp +=3D num;
 		if (zsp->z_wp >=3D zend)
-			zsp->z_cond =3D ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
 		return;
 	}
=20
@@ -2857,7 +2870,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devi=
p,
 			n =3D num;
 		}
 		if (zsp->z_wp >=3D zend)
-			zsp->z_cond =3D ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
=20
 		num -=3D n;
 		lba +=3D n;
@@ -4731,14 +4744,8 @@ static void zbc_finish_zone(struct sdebug_dev_info=
 *devip,
 	enum sdebug_z_cond zc =3D zsp->z_cond;
=20
 	if (zc =3D=3D ZC4_CLOSED || zc =3D=3D ZC2_IMPLICIT_OPEN ||
-	    zc =3D=3D ZC3_EXPLICIT_OPEN || (empty && zc =3D=3D ZC1_EMPTY)) {
-		if (zc =3D=3D ZC2_IMPLICIT_OPEN || zc =3D=3D ZC3_EXPLICIT_OPEN)
-			zbc_close_zone(devip, zsp);
-		if (zsp->z_cond =3D=3D ZC4_CLOSED)
-			devip->nr_closed--;
-		zsp->z_wp =3D zsp->z_start + zsp->z_size;
-		zsp->z_cond =3D ZC5_FULL;
-	}
+	    zc =3D=3D ZC3_EXPLICIT_OPEN || (empty && zc =3D=3D ZC1_EMPTY))
+		zbc_set_zone_full(devip, zsp);
 }
=20
 static void zbc_finish_all(struct sdebug_dev_info *devip)
--=20
2.36.1

