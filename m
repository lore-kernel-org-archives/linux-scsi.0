Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEFCC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240921AbiBQNaZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240817AbiBQNaX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:23 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C52C2AE709
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104608; x=1676640608;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FRwkDIbpah/fWM4dnE3n8IBBSfL3CzeUT5j6zZjx4s0=;
  b=HyPr7SDnquohtPAY5S6wEi85piy2kSYbe7BcnRMqKHGteTaJBh6OhIue
   9gjI9eyxTGVWwBAJffSQ5zv5Ivd7+syK65CjJ7/f359GasLCtx1fdfXSx
   siuJEpBRQxP+mx4Nj0wPSUFyoxuukK065d0P6jmhK0CbQZyfSPEPcCvyl
   +AXXmENOjDgg4jB/bPEIRo1kzT+EMpR04AMqbajSupYf0ws2bZq5n88eO
   UB3KjhdSLu7Aaku7O3qdNUUAjG0Qq7HFka0mzT7wezFEFdttpJDy6y0Yh
   toKQFU7ZjhvOPZY220Zvreh1VRkjyO9dEod3ErkNHJjfxdlMk+BVfcDzC
   w==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303140"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:08 +0800
IronPort-SDR: IPmCngVR9TprUnUb1CgWSDAoTZXBldegMqffVvh8VucOINh1WWrl+JjErT/XGTIZOLWAprE43B
 tV4M0hXwHILELjsSXvFFdn3goNNmFANY3NT8EsC7AYOxSZKn2AJuCk3Bf/sNlpkhyZ+/osrieW
 YFrNyueHmDdPx45KDx5rMaIIMsatI0DbVqOJrWHlrQ73nmAo1b00KW1hxcXwFJNO4JfTWQqaE6
 VE0RPh/mosj5o0v5iiRxqdtIutVhkMoceoRIi18Kx9tFNVAdzw3engA6rzxEdjF2dFrWRx407t
 vrO/7cMbw2GbQuDx3jYL84z9
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:47 -0800
IronPort-SDR: xN3s/BlLMoHcHgAyjPy6KOChZfvtQ4Hl1VP3altt+gkTe8taaY/zeMpEgHWI30idkJmaJXxfsk
 DvU3EJJsIamPAlMeG9mMausoAf01Ob2OvtZK4jmOp7DnPfsBlU1T0rHTX8jM+kDXJyz1o5usUG
 Z4hr8Z4PeVXpN02HUYyZaBCQ3DbLEvOHtvUmT/6zM8CBllTU06DkrqdNc17b/ZQIr9du0UJFOn
 IKqEK0OvWE01uGvUsuqukmtk2WVqBBZmXywg/sHry/w+OWSkjsZ9lRPJqC3Pl9iHwFyjlENe5T
 0bE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:09 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwg375Q7z1SVp4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:07 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104607; x=1647696608; bh=FRwkDIbpah/fWM4dnE
        3n8IBBSfL3CzeUT5j6zZjx4s0=; b=TfOLsC+6eq/JcVSxNRRrXV5cChs6YpfBZD
        rMn4qpG/uoer+Y+wznNQ3JRNSPgwX9jqKPmBtM93aXUO/17d3EC2LCTiwAB6mYgz
        vYQxgKsfAEItQMXAhkWLbocxz90LihVGqPYKz7PcuqOdNey/1DNIlMv3Qxh4ykaQ
        tzqpQNONGuHhYaEfGDSdrTlaqbUK9geShwSHUojAUUBW9I+2Jwadd8Yl0nrSrDc2
        QV9I+XYSiRHSxaBM/0D+GwEjmYD0/sOy4j6so/R00UaFUzpZmeS3Q8Vx1LlouL4T
        SauWIOfdxN7CeIa1XdfC6UYsc1E+hJxH6t45SJsGzQ4wvOAGZNEA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id FJYOgkuvwzwS for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:07 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwg23DF4z1Rwrw;
        Thu, 17 Feb 2022 05:30:06 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 06/31] scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
Date:   Thu, 17 Feb 2022 22:29:31 +0900
Message-Id: <20220217132956.484818-7-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
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
index 817bba65feb3..e20a1d4db026 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4619,7 +4619,7 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *=
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

