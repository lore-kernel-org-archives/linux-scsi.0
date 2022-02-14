Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA06C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239312AbiBNCUD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239297AbiBNCT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:58 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822E655480
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805186; x=1676341186;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=xiP1M0lFxhMkb2FeSA/f5haQvFI94F08NJluHNNUbzw=;
  b=jZunM9E1qJ7oXEHMKClzEjeJRRg/NxlN0AUOxtFXSFIF6y5TdCdZU4kt
   rKtLtVwgUuzDF6orfnD+jf6k5mzIYeaJlDcRzesWG/j9muNdTWm1Pz9MT
   l4Mx0q11pEc2/qmEBoGYY+40XNSWrzjjI/Gr932RE1Pae933DOVrRKlEC
   timUMRYxE0d/S9H4XqC8JOZmVq0SKAHTO9PKHqU9oBZfUK5nnYx2bUujZ
   e47tN5B0KL9+fTiSpbSizaXpNG/Q6741eCengPNtjykGNZeRcttDtH45o
   l7RkZe/yp+l4hE7YQjJVv1dl/MKA3fdOPu7Gdw3BVRkxRcmtwF8mN6+om
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819780"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:46 +0800
IronPort-SDR: l7GmQVf4qCp9QKiZ3qVPoQRGQBEqDoaVXsJe16bOXVWmDIfjvcwKSEaTlo5Q/yihnvJ4pKw1QC
 T+djppzKr1elC3BOnJqzSmMGEZlE7PGNA87vtr85g6IgScdCAwBGs5buHN+puXTVeP7FZwZ3kQ
 F1ABakDUxlGjju/TXUAH/IwsjHSjM6kk2qATGRGdHkWJNkkSX7DyNR6kI9fe4T8iBfKpDDJGgP
 9PLSAQk+BD9Sw6dybtzw8VN4uepOSmp5h78XkJSPAuYABh7OjYpdGKIlfCDntB81fcgr9JtLWi
 HwbG1i5g016olHf4GbYW07nV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:38 -0800
IronPort-SDR: CcbBA68pE+rX0n2B8h21aYSRzbmWQWD6YLuAfn/RGB9a0S1vdBAf5OcDQmNSYpfq+KEObdqceg
 zmXKFnj4s7I8wZtqL4dnoyki8Xx/ScYs3YYmZlnd0f41H7bm6pNx8PnrQ40vZVl1URftTGNidV
 ZChnvUYbqKPoK4Dylqx2qRppLAmRxCz40KyqCq3EQfmFO1S/D7+3jPTvkqUPXHCixSGnIBpi98
 K7RqzYSnPkSv2jL+Hjj5WCe69VYBZ1vG9u7UimjDpOSh5Z49/D0/hbKOFSCvhl5c5cUlXBfJMT
 zVc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:47 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwz0kHhz1SVp2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:47 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805186; x=1647397187; bh=xiP1M0lFxhMkb2FeSA
        /f5haQvFI94F08NJluHNNUbzw=; b=Y7veT0ZMUrar4MxF+mgKYc7wqdu/oNLTS5
        YdfH46J5Q7WlECNqwNdBagI0zOE6LFwl33NhbWlO7iA31bZcsdzCwfyGPpCQ8a8I
        UyFEXAWsGlvXFrjhdrhe4SdEcnYE6cjldBPNEFKDKcgcxgPij0nGIVbD/ZIALpeZ
        hRsX5xFsx4Hdme2HmuY1EojtZ7PSSXKOUfln2QnGA/CojW2CIMxs90x1+VZqSHcg
        vjB/aPb4aJq8vP1zyJ+57t9CrJUWpPqy6vq/f23G5+drg1QC750mhYeL2u5hmClo
        BT27ncA1Q+Hzn5vSx+L2Eg63GNJQ2eNGUEzCxREcvxzuMq2F1Alw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id lGtx1RwlC4NL for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:46 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwx5Lgfz1Rwrw;
        Sun, 13 Feb 2022 18:19:45 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 13/31] scsi: pm8001: Remove local variable in pm8001_pci_resume()
Date:   Mon, 14 Feb 2022 11:17:29 +0900
Message-Id: <20220214021747.4976-14-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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

