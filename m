Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D39C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiBRDPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:20 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiBRDPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:13 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8C4CA0E5
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154098; x=1676690098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fXOF40/S8zEtelNS6z7k47nZ1ECRVRdZ58w3E2pA9QI=;
  b=dcfnO1/QWgK+QJ9QD5e133biJ2ehmggNfpjdcEgI7Fxb4KmXV/deaLUC
   k9S3cS8trZwSxiSE5IgkgsZJVoAR22nnmisQolqBv4DJBEIa8z3UFwbpC
   RepssthUr3LtOR180+9LJtMYMUqkMeJyzfO2egWhyGqR8HttH0ZkCIDJf
   Vr/Y6Mh17OFE9tyAC0YGNPSpVbajpXvYlgLLXi3IaAiI/HDfgbbxneWU9
   bcOQG/KV+4+E+Aw+Mcw+9ilNIYoySpAc23PIL/8GTMaLpCUs4jOWDfkNU
   XQZMkf+w2Xi7T09bikocnSs8/ON7RLDD7SbZmOIFkut2HHuWzqipfirEH
   w==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225727"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:14:58 +0800
IronPort-SDR: rsHF2bcfFDZK9i5jZ8AtaNpCqcxRq76Ym+3j/T/jCR3pmQIu+LV0UhJdyajFcnSGuooRuO64Zv
 7bG3MZ6+3eMco3gYmBniMIV0xHSv/Qd1KQdUMHGtq+agtTz/dycw7YQL0HsM7KdbhzgkfI/5g/
 QyMvjovHCGgPXa1cq/xAk1k85qbcj5AfICmhaVmy9V176YR7Ydc8R1AxBzC1OeEZgjSeUdVYpd
 qWmzLfnZNg8o91Mt4LiQPr4I9nOgmvO9pcLSGg0QchsxoMNWcxEqEOiEaqMjvhN3FndQNqrcMp
 YTpsIABRs/3uTP1gnWMKvA8Z
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:35 -0800
IronPort-SDR: 0IEMrdPdYKcSsQ0dcwYvFlSpyvjRGnB5ilB8HaJVi3Pemuha5Q8nHrixDvUw5w8dAy0Zy7n+Sq
 hh/r3qQO9kPkIBbGx8eD6q8nBTDDCLreGT3ZpSW7L7LQsRIbnYMnX2gA+2bCA/AtXbyNXVIflM
 mCh22kmQsDgYQXA5HS9wNUqN16p+kQF7yznIo0ulfZ0agNseBbvtNV1csnu2rTRv/aVTuq2jv3
 nk5qcwdWGJJslZLxP/iwKy91WajD2JjtL7Jxij184QYxnebqHN3+VD7V3DC5rvoX9RS2B33tvI
 Xgs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:14:57 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyn0txLz1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:57 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154096; x=1647746097; bh=fXOF40/S8zEtelNS6z
        7k47nZ1ECRVRdZ58w3E2pA9QI=; b=JnfEed6jbUmZVBXxIBM6/LKFTaWqaF4jWw
        PQpAy5nC5TOaUVb9Bn5qykIjSzKpN/YIAYTk6Lz991xM3Sxkf+PAeJ/dtOsYio4i
        31QsHM9f6cLy5E/JIvvmZF64yiK3cDWh9BaSGdiY34UDuZhFaRbAwws3cmvPZUW1
        9LWWN/HEF97lPZG6IVArwTdJgdDKkbJjuvpDPOzuKBIO++UZaxxAP6T9Oke6vvQx
        6zYxU27ZTvoYkJxM6BLIfRiiLz7qDOKGb3pVIV9w1I1SxYghnNArCU7f8b8xpLuE
        rSibEL5GpWcygVMLpdkPZhN4uBPWgko8ULUsB+xBaUGu7eT0UYcQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qqCYizVkXRP1 for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:14:56 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyl4tD2z1Rwrw;
        Thu, 17 Feb 2022 19:14:55 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 06/31] scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
Date:   Fri, 18 Feb 2022 12:14:20 +0900
Message-Id: <20220218031445.548767-7-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
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

