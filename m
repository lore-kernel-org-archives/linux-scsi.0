Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82527C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 04:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiFHEHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 00:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiFHEDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 00:03:03 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D25926D8A1
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 18:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654650973; x=1686186973;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PPhoRAeTv47RR97cO35Z0q9LVEb3uFeKAtyPj/I4DYM=;
  b=EuZHtDGqPlzUx3xXdnhvuuVMZWScv5+ws+1s6Sb71oDocUW5GPDHJaLv
   3RPadxGJBkreZG/igI9izgvvkkQLmpZ8/uR6pMEMk1XgBbLsAiGxmEojj
   YjOwhKkDuVuNtKdr+bPJdzwI+NgvqkVmsfN8btJgR+t1/wjmDKI0Yn/qg
   k7/MD5cg015OCGY8QTJvX4hGvHWBg3MXFYmEFiMMiPhsuI7vbWywGGUMb
   DgAmh+waB/ZvCiGetC/A0xGnQdwWvNED6RIGU9QXwgmnAsoGk8M96CeR5
   Z4GutDeYk19Om7CF/dsTzXDtGrZsBxIyEi+ECLmFi68f7bL+vIIqeLocO
   g==;
X-IronPort-AV: E=Sophos;i="5.91,284,1647273600"; 
   d="scan'208";a="202546629"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2022 09:13:03 +0800
IronPort-SDR: nBrc8HBWDzdf+yII8dyqMD4y8rwkn2dgkOD9Kh1330ldTUgp/lMRxaPSlnV6pcXW3iSs/yzlEu
 JXhilLMceIkcP8UTDQ/vB++DMedckRKz5gvaAlYoTn01g7gXFBYvSzpFk2mwdDYqyg8EQFD6tV
 naTj40RHisOd6tGwjRyp6gCuGUCrgNpyi02EKyQO1/lfAKb6P2n8Eg7O2zA/qgYyA87V0jeolL
 tvPIoUplzAJMfWdIDIh6sQ0kpUcZBz50ooyt/FzJwZ/XTJlvQ9LWLy/90nlsuUe6bnWeej+dUA
 oHpV+3nsBCLhkKcIbKifQPsD
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2022 17:31:55 -0700
IronPort-SDR: 36z6ZAN2XJP82isOFn0JhUnMdniX1k8mPyIvLEQSfo5XA0R+3lH4j+Jllb027bXAR5jsOb7nLi
 xzsXA0cIUDFw31HFWsuzmB5uc1y/7Gve3X20mT0elQ3P4Gz5m1LkGPmA8s52Pf/6wg8k/4NzrK
 xcbF4EG2ZdnCzbSnyBbs+JLqFqzaqDKF18nu5QBVuUCZu+1fVH5To34n3Qk9RrpWCn+BUAEGhr
 E8HY/92tDq84zVsOlUwksdmC6+yi9UbwAtGRDTGIyqgpVtiB00okGZs1/2QEpzEAQ6+kpQhLDG
 1Ew=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2022 18:13:06 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LHq3P2SwSz1Rwrw
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 18:13:05 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1654650784;
         x=1657242785; bh=PPhoRAeTv47RR97cO35Z0q9LVEb3uFeKAtyPj/I4DYM=; b=
        BKnjL193nHwsoPNwHU5oVQLri30U2sngRiajtVGTSTULYw2OCMm8WjzWjIZfPG1i
        bdqGir4Hmqqdl81+sBU2D0AasxAmopFm+whPpUAruVbhfHZwYVglpQYyCCfaOCV9
        eatGG1SCDh0HgeeD8M3VvEc6w3w5uDmzb9VmWaL6/piuDv/vg9lIlXJORDzBKJuf
        jjHVC1RTxWwS1BT5iTpeCYOX1VdvuutK++CvDR3AefYuCu7vs9hWhMekLLwBVzJn
        si+uW6rsyypKKCKCVd0y15PTfku/3RGNLGSv2+sdSUTotLldsrNgFqMWMa/Zs3zg
        M30ZuhV8vt9X/uRufmMt+Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ig_NHZUpe8ic for <linux-scsi@vger.kernel.org>;
        Tue,  7 Jun 2022 18:13:04 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LHq3N1HH9z1Rvlc;
        Tue,  7 Jun 2022 18:13:03 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2] scsi: scsi_debug: fix zone transition to full condition
Date:   Wed,  8 Jun 2022 10:13:02 +0900
Message-Id: <20220608011302.92061-1-damien.lemoal@opensource.wdc.com>
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

Introduce the helper function zbc_set_zone_full() and use it in
zbc_inc_wp() to correctly transition zones to the full condition.

Fixes: 0d1cf9378bd4 ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
Changes from v1:
* Simplify the patch to not modify the zbc_finish_zone() function and
  not use the CLOSED zone condition as an intermediate state in
  zbc_set_zone_full(). Cleanups to remove the use of the closed
  condition as an intermediate state will be sent later.

 drivers/scsi/scsi_debug.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1f423f723d06..b8a76b89f85a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2826,6 +2826,24 @@ static void zbc_open_zone(struct sdebug_dev_info *=
devip,
 	}
 }
=20
+static inline void zbc_set_zone_full(struct sdebug_dev_info *devip,
+				     struct sdeb_zone_state *zsp)
+{
+	switch (zsp->z_cond) {
+	case ZC2_IMPLICIT_OPEN:
+		devip->nr_imp_open--;
+		break;
+	case ZC3_EXPLICIT_OPEN:
+		devip->nr_exp_open--;
+		break;
+	default:
+		WARN_ONCE(true, "Invalid zone %llu condition %x\n",
+			  zsp->z_start, zsp->z_cond);
+		break;
+	}
+	zsp->z_cond =3D ZC5_FULL;
+}
+
 static void zbc_inc_wp(struct sdebug_dev_info *devip,
 		       unsigned long long lba, unsigned int num)
 {
@@ -2838,7 +2856,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devi=
p,
 	if (zsp->z_type =3D=3D ZBC_ZTYPE_SWR) {
 		zsp->z_wp +=3D num;
 		if (zsp->z_wp >=3D zend)
-			zsp->z_cond =3D ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
 		return;
 	}
=20
@@ -2857,7 +2875,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devi=
p,
 			n =3D num;
 		}
 		if (zsp->z_wp >=3D zend)
-			zsp->z_cond =3D ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
=20
 		num -=3D n;
 		lba +=3D n;
--=20
2.36.1

