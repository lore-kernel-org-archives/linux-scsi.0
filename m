Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF241C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbiBTDSo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiBTDSi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:38 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F20340CD
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327096; x=1676863096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J0/LlqQwzsrgpyn1bhRFQWdRsj7/wpmjTh1sBqjyc6Q=;
  b=ZD/+oyWOgp4/7C1dqgyaB1aMLPRfIt1/PnP7+Cv6biYdlznIKBZ5coz0
   /Z34pzMUqradNKyA3mHAsKaFHcmrQZuim0b9EU5fraS0PMMdiDS3WhqHF
   OkNNGI2Nc5SUKi9QMCrEHCTQ3ONnSvfGeuS0MZhYw+UliCdcH5p4u+GKO
   FCY0j+kqPrsRT0bFyCh0nqJbpu0imttNNG6+YiKodjRtMmVbmhpmqIQVX
   bJsD9nuDtXQYMuJmk9Q508H2BwjU/M8vSrxlBsfsE61otyiS+gvmxpPq8
   zehXbD219pLDqCTAvkJYCRScEv2rsXqS6qqdXl8q0WI9nhtnPBturZpOf
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405729"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:16 +0800
IronPort-SDR: m1LWwyIFH/RpYE+nuxrN4IeQP0dHQ+uXXZM2QD7S76jQGyET05tQLdJuJgrRzPe31IwZAJriCn
 0fa3Z4nEDjKR0+02UDYUQmJcDDcqc4c53lkZxh9leBPGhW2nRo5qp5hMwxJLTEJep/cyMCuOu4
 jFFt+gjGsGL4Q1+o7ty3EP6vLO1YfwJuv22rrSpZ5EMBA0hdi4zcJhNk/otKvElEf2enebaSpX
 bNlPQx7Mng8o+oPL0LoiNxc2PHSvk1oN10l45S7lkf9wQMGEwO7LSYC3DcuqC5ymsRVc2L28hn
 7yavuvombLEpU51x7Zz3GS2z
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:49:53 -0800
IronPort-SDR: KZFD2ajYtrAzwOkoeUtpW9F4HZfo11ZtI1dzaETUeE4MYfbXCNimhTio7d5sCKegnFbT4MIdZN
 TPqi4hg5hfUtjbz75gV5RubNjUK1SHZO2xbG7R5IHIrLcH7edipeBQEiPQV9Z0R7aR1TVl3UyG
 IsdL69KxYiWoKMCTDz9VKv3bx4noGoW4DoBhZr/WvdfxyHs4XbffHKiKMUNdrVDVsxGxlB4qsw
 X1waRWofay1adcjU/beyV1sPONQK0KKBs+rv3XimFT8jW0Bv/mS5QmXRV4iY0x9aG38ricdSAO
 DR4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:18 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxj5yZGz1SVp2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:17 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327097; x=1647919098; bh=J0/LlqQwzsrgpyn1bh
        RFQWdRsj7/wpmjTh1sBqjyc6Q=; b=ekkEtmjtdmQ0nEe7I5I7htsR52erUBzLsx
        u7KwKSg6QuttIOFsTMppvE1QSq3do0rRVVoDkrcFqzex/UF+1WUZVTKIgisAHoGp
        pedq6pWBHpuH2wLCjSnbcuzSIaRr3OhUAu9zv4xF1nBR1h4nljLc3eNBrlvwjFb+
        uYRNtZcRr0c4gtgx1I3UYOXadBTaYoeWc4cimi+iSFvHI6lPqN/nk1s5UewPafb9
        gnhFT3Y+jNrgKpST4V8ZCCjYZmEJpvjpoxL19iFW2YTOO7uAV2fpDfIXMbEvaWoS
        ehrtvyJ5bF3iJuPssN7NHXUyn0spIaOKDYGWS4fd+jzklNSbugsg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JASuRskJLZMz for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:17 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxh1pq7z1Rvlx;
        Sat, 19 Feb 2022 19:18:16 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 02/31] scsi: pm8001: Fix __iomem pointer use in pm8001_phy_control()
Date:   Sun, 20 Feb 2022 12:17:41 +0900
Message-Id: <20220220031810.738362-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid the sparse warning "warning: cast removes address space '__iomem'
of expression" by declaring the qp pointer as "u32 __iomem *".
Accordingly, change the accesses to the qp array to use readl().

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 828d719afa1b..f5678be4c17b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -234,14 +234,13 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy,=
 enum phy_func func,
 		}
 		{
 			struct sas_phy *phy =3D sas_phy->phy;
-			uint32_t *qp =3D (uint32_t *)(((char *)
-				pm8001_ha->io_mem[2].memvirtaddr)
-				+ 0x1034 + (0x4000 * (phy_id & 3)));
-
-			phy->invalid_dword_count =3D qp[0];
-			phy->running_disparity_error_count =3D qp[1];
-			phy->loss_of_dword_sync_count =3D qp[3];
-			phy->phy_reset_problem_count =3D qp[4];
+			u32 __iomem *qp =3D pm8001_ha->io_mem[2].memvirtaddr
+				+ 0x1034 + (0x4000 * (phy_id & 3));
+
+			phy->invalid_dword_count =3D readl(qp);
+			phy->running_disparity_error_count =3D readl(&qp[1]);
+			phy->loss_of_dword_sync_count =3D readl(&qp[3]);
+			phy->phy_reset_problem_count =3D readl(&qp[4]);
 		}
 		if (pm8001_ha->chip_id =3D=3D chip_8001)
 			pm8001_bar4_shift(pm8001_ha, 0);
--=20
2.34.1

