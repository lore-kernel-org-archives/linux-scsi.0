Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68730C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiBRDPV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiBRDPO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:14 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C1112A757
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154099; x=1676690099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QveB5a+85eplIPaj4PtIIZ6/INt1r9nE8RbC6a9EBNw=;
  b=Wp4+TIFyASAvpaFCriKR5LGaV2Y4Rq/ZxFSPE8POnCp8GJ0E69oNHhRK
   iUgQiEaH/gZD7mBV1c+tESqswNgnLaA+HAzUT27v7qv/1lCx8g1DbGDw9
   ZnFVVW66cwcRmV7rMZrFe3CBF4hya1Fx8Q3mlROX/l+AgDvJuB8U0Zcqj
   m9L0o0ysRtqsxsiCQ/6jI7ZOjZNP/rigRHhIF7Ub9nLgq6DQP4cCGgm/F
   ZxwL608GyR2HqLHgL8Xtq/7J4V3/V+dWAWZR4FI8eXemL62Tqa9IVl5u1
   rhlu1jvdfEFAuZoozEsQ/pGyKPm/QuxAW9eEVCAHrTG0UTr3gdRu7VRo+
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225739"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:14:59 +0800
IronPort-SDR: BibEM7Ah4e0IsacXQjoQnEtT0od0HAurkfC99BPqf6OVv5zGbjVH2UcEuBot20EM3UX1/IZmAB
 Xb0mnIhPCuIPz+wzF5W+i24RwinA/V6WAJF3NbBlKMDnFkUFrm/+xNhlFrELNCEpi+Dd3I6/GW
 QMocKmGeDOPxOzqd00Q2pyel84hDu/Vq1jK7cf5Dasdk4GWmWO3L9jdSxAcw7C7b28C0ibrEZz
 zYgWe16tqp8VJ1OOgNnuUvFyzofqvousk73ruOmcTk+IX7Bn8jX4VV/33ANz7NRE8JHhjxjfuR
 aj9Mi2ANfbEB+NR2tjnWUHfe
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:36 -0800
IronPort-SDR: R016TXp5/tqhfVfRpepRMldI2x+qVcDhd+Ja5GZ/kjQKK5e8uS67NDpUhHACKxVbDctjEZHukC
 egCvNUb3xxDKO617recJtyBgRkmAxoyjRLin/Kr1Mkz5vopDMhGzMOAyzPiC4wrDrRTb0IzpNu
 PGSUeRTfJlSP9xGVJpN1XdjM34tBygWktkUhdRUw0sXpU459Mo2VTE/QeGW49AoPYstUy89Y3t
 3HTGQgsjbt3Dc6GPV8BPkq6IAwrMCazA8ZB92NTpEEMPtSTNAIP6ZbVBe0VFXNnVQGVjn72ttJ
 CpM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:14:59 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyp3qFGz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:58 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154098; x=1647746099; bh=QveB5a+85eplIPaj4P
        tIIZ6/INt1r9nE8RbC6a9EBNw=; b=O3CM1o9wWrYqTwW0i4S0wfAhOuUDRw7Z8S
        SlIOMj/0FdY0ERaYd2/ov8ee7V2LKTbEfvJsrczn8CLS3j4hV4GRmV5TEesUCOKN
        nqfsVIULxmEKmoDZIpxiFf13WNeaVmga4ZMpLVuhymEnoetA/OCP9/zcBEmLWo19
        M6kPIThOMXgeolDIaGu/vFSfYF44oJFFSuRSI1pa+x68cZoOpxJch3qKoQaNAjvx
        GOQopLCkVKfXdua+jTfkrLwDi/5lN6UP8Z3NY5UfxEpK6pbyK3J77qlLOkWGIu/y
        0nooRKzAIr7m59/4BuF/x/0F4IyPLt5gtrnBxUs9nALeov0HjyIw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id j5531HukGC6s for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:14:58 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyn0Gs5z1SHwl;
        Thu, 17 Feb 2022 19:14:56 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 07/31] scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
Date:   Fri, 18 Feb 2022 12:14:21 +0900
Message-Id: <20220218031445.548767-8-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The fields of the set_ctrl_cfg_req structure have the __le32 type, so
use cpu_to_le32() to assign them. This removes the sparse warnings:

warning: incorrect type in assignment (different base types)
    expected restricted __le32
    got unsigned int

Fixes: 842784e0d15b ("pm80xx: Update For Thermal Page Code")
Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware func=
tionalities and relevant changes in common files")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 0b3386a3c508..b303bc347f3d 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1201,9 +1201,11 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *=
pm8001_ha)
 	else
 		page_code =3D THERMAL_PAGE_CODE_8H;
=20
-	payload.cfg_pg[0] =3D (THERMAL_LOG_ENABLE << 9) |
-				(THERMAL_ENABLE << 8) | page_code;
-	payload.cfg_pg[1] =3D (LTEMPHIL << 24) | (RTEMPHIL << 8);
+	payload.cfg_pg[0] =3D
+		cpu_to_le32((THERMAL_LOG_ENABLE << 9) |
+			    (THERMAL_ENABLE << 8) | page_code);
+	payload.cfg_pg[1] =3D
+		cpu_to_le32((LTEMPHIL << 24) | (RTEMPHIL << 8));
=20
 	pm8001_dbg(pm8001_ha, DEV,
 		   "Setting up thermal config. cfg_pg 0 0x%x cfg_pg 1 0x%x\n",
--=20
2.34.1

