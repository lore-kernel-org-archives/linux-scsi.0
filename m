Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD549C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240934AbiBQNao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240909AbiBQNal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:41 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3965D2AF3D4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104619; x=1676640619;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xiP1M0lFxhMkb2FeSA/f5haQvFI94F08NJluHNNUbzw=;
  b=emiDe7K7vAq4jABx0frAvGH1XJIbwlakESBntSbVUWUXOIQyzkBfUd16
   6AKcIfvorJKeAcSGPlvRvK4EdfUj18SF+8EwdJVSsVmwNb5fTz+urK6z7
   nfrGWFaUVf6pcIqxNhsCqlcmbsC49pJmvivcOY8cU4wTJ/QGiFGDguK1K
   2xqlmZgfVl2ESgwpCtr/9u7c6T4+39oFEvkoWS4o4bk7h2iZRmUeLJxTX
   K2JbU5Nt3mCARTNTfdQMhfA0YpuTRLMu6hioUGnZ1r8rgFOoX3fAhssm8
   DrF22xSocKYJIiSZaDL4JOmBdSIrolbWOs9czx5mP3rE9it0cG8XrJ+tV
   A==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303174"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:18 +0800
IronPort-SDR: ihafkPllbugfp8hkekGrpVLJs0XdgTYtmi3J9ReVn7vNaCh7HMxzx5meU1A32Zmp4LJQpVQuiW
 CKxUdDmRtfeuLXk5+Q5f0XuyzG1sw7BotD350vBkJoV2li6MHrzh6PSD57BaW99g4SrwB/94aK
 8Nrssw9T/y4Rnrc9VxNk40R3p4xSDCQcPI8JhcpH1YOOpQAHvLPjzrkQSjy2TLu8XXSu3Rg8qw
 lK4GYEAO35GRuKAaZCqwB+nxwa34o/3SdJEtlFF7iUta+VzQqRxhPxGJPjueqLz+y7mn/h0x4o
 md+x9eullS39ZVXkNJVxoGlf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:57 -0800
IronPort-SDR: iU0fdLpHTbLgEsfoHHrRvNg02lfKDKI5NURS2pi5qBs+E+o9IiYXUcHl+yB4pNfCBdzbKbLekl
 f4HN7aPyf0Zwq2+O5aRw6IxRIVQBJ0CBZ1uc2eOgTdkHktMbpM8Gha8AF43JOTJNmgeeYEn8A8
 3bt0f+Es+YKOQ4l9l4MrkP7VFxlVN2olbXyrOMOmJ2Njgm7syQbCGviUYtPQ7RGW7ExmegRSeO
 qk23yIWvcQWID90yHBXm04uXaxOogqlsUGc8wSH5GWVpU/jMeNqB6uYwmAZvgDNCK0vzQXFsNz
 SPQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:19 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgG1WgCz1SVp5
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:18 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104617; x=1647696618; bh=xiP1M0lFxhMkb2FeSA
        /f5haQvFI94F08NJluHNNUbzw=; b=Y5l2VScCvYC1WEVrcj/V0QUnNX78YInJQx
        jlMwL3enaewqQKJAYoi+SHC+nW/Rn9vPt+rh9mB26m4xRcNNu9gdKEP/O1ibgQVY
        11qMx+lyR5xkNsZjpskSd98Eyq3Nrmv1suW00mtYBpwvUtPGM4p6miRE3q7nDzNh
        yZmp3bLppjMtdy/G/jQyfe6Iq9A5eaBWjYKEG/JFtculwkfO1/ZVXv++HrqdR7HB
        ti231v5YNMcX6LKUNzaFkx5jdmk+sVgWHAhgUQxG3M/InxooQD1sVb25Fb1LJR+T
        MpuSSxhDZnM/bwSe7zC6wa/GDlAsOEPrtFTp5xsvsTiRhSr44Rvw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JXZ7RI6I01ok for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:17 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgD40Bpz1Rwrw;
        Thu, 17 Feb 2022 05:30:16 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 13/31] scsi: pm8001: Remove local variable in pm8001_pci_resume()
Date:   Thu, 17 Feb 2022 22:29:38 +0900
Message-Id: <20220217132956.484818-14-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
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

Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
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

