Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF0AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbiBJLmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241158AbiBJLml (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:41 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204FD1081
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493363; x=1676029363;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=pPRaxLs4RU6X97Z7l3OroNrE2jwzr56AM3rErLhNkhs=;
  b=XgNbCsjXCTU1UtvyH78Gz26WNWkqqMDzW6ofw5mbm1AL+Qw3ALnChk6F
   8JgljDmdbPbXkUb1Ti5j86HzsdFMP63wUr9Y6LB8smo02FpgXEOKLxJHZ
   xV136Yh1IMxjKuWNFYcMxC4cpMP43Qm02osOt7E5tNPdD5BVX3bCrPT7X
   OUpa6aJolsW7mwqGDeYLOWwUCN8+er6flqRG2YtrE0cpTA3xDfN2JK2/B
   PmmNe33whAbAMSrq5ApoS6v2InBjPABH2GWqg8ZcTrHWVGSSuDY5ou5ih
   2scYNXPP9XdRrhWoC/+5uxWG/WRIBC06/DV68OQ3JuSLN2tNapi60XkU8
   g==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575658"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:43 +0800
IronPort-SDR: 7CrE4VIYOC7KL9A4HKb7LyFeLPXTB3xrWjzSzLJcTJJOOx2nI0nfUtjBLXYTy9lf5kArKNRtaY
 N1al8yseSCRV8uftAkiSiSw9KOcQKQrTqhtm9fZDBOnIa/NNx9eJBNTLCceYg5PTGgIYtTFhjj
 19Eju/MuxzTFYbfdjFXlQcnnI8dBm/XY/OioqMkvP/y/03fWcv8vh/NgAF0d67yDQECIH0mXTf
 sJCxRts8CDLKhDXPJFsfzTPciEhJGsDIZEs1gJT4oTMryDbRQ2IuesurX82NSttk5CHaFbLfrd
 5Q1K/U6nFsmxSxeuWVfYG7HP
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:40 -0800
IronPort-SDR: yI3sV23UnLR6UdQoXSuOvcadg3tl9TN98GMjO7CDTXoe2vjZcFKERoe4yCJ4OUONJYuJi14bn8
 q4wO707kmNO2ID0wfzffuBhUQlcWvVGDZTBETo7PAgJsRhwZK7ct3pjBwmOK6dWrS1kcaYmBwL
 Hb6X2U6FD/aBMHYjNk0zDMn0D61khPI6QsOq5OUF9C7AlLLaQceWEbpE9fHUYjzIcKK1m2UpcA
 BFjsXa3XAVIRBg704FjA95ScFAJZyqe5XHaFJRIi9o9fRtySQiNFt9dJgla/QaotLQPQhm9H+y
 mPY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:43 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcL5092z1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:42 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493362; x=1647085363; bh=pPRaxLs4RU6X97Z7l3
        OroNrE2jwzr56AM3rErLhNkhs=; b=sPGyNXDRHqsgCGYS2wo9YzIlfn4Xp7IWDr
        S83Ey+gFrXjG3GHPOxU/WvPQrcivbSxs+VFo2MtftxRh5vOpO+PhPZ7RMmGRqEk7
        9WudyFalR0YWv9qxR+6b/9B+UiwTrpPl4iUodCxWmPMhbp4/Wn+zh93NNQ8iMuUv
        p94Eq2TiBDb88HSN1LDDv/v3RZVo99+bOSRrxNk+ybeXQbyg7bZ1IiICv9aaHZ6A
        xX81cg0ejneUay1bwO0z/sjQlYMI0HWjCQtWR2Kp6w2kdDBC54iKVT9r8jyBchPV
        KolOHS3ZgEOgqT5k8Ucynu0m543TXQTCCO/RgxlqvJgTW04OVjqw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id mZJ40LutlipQ for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:42 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcK1bHbz1SVp0;
        Thu, 10 Feb 2022 03:42:40 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 15/20] scsi: pm8001: fix use of struct set_phy_profile_req fields
Date:   Thu, 10 Feb 2022 20:42:13 +0900
Message-Id: <20220210114218.632725-16-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
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
index fbdc56351901..dc0a84c81189 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4976,12 +4976,13 @@ static void mpi_set_phy_profile_req(struct pm8001=
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
@@ -5021,8 +5022,9 @@ void pm8001_set_phy_profile_single(struct pm8001_hb=
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

