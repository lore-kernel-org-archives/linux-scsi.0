Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38403C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbiBRDPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:50 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiBRDPX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:23 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6616120F7A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154108; x=1676690108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g9DqTo9CfqOPxmAnqtDwRWIZjNs6xzEf/L8jfuXNUaI=;
  b=WRu+a8CvvChIUWDlFWqrHgA+6ybz0o+Ro8Hx7gYm8ax8S2m7bh3iXaWE
   m57vSOKRHd5sUC3h6Ye0zsJ/JCWLU9dzfC6hb/5SuWZQl/pA3bnj/2fia
   xMXOcdTnjiqyFeJMWzLM9WhRi5vcKEtSdL2c7JH2sIgvsXzzVvOCivW2N
   Y8P5L7eA7BRQ3his/8MlVifKrWIT1jthPgzvmu1Xwf+Hg0Bk5Obfm2JZt
   n33/TDi/osYMZ1X333BUTPEp4C9eY0jcMW2IaGPAmrFxXTFVtpQ48UP5r
   ba13w5MGwzxqoexeTMFaxGg19qiZ8bd8IqLv1iOvqQW9EoCq1DOm7ciDY
   w==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225774"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:07 +0800
IronPort-SDR: kV9D2AzlVHGvEYovzqMRyrumo71si0EJ+OvP0itlGgnTujlh5ylOoZtHu23Qb/i2Dg5uYDz3HY
 pMNp/5/drSGAEyPhAJQmFnvbN0zxr4xIP8P+Yxknlsk3DHZkJsRPfLFaJiVdScVsIS0qq2+XzQ
 ELTc8ICJV9r12iI85ZhLzjmT1oLXx9OMUzNDP2P+GHink6pnhKrw4U8/+ioWt+i7CTEoANJpI6
 owYEkUffHHcab5sXW+SkszJBNtBexcannd0KU6al2PHfwyPPU7iYoSW964tITfit7ZR24R0kZ4
 wH6XijzP29HRvdh32FtTEFm6
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:45 -0800
IronPort-SDR: MV79fSEVgBlSUUo6BCXuzeUfcRf02oY9KoncmpF5NhRiPYvT6LQWth3tyJ5S5pcKVSy6buuFOf
 hTSqJduBB/tnIqObxn51W3BW5zBhTBhCPjQmSfuIaj63Qd5AAvjktcSUoSl2UDGygW6gQKvO7J
 +Pt7ogcfKeCJSr9yvcFtcEGZSgKWgBZ5aXI2IDnrbh8919oatEBdO48/Ry6RfuQj61aJqrIghA
 l3Cpwgwl0dUavCJgCq0Dh8kO95n0FTD9ExIR0Ejy+23ydt2jqKdPXzbuOcA+f3qmNURB2WNi1l
 BbY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:07 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyz0jBPz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:07 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154106; x=1647746107; bh=g9DqTo9CfqOPxmAnqt
        DwRWIZjNs6xzEf/L8jfuXNUaI=; b=dj6Gecc8R/3UpPo1FtadUPPvFLkRJUXOSD
        YN7EIYdnbWblVpqfdW72E383TWgiX5u0EMipB1PUoe9v8lafx0h9aVDFmd6mm1E9
        5IAvhZMmc25cPFeHsssxVLBRC9nMdyrT9l9a/n3H4yo+n7jmRoWc8LQ9ZrALM+yb
        PTbRxpFvP4za006fp8zaZ4rFiQNfZzo69njtEe1FJjI4gCdZf2/Ntwa7J8YbHr3G
        f1VNpk2cljEKRKQgSR+PzKehNTxJbe150MPhmesXEFdlP/913jr/5mlBYev0Q3lQ
        48XTqvripf467tR9IL2fE3dBb5EDTK+cIZnN5T4vLtCJBhAVA0TA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ck2_9fVXbWTr for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:06 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyx4J0Wz1Rwrw;
        Thu, 17 Feb 2022 19:15:05 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 13/31] scsi: pm8001: Remove local variable in pm8001_pci_resume()
Date:   Fri, 18 Feb 2022 12:14:27 +0900
Message-Id: <20220218031445.548767-14-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_pci_resume(), the use of the u32 type for the local variable
device_state causes a sparse warning:

warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype] device_state
    got restricted pci_power_t [usertype] current_state

Since this variable is used only once in the function, remove it and
use pdev->current_state directly. While at it, also add a blank line
after the last local variable declaration.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
index d8a2121cb8d9..4b9a26f008a9 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1335,13 +1335,13 @@ static int __maybe_unused pm8001_pci_resume(struc=
t device *dev)
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
 	u8 i =3D 0, j;
-	u32 device_state;
 	DECLARE_COMPLETION_ONSTACK(completion);
+
 	pm8001_ha =3D sha->lldd_ha;
-	device_state =3D pdev->current_state;
=20
-	pm8001_info(pm8001_ha, "pdev=3D0x%p, slot=3D%s, resuming from previous =
operating state [D%d]\n",
-		      pdev, pm8001_ha->name, device_state);
+	pm8001_info(pm8001_ha,
+		    "pdev=3D0x%p, slot=3D%s, resuming from previous operating state [D=
%d]\n",
+		    pdev, pm8001_ha->name, pdev->current_state);
=20
 	rc =3D pci_go_44(pdev);
 	if (rc)
--=20
2.34.1

