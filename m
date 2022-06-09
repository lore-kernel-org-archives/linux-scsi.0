Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DC3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 02:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbiFICZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 22:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiFICZD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 22:25:03 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639EC172C23
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 19:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654741502; x=1686277502;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=e/BNs8n1k0NTyuVT86TYgovEtWjZrcs5wJJYRUSQWu4=;
  b=j9Kq1ewtpSe/beZeMlaIvCOJhs19EJJvEWsJK7u+EZfdPEBlQQ1B+WyO
   HYQmv9XfSnxsQykPDxh8BevGXA3A38m+S5jHWj2Si/4JcBhckHkV8ChrZ
   TU9tkIShTL2prGiTNTaaXOdrPm1lNwP39EpckKpE2kcdS4QVDSGnC37kS
   yx2xfL6RszKccdM5ur0kku5r9cj2Sp0cB+xOSgCYwwqDbd5pkQyqAvkJi
   K2yJHyYaWC/4h6my9L9x/AvXyQ9xonVNtBM65qGQ4FDXhX/KmHDx2GbSC
   gg2/bPs4+4+S+/2LTWZiOB4+LHx8tn+3qqsa0mc2/eIJU1J+k8fhLARy7
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,287,1647273600"; 
   d="scan'208";a="314703269"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2022 10:25:01 +0800
IronPort-SDR: QTS0aBcT1BTJfSkwt0QBnXJbrDbrW2U7OMILKK6HabjYyzt5tDql1pD8cEU6knvifum85AWYrg
 cAftNynLwTMKM5AJxWFD1ZUsQ1pwx01gKYstz3UrRCZTYNEKqf4d473xfJxDpys149lDJNdbgC
 DI854RAwkyyyVPTjI7PtJJPUqMrd9Gk9nbTJl/C+1MOBr5AD/rfxCHaf5ypBL1O3lilH2DFzbQ
 16F9tRR7srvEuW98kn4+CmN7e9RVfg/zUB++VVovkWV9hhnHVfuuCp+f4uOP1kd4JF464CWWem
 BRmllnFZtKCg3Tvj1Bxypu1V
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jun 2022 18:43:50 -0700
IronPort-SDR: s6AEbd4aMgSNwmxQ7MRjcitGhESgxIOyZ6NqUoTom1ZkSQFTS3cHR1xJQuHPYF2aCIi+zH2iHD
 IXhK5l/wLGUnO76nqvj7V9ALDs7YuSjwXfmPsaDVe4AI17wvd/UofqeoEKekexqWqasu+5nULa
 b6JIsiwwBONPk2mRnv4LbKRCnOq7gQCtmXRRJBr30Ct9O9eLwrT9bUIKGTnLw96EWawrcsk6W7
 ZV6vRKqE6dB9sIXYEySxeYmyYKvhj/QbYBqO17N+NQmvKix9dDIVX6B1IjuZSFK1eLT+0ccM/M
 83I=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jun 2022 19:25:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LJSbx30DTz1Rwrw
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 19:25:01 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :mime-version:references:in-reply-to:x-mailer:message-id:date
        :subject:to:from; s=dkim; t=1654741500; x=1657333501; bh=e/BNs8n
        1k0NTyuVT86TYgovEtWjZrcs5wJJYRUSQWu4=; b=doptkXtPqxvAdr65biUsbSU
        axhXduJiRNVrj2UczmLx0RK9UajiHTkVs9r24xRMLmsABlzROpjyGGgqYp1cJULE
        K6mpSwOLufLhUwv5b/yIv3lLIUIuc1ltCsU54ZyJcR0np7wHdJ1UWWaW8RHu0Wqo
        wpQiYh/sqXVoLwXs4N/b2INto2qmkQzVHWvfTOmcOJoa5HxVMD9yY107JJkN3ht/
        1mlM+KlpNyAdRH9XPY8kcr6mEypQX4UKSCe7FK6HYRfdPQEqodv5k9jhkb4Bagk3
        fSq0RYVub2+K2MtBqxcbrd8gBuTr2Ga8mxEBQcfsLTk3fyuTAOzOgdLEuX67avA=
        =
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MJHjuQTbEIjy for <linux-scsi@vger.kernel.org>;
        Wed,  8 Jun 2022 19:25:00 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LJSbv6cRpz1Rvlc;
        Wed,  8 Jun 2022 19:24:59 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 2/3] scsi: libsas: introduce struct smp_rg_resp
