Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F60C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347749AbiBKHhl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347748AbiBKHhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:35 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2627B2678
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565048; x=1676101048;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=FeXdlqn2vSeYOtDQaxXiZabjzvdlegzxYr7xC79s/XQ=;
  b=E0oI4jHbH4XEUFPCiq3FkgP7KOPwDEZmfCqbIJK/xPScFUoJHf9/qZvi
   lwjlkDAJ33b/BPZG7BGZKvdLaGC5Ssf6p6t3xZHMESa6ow9cg62hK6+XJ
   wlW+XAsN/BgrhWBcnxmSXbpDi0EyYmsJipVTy7//9kETHBYoZIS84J3zv
   Fdl37VkhX1S1BWXg/knyKpyVrZAi0GhmvLKm6cNS0ALLpjIwHYUIJc2ao
   AAr1Mvb5RyUJPzdm7DtjX2k+cVvoXabONLXL3klXjseLQhjOCIEdvox0v
   OkkrSTh+DV0DcdUGcyGdY//02Wv3tANKnyJ+dAP/dWSPQvYiWVonxsiOm
   w==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675155"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:28 +0800
IronPort-SDR: MxSaA526LlWQd/D/KfEszHpgEMvggTjU9FFkexRIwhA2ODE4OsJXQpj64qn72Kd3IYDLFlN+dn
 971Eyl26NIjmBHC7CKCqMsSpeqbjk04eZxhboFCtijv58OxDSoqKkSNvbSPrjT/17Rbk4IOeJk
 iOmvS6eU8WlK9zXULyLWLvP2+5xF/IHSoC2PxTapS67EXJzOI4YjsCWrx7YEch95N0lbJjDjmr
 7Ltsvykzarf60pAed9UUJn95PccZ5AytVg9DnBcaTPytyjW+TOZGzQetCve/lDB6VFVHPpmV5K
 rNxkRHOOf/6ey5dLrEoWV84h
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:16 -0800
IronPort-SDR: 9wsgEj5sWJN6wZ+lBaqm0bYgTUHb6KvXJqofRw8rZ+9gvQtM8jXDv5vSqimRuNORS9crk6v5CK
 0I1moQIfNcYkRD3SmBDqMR1wwO6LpWOTUTzEplgqSwBn87ovL04c5D10u93J/alrghH2Z54NLt
 sGnVNG5BLFWOL1pDMp2Nue6r1wSKxFHfEh9vdN0Qq92F6UQx1sapLXK0/xDBTuwejlL42b3OCH
 6z9WYMNzusrS2eoaa0DiRmx5/zIy5RR8HTxIts+TyGh63u7xTBfuHcYDuWnXZrngDz+BTkSzvl
 uCg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56x5Qytz1SVp4
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565049; x=1647157050; bh=FeXdlqn2vSeYOtDQax
        XiZabjzvdlegzxYr7xC79s/XQ=; b=c5FXOabpsrvlAdpp0YSJaHBneQLnthe09s
        Y4gKUBFbQ7IMhxILThWgNOfHNhD7VyppZtdh7Q/46EAFPi+jZZrIHOlLp4ml3TaY
        xGCpZ+Oi3EiQSEKf09y9z6XkPwQTcXZMforljDJ25cp7t9yqxbsyRu8yww5HME+G
        x3nwxTErG5FqGUF0gBpnWNZOuXMMcl6QWf9Ijx19vyFAY2sCzGRLy7HSdG5M+w+5
        vEPyoqp/TXwMdAm5Cm0QnEZF3BfLgzwdgKY5NEtxeICFQpN29FqQZjdc8ykqS3GZ
        As44bp0grehAtMjnQ02I02yjq0MEZdIw4D7wsoGO/nOub8yATQ4w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SNPkpZHo6x5o for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:29 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56w2Nn6z1SVny;
        Thu, 10 Feb 2022 23:37:28 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 18/24] scsi: pm8001: fix NCQ NON DATA command completion handling
Date:   Fri, 11 Feb 2022 16:36:58 +0900
Message-Id: <20220211073704.963993-19-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NCQ NON DATA is an NCQ command with the DMA_NONE DMA direction and so a
register-device-to-host-FIS response is expected for it.

However, for an IO_SUCCESS case, mpi_sata_completion() expects a
set-device-bits-FIS for any ata task with an use_ncq field true, which
includes NCQ NON DATA commands.

Fix this to correctly treat NCQ NON DATA commands as non-data by also
testing for the DMA_NONE DMA direction.

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 3 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 9d982eb970fe..8095eb0b04f7 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2418,7 +2418,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha, void *piomb)
 				len =3D sizeof(struct pio_setup_fis);
 				pm8001_dbg(pm8001_ha, IO,
 					   "PIO read len =3D %d\n", len);
-			} else if (t->ata_task.use_ncq) {
+			} else if (t->ata_task.use_ncq &&
+				   t->data_dir !=3D DMA_NONE) {
 				len =3D sizeof(struct set_dev_bits_fis);
 				pm8001_dbg(pm8001_ha, IO, "FPDMA len =3D %d\n",
 					   len);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 283b68d7da24..d9f0afe784e7 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2509,7 +2509,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha,
 				len =3D sizeof(struct pio_setup_fis);
 				pm8001_dbg(pm8001_ha, IO,
 					   "PIO read len =3D %d\n", len);
-			} else if (t->ata_task.use_ncq) {
+			} else if (t->ata_task.use_ncq &&
+				   t->data_dir !=3D DMA_NONE) {
 				len =3D sizeof(struct set_dev_bits_fis);
 				pm8001_dbg(pm8001_ha, IO, "FPDMA len =3D %d\n",
 					   len);
--=20
2.34.1

