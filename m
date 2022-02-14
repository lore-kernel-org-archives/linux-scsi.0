Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90799C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239287AbiBNCTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239276AbiBNCTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:45 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23EE54BF3
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805177; x=1676341177;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=lPlJ1jpntsbW3qJvt9DWbYFxrXX/dwT/B8+c/OeYbws=;
  b=VwUjRWqZwqtdmH9JMqwxjV2wEF1uWDflf9VtB/P06wDgx0E9EDA/x13T
   Tg+mzEvJHHZ03sQnxT2bFUwY+n5s6iiM8lFk5TRS9MU1wGJpILGV4J0Qd
   34jqfoqGPQU/gQct10fzHXfOM7bAGRg8kEQ/NdlCxsY3GbUzIPh4CjnPw
   bQ/G84X89hLcNq33NlzJ1Axz7HjkPp2Y8f5TdOgfyYc2VjmVRUdwvd4VN
   MmGkagSeSyD+3NA6yZDmmydElkcUImwKrLD0MzGuGzj4krz0avgNMYLRT
   pOhp6e5OBnD2cdS7n+tw2MiJgMf5uT4IZjUQjS/53hXlaMZiVH8ZhYcTt
   g==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819763"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:37 +0800
IronPort-SDR: VOkFkZ4hPzFBSBhyv6JlUqWYllAV0imugAuQnt7K+b2jOBvF1CSIW3xvcuzXWC84nuHM38d/We
 YoANoEqGzjPhDn8PDgPJ/FPPsk0Wc0MlrAB0+pGhwVgNSolka+csfsWJ83dNuETJcrUQTR1XdT
 faGrje5TEekIMjPyTxw7PwETL5qAQWjCpU/xfh8t95ufEdw6cJkm065AAHzw+5d7MJ7BicvLF4
 ES+4qhLuWj6uDAWS3MrTVdlGq5g3L9QHpzv8mAxk76bppEQKYQVx3wBpv5uy2CJSSIeRFucArc
 NLwVZdHntH3BtEKIpovlMoSX
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:29 -0800
IronPort-SDR: 8krEBpmF2N1EaMibRJ9ybqJkIueFIqQ4cuehKEo/HD3s0w4pZJ8xS0LiQFv8VMp0hSUg0Bvs8Z
 YCWLmbCmf0mwv9C6gtWi97S7dja4UL+7BWSQrkiIKJKpMPKpX0uV2fVxyyqoCNUCMiXH9fMH45
 jB1YZNn58ykc6UjBsaB/Kz1neitM7fOGDBRdu65UhIbMYJebysu+iORqvlOS2Yv09PJudstGlW
 1Yqj/gXRXfU9c6WesQFGMkwvXnxzy87xQ9cVhxn7Y3e/44C+WpjxsZR3hTg0tiTfpqh/kWql/G
 ujM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:38 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwp16GFz1SVp4
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:38 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805177; x=1647397178; bh=lPlJ1jpntsbW3qJvt9
        DWbYFxrXX/dwT/B8+c/OeYbws=; b=B4ML4AiZVuAQU09ZJ2GHBhv9yUhAsxJoSW
        NpA+q7lD/z/SWo9L8eZyWrh+/M+BL3ClfGwyFpIAX6N8bAQsHK0q676sifeDlze2
        ep2zQvPLmITAJAYCpLTK13rqIW80nHjhgZBh3794L+4m2SvI7BwuASqg4mrZVcEX
        jzlKCF0U4ekLhrH1GA5jluiIWHutvf7M1qoT6MDbomb3uVK6nla8vY8G5KGIafqg
        7xXeQrD1HAIIr7FixawYObZ9+Zg/aTEzyFlfXtOlYQDu9Ik5xlxtEPmVlJdpitrd
        wcLS03Y2nm/XFFFu6FLSqnJJI1VVmbl9qBARqxZfIso2L6wmzO/g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EBOBEfoeX2MW for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:37 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwm5QCYz1Rwrw;
        Sun, 13 Feb 2022 18:19:36 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 06/31] scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
Date:   Mon, 14 Feb 2022 11:17:22 +0900
Message-Id: <20220214021747.4976-7-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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
index dff859bc5501..3893bd470bcc 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4636,7 +4636,7 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *=
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

