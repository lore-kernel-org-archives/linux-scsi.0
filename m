Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B41EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 02:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbiFICij (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 22:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236977AbiFICii (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 22:38:38 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F217E3207E5
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 19:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654742315; x=1686278315;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5tz4IECGAzEowmyx4EsToQK31tQYtdhN58jU9jp5bE0=;
  b=iPLvhZAqonOdBOWiQKh6+bLV+nJUTUYGq7tf45L55JN0Voh9HJukDRje
   YdYoeKILyprnNWN5NhguggTZXRXJXprwdXUKR0tQ/MfnD1bG9Z6Plp3zZ
   rVN5zARl0dZGqbi/ov9+D0jOt2hwO/W/+xf2xVkwQyyr4VYpsiy3+bK/p
   UfWqqpKWFJQvE5P2ZwjrTYSPJ9hZXfDtSxBVc3GyU6r6yakuI5Xvv3ElP
   OKBrJlHFfBm8fQPnftzrliVpZp5QLLHg1EkgnY9vFNxDmLHAFj+7rUOWd
   SED+hKqrRjJiZBtcUFHe5Sau54Gqg+v9zq8N5Kv/zF7twFTYqbcqmqA7R
   w==;
X-IronPort-AV: E=Sophos;i="5.91,287,1647273600"; 
   d="scan'208";a="314704164"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2022 10:38:33 +0800
IronPort-SDR: 8j2gFFnodkf49SQH7+6v0CfLYl17NnMGPI8yV1dg1paiViF9Y37erpDYcJKBUwiPq77tZzhcPW
 SNqpTmW8YZ6va/7280sUMUngZRYeDwJbce5Vty2MU+FpGYCvMLpLHllLgt9qmx04w6gtiKZKmL
 zm5Cx33PCHm5bCjQw3AuyCmLay/sV8Tmbq5917g/BLyfSVbsCRkNIVAhvASeb5IC+1krxNC7yW
 EKBfilQDJ9BvXLSeiZewiagVZwBIuk7CULlxJM8/ccjMqAkge+XKh+DwQmTrvT6CmWnAxF43JV
 11Al4qcP/QX2gLGw7DdfdWXN
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jun 2022 18:57:21 -0700
IronPort-SDR: cZeWwODwkMPdcvkX2bAv87gW5/5h1N3LCprhYDv3hr1zGbd7xdHY5PARqynWzoy/6KyuIOBT+4
 oLKPbQQE7BAWB4yRlCyc3+CtVON0VodyzuLsLoUZiGlPJg0MKuLFTEc2YIKz9wvP9f4bvrnDk9
 TjETC3KLgFPMxayA3o7jEw+S9+poJ71kKn3m5igaYVvSt7uoCCXGbVUjhiYM809xDK8trkxdvU
 EJlfIS8r9ajPGHa7wgZYLjt+UO+igSBbG9SHOW4Nqn3iHKyRndWSVeQJpM73e283UYyxTPIJ2h
 JaM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jun 2022 19:38:34 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LJSvY2j52z1Rvlx
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 19:38:33 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :mime-version:x-mailer:message-id:date:subject:to:from; s=dkim;
         t=1654742312; x=1657334313; bh=5tz4IECGAzEowmyx4EsToQK31tQYtdhN
        58jU9jp5bE0=; b=dqNoDb1kuXp2JKaTp1szVdoPEGs6YHT0ZoVPCHCuuLY6sByF
        bqkRjZxnTUykst+T/KTBk88oksijQkgCVTSL/pZVOOYXFVn087PKaGXuU50VBVnw
        mRPD1aqOQYtdfTR/pBWcqCSsdar/oFW6sK5+HqaRaQ1d5tJvqjbLUlhci4zbjnl+
        fw9rA2++CdBhtxPIFSGvQf5F5dB/w69q/jb1RjJGqjTXoXNM6eFmSVxQQIDA+SqS
        kuWX/+NqhczAueL1fO/4/MvXgTuRhm3UUKKM0kB1BSjLGcGrr8mz27HLfSyYwMip
        3w2scL5B82w6kgKRtknb15lVKg19L8Rr6Uc2eQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id v_KcqHtJ8g96 for <linux-scsi@vger.kernel.org>;
        Wed,  8 Jun 2022 19:38:32 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LJSvW4qPfz1Rvlc;
        Wed,  8 Jun 2022 19:38:31 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH] scsi: mpt3sas: fix compilation warnings
Date:   Thu,  9 Jun 2022 11:38:30 +0900
Message-Id: <20220609023830.442213-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using an allocated memory area with a size smaller than the data
structure it is cast to generates warnings with gcc12:

In function =E2=80=98_base_assign_fw_reported_qd=E2=80=99,
    inlined from =E2=80=98_base_static_config_pages=E2=80=99 at
    drivers/scsi/mpt3sas/mpt3sas_base.c:5495:7,
    inlined from =E2=80=98_base_make_ioc_operational=E2=80=99 at
    drivers/scsi/mpt3sas/mpt3sas_base.c:8109:6:
drivers/scsi/mpt3sas/mpt3sas_base.c:5397:40: warning: array subscript
=E2=80=98Mpi2SasIOUnitPage1_t {aka struct _MPI2_CONFIG_PAGE_SASIOUNIT_1}[=
0]=E2=80=99 is
partly outside array bounds of =E2=80=98unsigned char[20]=E2=80=99 [-Warr=
ay-bounds]
 5397 |           (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
...

Fix this by allocating sas_iounit_pg1 with a size equal to its structure
type (Mpi2SasIOUnitPage1_t). This increases slightly the amount of
memory allocated, but this is acceptable as this is not the hot path and
the memory area is temporary (used only within
_base_assign_fw_reported_qd()).

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index 37d46ae5c61d..3b30d2c26f2a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5380,7 +5380,7 @@ static int _base_assign_fw_reported_qd(struct MPT3S=
AS_ADAPTER *ioc)
 		goto out;
 	/* sas iounit page 1 */
 	sz =3D offsetof(Mpi2SasIOUnitPage1_t, PhyData);
-	sas_iounit_pg1 =3D kzalloc(sz, GFP_KERNEL);
+	sas_iounit_pg1 =3D kzalloc(sizeof(Mpi2SasIOUnitPage1_t), GFP_KERNEL);
 	if (!sas_iounit_pg1) {
 		pr_err("%s: failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
--=20
2.36.1

