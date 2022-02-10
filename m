Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F2AC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241124AbiBJLmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241113AbiBJLm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:28 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE361026
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493350; x=1676029350;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ejO8Y5jwWSKmpKfhNMn6tqrpuf8bsQwZ4IjznBqtY7Y=;
  b=UPpMoD9TAZGqzIzfocyI+4kCEI3Dh7ZMP+ASRGvj7nqwo7LGXFgxbBK1
   Tr8JSoyP1wxaYwHf3CWiCQeOMNXG2cvq7Rx+X0ybyuIrvh2xnT7eMcrA6
   3rFHXSq5VR+ZdGX2Mx+F2q5VqfMDO9PVFt1QEimELbfuV3v9GNPc3c9mc
   zpPCXrjPSulg4TgvLlaRgS6IUj8SAEKWH9dsQSvClIo2W4o0oha0IO10w
   wVt/VGaFgcMQP9UGbw969pSpsHBi+HhrU+Y1cXaAbW5bUKaS0earHE/Iv
   LoMOLd6IpVbfL0LUeluBl6SgAuYcjngq2LhVrHBFShWMtAgi62opXNykP
   A==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575627"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:30 +0800
IronPort-SDR: Yfa1C5Mj004n9Zgh8Ttt2R+Vpp4oZXePJMhXK4sBA6XoYNl04Mib0u2PW4h/AyacctME8MQ8fg
 6nCyPtC4wLlaYv+XdQOEzSdd+WG6aHT2eJ4UalLFnGJ1TJBnywNLfZHASNddZQeKciYbhXLYPC
 9LG9ch24y5Gfj0kxEYtKouCa3zM/2eIYJ9C3sTFQ07G9HoQ0soDDksU4z7kl4RhVMi4lufISsA
 jffpQhe2lFiAdnkbbb8XgJ5a8S+fCfMSor1HXARcKSJ5oY5akl9binTUPHZ+IPsOOZXYkuU/4S
 Idv6gNgTVi3t4J6Cyh3DNK8e
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:27 -0800
IronPort-SDR: Wk3FHXBCqb6IqiO3OOvuBJORwJ+bFMic3I03u2wPWQDcbzyh24ZO9aJKkJ59ex+DF2AtOZivuS
 O3GYvTzaO9cg9KzS2kOaia2svmU6wdFbR4KjsYVi3fAp6SRudLSgpIclZ3LHGP2Cgpuzpr7hyI
 6tFRj4fChIVeo3vSQfCmwMQnQ0K/iHWxhs5eICtagN8ltpvaHzLB235TnPil+1r55R1wXEnBCz
 QaDPvhjxkPpxZaYBwB3Y21aE/Vsh0zxHH/5u2GX2jQJOvsvDrhT4+NYgn6uo4pfbKPtyGz+nkN
 swk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZc55Fdcz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493349; x=1647085350; bh=ejO8Y5jwWSKmpKfhNM
        n6tqrpuf8bsQwZ4IjznBqtY7Y=; b=AxH34ZwhIxXseR4o///UlW1/8IOeT9i08s
        jajNpdvlnJLNjVA0sNaKbPoodYuFfJ4O35CzwSEAiBzJXJ88xs+o0Nr1s8rAEoBP
        2YbdqW4gesk+Z//1VAN3oJd2fJ6aWlNk/tWQiFYw6Kfv8WZXf0vDHNtVJA/zQk2G
        X/6Ul6TFB7Yz3K4s/sCrAM0gJXc5Wl9JaoB7bHAgo0IndzUnkAoAZ+WLRga8Y1UF
        b2hBIMViVw7SM4fTCDTfbI05D47aD5ggR5yD4maAjcdXnj5v+0zQEuCRgD9T9/t8
        09p69GjAXBmqgILvdaXnAZCIxefUVAB4S/uXhJCAy7fiFvw84omQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6Tb8L4-lYDGp for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:29 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZc42LwGz1SHwl;
        Thu, 10 Feb 2022 03:42:28 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 05/20] scsi: pm8001: Remove local variable in pm8001_pci_resume()
Date:   Thu, 10 Feb 2022 20:42:03 +0900
Message-Id: <20220210114218.632725-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
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