Date:   Thu,  9 Jun 2022 11:24:55 +0900
Message-Id: <20220609022456.409087-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When compiling with gcc 12, several warnings are thrown by gcc when
compiling drivers/scsi/libsas/sas_expander.c, e.g.:

In function =E2=80=98sas_get_ex_change_count=E2=80=99,
    inlined from =E2=80=98sas_find_bcast_dev=E2=80=99 at
    drivers/scsi/libsas/sas_expander.c:1816:8:
drivers/scsi/libsas/sas_expander.c:1781:20: warning: array subscript
=E2=80=98struct smp_resp[0]=E2=80=99 is partly outside array bounds of =E2=
=80=98unsigned
char[32]=E2=80=99 [-Warray-bounds]
 1781 |         if (rg_resp->result !=3D SMP_RESP_FUNC_ACC) {
      |             ~~~~~~~^~~~~~~~

This is due to the use of the struct smp_resp to aggregate all possible
response types using a union but allocating a response buffer with a
size exactly equal to the size of the response type needed. This leads
to access to fields of struct smp_resp from an allocated memory area
that is smaller than the size of struct smp_resp.

Fix this by defining struct smp_rg_resp for sas report general
responses.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/libsas/sas_expander.c | 31 +++++++++++++-----------------
 include/scsi/sas.h                 |  8 ++++++++
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
index fb998a8a7d3b..78a38980636e 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -429,27 +429,14 @@ static int sas_expander_discover(struct domain_devi=
ce *dev)
=20
 #define MAX_EXPANDER_PHYS 128
=20
-static void ex_assign_report_general(struct domain_device *dev,
-					    struct smp_resp *resp)
-{
-	struct report_general_resp *rg =3D &resp->rg;
-
-	dev->ex_dev.ex_change_count =3D be16_to_cpu(rg->change_count);
-	dev->ex_dev.max_route_indexes =3D be16_to_cpu(rg->route_indexes);
-	dev->ex_dev.num_phys =3D min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);
-	dev->ex_dev.t2t_supp =3D rg->t2t_supp;
-	dev->ex_dev.conf_route_table =3D rg->conf_route_table;
-	dev->ex_dev.configuring =3D rg->configuring;
-	memcpy(dev->ex_dev.enclosure_logical_id, rg->enclosure_logical_id, 8);
-}
-
 #define RG_REQ_SIZE   8
-#define RG_RESP_SIZE 32
+#define RG_RESP_SIZE  sizeof(struct smp_rg_resp)
=20
 static int sas_ex_general(struct domain_device *dev)
 {
 	u8 *rg_req;
-	struct smp_resp *rg_resp;
+	struct smp_rg_resp *rg_resp;
+	struct report_general_resp *rg;
 	int res;
 	int i;
=20
@@ -480,7 +467,15 @@ static int sas_ex_general(struct domain_device *dev)
 			goto out;
 		}
=20
-		ex_assign_report_general(dev, rg_resp);
+		rg =3D &rg_resp->rg;
+		dev->ex_dev.ex_change_count =3D be16_to_cpu(rg->change_count);
+		dev->ex_dev.max_route_indexes =3D be16_to_cpu(rg->route_indexes);
+		dev->ex_dev.num_phys =3D min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);
+		dev->ex_dev.t2t_supp =3D rg->t2t_supp;
+		dev->ex_dev.conf_route_table =3D rg->conf_route_table;
+		dev->ex_dev.configuring =3D rg->configuring;
+		memcpy(dev->ex_dev.enclosure_logical_id,
+		       rg->enclosure_logical_id, 8);
=20
 		if (dev->ex_dev.configuring) {
 			pr_debug("RG: ex %016llx self-configuring...\n",
@@ -1756,7 +1751,7 @@ static int sas_get_ex_change_count(struct domain_de=
vice *dev, int *ecc)
 {
 	int res;
 	u8  *rg_req;
-	struct smp_resp  *rg_resp;
+	struct smp_rg_resp  *rg_resp;
=20
 	rg_req =3D alloc_smp_req(RG_REQ_SIZE);
 	if (!rg_req)
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index b3ee9bd63277..a8f9743ed6fc 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -696,6 +696,14 @@ struct report_phy_sata_resp {
 #error "Bitfield order not defined!"
 #endif
=20
+struct smp_rg_resp {
+	u8    frame_type;
+	u8    function;
+	u8    result;
+	u8    reserved;
+	struct report_general_resp rg;
+} __attribute__ ((packed));
+
 struct smp_disc_resp {
 	u8    frame_type;
 	u8    function;
--=20
2.36.1

