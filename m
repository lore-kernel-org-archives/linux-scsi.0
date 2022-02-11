Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C37C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347769AbiBKHhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347726AbiBKHh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:27 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7F4112A
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565044; x=1676101044;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=T0RknSK7iqFE4xOMmrc8pK6mkwHdkLqp91rQAtj5i64=;
  b=EbfbZ+HBSXu72jrr26Sj7YOprNEpwHl7A/j3VgnBzxBPssao6P1wIPov
   QcTUX9bxBMGEIGuYbUFUKrkyMQwipma0bS7cYoa6919TMKtwNAQaDqbRD
   5yctPHxSti2edDcwRnSWSgMzOrhetCw8G2a8V4hvkvrWvylZpkGXE/tPk
   WEicgAsiBfS41MNZIrrvGJYWdKsUGE1cN0wkrIgFNbPQ4efHC79XH04A7
   aAOQ85E9LraQPsX2bmBtv2nKZRGtoP0eh3yaEIG1Rfbst3r0byi9ilWHz
   mipjzDjQiEFgZPJ/74SOUYErI+7BPifg+/EIurRE816j4wS1t4woJpMCK
   A==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675150"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:24 +0800
IronPort-SDR: VLaUBB3qgbn1jCHHxm9ef0bhe4W4mGqSg6Cel1ezc39MuJ+zWhyjq1FpwCT5RRLb3w02XBEcW/
 Q5fDyIoov+AYJxf4ZfBGYngYflcpi3GE/G7Q6vOttkpuS2JhD/s6srtfJSfqusPkfDMt+gTTUp
 gWi9dKvB5wkYVkLwopR3n7Uy8ZBeXAQyMevOyPyKZy4gojKP45sFNgUBr1t4F0ZQUiBk/Ar3AK
 DY8ifX/A7Z3OKZNKrfEsMUTY3Gm7feCyx1kS4dQuiXGjjYNBeDsWLtC6u35iUWOYQoP2ODOYIw
 oM4vD4zQRnsWBdPeU9a19nwC
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:12 -0800
IronPort-SDR: y0qkfwHZ27kQxgU4UtHWwUuwUd5Gi4t3hetNFVKKsIt7SrE+DlhvN/Sibjtuop15jyZpYOF+bW
 EeNMkVzdj9Jc+dP8hmhYhmS/umaoH4Iirs3l4/eoFwvX05oUqbIrsyO8eE8jx1nBx7ESJFVThW
 ArjOtKZ/vaWKOAuwF8rLDNfJ2JSonjK6GWKIch/R4TrOhy9RQWSvF9kAMRRnSYXiRfS6BUj+EJ
 jspoBNRNZ8d+Qxdwmz+uz9mM+mtSAN2SbDSjO8l4QNRGThd5XWuZR5ZqzE7zKstfEBcqdlIseX
 His=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:26 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56s6bBFz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:25 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565045; x=1647157046; bh=T0RknSK7iqFE4xOMmr
        c8pK6mkwHdkLqp91rQAtj5i64=; b=fWWoPcjNcQx+lNTBsZkixQlbKznUAIKjYv
        XO3Zs3X/JGeOfAm8XFxJYrUbcymwgQiD8G5ITq+ncXCTvgIyhrfA9m0NneXtPyDN
        dVnJ9g8O5iJh0ToddEb/BqClmePh9SLO0etmPXvOkTgX1hldEVa14R9yBahwKnnT
        E2ygxuIDOleEoHOdbFvi5sh//J6BzoI9jg88olWjFr29d8NfkiuTCx4hZF2wU6KM
        +6IDIaeuMnAmpbtsQezn2pVLMEr0v3DJOiY0KMlv7lzWnqZFAgOZPZdDQGtnHxI5
        JoaFxEnVLX1sU7Rg7HF3K7M3l2jcDOMo301fMNN09Hl20pknd0nA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6sc_MlM5OPgZ for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:25 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56r3PJ2z1Rwrw;
        Thu, 10 Feb 2022 23:37:24 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 15/24] scsi: pm8001: fix use of struct set_phy_profile_req fields
Date:   Fri, 11 Feb 2022 16:36:55 +0900
Message-Id: <20220211073704.963993-16-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In mpi_set_phy_profile_req() and pm8001_set_phy_profile_single(), use
cpu_to_le32() to initialize the ppc_phyid field of struct
set_phy_profile_req. Furthermore, fix the definition of the reserved
field of this structure to be an array of __le32, to match the use of
cpu_to_le32() when assigning values. These changes remove several sparse
type warnings.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 12 +++++++-----
 drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index faff475333a9..288bad31b423 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4975,12 +4975,13 @@ static void mpi_set_phy_profile_req(struct pm8001=
_hba_info *pm8001_ha,
 		pm8001_dbg(pm8001_ha, FAIL, "Invalid tag\n");
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
-	payload.ppc_phyid =3D (((operation & 0xF) << 8) | (phyid  & 0xFF));
+	payload.ppc_phyid =3D
+		cpu_to_le32(((operation & 0xF) << 8) | (phyid  & 0xFF));
 	pm8001_dbg(pm8001_ha, INIT,
 		   " phy profile command for phy %x ,length is %d\n",
-		   payload.ppc_phyid, length);
+		   le32_to_cpu(payload.ppc_phyid), length);
 	for (i =3D length; i < (length + PHY_DWORD_LENGTH - 1); i++) {
-		payload.reserved[j] =3D  cpu_to_le32(*((u32 *)buf + i));
+		payload.reserved[j] =3D cpu_to_le32(*((u32 *)buf + i));
 		j++;
 	}
 	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
@@ -5020,8 +5021,9 @@ void pm8001_set_phy_profile_single(struct pm8001_hb=
a_info *pm8001_ha,
 	opc =3D OPC_INB_SET_PHY_PROFILE;
=20
 	payload.tag =3D cpu_to_le32(tag);
-	payload.ppc_phyid =3D (((SAS_PHY_ANALOG_SETTINGS_PAGE & 0xF) << 8)
-				| (phy & 0xFF));
+	payload.ppc_phyid =3D
+		cpu_to_le32(((SAS_PHY_ANALOG_SETTINGS_PAGE & 0xF) << 8)
+			    | (phy & 0xFF));
=20
 	for (i =3D 0; i < length; i++)
 		payload.reserved[i] =3D cpu_to_le32(*(buf + i));
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80x=
x_hwi.h
index c41ed039c92a..d66b49323d49 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -972,7 +972,7 @@ struct dek_mgmt_req {
 struct set_phy_profile_req {
 	__le32	tag;
 	__le32	ppc_phyid;
-	u32	reserved[29];
+	__le32	reserved[29];
 } __attribute__((packed, aligned(4)));
=20
 /**
--=20
2.34.1

