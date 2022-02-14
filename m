Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C193C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239329AbiBNCUI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239292AbiBNCUB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:01 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AD055499
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805193; x=1676341193;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=T4zz8y6S9du7ZdDPwmWWGhl2Ku/KHArNURVQc3Boojg=;
  b=bXPNw++6JdxlKXmXouk+ek5BA5w6qOzqULUjlHhhH8m73rFYiT0ysOH2
   1g6St/tjuSx5Zjp/eDQNWemqOedpkqeLTS4eeLgZIlBv27Zm67ZN6uXUv
   BIn9rlPODlbvVma36NlgHsrpZLYm0mRjMUvikQfvcFBfZ03X9Mffa+80v
   B8LX2yxorsAN4rvVDUOOLg+NvqITHVVK1zRw+04hL1rgF2YP4QXf+F6n1
   TIMRpReuZKS1NEYgsNLXqLVADspJf/12dWuYSy7G5xpCSWFPXf5p870VI
   eR8ZkEg3ECPuuy93YUMncFxcub0Ze+bopPY6LKkXL0C662ELdcb1tdJ/U
   w==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819790"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:53 +0800
IronPort-SDR: /oHIHqnGMwRgcvOMNgORH2fkpS7EG1wHL4vXVWOuY3WUKKsMbQJ76TXz+uSL2wO9EKMQ/UApjM
 V3qUektvta0cnlmmP0zwGdtIEmIAS18Wl1O16oK52VulBhiGEhOdGiLN8nsftFNvwDUKdqeI1r
 JoJJFHdm05LOUkrToXt9nVyGX3CxWrdV71hW6eDsjhJcbSGoKZi4YC+rT3QNDbUmnGd7SHXfIa
 sx+C5G5Z5nIGet7terImGVpXaDovapqgaSci3/4LI06z+/2BnjQ70GQLUyHCOHFJibwe4VVPA2
 rAJy8NYB1vH36MLC7BmsAVmD
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:45 -0800
IronPort-SDR: 5jQszL8cAcADI4fGooPEMfKTM5xDJO0lm+cQaFfXhJVC4aqVLKvTUTpiEVFzSiPJieRkEGw8t3
 DsmBxuWzvFMU+MGYq2X+PnsiIlrbJ5S7CyxTj5wXd4kJ6tIQ6xzh6MBfTPKY3epq9ZPjPCnF41
 G4bUGFlwN49kRXXyITWZPsDS1hC9bUvD3WDA+3u9r9sjK7B36d2FdmH2OcpOcZQ9H1/XizKWJQ
 Nm7+8N/MCZnUrK9w2o/X+DG3m2fHjIFnDWLxVKgjT3sm8TKkvK0DRp/McP4xGCmVBfIlhSt9LU
 7CI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:54 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnx54Xfnz1SVp5
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:53 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805193; x=1647397194; bh=T4zz8y6S9du7ZdDPwm
        WWGhl2Ku/KHArNURVQc3Boojg=; b=lCK0nilzMLXPH94Lz/gtFQn3j4ckOq19JH
        kGk5yIAtZ+bZKbPELEmbvCoWBO7je8/A275MpDnHaE6GfHeOdTIr+W2KnpH2ogoc
        SHFYrqtHbjlovbDN0qF2dqUiDUDzsHd5fKYvln9o6qQ8Le/awV2S+bF10d+hPahw
        bVKPJK6wYso44OFmRjhYpLqAv1VNx1BV2H3kz3SNXix80uxliZuXJgr1DCN3DFPX
        Kq4dBetrW29vErrBgYDsN1fbI7vGVsUN9MZ5dMBpm5hqfL8n8MRweJXQ0R6mYCA4
        XyyQaN841KBWxIwdcg5KU9mw0+jazCbcg4aWcWUQKjnhaIW/KqIQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KGHzqHr9aNtU for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:53 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnx41qnxz1SHwl;
        Sun, 13 Feb 2022 18:19:52 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 18/31] scsi: pm8001: Fix pm80xx_chip_phy_ctl_req()
Date:   Mon, 14 Feb 2022 11:17:34 +0900
Message-Id: <20220214021747.4976-19-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If pm8001_mpi_build_cmd() fails, the allocated tag should be freed.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index b0b6dc643916..73e9379ab09a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4932,8 +4932,13 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_h=
ba_info *pm8001_ha,
 	payload.tag =3D cpu_to_le32(tag);
 	payload.phyop_phyid =3D
 		cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
-	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+				  sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return rc;
 }
=20
 static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_h=
a)
--=20
2.34.1

