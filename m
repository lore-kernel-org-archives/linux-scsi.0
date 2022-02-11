Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E718C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347728AbiBKHh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347714AbiBKHhT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:19 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BF310B1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565036; x=1676101036;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=QxFaq4u/ltI4EXOZN0EExZT+6BlFEgHRDm4Mn9uwkNU=;
  b=hEuSBf838jhejNtj4aoB8WgSfNPDI5xFOT0Wk9Ap7jiQmZTdANnHu/I3
   it0mUvCe+/jVbOPPCxc3hKOd7GLwbRBBp5GvdJaq+F6iTRh+Qr3N2CyNM
   ufwxo8zTwWq1U2jttToQhMHchcoVNJlKqx9tCSeF7YuxXRwEpghOhWszJ
   pq5TM2W0L/czzFs8/aVe4uphNmoqISkf28qxfnm+Lwf25bKtsKlaLlNgZ
   M4bt/mzGEbVctP9QkmBtlc0fq1ocioxCOZRkoVhEOqVKkSzL29LIoMehN
   7eJ+dgquET7a1zmINJsV0yb+GKMVyxxtJ7tEHWCQjkoyF11AayrH2s9zB
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675138"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:16 +0800
IronPort-SDR: o/9Xz3EstcgxDWrft3jSRbJS1ddpWeTV0IxDmzPwQs7Zb12trh917XmPA+ea1N59R1NfWnJKF3
 AHAX6wG7QM5/GAzK4mHCIaMwKVMphWplusSH2rr+H/4HUmRux0x2O4Oz1jVQUAb8MQTsAQLyDT
 /J8gdx3gaXvMh4gTXyhBYSzGLAG69OoWh/VoRccb1xlPm2vZhr3gDrhtco1lMDZ+Z69ejLl+tV
 rAF4TgNw3sp3K7bQWPp21aA5R46nqNZlpNC+eArDQ9YEAP9lzmlQBMRYZKvxG5hPSUkJj/plAM
 w+0ooOlIoCPGZA1BZDL2A30g
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:05 -0800
IronPort-SDR: IgEFq1DYp4m6DTP9QZQcVgu/+1P87UnGzpunawD5e5EZs5/NL9xYRXwWdnf9v9DgJ3Arj1Ycqi
 ddhLneAOq2Pz2bbB69urbHkpGuRWwmHJxbSA3wMLWZ4UsE0OgJmgUklp9+tKC/4AUne4/8P2oQ
 +7tQbPZB8kSs0lFAbXtXLR1UBs6sH92+TOVN33aHfBKjxI1luGat+0jtSJv06w5jbDBnG5Y0Bo
 BOfvYFwKfEeOZ7LyZoTQEmIaw5gUzdq8w3gw46858qSxWa84AORbI1ztRTUrrQj8Fj4vOg+ehd
 fQc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:19 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56k2KpZz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:18 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565037; x=1647157038; bh=QxFaq4u/ltI4EXOZN0
        EExZT+6BlFEgHRDm4Mn9uwkNU=; b=eOZU1F3ZaK89Ek/Pibt4P3leki6qm2tupg
        gsQG5ioR6Td8b+DQPCfUYqCaT0MJdCHfzktsFDjGPrRwKIeCGNpWBjRxcaIzmcuW
        N/ancj+aO2JvbHcFdQFo1bpFH7hHx73d9or72yfPcfzzmmomaoedD/zghXDsERpx
        ssfwTKyTigmQt2/YtJ+Uzp7dCqvZRrhBpcfIf9nsDazK2uAwRXmqTHYGDmFdm3mi
        69DG6sQITSLiUu47kms8LhiRvI8y6uQqF6fyyljd7fse2+8dynQ9f8kUj1t9WVPl
        pvJWruNQtYfZLUL0/c9MuS1LSNId1MXofF6P04Dmu+D6Bu7RF14Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3cmOcezo_g3S for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:17 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56h6lsvz1SHwl;
        Thu, 10 Feb 2022 23:37:16 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 09/24] scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
Date:   Fri, 11 Feb 2022 16:36:49 +0900
Message-Id: <20220211073704.963993-10-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ds_ads_m field of struct ssp_ini_tm_start_req has the type __le32.
Assigning a value to it should thus use cpu_to_le32(). This fixes the
sparse warning:

warning: incorrect type in assignment (different base types)
   expected restricted __le32 [addressable] [assigned] [usertype] ds_ads_=
m
   got int

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index d978f7226206..43c2ab90f711 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4626,7 +4626,7 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *=
pm8001_ha,
 	memcpy(sspTMCmd.lun, task->ssp_task.LUN, 8);
 	sspTMCmd.tag =3D cpu_to_le32(ccb->ccb_tag);
 	if (pm8001_ha->chip_id !=3D chip_8001)
-		sspTMCmd.ds_ads_m =3D 0x08;
+		sspTMCmd.ds_ads_m =3D cpu_to_le32(0x08);
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd,
 			sizeof(sspTMCmd), 0);
--=20
2.34.1

